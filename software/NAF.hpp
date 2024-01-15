#ifndef __NAF_H__
#define __NAF_H__

#include <iostream>
#include <string>
#include <vector>
#include <math.h>

typedef struct{
    float a;
    float b;
}range;

typedef struct{
    float k;
    float b;
}linear;

using namespace std;

class Activation_function
{
public:
    Activation_function(){};
    Activation_function(string a, int bit_length, int mini_length, int range_num, int k_bit_length, int b_bit_length);
    ~Activation_function(){};
    void work(){
        refine_ranges();
        optimize();
    }
    float report_mae(){return _mae;}
    float report_aae(){return _aae;}
    float report_mse(){return _mse;}
    vector<linear> report_linear_list(){return _linear_list;}
    vector<range> report_range_list(){return _range_list;}
    int _points_num;
    int _bit_length;
    int _mini_length;
    int _range_num;
    int _k_bit_length; 
    int _b_bit_length;
    
    float _mini_range;

private:
    vector<float> _x_list;
    vector<float> _original_list;
    //vector<float> approximate_list;
    vector<range> _range_list;
    vector<linear> _linear_list;
    float _mae; // maximum absolute error
    float _aae; // average absolute error
    float _mse; // mean square error

    void lineplofit(vector<float>& x, vector<float>& y, int num, linear* result);
    float get_error(int num, vector<float>& a, vector<float>& b);
    void refine_ranges();
    void optimize();
    void generate_approximate(vector<float>& x, linear& a, vector<float>* y);
    float get_mae(int num, vector<float>& a, vector<float>& b);
    float get_sae(int num, vector<float>& a, vector<float>& b); //sae: sum of the absolute error
};

#endif