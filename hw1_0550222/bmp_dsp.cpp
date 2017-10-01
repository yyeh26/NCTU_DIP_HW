#include <iostream>
#include <fstream>
#include <math.h>


using namespace std;


bmp_dsp::bmp_dsp()
{
    cout << "bmp_dsp built" << endl;
}

bmp_dsp::~bmp_dsp()
{
    //delete [] _header;
    //delete [] _image ;
    //delete [] _image_out;

}

bool bmp_dsp::write(const char *filename)
{

    ofstream file_img(filename, ios::out | ios::binary);
    char zero_char = 0;

    if(!file_img){
        cout << "False to write the file" << endl;
    }

    file_img.write( _header_out, sizeof(char)*54);
    cout << "Output Dimension: " <<(*(int*)&_header_out[18]) << ", " << (*(int*)&_header_out[22]) << endl;
    cout << "Output Padding:" << _padding_output << endl;
    file_img.write( _image_out,  sizeof(char)* ( (*(int*)&_header_out[18])*_channel + _padding_output ) * (*(int*)&_header_out[22])  );
    file_img.write(  &zero_char,  sizeof(char)* 2 );
    file_img.close();

    return true;
}

void bmp_dsp::clone()
{
    _header_out = _header;
    _image_out = _image;
    _padding_output = _padding_input;
}

void bmp_dsp::quanti(const int quanti_factor){

    _header_out = _header;
    _padding_output = _padding_input;
    _image_out = new char[ ( (*(int*)&_header_out[18]) + _padding_output ) * (*(int*)&_header_out[22]) * _channel];
    for(int i=0 ; i < ( (*(int*)&_header_out[18]) + _padding_output ) * (*(int*)&_header_out[22]) *_channel ; ++i)
    {
        _image_out[i] = ( (unsigned int)_image[i] >> quanti_factor ) << quanti_factor;
    }
}

void bmp_dsp::scaling(const bool bl_up_scaling)
{
    if(bl_up_scaling)
    {
        *(int*)&_header[18] = _width*2;
        *(int*)&_header[22] = _height*2;
        _padding_output = (4-_width*2*_channel%4)%4 ;
        cout << "UP SCALING OUTPUT PADDING:"  << _padding_output << endl;
        _image_out = new char[ _height*2 * (_width*2+_padding_output) * _channel ];
        double i_in, j_in ;
       for( int i=0 ; i < _height*2 ; ++i ){
            for( int j=0 ; j < _width*2 ; ++j ){
                for (int k=0 ; k < _channel ; ++k ){
                    /*if( (i < (_height-1))&&(j < (_width-1)) ){
                        _image_out[ i*2   *(2*_width*_channel+_padding_output)+ j*2   *_channel+k ] =  _image[ i*(_width*_channel+_padding_input)+j*_channel+k ] ;
                        _image_out[(i*2+1)*(2*_width*_channel+_padding_output)+ j*2   *_channel+k ] = ( (unsigned char)_image[ i*(_width*_channel+_padding_input)+j*_channel+k ] + (unsigned char)_image[ (i+1)*(_width*_channel+_padding_input)+(j  )*_channel+k ] )/2;
                        _image_out[ i*2   *(2*_width*_channel+_padding_output)+(j*2+1)*_channel+k ] = ( (unsigned char)_image[ i*(_width*_channel+_padding_input)+j*_channel+k ] + (unsigned char)_image[ i    *(_width*_channel+_padding_input)+(j+1)*_channel+k ] )/2 ;
                        _image_out[(i*2+1)*(2*_width*_channel+_padding_output)+(j*2+1)*_channel+k ] = ( (unsigned char)_image[ i*(_width*_channel+_padding_input)+j*_channel+k ] + (unsigned char)_image[ (i+1)*(_width*_channel+_padding_input)+(j+1)*_channel+k ] )/2 ;
                    }
                    else
                    {
                        _image_out[ i*2   *(2*_width*_channel+_padding_output)+ j*2  *_channel+k ] = _image[ i*(_width*_channel+_padding_input)+j*_channel+k ] ;
                        _image_out[(i*2+1)*(2*_width*_channel+_padding_output)+ j*2  *_channel+k ] = _image[ i*(_width*_channel+_padding_input)+j*_channel+k ] ;
                        _image_out[ i*2   *(2*_width*_channel+_padding_output)+(j*2+1)*_channel+k ] = _image[ i*(_width*_channel+_padding_input)+j*_channel+k ] ;
                        _image_out[(i*2+1)*(2*_width*_channel+_padding_output)+(j*2+1)*_channel+k ] = _image[ i*(_width*_channel+_padding_input)+j*_channel+k ] ;
                    }*/
                    i_in = ( ((double)_height-1)/((double)_height*2-1) ) * (double)i ;
                    j_in = ( ((double) _width-1)/((double) _width*2-1) ) * (double)j ;

                    _image_out[ i*(_width*2*_channel+_padding_input)+j*_channel+k ] = (unsigned char)_image[ ((int)floor(i_in))*(_width*_channel+_padding_input)+((int)floor(j_in))*_channel+k ]*( 1-( i_in-floor(i_in) ) )*( 1-( j_in-floor(j_in) ) ) +
                                                                                      (unsigned char)_image[ ((int) ceil(i_in))*(_width*_channel+_padding_input)+((int)floor(j_in))*_channel+k ]*(     i_in-floor(i_in)   )*( 1-( j_in-floor(j_in) ) ) +
                                                                                      (unsigned char)_image[ ((int)floor(i_in))*(_width*_channel+_padding_input)+((int) ceil(j_in))*_channel+k ]*( 1-( i_in-floor(i_in) ) )*(     j_in-floor(j_in)   ) +
                                                                                      (unsigned char)_image[ ((int) ceil(i_in))*(_width*_channel+_padding_input)+((int) ceil(j_in))*_channel+k ]*(     i_in-floor(i_in)   )*(     j_in-floor(j_in)   ) ;
                }
            }
        }
        _header_out = _header;
    }
    else
    {
        *(int*)&_header[18] = _width/2;
        *(int*)&_header[22] = _height/2;
        _padding_output = (4-_width/2*_channel%4)%4;
        _image_out = new char[ _height/2 * (_width/2*_channel+_padding_output) ];

        cout << (*(int*)&_header[18]) << ", " << (*(int*)&_header[22]) << endl;

        for( int i=0 ; i < _height/2 ; ++i ){
            for( int j=0 ; j < _width/2 ; ++j ){
                for (int k=0 ; k < _channel ; ++k ){
                        _image_out[ i*(_width/2*_channel+_padding_output)+j*_channel+k ] =  _image[ i*2*(_width*_channel+_padding_input)+j*2*_channel+k ] ;
                }
            }
        }
        _header_out = _header;
    }
}

bool bmp_dsp::read(const char *filename)
{
    ifstream file_img(filename, ios::in|ios::binary);
    if(!file_img.is_open()){
        cout << "FILE OPEN FAIL" << endl;
    }


    //read header
    _header = new char[54];
    file_img.read( (char*)_header, sizeof(char)*54 );
    _width = *(int*)&_header[18];
    _height = *(int*)&_header[22];
    _bitDepth = *(int*)&_header[28];
    _channel = _bitDepth/8;
    _padding = 0;
    _padding_input = (4-_width*_channel%4)%4;
    cout << "Input Dimension:" << _width << ", " << _height << endl;
    cout << "Input Padding:" << _padding_input << endl;

    _image = new char[ _height*( _width+_padding_input )*_channel  ];
    file_img.read( _image, sizeof(char)*_height*( _width+_padding_input )*_channel );

    file_img.close();
    return true;
}

