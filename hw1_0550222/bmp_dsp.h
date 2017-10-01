#include <iostream>
#include <vector>
using namespace std;

class bmp_dsp{
public:

    bmp_dsp();
    ~bmp_dsp();

    bool read(const char *filename);
    bool write(const char *filename);
    void quanti(const int quati_factor);
    void scaling(const bool bl_up_scaling);
    void clone();
private:
    char* _header;
    char* _image;

    int _width;
    int _height;
    int _channel;
    short _bitDepth;
    int _usedColor;
    int _padding;
    int _padding_input;
    int _padding_output;

    char* _header_out;
    char* _image_out;

};
