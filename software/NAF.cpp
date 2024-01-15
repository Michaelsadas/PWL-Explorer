#include "NAF.hpp"

Activation_function::Activation_function(string a, int bit_length, int mini_length, int range_num, int k_bit_length, int b_bit_length){
    _bit_length = bit_length;
    _mini_length = mini_length;
    _range_num = range_num;
    _k_bit_length = k_bit_length;
    _b_bit_length = b_bit_length;
    _mini_range = 1.0 / pow(2.0, _mini_length);

    int i;
    double step = 1.0 / pow(2.0, _bit_length);
    float inter1, inter2, inter3;
    range temp_range;

    if(a != "ln"){
        _points_num = (int)pow(2, _bit_length) * 8;
        for(i = 0; i < 8; i = i + 2){
            temp_range.a = -8 + i;
            temp_range.b = -6 + i;
            _range_list.push_back(temp_range);
        }
        for(i = 0; i < _points_num; i++){
            _x_list.push_back(-8.00 + i * step);
        }
        if(a == "Sigmoid"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(1 / (1 + exp(-_x_list[i])));
            }
        }
        else if(a == "Swish"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(_x_list[i] / (1 + exp(-_x_list[i])));
            }
        }
        else if(a == "Tanh"){
            for(i = 0; i < _points_num; i++){
                inter1 = exp(-_x_list[i]);
                inter2 = exp(_x_list[i]);
                _original_list.push_back((inter2 - inter1) / (inter2 + inter1));
            }
        }
        else if(a == "Elu"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(_x_list[i] > 0 ? _x_list[i] : (exp(_x_list[i]) - 1));
            }
        }
        else if(a == "Relu"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(_x_list[i] > 0 ? _x_list[i] : 0);
            }        
        }
        else if(a == "Gelu"){
            for(i = 0; i < _points_num; i++){
                inter1 = pow(2 / M_PI, 0.5) * (_x_list[i] + 0.044715 * pow(_x_list[i], 3.0));
                inter2 = exp(-inter1);
                inter3 = exp(inter1);
                _original_list.push_back(0.5 * _x_list[i] * (inter3 - inter2) / (inter3 + inter2));
            }        
        }
        else if(a == "Softplus"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(log(1 + exp(_x_list[i])));
            }          
        }
        else if(a == "Exp"){
            for(i = 0; i < _points_num; i++){
                _original_list.push_back(exp(_x_list[i]));
            }  
        } else {
        cout << "Fail to find the target function." << endl;
        exit(1);
    }
    }
    else if (a == "ln"){
        _points_num = (int)pow(2, _bit_length) * 1;
        for(i = 0; i < 4; i ++){
            temp_range.a = 1 + i * 0.25;
            temp_range.b = 1 + i * 0.25 + 0.25;
            _range_list.push_back(temp_range);
        }
        for(i = 0; i < _points_num; i++){
            _x_list.push_back(1.00 + i * step);
        }
        for(i = 0; i < _points_num; i++){
            _original_list.push_back(log(_x_list[i]));
        }

    }
}

void Activation_function::lineplofit(vector<float>& x, vector<float>& y, int num, linear* result){
    float sum_x2 = 0.0;
    float sum_y = 0.0;
    float sum_x = 0.0;
    float sum_xy = 0.0;
    int i;
    for (i = 0; i < num; ++i)
    {
        sum_x2 += x[i] * x[i];
        sum_y += y[i];
        sum_x += x[i];
        sum_xy += x[i] * y[i];
    }
    float tmp = num * sum_x2 - sum_x * sum_x;
    if (abs(tmp) > 0.000001f)
    {
        result->k = (num * sum_xy - sum_x * sum_y) / tmp;
        result->b = (sum_x2 * sum_y - sum_x * sum_xy) / tmp;
    }
    else
    {
        result->k = 0;
        result->b = x[0];
    }
}

float Activation_function::get_error(int num, vector<float>& a, vector<float>& b){
    float error = 0;
    for(int i = 0; i < num; i++){
        error += (a[i] - b[i]) * (a[i] - b[i]);
    }
    return error;
}

void Activation_function::generate_approximate(vector<float>& x, linear& a, vector<float>* y){
    int n = x.size();
    float tmp;
    vector<float> result;
    for(int i = 0; i < n; i++){
        tmp = float(long((x[i] * a.k + a.b) * (1 << _bit_length))) / (1 << _bit_length);
        // tmp = x[i] * a.k + a.b;
        if((*y).size() <= i) (*y).push_back(tmp);
        else (*y)[i] = tmp;
    }
};

