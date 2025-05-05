#                 EFEL for Dual HEKA DAT Files v1.0
#                   *Created by AY on 3/25/2022*
#                   *Last Updated on 4/08/2022*
#     *For any issues or bugs, please contact alex.yonk2@gmail.com*
#*This script was designed to analyze electrophysiological parameters from HEKA .dat files converted into mat files
#*It must be used in conjunction with the ***HEKA_importerV2*** MATLAB script
#*The output can be combined with the EI_Balance_Analysis to perform E/I analysis
#*****However, the E/I analysis requires text file output from the SP CC and the SP E/I analysis from this script
#*Averages can be calculated through the accompanying Multi_SP/PPR/Train scripts

#Import these scripts (Install them too!)
from scipy.io import loadmat, matlab
from scipy import interpolate
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
            if isinstance(d[key], matlab.mio5_params.mat_struct):
                d[key] = _todict(d[key])
            elif isinstance(d[key], np.ndarray):
                d[key] = _toarray(d[key])
        return d

    def _todict(matobj):
        d = {}
        for strg in matobj._fieldnames:
            elem = matobj.__dict__[strg]
            if isinstance(elem, matlab.mio5_params.mat_struct):
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
                if isinstance(sub_elem, matlab.mio5_params.mat_struct):
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
    print('Experiment ' + str(ii + 1) + ' is a(n) ' + str(SelectCell['Expt' + str(ii + 1)]['Cell1']['ExptID' + str(ii + 1)]) + ' contains ***' + str(Cols[1]) + ' *** traces.')

User_choices['ExptVal'] = int(input('Which experiment would you like to analyze?:'))

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
#Calculates IV curve parameters FOR ONE CELL including spikecount, RMP, Rin, Freq, etc.
if 'IV' in Cell['ExptID']:
    User_choices['IV_graph'] = int(input('Would you like to save the graph? (Input 1): '))
    User_choices['IV_output'] = int(input('Would you like to output the results as a CSV? (Input 1): '))
