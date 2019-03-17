## --------------------------------------------------------------------------------------
## Organization: CALPLUG-FPGA
## Project Name:
## Date: Winter 2019
## --------------------------------------------------------------------------------------
## File Name: generate_digital_sine_wave.py
## File Description: This is the main python module that generates digital sampled points
##                   of a user_defined sine wave
## --------------------------------------------------------------------------------------

import math;

##-------------------##
##  GLOBAL CONSTANT  ##
##-------------------##

COSINE_WAVE_FREQUENCY = 10;
COSINE_WAVE_PERIOD = 1/COSINE_WAVE_FREQUENCY;
COSINE_WAVE_AMPLITUDE = 100;


SAMPLING_FREQUENCY = 256;        # SAMPLING_FREQUENCY must exceed twice of the SINE_WAVE_FREQUENCY
TOTAL_SAMPLING_POINTS = 256;

##===================##


class cosine_wave:
    def __init__(self, frequency = COSINE_WAVE_FREQUENCY, amplitude = COSINE_WAVE_AMPLITUDE, \
                 sampling_frequency = SAMPLING_FREQUENCY, total_sampling_points = TOTAL_SAMPLING_POINTS):
        self._f = frequency;
        self._p = 1/frequency;
        self._a = amplitude;

        self._num_of_binary_bits_required = math.ceil(math.log(self._a*2+1, 2));
        self._samplingFrequency = sampling_frequency;
        self._total_sampling_points = total_sampling_points;
        self._sampling_gap_period = 1/self._samplingFrequency;
        self._function = lambda t : self._a * math.cos(self._f * t);

    def generate_sampled_points(self) -> (float):
        ''' This function returns a tuple of FLOATING POINT numbers '''
        return tuple( [self._function(t) for t in [ (0+self._sampling_gap_period*n) for n in range(self._total_sampling_points) ] ] );

    @staticmethod
    def replace_str_char_with_index(i: int, s_original:str, s_replaced: str) -> str:
        return s_original[:i] + s_replaced + s_original[i+1:];
    
    def twos_complement(self, binary_num:str) -> str:
        '''
        This function takes in a SIGNED binary number in string and return its correct form in twos complement.
            e.g.
                self._num_of_binary_bits_required = 8;
                    str("-10111") --> str("11101001")
        '''
        if (binary_num[0] == '-'):
            ones_complement_num = ''.join([ "1" if s == "0" else "0" for s in binary_num[1:] ]);
            twos_complement_num = ones_complement_num;
            
            for i in range(len(ones_complement_num)-1, 0, -1):
                if (ones_complement_num[i] == '0'):
                    twos_complement_num = cosine_wave.replace_str_char_with_index(i, twos_complement_num, '1');
                    break;
                else:
                    twos_complement_num = cosine_wave.replace_str_char_with_index(i, twos_complement_num, '0');
            else:
                twos_complement_num = '1' + twos_complement_num;

            return (self._num_of_binary_bits_required-len(twos_complement_num)) * "1" + twos_complement_num;
        else:
            return (self._num_of_binary_bits_required-len(binary_num)) * "0" + binary_num;
            
    
    def generate_digital_sampled_points(self)-> (str):
        ''' This function returns a tuple of STRING that represent the binary numbers'''
        print( "Generating Sampled Points: " );
        print( "This set of Sampled Data is {0} bits each...".format(self._num_of_binary_bits_required) );
        
        return tuple( [ self.twos_complement(("{:b}".format(math.floor(d)))) for d in self.generate_sampled_points() ] );
        
if __name__ == "__main__":
    generated_sampled_points = cosine_wave().generate_digital_sampled_points();
    for pnt in generated_sampled_points:
        print(pnt);

    file_name = "generated_data.txt"
    print("Writing to a text file called <{}>...".format(file_name));

    
    try:
        f = open(file_name, "w+");
        for data in generated_sampled_points:
            f.write(str(data)+'\n');
        print("Write to file SUCCESSFUL!!")
    finally:
        f.close();
   
'''
    try:
        f = open(file_name, "w+");
        for i in range(256):
            if (i == 3):
                f.write("01111111");
            else:
                f.write("00000000");
        print("Write to file SUCCESSFUL!!");
    finally:
        f.close();
'''





