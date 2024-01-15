import os
import time
import optuna
import argparse
from swSession import *
from hwSession import *
from paramAF import *
from utils import *


def param_space(trial):
    # common params for all activation functions
    pre_delay = trial.suggest_int('pre_delay', 0, 1)
    compute_delay = trial.suggest_int('cpmpute_delay', 0, 1)
    axis_delay = trial.suggest_int('axis_delay', 0, 1)
    add_delay = trial.suggest_int('add_delay', 0, 1)
    bit_length = trial.suggest_int('bit_length', 6, 12)
    mini_length1 = trial.suggest_int('mini_length1', 2, 4)
    range_num1 = trial.suggest_int('range_num1', 8, 32)
    k_bit_length = trial.suggest_int('k_bit_length', 4, 12)
    b_bit_length = trial.suggest_int('b_bit_length', 4, 12)
    param_af.set_pre_delay(pre_delay)
    param_af.set_compute_delay(compute_delay)
    param_af.set_axis_delay(axis_delay)
    param_af.set_add_delay(add_delay)
    param_af.set_bit_length(bit_length)
    param_af.set_mini_length1(mini_length1)
    param_af.set_range_num1(range_num1)
    param_af.set_k_bit_length(k_bit_length)
    param_af.set_b_bit_length(b_bit_length)
    # additional params for softmax
    if param_af.func_type == 'Softmax':
        mini_length2 = trial.suggest_int('mini_length2', 2, 4)
        range_num2 = trial.suggest_int('range_num2', 8, 32)
        param_af.set_mini_length2(mini_length2)
        param_af.set_range_num2(range_num2)
    else:
        param_af.set_mini_length2(2)
        param_af.set_range_num2(2)
    fp_writer.writerow([trial.number, param_af.pre_delay, param_af.compute_delay, param_af.axis_delay,
                        param_af.add_delay, param_af.bit_length, param_af.mini_length1, param_af.range_num1,
                        param_af.mini_length2, param_af.range_num2, param_af.k_bit_length, param_af.b_bit_length])
    fp.flush()
    return param_af


def objective(trial):
    cur_param_af = param_space(trial)
    mae = sw.run(params=cur_param_af, iter_num=trial.number)
    [area, delay] = hw.run(params=cur_param_af, iter_num=trial.number)
    mae_n = mae / sw.ref_acc
    area_n = area / hw.ref_area
    delay_n = delay / hw.ref_delay
    adp_n = area_n * delay_n
    return [mae_n, adp_n]


def optAF(func_type, iter_num):
    # BayesOpt configurations
    study_name = func_type + '_dse'
    storage = "sqlite:///" + study_name + ".db"
    sampler = optuna.samplers.TPESampler(seed=512, multivariate=True)
    study = optuna.create_study(storage=storage, study_name=study_name, sampler=sampler,
                                directions=['minimize', 'minimize'], load_if_exists=False)
    # study = optuna.create_study(sampler=sampler, direction='minimize', load_if_exists=False)
    study.optimize(objective, n_trials=iter_num, show_progress_bar=True)

    fig = optuna.visualization.plot_pareto_front(study)
    fig.show()

    print("Pareto front:")
    trials = sorted(study.best_trials, key=lambda t: t.values)
    for trial in trials:
        print("Trial#{}".format(trial.number))
        print("Params: {}".format(trial.params))
    print(f"Number of trials on the Pareto front: {len(study.best_trials)}")

    trial_with_lowest_mae = min(study.best_trials, key=lambda t: t.values[0])
    print(f"Trial with lowest mae: ")
    print(f"\tnumber: {trial_with_lowest_mae.number}")
    print(f"\tparams: {trial_with_lowest_mae.params}")
    print(f"\tvalues: {trial_with_lowest_mae.values}")

    trial_with_minimum_adp = min(study.best_trials, key=lambda t: t.values[1])
    print(f"Trial with minimum adp: ")
    print(f"\tnumber: {trial_with_minimum_adp.number}")
    print(f"\tparams: {trial_with_minimum_adp.params}")
    print(f"\tvalues: {trial_with_minimum_adp.values}")

    fig_mae_h = optuna.visualization.plot_optimization_history(study, target=lambda t: t.values[0],
                                                               target_name="mae")
    fig_adp_h = optuna.visualization.plot_optimization_history(study, target=lambda t: t.values[1],
                                                               target_name="adp")
    fig_mae_h.show()
    fig_adp_h.show()

    fig_mae_i = optuna.visualization.plot_param_importances(study, target=lambda t: t.values[0],
                                                            target_name="mae")
    fig_adp_i = optuna.visualization.plot_param_importances(study, target=lambda t: t.values[1],
                                                            target_name="adp")
    fig_mae_i.show()
    fig_adp_i.show()


