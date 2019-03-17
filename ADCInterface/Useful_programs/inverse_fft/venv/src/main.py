## --------------------------------------------------------------------------------------
## Organization: CALPLUG-FPGA
## Project Name:
## Date: Winter 2019
## --------------------------------------------------------------------------------------
## File Name: plotting_sampled_data.py
## File Description: This is the main python module that implements the function of
##                   plotting a set of sampled data
## --------------------------------------------------------------------------------------


## ------------------------ ##
##     GLOBAL CONSTANT      ##
## ------------------------ ##

input_file_name = "input_data.txt";
output_file_name = "output_data.txt";

default_dataset = tuple([500 if i == 4 else 0 for i in range(256)]);

## ------------------------ ##

import numpy;
import numpy.fft as fft;

class Inverse_FFT_calculator:
    def __init__(self, dataset = tuple()):
        self.dataset = dataset;
        self.inversed_result = tuple();
        self.input_file_name = input_file_name;
        self.output_file_name = output_file_name;

    def get_dataset(self, lst:list):
        self.dataset = tuple(lst);

    def calculate(self):
        ''' This is the main function that calcualtes the inverse fft of the stored dataset'''
        print("Calculating the inverse fourier transform of the stored data set...\n");
        self.inversed_result = fft.ifft(self.dataset);

    def extract_data_from_file(self):
        try:
            print("Extracting from file <{}>...".format(self.input_file_name));
            file = open(self.input_file_name, "r");
            data_list = [];
            for line in file:
                real, imag = line.split();
                data_list.append(complex(int(real),int(imag)));
            self.dataset = tuple(data_list);
        finally:
            file.close();



    def write_inversed_to_file(self):
        try:
            print("writing to file <{}>...".format(self.output_file_name));
            if self.dataset != tuple():
                file = open(self.output_file_name, "w+");
                for data_pnt in self.inversed_result:
                    file.write("{} {}\n".format(data_pnt.real, data_pnt.imag));
                print("Calculation and Write is SUCCESSFUL!!");
            else:
                print("No data found inside the file <{}>".format(self.input_file_name));
        finally:
            file.close();







if __name__ == "__main__":

    ifft = Inverse_FFT_calculator(default_dataset);
    #ifft.extract_data_from_file();
    ifft.calculate();
    ifft.write_inversed_to_file();



    '''
    for i in fft.ifft([0,4,0,0]):
        print(type(i));
    '''

    '''
    a = numpy.array([1 + 2j, 3 + 4j, 5 + 6j]);
    for i in a:
        print(i.real);
        '''


