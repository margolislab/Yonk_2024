#                 EFEL for HEKA DAT Files v1.0
#                   *Created by AY on 07/13/2023*
#                   *Last Updated on 07/13/2023*
#     *For any issues or bugs, please contact alex.yonk2@gmail.com*
#*This script was designed to analyze electrophysiological parameters from HEKA .dat files converted into mat files
#*It must be used in conjunction with the ***HEKA_importerV2*** MATLAB script
#*The output can be combined with the EI_Balance_Analysis to perform E/I analysis
#*****However, the E/I analysis requires text file output from the SP CC and the SP E/I analysis from this script
#*Grand Averages can be calculated through the accompanying Multi_SP/PPR/Train scripts

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
efel.setThreshold(10) #Sets threshold for detecting AP spikes (must be above +10mV)

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
    Cols = np.shape(SelectCell['Expt' + str(ii + 1)]['Exp' + str(ii + 1)])
    if len(Cols) < 2:
        print('Experiment ' + str(ii + 1) + ' is a(n)' + str(SelectCell['Expt' + str(ii+1)]['ExptID' + str(ii + 1)]) + 'contains ***1*** trace.')
        continue
    print('Experiment ' + str(ii + 1) + ' is a(n) ' + str(SelectCell['Expt' + str(ii + 1)]['ExptID' + str(ii + 1)]) + ' contains ***' + str(Cols[1]) + ' *** traces.')

User_choices['ExptVal'] = int(input('Which experiment would you like to analyze?:'))