if __name__ == "__main__":
    ##############################################################################################################
    # Run single activation function
    ##############################################################################################################
    print('[INFO] Starting Activation Function Exploration...')
    start_time = time.time()
    parser = argparse.ArgumentParser(description="Activation Function Exploration")
    parser.add_argument("--func", type=str, help="The type of the activation function. "
                        "Options: [Softmax, Sigmoid, Swish, Tanh, Elu, Relu, Gelu, Softplus]", default="Softmax")
    parser.add_argument("--num", type=int, help="The number of optimization steps", default=50)
    args = parser.parse_args()
    param_af = ParamAF()
    param_af.set_func_type(args.func)

    root = os.path.abspath('.')
    yml_path = os.path.join(root, 'config.yml')
    config = get_yaml(yml_path)
    csv1_path = os.path.join(root, 'result', args.func + '_acc.csv')
    csv2_path = os.path.join(root, 'result', args.func + '_ppa.csv')
    param_af_path = os.path.join(root, 'result', args.func + '_param.csv')
    fp = open(param_af_path, 'w')
    fp_writer = csv.writer(fp)
    fp_writer.writerow(['iter_num', 'pre_delay', 'compute_delay', 'axis_delay', 'add_delay', 'bit_length',
                        'mini_length1', 'range_num1', 'mini_length2', 'range_num2', 'k_bit_length', 'b_bit_length'])
    fp.flush()
    sw = SWSession(config=config, csv_path=csv1_path, func_type=args.func)
    hw = HWSession(config=config, csv_path=csv2_path, func_type=args.func)
    # initialize software and hardware
    sw.reset()
    hw.reset()
    # perform activation function exploration
    optAF(args.func, args.num)
    end_time = time.time()
    # close csv files
    sw.finish()
    hw.finish()
    fp.close()
    runtime = end_time - start_time
    print('[INFO] Activation Function Optimization is Done!')
    print('[INFO] Total Runtime for {} is {} seconds.'.format(args.func, str(runtime)))

    ##############################################################################################################
    # Run all activation functions
    ##############################################################################################################
    # print('[INFO] Starting Activation Function Exploration...')
    # for af_func in ['Softmax', 'Sigmoid', 'Swish', 'Tanh', 'Elu', 'Gelu', 'Softplus']:
    #     time_log = open('runtime.log', 'a')
    #     start_time = time.time()
    #     parser = argparse.ArgumentParser(description="Activation Function Exploration")
    #     parser.add_argument("--func", type=str, help="The type of the activation function. "
    #                                                  "Options: [Softmax, Sigmoid, Swish, Tanh, "
    #                                                  "Elu, Relu, Gelu, Softplus]",
    #                         default=af_func)
    #     parser.add_argument("--num", type=int, help="The number of optimization steps", default=50)
    #     args = parser.parse_args()
    #     param_af = ParamAF()
    #     param_af.set_func_type(args.func)
    #
    #     root = os.path.abspath('.')
    #     yml_path = os.path.join(root, 'config.yml')
    #     config = get_yaml(yml_path)
    #     csv1_path = os.path.join(root, 'result', args.func + '_acc.csv')
    #     csv2_path = os.path.join(root, 'result', args.func + '_ppa.csv')
    #     param_af_path = os.path.join(root, 'result', args.func + '_param.csv')
    #     fp = open(param_af_path, 'w')
    #     fp_writer = csv.writer(fp)
    #     fp_writer.writerow(['iter_num', 'pre_delay', 'compute_delay', 'axis_delay', 'add_delay', 'bit_length',
    #                         'mini_length1', 'range_num1', 'mini_length2', 'range_num2', 'k_bit_length', 'b_bit_length'])
    #     fp.flush()
    #     sw = SWSession(config=config, csv_path=csv1_path, func_type=args.func)
    #     hw = HWSession(config=config, csv_path=csv2_path, func_type=args.func)
    #     # initialize software and hardware
    #     sw.reset()
    #     hw.reset()
    #     # perform activation function exploration
    #     optAF(args.func, args.num)
    #     end_time = time.time()
    #     # close csv files
    #     sw.finish()
    #     hw.finish()
    #     fp.close()
    #     runtime = end_time - start_time
    #     time_log.write('Total Runtime for {} is {} seconds\n'.format(args.func, str(runtime)))
    #     print('[INFO] Total Runtime for {} is {} seconds.'.format(args.func, str(runtime)))
    #
    # time_log.close()
    # print('[INFO] Activation Function Optimization is Done!')
