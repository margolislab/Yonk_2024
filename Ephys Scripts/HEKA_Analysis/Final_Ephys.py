
#Import these scripts (Install them too!)
from scipy.io import loadmat, matlab
from scipy import interpolate
from scipy import signal
import efel
import pandas as pd
import numpy as np
from tkinter import filedialog
from matplotlib import pyplot as plt
from csv import DictWriter
import csv
from os import chdir, getcwd

#Enable EFEL Settings
efel.setDoubleSetting('interp_step',0.05) #Must be set to the sampling rate (20,000 Hz = 0.05)
efel.setDoubleSetting('voltage_base_start_perc',0.1)
efel.setDoubleSetting('voltage_base_end_perc',0.8)
efel.setDerivativeThreshold(10) #Value can be changed, but normally set to 10
efel.setThreshold(10)

#Create global variable to store parameter information
Results = list()
trace_calc = dict()
User_choices = dict()
Cell = dict()

#Function that loads nested mat structures into a dictionary instead of using dot notation to
#extract individual pieces of data
def load_mat(filename):
    def _check_vars(d):
        for key in d:
            if isinstance(d[key], matlab.mat_struct):
                d[key] = _todict(d[key])
            elif isinstance(d[key], np.ndarray):
                d[key] = _toarray(d[key])
        return d

    def _todict(matobj):
        d = {}
        for strg in matobj._fieldnames:
            elem = matobj.__dict__[strg]
            if isinstance(elem, matlab.mat_struct):
                d[strg] = _todict(elem)
            elif isinstance(elem, np.ndarray):
                d[strg] = _toarray(elem)
            else:
                d[strg] = elem
        return d

    def _toarray(ndarray):
        if ndarray.dtype != 'float64':
            elem_list = []
            for sub_elem in ndarray:
                if isinstance(sub_elem, matlab.mat_struct):
                    elem_list.append(_todict(sub_elem))
                elif isinstance(sub_elem, np.ndarray):
                    elem_list.append(_toarray(sub_elem))
                else:
                    elem_list.append(sub_elem)
            return np.array(elem_list)
        else:
            return ndarray

    data = loadmat(filename, struct_as_record=False, squeeze_me=True)
    return _check_vars(data)

#Allows user to select and set working directory
wd = filedialog.askdirectory()
chdir(wd)

#Opens a dialog box allowing the user to select the file and removes the extension from the file name & load in the file
file_path = filedialog.askopenfilename()
AllData = load_mat(file_path)

#Describe the number of cells present in the file
print('There are *** ' +str(int(AllData['Data']['Projects'])) + ' *** projects in this file.')

#Allows user to choose which cell they want to analyze
User_choices['CellVal'] = int(input('Which project would you like to analyze?: '))

#Selects and stores data in a new variable that can be more easily accessed
SelectCell = AllData['Data']['Proj' + str(User_choices['CellVal'])]

#Prints the number of experiments and type of each experiment for user selection
print('There are *** ' + str(int(SelectCell['Expts'])) + ' *** experiments for this project.' + '\n')
for ii in range(SelectCell['Expts']):
    Cols = np.shape(SelectCell['Expt' + str(ii + 1)]['Cell1']['Exp' + str(ii + 1)])
    if len(Cols) < 2:
        print('Experiment ' + str(ii + 1) + ' is a(n)' + str(SelectCell['Expt' + str(ii+1)]['Cell1']['ExptID' + str(ii + 1)]) + 'contains ***1*** trace.')
        continue
    print('Experiment ' + str(ii + 1) + ' is a(n) ' + str(SelectCell['Expt' + str(ii + 1)]['Cell1']['ExptID' + str(ii + 1)]) + ' contains ***' + str(Cols[1]) + ' *** traces.')

User_choices['ExptVal'] = int(input('Which experiment would you like to analyze?:'))

#Stores all pertinent information into a new variable that will be accessed for all analyses
Cell['ExptID'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['Cell1']['ExptID' + str(User_choices['ExptVal'])]
Cell['Data'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['Cell1']['Exp' + str(User_choices['ExptVal'])]
Cell['Stim'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['Cell1']['Stim' + str(User_choices['ExptVal'])]
Cell['TraceMax'] = np.shape(Cell['Data'])
Cell['Time'] = AllData['Data']['Time'][0:Cell['Data'].shape[0]]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  Analysis Section--IV Analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Calculates IV curve parameters including spikecount, RMP, Rin, Freq, HHW, etc.
if 'IV' in Cell['ExptID']:
    User_choices['IV_graph'] = int(input('Would you like to save the graph? (Input 1): '))
    User_choices['IV_output'] = int(input('Would you like to output the results as a CSV? (Input 1): '))

    #Initialize sweep counter and other standards
    i = 0
    Stim_start = 4000
    Stim_end = 13999
    
    
    for i in range(i,Cell['TraceMax'][1],1):
        FDerv = np.diff(Cell['Data'][Stim_start:Stim_end,i]) / 0.05
        Spikes = np.where(FDerv > 200)
    
    
    
    
    
    
    
    
