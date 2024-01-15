#ifndef __SOFTMAX_H__
#define __SOFTMAX_H__
#include <vector>
#include "NAF.cpp"
#include "NAF.hpp"

using namespace std;

class Softmax
{
public:
    Softmax(){};
    Softmax(vector<float>& sample, Activation_function& ln, Activation_function& exp, int bit_length);
    ~Softmax(){};
    void work();
    float report_mae(){return _mae;}
    float report_aae(){return _aae;}
    float report_mse(){return _mse;}
    vector<float> get_result(){return _result;}
    vector<range> _ln_range_list;
    vector<linear> _ln_linear_list;
    vector<range> _exp_range_list;
    vector<linear> _exp_linear_list;

private:
    vector<float> _sample;
    vector<float> _result;
    vector<float> _origin;
    int _bit_length;
    float _mae; // maximum absolute error
    float _aae; // average absolute error
    float _mse; // mean square error
    float my_exp(float x);
    float my_ln(float x);    
};


#endif