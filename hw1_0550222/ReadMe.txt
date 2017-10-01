

To run the homework assignment functionalities, 

CLONE:

1. Open file "imgRWbmp.cpp" 
2. Change the input/output filemane ( Reference the bmp_dsp class below ) 
3. Press compile and run 

QUANTIZATION:

1. Open file "imgQR.cpp"
2. Change the input/output filemane ( Reference the bmp_dsp class below )  
3. Press compile and run 
 
SCALING

1. Open file "imgScaling.cpp"
2. Change the input/output filemane ( Reference the bmp_dsp class below )  
3. Press compile and run 

----------------------------------------------------------------------------

bmp_dsp class is a self-define class with following public functions:

bmp_dsp( ): constructor
read( Input Filename ): read the file from given path.
write( Input Filename ): write the file to given path.
quanti( quantization factor): quantization factor will quantize the give byte from LSB.
scaling( ): True for scaling up, false for scaling down. 