# %%  
    i = 0
    for i in range(i,Cell['TraceMax'][1],1):
        trace1 = {}
        trace1['T'] = Cell['Time'][:]
        trace1['V'] = Cell['Data'][:,i]
        trace1['stim_start'] = [200.5]
        trace1['stim_end'] = [700]
        traces = [trace1]
        traces_results = efel.getFeatureValues(traces,['Spikecount','voltage_base','peak_voltage','peak_time'])
        
        #If a Spikecount of 0 is detected, continue for loop
        #Cannot append "N/A" as the DictWriter won't work
        if traces_results[0]['Spikecount'] == 0:
            continue        
    
        if traces_results[0]['Spikecount'] == 1:
            #Calculate input resistance based on lowest hyperpolarizing step (Hard coded hyperpolarizing step)
            Vin = (((Cell['Data'][6000,4]) - (Cell['Data'][2000,4])) / 1000) #Voltage is calculated in mV, but converted to V
            Iin = (((Cell['Stim'][6000,4]) - (Cell['Stim'][2000,4])) / 1000000) #Current is calculated in microA, but converted to A
            traces_results[0]['Rin'] = (Vin/Iin) / 1000 #Resistance is provided in MOhms
            traces_results[0]['Rheo'] = ((Cell['Stim'][4001,i])*1000)+1
            Trace_Results = {'AP #': int(traces_results[0]['Spikecount']),
                             'RMP': float(traces_results[0]['voltage_base']),
                             'Rin': traces_results[0]['Rin'],
                             'Rheobase': int(traces_results[0]['Rheo'])}
            Results.append(Trace_Results)
            
            plt.plot(Cell['Time'],Cell['Data'][:,i])
            plt.scatter(traces_results[0]['peak_time'],traces_results[0]['peak_voltage'] + 20,c='r',marker = '+')
            plt.xlabel('Time (in ms)')
            plt.ylabel('Voltage (in mV)')
            plt.show()
            continue
    
        #If Spikecount is greater than 1, the code continues as normal
        if traces_results[0]['Spikecount'][0] >= 2:
            traces_results = efel.getFeatureValues(traces,[
                'Spikecount','voltage_base','AP_begin_voltage','AP_begin_indices','min_AHP_values','min_AHP_indices',
                'peak_time','peak_indices','peak_voltage'])
            
            #Converts peak time values into individual sampling points for comparison against AP_begin_indices values
            traces_results[0]['peak_time'] = traces_results[0]['peak_time'] / 0.05

            #An error occurs when the number of peak_time indices does not equal the number of AP begin indices
            #To correct for erroneous values, a while loop circles through and removes inappropriate values
            #until the number of peak_time and AP_begin indices are equal
            while len(traces_results[0]['AP_begin_indices']) != len(traces_results[0]['peak_time']):
                oper_ind_list = [traces_results[0]['AP_begin_indices'],traces_results[0]['peak_time']]
                operdifflist = np.empty((max(y.shape[0] for y in oper_ind_list), len(oper_ind_list)))
                operdifflist[:] = np.nan
                for a,y in enumerate(oper_ind_list):
                    operdifflist[0:len(y), a] = y.T
                    oper_diff = np.diff(operdifflist)
                    oper_del = np.where(oper_diff < 0)
           
                #Conditional if statement to catch when the difference is 0, but the parameters are not equal
                #Usually means that there is an extra value (read NaN) at the end
                if len(oper_del[0]) == 0:
                 oper_del = np.argwhere(np.isnan(oper_diff))
                    
                #Deletes the value corresponding to inappropriate values from specified parameters
                traces_results[0]['peak_time'] = np.delete(traces_results[0]['peak_time'], oper_del[0][0])
                traces_results[0]['peak_voltage'] = np.delete(traces_results[0]['peak_voltage'], oper_del[0][0])    
                traces_results[0]['peak_indices'] = np.delete(traces_results[0]['peak_indices'], oper_del[0][0])
                traces_results[0]['Spikecount'] = traces_results[0]['Spikecount'] - 1    
            
                if len(traces_results[0]['AP_begin_indices']) == len(traces_results[0]['peak_time']):
                    break
            
            #An error occurs when the number of AHP indices does not equal the number of AP begin indices
            #To correct for erroneous values, a while loop circles through and removes inappropriate values
            #until the number of AHP and AP_begin indices are equal
            while len(traces_results[0]['AP_begin_indices']) != len(traces_results[0]['min_AHP_indices']):
                oper_ind_list2 = [traces_results[0]['AP_begin_indices'],traces_results[0]['min_AHP_indices']]
                operdifflist2 = np.empty((max(z.shape[0] for z in oper_ind_list2), len(oper_ind_list2)))
                operdifflist2[:] = np.nan
                for p,z in enumerate(oper_ind_list2):
                    operdifflist2[0:len(z), p] = z.T
                    oper_diff2 = np.diff(operdifflist2)
                    oper_del2 = np.where(oper_diff2 < 0)
            
            #Conditional If statement to catch when the difference is 0, but the parameter length is not equal
            #Usually means that there is an extra value (read NaN) at the end
                if len(oper_del2[0]) == 0:
                    oper_del2 = np.argwhere(np.isnan(oper_diff2))
            
            #Deletes the value corresponding to inappropriate values from specified parameters
                traces_results[0]['min_AHP_indices'] = np.delete(traces_results[0]['min_AHP_indices'], oper_del2[0][0])
                traces_results[0]['min_AHP_values'] = np.delete(traces_results[0]['min_AHP_values'], oper_del2[0][0])
            
            #When the number of AHP and AP_begin indices are equal, the while loop terminates
                if len(traces_results[0]['AP_begin_indices']) == len(traces_results[0]['min_AHP_indices']):
                    break

            SaveUp = list()
            SaveDown = list()
            Amplitude = list()
            AHP = list()
            Dur = list()
            HHWApp = list()
            Rise = list()
                
            #For loop to capture many spike dependent parameters (HHW, Amplitude, etc.)
            #Each spike has a line interpolated over it (generating 1000 points within each spike)
            #More data points allows for more precise spike-dependent measures
            for spike in range(traces_results[0]['Spikecount'][0]):
                TraceData = Cell['Data'][:,i]
                SpikeVal = TraceData[traces_results[0]['AP_begin_indices'][spike]:traces_results[0]['min_AHP_indices'][spike]]
                HHthres = (traces_results[0]['peak_voltage'][spike] + traces_results[0]['AP_begin_voltage'][spike]) / 2
                print('Peak voltage is', traces_results[0]['peak_voltage'][spike])
                print('AP threshold voltage is', traces_results[0]['AP_begin_voltage'][spike])
                print('HHW threshold is', HHthres)
                shape = np.shape(SpikeVal)
                x = np.linspace(0,shape[0],shape[0])
                f2 = interpolate.interp1d(x,SpikeVal,kind = 'cubic')
                xnew = np.linspace(0,shape[0],num = 1000, endpoint = True)
                fig, ax = plt.subplots()
                ax.plot(x,SpikeVal, 'o',xnew, f2(xnew),'-')
                ax.hlines(HHthres,min(xnew),max(xnew),'r')
                plt.show()
                
                #Calculate amplitude for each spike
                IndAmp = np.max(f2(xnew)) - f2(xnew)[0] 
                #Calculate AHP values for each spike
                IndAHP = f2(xnew)[-1] - f2(xnew)[0] 
                #Calculate duration of each spike
                IndDur = abs(traces_results[0]['AP_begin_indices'][spike] - traces_results[0]['min_AHP_indices'][spike]) * 0.05
                #Calculate 10-90% rise time
                Rise100 = xnew[traces_results[0]['AP_begin_indices'][spike] - traces_results[0]['peak_indices'][spike]]
                Rise10 = Rise100 * .10
                Rise90 = Rise100 * .90
                IndRise = (Rise90 - Rise10) * 0.05
                #Calculate the upper and lower values nearest to the HHW threshold
                Up = np.where(f2(xnew) >= HHthres)
                save = xnew[Up[0][0]]
                Down = np.where(f2(xnew) <= HHthres)
                dThres = np.where(np.diff(Down) > 10)
                dThres = dThres[1] + 1
                DownInd = Down[0][dThres]
                save2 = xnew[DownInd]
                #Subtract lower threshold from upper and multiply to convert into ms
                HHW = (save2 - save) * 0.05
    
                SaveUp.append(save)
                SaveDown.append(save2)
                Amplitude.append(IndAmp)
                AHP.append(IndAHP)
                Dur.append(IndDur)
                HHWApp.append(HHW)
                Rise.append(IndRise)
                continue

            #Save each set of individual amplitudes into the traces_results list as a numpy array
            traces_results[0]['AP_Amplitude'] = np.array(Amplitude)
            traces_results[0]['AHP'] = np.array(AHP)
            traces_results[0]['HHW'] = np.array(HHWApp)
            traces_results[0]['Rise'] = np.array(Rise)

            #Reset peak time values back to normal and calculate rheobase if it isn't calculated yet
            traces_results[0]['peak_time'] = traces_results[0]['peak_time'] * 0.05
            traces_results[0]['Rheo'] = ((Cell['Stim'][4001,i])*1000)

            #Calculate ISI values based on AP_begin_indices and multiply each value by the sampling point value (0.05ms)
            traces_results[0]['ISI_values'] = np.diff(traces_results[0]['AP_begin_indices']) * 0.05
            
            #Calculate Duration of Spiking by subtracting the x-axis index of the last spike from the x-axis index
            #of the first spike
            traces_results[0]['DurSpike'] = Cell['Time'][[traces_results[0]['AP_begin_indices'][-1]]] - Cell['Time'][[traces_results[0]['AP_begin_indices'][0]]]            

            #Calculate iniput resistance based on the lowest hyperpolarizing step (Hard coded hyperpolarizing step)
            trace_calc['Vin'] = (((Cell['Data'][6000,4]) - (Cell['Data'][2000,4])) / 1000) #Voltage is calculated in mV, but converted to V
            trace_calc['Iin'] = (((Cell['Stim'][6000,4]) - (Cell['Stim'][2000,4])) / 1000000) #Current is calculated in microA, but converted to A
            traces_results[0]['Rin'] = ((trace_calc['Vin']/trace_calc['Iin']) / 1000) #Resistance is provided in MOhms

            #Calculate frequency and adaptation parameters
            Frequency = 1 / traces_results[0]['ISI_values']
            traces_results[0]['MeanInstFreq'] = np.mean(Frequency) * 1000
            traces_results[0]['MaxFreq'] = np.max(Frequency) * 1000
            traces_results[0]['FreqAdapt'] = traces_results[0]['ISI_values'][-1] / traces_results[0]['ISI_values'][0]
            traces_results[0]['PeakAdapt'] = traces_results[0]['AP_Amplitude'][-1] / traces_results[0]['AP_Amplitude'][0]

            #Save all sweep results in a dictionary
            Trace_Results = {'AP #': int(traces_results[0]['Spikecount'][0]),'RMP': float(traces_results[0]['voltage_base']),
                            'Rin': traces_results[0]['Rin'],'Spiking Duration': float(traces_results[0]['DurSpike']),
                            'Mean AP Amplitude': np.mean(traces_results[0]['AP_Amplitude']),'Mean Inst. Freq.': traces_results[0]['MeanInstFreq'],
                            'Max Freq.': traces_results[0]['MaxFreq'], 'Freq. Adapt.': traces_results[0]['FreqAdapt'],
                            'Peak Adapt.': traces_results[0]['PeakAdapt'], 'Mean ISI': np.mean(traces_results[0]['ISI_values']),
                            'Mean AHP Amplitude': np.mean(traces_results[0]['AHP']), 'Rheobase': int(traces_results[0]['Rheo']),
                            'Mean HHW': np.mean(traces_results[0]['HHW']), 'Mean Rise': np.mean(traces_results[0]['Rise'])}

            #Plot individual sweeps in the output window
            plt.plot(Cell['Time'],Cell['Data'][:,i])
            plt.scatter(traces_results[0]['peak_time'],traces_results[0]['peak_voltage'] + 20, c = 'r', marker = '+')
            plt.xlabel('Time (in ms)')
            plt.ylabel('Voltage (in mV)')
            plt.show()



        Results.append(Trace_Results)
        continue