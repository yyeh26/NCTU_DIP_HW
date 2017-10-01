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
    bmp_dsp bmp_clone;
    bmp_clone.read("Data/input2.bmp");
    bmp_clone.clone();
    bmp_clone.write("output_data/input2.bmp");

    return 0;
}