#Stores all pertinent information into a new variable that will be accessed for all analyses
Cell['ExptID'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['ExptID' + str(User_choices['ExptVal'])]
Cell['Data'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['Exp' + str(User_choices['ExptVal'])]
Cell['TraceMax'] = np.shape(Cell['Data'])
Cell['Time'] = AllData['Data']['Time'][0:Cell['Data'].shape[0]]
Cell['Stim'] = SelectCell['Expt' + str(User_choices['ExptVal'])]['Stim' + str(User_choices['ExptVal'])]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  Analysis Section--IV Analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Calculates IV curve parameters including spikecount, RMP, Rin, Freq, HHW, etc.
if 'IV' in Cell['ExptID']:
    User_choices['IV_graph'] = int(input('Would you like to save the graph? (Input 1): '))
    User_choices['IV_output'] = int(input('Would you like to output the results as a CSV? (Input 1): '))

    i = 0
    for i in range(i,Cell['TraceMax'][1],1):
        trace1 = {}
        trace1['T'] = Cell['Time'][:]
        trace1['V'] = Cell['Data'][:,i]
        trace1['stim_start'] = [201]
        trace1['stim_end'] = [700]
        traces = [trace1]
        traces_results = efel.getFeatureValues(traces,['Spikecount','voltage_base','peak_voltage','peak_time'])
    
        #If a Spikecount of 0 is detected, continue for loop
        #Cannot append "N/A" as the DictWriter won't work
        if traces_results[0]['Spikecount'] == 0:
            continue
        
        #If a Spikecount of 1 is detected, plot graph and continue
        #Potential to be modified if Threshold_AP is needed for each trace
        if traces_results[0]['Spikecount'] == 1:
            #Calculate input resistance based on lowest hyperpolarizing step (Hard coded hyperpolarizing step)
            trace_calc['Vin'] = (((Cell['Data'][6000,4]) - (Cell['Data'][2000,4])) / 1000) #Voltage is calculated in mV, but converted to V
            trace_calc['Iin'] = (((Cell['Stim'][6000,4]) - (Cell['Stim'][2000,4])) / 1000000) #Current is calculated in microA, but converted to A
            trace_calc['Rin'] = ((trace_calc['Vin']/trace_calc['Iin']) / 1000) #Resistance is provided in MOhms
            trace_calc['Rheo'] = ((Cell['Stim'][4001,i])*1000)+1
            Trace_Results = {'AP #': int(traces_results[0]['Spikecount']), 'RMP': float(traces_results[0]['voltage_base']),
                         'Rin': trace_calc['Rin'],'Rheobase': int(trace_calc['Rheo'])}
            
            Results.append(Trace_Results)
            
            #Plot individual traces with one spike
            plt.plot(Cell['Time'],Cell['Data'][:,i])
            plt.scatter(traces_results[0]['peak_time'],traces_results[0]['peak_voltage'] + 20,c='r',marker = '+')
            plt.xlabel('Time (in ms)')
            plt.ylabel('Voltage (in mV)')
            plt.show()
            continue
        
        #If Spikecount is greater than 1, the code continues as normal
        if traces_results[0]['Spikecount'] >= 2:
            traces_results = efel.getFeatureValues(traces,['Spikecount','voltage_base','AP_begin_voltage',
                                                           'AP_begin_indices','min_AHP_values','min_AHP_indices',
                                                           'peak_time','peak_indices','peak_voltage'])

        #Removes erroneously detected AP_begin_indices at the end of the trace if present
        if traces_results[0]['AP_begin_indices'][-1] > 14000:
            traces_results[0]['AP_begin_indices'] = np.delete(traces_results[0]['AP_begin_indices'], -1)
            traces_results[0]['AP_begin_voltage'] = np.delete(traces_results[0]['AP_begin_voltage'], -1)

        while len(traces_results[0]['AP_begin_indices']) != len(traces_results[0]['peak_indices']):
            difference = len(traces_results[0]['AP_begin_indices']) - len(traces_results[0]['peak_indices'])
            if difference > 0:
                oper_difference = np.diff(traces_results[0]['AP_begin_indices'])
                oper_delete = np.where(oper_difference < 100)
                traces_results[0]['AP_begin_indices'] = np.delete(traces_results[0]['AP_begin_indices'], oper_delete[0][0]+1)
                traces_results[0]['AP_begin_voltage'] = np.delete(traces_results[0]['AP_begin_voltage'], oper_delete[0][0]+1)

        #An error occurs when the number of peak_time indices does not equal the number of AP begin indices
        #To correct for erroneous values, a while loop circles through and removes inappropriate values
        #until the number of peak_time and AP_begin indices are equal
        while len(traces_results[0]['AP_begin_indices']) != len(traces_results[0]['peak_indices']):
            oper_ind_list = [traces_results[0]['AP_begin_indices'],traces_results[0]['peak_indices']]
            operdifflist = np.empty((max(y.shape[0] for y in oper_ind_list), len(oper_ind_list)))
            operdifflist[:] = np.nan
            for i,y in enumerate(oper_ind_list):
                operdifflist[0:len(y), i] = y.T
                oper_diff = np.diff(operdifflist)
                oper_del = np.where(oper_diff < 0)
                
            #Conditional if statement to catch when the difference is 0, but the parameters are not equal
            #Usually means that there is an extra value (read NaN) at the end
            if len(oper_del[0]) == 0:
                oper_del = np.argwhere(np.isnan(oper_diff))
                
            #Deletes the value corresponding to inappropriate values from specified parameters
            traces_results[0]['peak_time'] = np.delete(traces_results[0]['peak_time'], oper_del[0][0])
            traces_results[0]['peak_voltage'] = np.delete(traces_results[0]['peak_voltage'], oper_del[0][0])    
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
            for i,z in enumerate(oper_ind_list2):
                operdifflist2[0:len(z), i] = z.T
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

        #Prep new lists to capture parameters for each sweep
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
        traces_results[0]['AHPAdapt'] = traces_results[0]['AHP'][-1] / traces_results[0]['AHP'][0]

        #Plot individual sweeps in the output window
        plt.plot(Cell['Time'][0:20000],Cell['Data'][:,i][0:20000])
        plt.scatter(traces_results[0]['peak_time'],traces_results[0]['peak_voltage'] + 20, c = 'r', marker = '+')
        plt.xlabel('Time (in ms)')
        plt.ylabel('Voltage (in mV)')
        plt.show()

        #Save all sweep results in a dictionary
        Trace_Results = {'AP #': int(traces_results[0]['Spikecount'][0]),'RMP': float(traces_results[0]['voltage_base']),
                        'Rin': traces_results[0]['Rin'],'Spiking Duration': float(traces_results[0]['DurSpike']),
                        'Mean AP Amplitude': np.mean(traces_results[0]['AP_Amplitude']),'Mean Inst. Freq.': traces_results[0]['MeanInstFreq'],
                        'Max Freq.': traces_results[0]['MaxFreq'], 'Freq. Adapt.': traces_results[0]['FreqAdapt'],
                        'Peak Adapt.': traces_results[0]['PeakAdapt'], 'Mean ISI': np.mean(traces_results[0]['ISI_values']),
                        'Mean AHP Amplitude': np.mean(traces_results[0]['AHP']), 'Rheobase': int(traces_results[0]['Rheo']),
                        'Mean HHW': np.mean(traces_results[0]['HHW']), 'Mean Rise': np.mean(traces_results[0]['Rise']), 'AHP Adapt': traces_results[0]['AHPAdapt']}
            
        #Append each dictionary into a list
        Results.append(Trace_Results)
        continue
    
    plt.plot(Cell['Time'][0:20000],Cell['Data'][0:20000])
    plt.title('All Traces')
    plt.xlabel('Time (in ms)')
    plt.ylabel('Voltage (in mV)')
    if User_choices['IV_graph'] == 1:
        #Change the string here to modify the output graph name
        plt.savefig('IV.svg',format='svg',dpi = 1200)
    plt.show()
    
    #Outputs IV parameters into a CSV
    if User_choices['IV_output'] == 1:
        with open(str(AllData['filename']) + 'C' + str(User_choices['CellVal']) + 'E' + str(User_choices['ExptVal']) +  '_IV.csv','w',newline = '') as IV:
            writer1 = DictWriter(IV,('Rin','Rheobase','AP #','RMP','Mean HHW','Mean ISI',
                                     'Mean AP Amplitude','Peak Adapt.','Mean AHP Amplitude',
                                     'AHP Adapt','Spiking Duration','Mean Inst. Freq.','Max Freq.',
                                     'Freq. Adapt.','Mean Rise'))
            writer1.writeheader()
            writer1.writerows(Results)
            IV.close()            

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  Analysis Section--SP Analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Used to calculate single pulse parameters (all sweeps)
if 'SP CC' in Cell['ExptID']:
    #Allows the user to save the average graph, if needed
    User_choices['SPCCGraph'] = int(input('Would you like to save the average/individual trace graph? (Input 1): '))
    
    #Asks the user if any traces need to be NaNed out
    #If the user chooses 0, continue with the analysis
    #If the user chooses 1, script asks user for number of traces to be NaNed
    #and runs a for loop to nan out selected traces
    User_choices['SP NaN'] = int(input('If traces need to be NaNed, input 1. Otherwise, input 0: '))
    if User_choices['SP NaN'] == 0:
        print('Continuing to SP Analysis')
    if User_choices['SP NaN'] == 1:
        User_choices['SP_NaN_Trace'] = int(input('Please input the number of traces to be NaNed: '))
        for i in range(User_choices['SP_NaN_Trace']):
            User_choices['SP_Traces'] = int(input('Please input the trace to be Naned from 0 to ' + str(Cell['TraceMax'][1]) + ' : '))
            Cell['Data'][:,User_choices['SP_Traces']] = np.nan
    elif User_choices['SP NaN'] == 0: #Added to ensure that graphs plot properly if traces are NaNed out
        User_choices['SP_NaN_Trace'] = 0
    
    Allzero = list()
    AllPSP = list()
    AllLat = list()
    AllRise = list()
    
    for i in range(Cell['TraceMax'][1]):
        TraceData = Cell['Data'][:,i]
        nan = np.isnan(TraceData)
        if nan[0] == True:
            continue
        TraceFilter = signal.savgol_filter(TraceData, 21, 2)
        trace_base = np.nanmean(TraceFilter[0:10000])
        zero_trace = TraceFilter - trace_base
        IndAmp = np.nanmax(zero_trace[19900:21000])
        PeakAmp = np.nanargmax(zero_trace[19900:21000]) + 19900
        Lat = (PeakAmp - 20000)*0.05


        #Calculate first derivative to identify rise starting point
        #dy = np.diff(zero_trace[9900:10500]) / np.diff(Cell['Time'][9900:10500])
        #dyThres = 1.0
        #Infl = np.where(dy >= dyThres)
        #RiseStart = Infl[0][0] + 9900
        #RiseEnd = np.nanargmax(zero_trace)
        #Rise = (RiseEnd - RiseStart) * 0.05

        Allzero.append(zero_trace)
        AllPSP.append(IndAmp)
        AllLat.append(Lat)
        #AllRise.append(Rise)

        plt.plot(Cell['Time'][19900:21000],zero_trace[19900:21000])
        #plt.vlines((PeakAmp) * 0.05,-2,20,'orange')
        #plt.vlines(500,-2,20,'red')
        #plt.vlines((RiseStart)*0.05,-2,20,'blue')
        plt.show()

        AllResults = {'PSP': IndAmp, 'Latency': Lat}
        Results.append(AllResults)

    #Calculate average PSP and latency to max PSP amplitude
    PSP = np.nanmean(AllPSP)
    Latency = np.nanmean(AllLat)
    
    #Concatenate all zeroed sweeps and average them to form an average trace
    AvgTrace = np.column_stack(Allzero)
    AvgTrace = np.nanmean(AvgTrace,axis = 1)
    AvgPSP = np.nanmax(AvgTrace[19900:21000])
    
    fig, ax = plt.subplots()
    for i in range(Cell['TraceMax'][1] - User_choices['SP_NaN_Trace']): #19900:21000
        ax.plot(Cell['Time'][19900:21000],Allzero[i][19900:21000], c ='lightgray',linewidth = 0.3)
        ax.plot(Cell['Time'][19900:21000],AvgTrace[19900:21000], c = 'k')
        #ax.scatter(500,-2,c = 'blue', marker = 's')
        #ax.vlines(np.nanargmax(AvgTrace)*0.05,0,AvgPSP + 5, 'orange',linewidth = 0.5)
        ax.vlines(1000,0,AvgPSP + 5, 'red',linewidth = 0.5)
        ax.title.set_text('Average PSP')
        ax.set_xlabel('Time (in ms)')
        ax.set_ylabel('PSP Amplitude (in mV)')
        ax.set_ylim(-5,15)
    if User_choices['SPCCGraph'] == 1:
        plt.savefig('SP.svg',format = 'svg',dpi = 1200)
    plt.show()
    plt.close()    
    
    #Automatically save the individual max amplitude points as a text file
    np.savetxt(str(AllData['filename']) + '_C' + str(User_choices['CellVal']) + '_SP.txt', AllPSP)    

    with open(str(AllData['filename']) + 'C' + str(User_choices['CellVal']) + 'E' + str(User_choices['ExptVal']) +  '_SP.csv','w',newline='') as SP:
        writer1 = DictWriter(SP,('PSP','Latency'))
        writer1.writeheader()
        writer1.writerows(Results)
        SP.close()           

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  Analysis Section--PPR Analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Calculates the PPR Ratio of pulses 2-5 compared to the amplitude of pulse 1
if 'PPR CC' in Cell['ExptID']:
    #Allows the user to save the average graph, if needed
    User_choices['PPRGraph'] = int(input('Would you like to save the average/individual trace graph? (Input 1): '))
    
    #Same NaNing method as SP
    User_choices['PPR NaN'] = int(input('If traces need to be NaNed, input 1. Otherwise, input 0: '))
    if User_choices['PPR NaN'] == 0:
        print('Continuing to SP Analysis')
    if User_choices['PPR NaN'] == 1:
        User_choices['PPR_NaN_Trace'] = int(input('Please input the number of traces to be NaNed: '))
        for i in range(User_choices['PPR_NaN_Trace']):
            User_choices['PPR_Traces'] = int(input('Please input the trace to be Naned from 0 to ' + str(Cell['TraceMax'][1]) + ' : '))
            Cell['Data'][:,User_choices['PPR_Traces']] = np.nan
    elif User_choices['PPR NaN'] == 0: #Added to ensure that graphs plot properly if traces are NaNed out
        User_choices['PPR_NaN_Trace'] = 0

    PPRBase = list()
    PPRAmp = list()
    PPRPSP = list()
    AvgPSP = list()
    AvgPPR = list()
    
    #Calculate initial baseline and subtract it from all sweep values for a baseline of 00
    for i in range(Cell['TraceMax'][1]):
        base = np.nanmean(Cell['Data'][0:10000,i])
        zero_trace = Cell['Data'][:,i] - base
        PPRAmp.append(zero_trace)
        
        plt.plot(Cell['Time'][19900:26000],zero_trace[19900:26000])
        plt.show()
    
    #Calculate max amplitude for all 5 peaks compared to single baseline value for each sweep
    PPRAmp = np.transpose(PPRAmp)
    for i in range(int(Cell['TraceMax'][1])):
        iterstart = 20001
        iterend = 21000
        for ii in range(5):
            psp = np.nanmax(PPRAmp[iterstart:iterend,i])
            PPRPSP.append(psp)
            iterstart += 1000
            iterend += 1000
    
    #Concatenate all PSP values together
    PPRPSP = np.array(PPRPSP)
    PPRPSP = np.split(PPRPSP,int(Cell['TraceMax'][1]),0)
    PPRPSP = np.column_stack(PPRPSP)
    
    #Calculate the average PSP for each pulse
    for i in range(5):
        MeanPSP = np.nanmean(PPRPSP[i])
        AvgPSP.append(MeanPSP)
    
    #Calculate pulse ratios compared to pulse 1
    FinalPSP = np.array([AvgPSP[0]/AvgPSP[0], AvgPSP[1]/AvgPSP[0], AvgPSP[2]/AvgPSP[0], AvgPSP[3]/AvgPSP[0], AvgPSP[4]/AvgPSP[0]])
    
    #Calculate final averaged plot
    AvgTrace = np.nanmean(PPRAmp,axis = 1)
    
    #Plot all individual traces of RawPPRCC
    plt.plot(Cell['Time'],Cell['Data'])
    plt.xlabel('Time (in ms)')
    plt.ylabel('Voltage (in mV)')
    plt.show()
    
    #Plots box plot of PPR compared to P1
    x = 1,2,3,4,5
    plt.axhline(1,linestyle = '--',c = 'b')
    #plt.errorbar(x, PPR, yerr= PPRSEM, ls = 'none', c = 'k')
    plt.scatter(x,FinalPSP,marker = '+',s = 20**2, c = 'r')
    plt.xticks([1,2,3,4,5])
    plt.title('PPR of Cell ' + str(User_choices['CellVal']) + ', Experiment ' + str(User_choices['ExptVal']))
    plt.xlabel('Pulse #')
    plt.ylabel('PPR (Ratio of P1)')
    #plt.ylim([0.75,1.25])
    plt.show()

    #Plots average trace in black overlaid on individual PPR sweeps
    fig,ax = plt.subplots()
    
    for i in range(Cell['TraceMax'][1] - User_choices['PPR_NaN_Trace']):
        ax.plot(PPRAmp[19900:26000,i], c ='lightgray')
        ax.plot(AvgTrace[19900:26000], c = 'k')
        ax.scatter(101,-2,c = 'blue', marker = 's')
        ax.scatter(1151,-2,c = 'blue', marker = 's')
        ax.scatter(2201,-2,c = 'blue', marker = 's')
        ax.scatter(3251,-2,c = 'blue',marker = 's')
        ax.scatter(4301,-2,c = 'blue',marker = 's')
    ax.title.set_text('Average PPR')
    ax.set_xlabel('Time (in ms)')
    ax.set_ylabel('PSP Amplitude (in mV)')
    ax.set_ylim(-5,15)
    if User_choices['PPRGraph'] == 1:
        plt.savefig('SPNPPR.svg',format='svg',dpi=1200)
    plt.show()
    plt.close()

    #Automatically save all indivdiual traces to a txt file
    #Automatically save the individual max amplitude points as a text file
    np.savetxt(str(AllData['filename']) + '_C' + str(User_choices['CellVal']) + '_PPR.csv', AvgPSP)
    
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  Analysis Section--Train Analysis
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Calculates average PSP for each of the 25 pulses
if 'Train CC' in Cell['ExptID']:
    #Allows the user to save the average graph, if needed
    User_choices['TrainGraph'] = int(input('Would you like to save the average/individual trace graph? (Input 1): '))
    
    #Same NaNing method as SP
    User_choices['Train NaN'] = int(input('If traces need to be NaNed, input 1. Otherwise, input 0: '))
    if User_choices['Train NaN'] == 0:
        print('Continuing to SP Analysis')
    if User_choices['Train NaN'] == 1:
        User_choices['Train_NaN_Trace'] = int(input('Please input the number of traces to be NaNed: '))
        for i in range(User_choices['Train_NaN_Trace']):
            User_choices['Train_Traces'] = int(input('Please input the trace to be Naned from 0 to ' + str(Cell['TraceMax'][1]) + ' : '))
            Cell['Data'][:,User_choices['Train_Traces']] = np.nan
    elif User_choices['Train NaN'] == 0:
        User_choices['Train_NaN_Trace'] = 0
    
    #Set up lists that will save certain values
    Ratio = list()
    Zero_Trace = []
    PSP_dict = {}
    
    #Calculate the average baseline and zero by subtracting baseline from all values
    for i in range(Cell['TraceMax'][1]):
        baseline = np.nanmean(Cell['Data'][0:20000,i])
        zeroed_trace = Cell['Data'][:,i] - baseline
        Zero_Trace.append(zeroed_trace)
    
    #Calculates maximal PSP value for each of the 25 pulses from each trace and places it into a dictionary
    for i in range(Cell['TraceMax'][1]):
        iterstart = 20000
        iterend = 21000
        PSPlist = []
        for ii in range(30):
            PSP = np.nanmax(Zero_Trace[i][iterstart:iterend])
            PSPlist.append(PSP)
            iterstart += 1000
            iterend += 1000
        PSP_dict[i] = PSPlist
    
    #Convert data into Dataframe to use pandas mean and std functions
    MaxP = pd.DataFrame.from_dict(PSP_dict,orient = 'index')
    AvgPSP = pd.DataFrame.mean(MaxP,axis = 0)
    for i in range(30):
        Rat = AvgPSP[i] / AvgPSP[0]
        Ratio.append(Rat)
    
    #Calculate the average PSP and standard deviation values for each pulse and average train values
    AvgTrain = np.nanmean(Cell['Data'], axis = 1)
    AvgTrain = AvgTrain - (np.nanmean(AvgTrain[0:20000]))

    #Plot all traces simultaneously for visualization
    plt.plot(Cell['Time'],Cell['Data'])
    plt.title('All Traces for Cell ' + str(User_choices['CellVal']) + ', Experiment ' + str(User_choices['ExptVal']))
    plt.xlabel('Time (in ms)')
    plt.ylabel('Voltage (in mV)')
    plt.show()

    #Plot average PSP value with shaded standard deviation
    plt.figure()
    plt.plot(Ratio, c = 'k')
    plt.show()
    plt.close()
    
    #plot average train with individual traces
    plt.figure()
    plt.plot(AvgTrain, c = 'k', zorder = 2)
    plt.title('Average Train')
    plt.ylim(-5,15)
    for i in range(Cell['TraceMax'][1]):
        plt.plot(Zero_Trace[i], c = 'lightgrey',zorder = 1)
        iterate = 20001
    for i in range(30):
        plt.scatter(iterate,-2,c = 'blue', marker = '|')
        iterate += 1334
    if User_choices['TrainGraph'] == 1:
        plt.savefig('SPNTrain.svg',format='svg',dpi=1200)
    plt.show()
    plt.close()

    #Outputs the processed data as a CSV
    #with open(str(AllData['filename']) + '_C' + str(User_choices['CellVal']) + 'E' + str(User_choices['ExptVal']) +  '_Train.csv', 'w') as Train:
        #writer = csv.writer(Train)
        #writer.writerows(Zero_Trace)
        #Train.close()
        
    np.savetxt(str(AllData['filename']) + '_C' + str(User_choices['CellVal']) + '_Train.csv', AvgPSP)