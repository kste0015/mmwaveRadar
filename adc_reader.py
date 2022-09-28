import numpy as np
from matplotlib import pyplot as plt
import csv

if __name__ == '__main__':
    data = []
    with open('adc_data_real.csv', 'r',newline='') as csvfile:
        csvreader = csv.reader(csvfile,delimiter=',')
        line_count = 0
        for row in csvreader:
            data.append(row)
        
    print('hi')