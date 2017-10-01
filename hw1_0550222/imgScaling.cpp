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
    bmp_dsp bmp_up;
    bmp_up.read("Data/input2.bmp");
    bmp_up.scaling(SCALE_UP);
    bmp_up.write("output_data/input2_up.bmp");

    bmp_dsp bmp_down;
    bmp_down.read("Data/input2.bmp");
    bmp_down.scaling(SCALE_DOWN);
    bmp_down.write("output_data/input2_down.bmp");

    return 0;
}


