#include <iostream>
#include <fstream>
#include <stdio.h>
#include "bmp_dsp.h"
#include "bmp_dsp.cpp"
#define BMP_WIDTH_BIT 18
#define BMP_HEIGHT_BIT 22
#define SCALE_UP true
#define SCALE_DOWN false
using namespace std;
int main()
{
    bmp_dsp bmp_quanti_1;
    bmp_quanti_1.read("Data/input2.bmp");
    bmp_quanti_1.quanti(2);
    bmp_quanti_1.write("output_data/input2_1.bmp");

    bmp_dsp bmp_quanti_2;
    bmp_quanti_2.read("Data/input2.bmp");
    bmp_quanti_2.quanti(2);
    bmp_quanti_2.write("output_data/input2_2.bmp");

    bmp_dsp bmp_quanti_3;
    bmp_quanti_3.read("Data/input2.bmp");
    bmp_quanti_3.quanti(7);
    bmp_quanti_3.write("output_data/input2_3.bmp");
    return 0;
}


