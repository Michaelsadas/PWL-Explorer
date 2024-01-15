#include "softmax.hpp"
#include "softmax.cpp"
#include <string>
#include <string.h>
#include <iostream>
#include <fstream>
#include <random>
using namespace std;

int get_num(char* a)
{
    int size = strlen(a);
    int num = 0;
    for(int i = 0; i < size; i++){
        num = num * 10 + a[i] - '0';
    }
    return num;
}

void generate_sample(vector<float> &sample)
{
    default_random_engine e;
    uniform_real_distribution<float> u(-8,8);
    e.seed(3);

    for(int i = 0; i < 4096; i ++){
        sample.push_back(u(e));
    }
    return;
}

int main(int argc, char* argv[]){
    string target;
    int bit_length, mini_length1, range_num1, mini_length2, range_num2, k_bit_length, b_bit_length;
    float aae, mse, mae;
    vector<float> sample; //{1.0, -1.0, 1.0, 4.0, 5.0, 6.0, 7.0, -7.8, 5.0, 4.8};

    if (argc < 9){
        cout << "Too few input parameters" << endl;
        return 1;
    }else{
        target = argv[1];
        cout << "Target is " << target << endl;
        bit_length = get_num(argv[2]);
        cout << "Bit_length is " << bit_length << endl;
        mini_length1 = get_num(argv[3]);
        cout << "Mini_length1 is " << mini_length1 << endl;
        range_num1 = get_num(argv[4]);
        cout << "Range_num1 is " << range_num1 << endl;
        mini_length2 = get_num(argv[5]);
        cout << "Mini_length2 is " << mini_length2 << endl;
        range_num2 = get_num(argv[6]);
        cout << "Range_num2 is " << range_num2 << endl;
        k_bit_length = get_num(argv[7]);
        cout << "K_bit_length is " << k_bit_length << endl;
        b_bit_length = get_num(argv[8]);
        cout << "B_bit_length is " << b_bit_length << endl;
    }

    if(target == "Softmax"){
        generate_sample(sample);
        Activation_function ln("ln", bit_length, mini_length1, range_num1, k_bit_length, b_bit_length);
        Activation_function exp("Exp", bit_length, mini_length2, range_num2, k_bit_length, b_bit_length);
        ln.work();
        exp.work();
        Softmax softmax(sample, ln, exp, bit_length);
        softmax.work();
        aae = softmax.report_aae();
        mae = softmax.report_mae();
        mse = softmax.report_mse();
    }else{
        Activation_function a(target, bit_length, mini_length1, range_num1, k_bit_length, b_bit_length);
        a.work();
        aae = a.report_aae();
        mae = a.report_mae();
        mse = a.report_mse();
    }

    ofstream file;
    file.open("result.txt");
    if(!file.is_open()){
        exit(EXIT_FAILURE);
    }
    file << mae << " " << aae << " " << mse << endl;
    file.close();
    //bit_length = argv[];
    /*Activation_function a("Sigmoid", 8, 3, 16, 2, 2);
    a.work();
    float err = a.report_mae();
    cout << err << endl;
    //Activation_function::Activation_function(string a, int bit_length, int mini_length, int range_num, int k_bit_length, int b_bit_length){
    //Activation_function a("Exp", 4096, 16, 0.125, 9);
    Activation_function ln("ln", 8, 8, 0.125, 9);
    Activation_function exp("Exp", 8, 16, 0.125, 9);
    ln.work();
    exp.work();

    //vector<float> sample = {1.0, -1.0, 1.0, 4.0, 5.0, 6.0, 7.0};
    //Softmax softmax(sample, ln, exp);
    //softmax.work();*/


    return 0;
}