void Activation_function::refine_ranges(){
    int n = _range_list.size();
    int start, end;
    float range_begin;
    int index;
    int inner_num;
    float signal;
    vector<float> inter_x;
    vector<float> inter_origin;
    vector<float> inter_y;
    float temp_error;
    float min_error;
    float record_index = 0;
    float new_range_length;
    range new_range1, new_range2;
    linear temp_linear;

    while(n < _range_num){
        index = 0;
        start = 0;
        end = 0;
        min_error = -1;
        for(auto iterator = _range_list.begin(); iterator != _range_list.end(); iterator ++, index++){
            inner_num = (iterator->b - iterator->a) * _points_num / (_x_list[_points_num - 1] - _x_list[0]);
            end = start + inner_num;
            inter_x.assign(_x_list.begin() + start, _x_list.begin() + end); 
            inter_origin.assign(_original_list.begin() + start, _original_list.begin() + end); 
            lineplofit(inter_x, inter_origin, inner_num, &temp_linear);
            if(_linear_list.size() <= index) _linear_list.push_back(temp_linear);
            else _linear_list[index] = temp_linear;
            start += inner_num;
            
            generate_approximate(inter_x, _linear_list[index], &inter_y);
            temp_error = get_error(inner_num, inter_origin, inter_y);
            if(temp_error > min_error && (iterator->b - iterator->a) > _mini_range){
                record_index = index;
                min_error = temp_error;
            }
        }
        new_range_length = (_range_list[record_index].b - _range_list[record_index].a) / 2;
        range_begin = _range_list[record_index].a;
        new_range1.a = range_begin;
        new_range1.b = new_range2.a = range_begin + new_range_length;
        new_range2.b = range_begin + 2 * new_range_length;
        _range_list.erase(_range_list.begin() + record_index);
        _range_list.insert(_range_list.begin() + record_index, new_range2);
        _range_list.insert(_range_list.begin() + record_index, new_range1);
        n++;
    }

    start = 0;
    index = 0;
    for(auto iterator = _range_list.begin(); iterator != _range_list.end(); iterator ++, index++){
        inner_num = (iterator->b - iterator->a) * _points_num / (_x_list[_points_num - 1] - _x_list[0]);
        end = start + inner_num;
        inter_x.assign(_x_list.begin() + start, _x_list.begin() + end); 
        inter_origin.assign(_original_list.begin() + start, _original_list.begin() + end); 
        lineplofit(inter_x, inter_origin, inner_num, &temp_linear);
        if(_linear_list.size() <= index) _linear_list.push_back(temp_linear);
        else _linear_list[index] = temp_linear;
        start += inner_num;
    }

    for(auto iterator = _linear_list.begin(); iterator != _linear_list.end(); iterator ++){
        iterator->k = float(long(iterator->k * (1 << _k_bit_length))) / (1 << _k_bit_length);
        iterator->b = float(long(iterator->b * (1 << _b_bit_length))) / (1 << _b_bit_length);
    }
}

void Activation_function::optimize(){
    vector<float> inter_x;
    vector<float> inter_origin;
    vector<float> inter_y;
    int inner_num;
    int start = 0;
    int end = 0;
    int index = 0;
    float temp_k;
    float temp_b;
    float k_mini_change = 1.0 / (1 << _k_bit_length);
    float b_mini_change = 1.0 / (1 << _b_bit_length);
    float sum_error = 0;
    float sae = 0;
    float temp_error;
    float min_error;
    float temp_mae;
    float max_mae = 0;
    linear temp_linear, opt_linear;

    for(auto iterator = _range_list.begin(); iterator != _range_list.end(); iterator ++, index ++){
        inner_num = (iterator->b - iterator->a) * _points_num / (_x_list[_points_num - 1] - _x_list[0]);
        end = start + inner_num;
        inter_x.assign(_x_list.begin() + start, _x_list.begin() + end);
        inter_origin.assign(_original_list.begin() + start, _original_list.begin() + end);
        start += inner_num;

        min_error = 1000;
        for(temp_k = -2 * k_mini_change; temp_k < 3 * k_mini_change; temp_k += k_mini_change){
            for(temp_b = -2 * b_mini_change; temp_b < 3 * b_mini_change; temp_b += b_mini_change){
                temp_linear.k = _linear_list[index].k + temp_k;
                temp_linear.b = _linear_list[index].b + temp_b;

                generate_approximate(inter_x, temp_linear, &inter_y);
                temp_error = get_error(inner_num, inter_y, inter_origin);
                if(temp_error < min_error){
                    opt_linear.k = temp_linear.k;
                    opt_linear.b = temp_linear.b;
                    min_error = temp_error;
                }
            }
        }
        sum_error += min_error;
        _linear_list[index].k = opt_linear.k;
        _linear_list[index].b = opt_linear.b;
        generate_approximate(inter_x, opt_linear, &inter_y);
        temp_mae = get_mae(inner_num, inter_y, inter_origin);
        if(temp_mae > max_mae){
            max_mae = temp_mae;
        }
        sae += get_sae(inner_num, inter_y, inter_origin);
    }
    _mae = max_mae;
    _mse = sum_error / _points_num;
    _aae = sae / _points_num;
}

float Activation_function::get_mae(int num, vector<float>& a, vector<float>& b){
    float mae = 0;
    float temp;
    for(int i = 0; i < num; i++){
        temp = fabs(a[i] - b[i]);
        if(temp > mae){
            mae = temp;
        }
    }
    return mae;
};

float Activation_function::get_sae(int num, vector<float>& a, vector<float>& b){
    float sae = 0;
    for(int i = 0; i < num; i++){
        sae += fabs(a[i] - b[i]);
    }
    return sae;
}; 