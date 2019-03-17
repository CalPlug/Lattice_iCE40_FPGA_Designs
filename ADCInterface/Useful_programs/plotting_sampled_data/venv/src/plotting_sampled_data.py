## --------------------------------------------------------------------------------------
## Organization: CALPLUG-FPGA
## Project Name:
## Date: Winter 2019
## --------------------------------------------------------------------------------------
## File Name: plotting_sampled_data.py
## File Description: This is the main python module that implements the function of
##                   plotting a set of sampled data
## --------------------------------------------------------------------------------------

import matplotlib.pyplot as plt;
import math;

class FailedtoOpenFileError(Exception):
    pass;

def extracting_data_from_file(data_file:"file") -> tuple:
    ''' This is a function that takes in a text file and extracts sampled point/data from it '''
    data_list = [];
    for line in data_file:
        real, imag = line.split();
        #data_list.append(math.sqrt(int(real)**2 + int(imag)**2));
        data_list.append(float(real));
    return tuple(data_list);


def main():
    try:
        data_file = open("data.txt", "r");
        sampled_points_tuple = extracting_data_from_file(data_file);
        plt.plot([i for i in range(len(sampled_points_tuple))], sampled_points_tuple);
        plt.show();
    except:
        raise FailedtoOpenFileError;
    finally:
        data_file.close();

if __name__ == "__main__":
    main();

