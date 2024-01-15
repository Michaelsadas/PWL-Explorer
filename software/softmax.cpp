#include "softmax.hpp"

Softmax::Softmax(vector<float>& sample, Activation_function& ln, Activation_function& exp, int bit_length){
    _sample = sample;
    _ln_range_list = ln.report_range_list();
    _ln_linear_list = ln.report_linear_list();
    _exp_range_list = exp.report_range_list();
    _exp_linear_list = exp.report_linear_list();
    _bit_length = bit_length;
}

void Softmax::work(){
    float max_sample = _sample[0];
    int coeff = 0;
    for(auto iterator = _sample.begin(); iterator != _sample.end(); iterator ++){
        if(*iterator > max_sample){
            max_sample = *iterator;
        }
    }
    float sum = 0.0;
    float sum2 = 0.0;
    for(auto iterator = _sample.begin(); iterator != _sample.end(); iterator ++){
        sum += my_exp(*iterator - max_sample);
    }
    while(sum >= 2){
        sum = sum / 2.0;
        coeff ++;
    }
    float common = my_ln(sum) + coeff * log(2);
    float temp;
    int index = 0;
    for(auto iterator = _sample.begin(); iterator != _sample.end(); iterator ++, index++){
        temp = my_exp(*iterator - max_sample - common);
        if(_result.size() <= index) _result.push_back(temp);
        else _result[index] = temp;
    }

    sum = 0.0;
    for(auto iterator = _sample.begin(); iterator != _sample.end(); iterator ++){
        temp = exp(*iterator);
        sum += temp;
        if(_origin.size() <= index) _origin.push_back(temp);
        else _origin[index] = temp;
    }
    for(auto iterator = _origin.begin(); iterator != _origin.end(); iterator ++){
        *iterator = *iterator / sum;
    }

    _mae = 0;
    _aae = 0; 
    _mse = 0;
    for(auto iterator1 = _origin.begin(), iterator2 = _result.begin(); iterator1 != _origin.end() && iterator2 != _result.end(); iterator1 ++, iterator2++){
        temp = fabs(*iterator1 - *iterator2);
        _mae = _mae > temp ? _mae : temp;
        _aae += temp;
        _mse += temp * temp;
    }
    _aae /= _result.size();
    _mse /= _result.size();
};

float Softmax::my_exp(float x){
    float k,b;
    int index = 0;
    if(x < -8.0) return 0;
    for(auto iterator = _exp_range_list.begin(); iterator != _exp_range_list.end(); iterator ++, index ++){
        if(x <= iterator->b && x >= iterator->a){
            k = _exp_linear_list[index].k;
            b = _exp_linear_list[index].b;
            break;
        }
    }
    return x * k + b;
    // return float(long((x * k + b) * (1 << _bit_length))) / (1 << _bit_length);
}

float Softmax::my_ln(float x){
    float k,b;
    int index = 0;
    for(auto iterator = _ln_range_list.begin(); iterator != _ln_range_list.end(); iterator ++, index ++){
        if(x <= iterator->b && x >= iterator->a){
            k = _ln_linear_list[index].k;
            b = _ln_linear_list[index].b;
            break;
        }
    }
    // return float(long((x * k + b) * (1 << _bit_length))) / (1 << _bit_length);
    return x * k + b;
}