%{
---------------------------------------------------------------------------------------------------------------------------------------------------------
Full FP Analyis Script
Written by: Logan Pasternak
Modified by: Sofia Juliani & Alex Yonk
Last modification date: 2023-06-22

OBJECTIVE = Combine data from TDMS (licks), behavioral output (text file),
and signals collected within the Tucker-Davis Technologies Synapse software
(isosbestic signal, GCaMP signal, pupil dynamics, and whisker dynamics) for
correlational analysis based on trial outcome (Hit, Miss, False Alarm, and
Correct Rejection).
---------------------------------------------------------------------------------------------------------------------------------------------------------
%}

%% Data importation %%
clear; %Clear all variables
clc; %Clear command window
TDMSstructpath = 'D:\b. Thesis Data\e. Scripts\TDMS_getStruct'; %Hardcode the location of the TDMS_getStruct variable
addpath(genpath(TDMSstructpath)); %Add the TDMS struct folder to the path

%Permits user to select TDMS folder
disp('Please select tdms folder');
[TDMSpath] = uigetdir; %Permits usert choose the TDMS folder

%Automatically loads in the PADCAT function, permitting the user to
%concatenate rows/columns of different sizes
padcatpath = 'D:\b. Thesis Data\e. Scripts\PADCAT';
addpath(genpath(padcatpath));

%Automatically loads in the AUC/AUC_BOOTSTRAP functions for the AUROC
%analysis
aurocpath = 'D:\b. Thesis Data\e. Scripts\AUC';
addpath(genpath(aurocpath));

%Permits user to select the TDMS file to the related folder
disp('Please select the related tdms text file');
[file, Textpath] = uigetfile('*.txt'); %Permits user to select related TDMS text file
txtpath = fullfile(Textpath,file);

%Permits user to select the FP folder related to the TDMS data
disp('Please select the related fiber photometry folder');
[FPpath] = uigetdir; %Permits user to select related fiber photometry folder
SDKpath = 'D:\b. Thesis Data\e. Scripts\TDTMatlabSDK-master'; %Hardcode the location of the TDTbin2mat folder
addpath(genpath(SDKpath)); %Add the TDTbin2mat folder to the path

tdmsfiles = dir([TDMSpath '/*.tdms']); %Changes the directory to the tdms folder
tdmsPaths = strings(150,1); %Creates an empty string array of 150 rows x 1 column
EventOutcome = {};

for i = 1:length(tdmsfiles)
    tdmsPaths(i) = convertStringsToChars(strcat(tdmsfiles(i).folder,'/',tdmsfiles(i).name)); %Creates a cell of all path locations for each TDMS file within the folder
    q = tdmsPaths{i}; %creates a vector containing the path of each TDMS file
    txtdata(i).sample = TDMS_getStruct(q); %Uses the TDMS_getStruct function to load in all TDMS data for each trial
end

%% Text file reader %%
formatSpec = '%s%s%f%s'; %set the format for reading in information from the TDMS text file
T = readtable(txtpath,'Format',formatSpec); %reads in the data within the formatting specs
Date = string(table2array(T(:,1))); %Segments the data into Date and converts to a string
Timestamps = string(table2array(T(:,2))); %Segments the data into Timestamps and converts into string
TDMSEvents = string(table2array(T(:,4))); %Segments the data into events and converts into a string

%Replaces the number of each month with a shorthand string of each month
Q = split(Date,'/');
month = str2double(Q(2,1));
switch month
    case 1
        for i = 1:length(Q)
            Q(i,1) = 'Jan';
        end

    case 2
        for i = 1:length(Q)
            Q(i,1) = 'Feb';
        end

    case 3
        for i = 1:length(Q)
            Q(i,1) = 'Mar';
        end

    case 4
        for i = 1:length(Q)
            Q(i,1) = 'Apr';
        end

    case 5
        for i = 1:length(Q)
            Q(i,1) = 'May';
        end

    case 6
        for i = 1:length(Q)
            Q(i,1) = 'Jun';
        end

    case 7
        for i = 1:length(Q)
            Q(i,1) = 'Jul';
        end

    case 8
        for i = 1:length(Q)
            Q(i,1) = 'Aug';
        end

    case 9
        for i = 1:length(Q)
            Q(i,1) = 'Sep';
        end

    case 10
        for i = 1:length(Q)
            Q(i,1) = 'Oct';
        end

    case 11
        for i = 1:length(Q)
            Q(i,1) = 'Nov';
        end

    case 12
        for i = 1:length(Q)
            Q(i,1) = 'Dec';
        end
end

for i = 1:length(Q)
    temp = Q(i,1);
    Q(i,1) = Q(i,2);
    Q(i,2) = temp;
end

K = join(Q,'-');
R = strings(length(Date),1);
for i = 1:length(Date)
    R(i) = append(K(i),Timestamps(i));
end

%Creates appropriate datetime values for all events
DT = datetime(R,'TimeZone','local','Format','dd-MM-yyyy HH:mm:ss:SSSS');

%
digitsTime = strlength(Timestamps(1,1));
digitsFromEnd = 6;

for i = 1:height(T) %Go through every trial event
    if strmatch('Go',TDMSEvents(i)) %#ok<*MATCH2> %If there is a direct string match with Go, check whether 2 events prior is Auto Reward
        if strmatch('Auto Reward',TDMSEvents(i-2)) %if yes, store Auto Reward as the outcome
            EventOutcome{i} = 'Auto Reward'; %#ok<*SAGROW>
        else %if no, store Go as the outcome
            EventOutcome{i} = 'Hit';
            HitStamp{i} = EventOutcome{i};
            tGo = Timestamps{i};
            tGo = str2num(tGo(digitsTime-digitsFromEnd:digitsTime)); %#ok<*ST2NM> 
            for j = i-4:i
                if strmatch('Stimulus',TDMSEvents(j))
                    tStim = Timestamps{j};
                    break
                end
            end
            tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
            HitTime = tGo-tStim;
            if HitTime < 0
                tStim = 60 - tStim;
                HitTime = tGo + tStim;
            end
            GoRT(i) = HitTime;
        end
    elseif strmatch('No Response',TDMSEvents(i))
        EventOutcome{i} = 'Miss';
        MissStamp{i} = EventOutcome{i};
    elseif strmatch('Inappropriate Response',TDMSEvents(i))
        EventOutcome{i} = 'False Alarm';
        FAStamp{i} = EventOutcome{i};
        FACheck = 1;
        tFA = Timestamps{i};
        tFA = str2num(tFA(digitsTime - digitsFromEnd:digitsTime));
        for j = i-3:i
            if strmatch('Stimulus',TDMSEvents(j))
                tStim = Timestamps{j};
                break
            end
        end
        tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
        FATime = tFA - tStim;
        if FATime < 0
            tStim = 60 - tStim;
            FATime = tFA + tStim;
        end
        FArt(i) = FATime;
    elseif strmatch('No Go',TDMSEvents(i))
        EventOutcome{i} = 'Correct Rejection';
    end
end

EventOutcome = EventOutcome(~cellfun('isempty',EventOutcome)); %Remove all empty cells
EventOutcome = transpose(EventOutcome); %Transposes EventOutcome

Hits = length(strmatch('Hit',EventOutcome)); %Calculates the number of Hits
Misses = length(strmatch('Miss',EventOutcome)); %Calculates the number of Misses
FAs = length(strmatch('False Alarm',EventOutcome)); %Calculates the number of FAs
NoGos = length(strmatch('Correct Rejection',EventOutcome)); %Calculates the number of NoGos
ARs = length(strmatch('Auto Reward',EventOutcome)); %Calculates the number of ARs

%% Fiber photometry analysis %%
cd(FPpath);
FPData = TDTbin2mat(FPpath);
GCaMP = FPData.streams.G__B.data.'; %Raw GCaMP signals
Iso = FPData.streams.IsoB.data.'; %Raw Isosbestic signals
Fs = FPData.streams.IsoB.fs; %Frame acqusition sampling
Ts = ((1:numel(FPData.streams.G__B.data)) / Fs)'; %Calculate timestamps by Fs
Events = FPData.epocs.sqr_.onset; %TS of the events

%Construct list for detrending via line of best fit
list={GCaMP,Iso};
for i=1:length(list)
   BestFitG= polyfit(Ts,list{i},2);
   TLG = ((BestFitG(1,1)*(Ts.^2)) + (BestFitG(1,2)*Ts) + (BestFitG(1,3)));
   DetrendSignals{i} = list{i}-TLG;
   clear TLG BestFitG
end

%Normalize the values for Z score and MAD Z score calculations
meanBaseG = mean(DetrendSignals{1});
medianBaseG = median(DetrendSignals{1});
madBaseG = mean(mad(DetrendSignals{1}));
stdBaseG = std(DetrendSignals{1});
meanBaseI = mean(DetrendSignals{2});
medianBaseI = median(DetrendSignals{2});
madBaseI = mean(mad(DetrendSignals{2}));
stdBaseI = std(DetrendSignals{2});

ZGCaMP = (DetrendSignals{1} - meanBaseG)/stdBaseG;
ZIso = (DetrendSignals{2} - meanBaseI)/stdBaseI;
ZmadGCaMP = (DetrendSignals{1} - medianBaseG)/madBaseG;
ZmadIso = (DetrendSignals{2} - medianBaseI)/madBaseI;

%Subtract the isosbestic signal from the GCaMP signal
Z = ZmadGCaMP - ZmadIso;

%%
for i = 1:150
    indexLow(i) = find(table2array(T(:,3)) == i,1,'first');
end

%Create a variable to store all pertinent trial related information
%Column 1 = Contains datetime values for each trial
%Column 2 = Contains events for each trial
%Column 3 = Contains voltage arrays for each trial
%Column 4 = Contains evenly spaced time values corresponding to each
%voltage sample for each trial
splitEvents = cell([150,5]);

trueTDMS = cell([150,1]); %Even-numbered indices are invalid, so they will be removed
for i = 1:150
    screen = txtdata(i).sample.Untitled.Untitled.data;
    len = length(txtdata(i).sample.Untitled.Untitled.data);
    truth = screen(1:2:len);
    trueTDMS{i} = truth;
end

%For each trial, store the TDMSEvent flags and datetime values for each
%trial
for i = 1:149
    splitEvents{i,1} = DT(indexLow(i):(indexLow(i+1)-1));
    splitEvents{i,2} = TDMSEvents(indexLow(i):(indexLow(i+1)-1));
    splitEvents{i,3} = trueTDMS{i}';
end

splitEvents{150,1}=DT(indexLow(150):end); %Adds in the datetime values for the last trial
splitEvents{150,2}=TDMSEvents(indexLow(150):end); %Adds in the trial string outputs for the last trial
splitEvents{150,3}=trueTDMS{150}'; %Adds in the voltage values for the last trial

All = {};
for i = 1:150
    All{i,1} = EventOutcome(i);
end

%Creates time values that correspond to each voltage sample
for i = 1:150
    eventNum = splitEvents{i,1};
    n = length(eventNum);
    timeBegin = eventNum(1);
    timeEnd = eventNum(end);
    s = length(splitEvents{i,3});
    time = linspace(timeBegin,timeEnd,s);
    time.Format = 'dd-MMM-yyyy HH:mm:ss:SSSS';
    splitEvents{i,4} = transpose(time);
end

%Synchronizes the timing and trial outcomes with the voltage values and
%stores within the variable All
for i = 1:150
    tt1 = timetable(splitEvents{i,1},splitEvents{i,2});
    tt2 = timetable(splitEvents{i,4},splitEvents{i,3});
    ttRes = synchronize(tt1,tt2);
    ttRes = fillmissing(ttRes,'previous');
    tt(i).sample = table2struct(timetable2table(ttRes));
    All{i,3} = ttRes.Var1_tt1;
    All{i,4} = ttRes.Var1_tt2;
end

%Converts datetime values into time in seconds for direct comparison with
%the GCaMP data
for i = 1:150 
    for ii = 1:length(tt(i).sample)
        SECzero = [];
        MINzero = [];
        MILLIzero = [];
        HOURzero = [];
        
        charsplit = char(tt(i).sample(ii).Time);
        TIME{i}(ii,1) = cellstr(charsplit(12));
        TIME{i}(ii,2) = cellstr(charsplit(13));
        if strcmp(TIME{i}(ii,1),'0') %NOTE = str2num removes leading zeros. To get around this, whenever a zero is detected, it is replaced with '1' and a mark is given to HOURzero vector. The multiple of the digit is removed from the final TIMEcat calculation.
            TIME{i}(ii,1) = cellstr('l');
            HOURzero = 1;
        end
        HOURcat = str2num(string(strcat(TIME{i}(ii,1),TIME{i}(ii,2))))*3600;
        
        TIME{i}(ii,3) = cellstr(charsplit(15));
        TIME{i}(ii,4) = cellstr(charsplit(16));
        if strcmp(TIME{i}(ii,3),'0') %NOTE = str2num removes leading zeros. To get around this, whenever a zero is detected, it is replaced with '1' and a mark is given to MINzero vector. The multiple of the digit is removed from the final TIMEcat calculation.
            TIME{i}(ii,3) = cellstr('1');
            MINzero = 1;
        end
        MINcat = str2num(string(strcat(TIME{i}(ii,3),TIME{i}(ii,4))))*60;
        
        TIME{i}(ii,5) = cellstr(charsplit(18));
        TIME{i}(ii,6) = cellstr(charsplit(19));
        if strcmp(TIME{i}(ii,5),'0') %NOTE = str2num removes leading zeros. To get around this, whenever a zero is detected, it is replaced with '1' and a mark is given to SECzero vector. The digit is removed from the final TIMEcat calculation.
            TIME{i}(ii,5) = cellstr('1');
            SECzero = 1;
        end
        SECcat = str2num(string(strcat(TIME{i}(ii,5),TIME{i}(ii,6))));

        TIME{i}(ii,7) = cellstr(charsplit(21));
        TIME{i}(ii,8) = cellstr(charsplit(22));
        TIME{i}(ii,9) = cellstr(charsplit(23));
        TIME{i}(ii,10) = cellstr(charsplit(24));
        if strcmp(TIME{i}(ii,7),'0') %NOTE = str2num removes leading zeros. To get around this, whenever a zero is detected, it is replaced with '1' and a mark is given to MILLIzero vector. The fraction of the digit is removed from the final TIMEcat calculation.
            TIME{i}(ii,7) = cellstr('1');
            MILLIzero = 1;
        end
        MILLIcat = (str2num(string(strcat(TIME{i}(ii,7),TIME{i}(ii,8),TIME{i}(ii,9),TIME{i}(ii,10)))) / 10000);

        TIMEcat{i}(ii) = HOURcat + MINcat + SECcat + MILLIcat;
        
        if HOURzero == 1
            TIMEcat{i}(ii) = TIMEcat{i}(ii) - 36000;
        end

        if MINzero == 1
            TIMEcat{i}(ii) = TIMEcat{i}(ii) - 600;
        end
        
        if SECzero == 1
            TIMEcat{i}(ii) = TIMEcat{i}(ii) - 10;
        end

        if MILLIzero == 1
            TIMEcat{i}(ii) = TIMEcat{i}(ii) - 0.1;
        end
        clear HOURzero MINzero SECzero MILLIzero
    end
    TIMEcat = TIMEcat.';
    All{i,2} = TIMEcat{i}.';
end

stimulusIndex = zeros(150,1); %Preallocate an array of zeros to store when the stimulus presentation occurred for each trial
for i = 1:150
    stimulusIndex(i) = find('Stimulus' == All{i,3},1,'first'); %to find the first instance of stimulus
    All{i,5} = stimulusIndex(i);
    TimeSync(i) = All{i,2}(stimulusIndex(i));
end

d = TimeSync(1) - Events(1);
TimeSync = (TimeSync - d).';

for i = 1:(150 - length(Events))
    delta = TimeSync(1:numel(Events))-Events;
    for ii = 1:length(delta)
        if delta(ii) < -5
            new = TimeSync(ii);
            Events = [Events(1:ii-1,:); new; Events(ii:end,:)];
        break
        end
    end
end

if length(Events) ~= 150
    Events(150) = TimeSync(150);
end

AllEvents = Events;

for i = 1:length(AllEvents)
    All{i,6} = AllEvents(i);
end


%% Align Ca2+ and Behavior
%Converts the time in seconds to match the Synapse time
for i = 1:150
    for ii = 1:length(All{i,2})
        All{i,7} = All{i,2} - All{i,2}(stimulusIndex(i));
    end
end

%For the length of the TDMS window trial, capture the FP data within the
%same window
PTend = round(2*Fs);
Grace = round(.5*Fs);
for i = 1:150
    for ii = 1:length(All{i,7})
        pre = abs(All{i,7}(1));
        post = abs(All{i,7}(end));
        before = round(pre*Fs);
        after = round(post*Fs);

        key = find(Ts >= All{i,6});
        a = key(1,1);
        tempAlign = double(Z(key-before:key+after));
        All{i,8} = tempAlign;
        b(i) = abs(after - length(All{i,8}));
    end
    keyend = find(All{i,7} >= 2);
    LPTend(i) = keyend(1,1);
end
LPTend = median(LPTend);
GCaMPstart = median(b);

%Capture when the time of first lick occurs
for i = 1:150
    if strcmp(All{i,1},'Hit')
        Hitkey(i) = find(All{i,3} == 'Reward',1,'first');
        All{i,9} = nonzeros(Hitkey(i));
    elseif strcmp(All{i,1},'False Alarm')
        FAkey(i) = find(All{i,3} == 'Inappropriate Response',1,'first');
        All{i,10} = nonzeros(FAkey(i));
    elseif strcmp(All{i,1},'Auto Reward')
        ARkey(i) = find(All{i,3} == 'Auto Reward',1,'first');
        All{i,11} = nonzeros(ARkey(i));
    end
    keyGend = find(All{i,7} >= 0.50);
    GraceEnd(i) = keyGend(1,1);
end
GraceEnd = median(GraceEnd);

%% Calculate lick data for all trials
uplim = input('Please provide upper limit for lick data: ');
lowlim = input('Please provide lower limit for lick data: ');

for i = 1:150
    upkey{i} = find(All{i,4} >= uplim);
    lowkey{i} = find(All{i,4} <= lowlim);
    lickkey{i} = sort([upkey{i};lowkey{i}]);
    All{i,12} = lickkey{i};
end

%% Behavioral Segmentation
indexh = 1; %sets up index to calculate the number of hit trials
indexf = 1; %sets up index to calculate the number of FA trials
indexno = 1; %sets up index to calculate the number of NoGo trials
indexm = 1; %sets up index to calculate the number of Miss trials
indexar = 1; %sets up index to calculate the number of AR trials

for i = 1:150
    if strcmp(All{i,1}, 'Hit') %If trial is Hit, store relevant variables in cell array
        h{indexh,1} = All{i,4}; %Lick-related voltages
        h{indexh,2} = All{i,7}; %Voltage-related time in seconds
        h{indexh,3} = All{i,8}; %Calcium signals
        h{indexh,4} = All{i,12}; %Number and index of licks relative to voltage
        h{indexh,5} = All{i,5}; %Index of presentation time window start
        h{indexh,6} = All{i,9}; %Index of first lick outside of the grace period
        indexh = indexh + 1;

    elseif strcmp(All{i,1}, 'Miss') %If trial is Miss, store relevant variables in cell array
        m{indexm,1} = All{i,4}; %Lick-related voltages
        m{indexm,2} = All{i,7}; %Voltage-related time in seconds
        m{indexm,3} = All{i,8}; %Calcium signals
        m{indexm,4} = All{i,12}; %Number and index of licks relative to voltage
        m{indexm,5} = All{i,5}; %Index of presentation time window start
        indexm = indexm + 1;

    elseif strcmp(All{i,1}, 'False Alarm') %If trial is FA, store relevant variables in cell array
        f{indexf,1} = All{i,4}; %Lick-related voltages
        f{indexf,2} = All{i,7}; %Voltage-related time in seconds
        f{indexf,3} = All{i,8}; %Calcium signals
        f{indexf,4} = All{i,12}; %Number and index of licks relative to voltage
        f{indexf,5} = All{i,5}; %Index of presentation time window start
        f{indexf,6} = All{i,10}; %Index of first lick outside of the grace period
        indexf = indexf + 1;

    elseif strcmp(All{i,1}, 'Correct Rejection') %If trial is CR, store relevant variables in cell array
        no{indexno,1} = All{i,4}; %Lick-related voltages
        no{indexno,2} = All{i,7}; %Voltage-related time in seconds
        no{indexno,3} = All{i,8}; %Calcium signals
        no{indexno,4} = All{i,12}; %Number and index of licks relative to voltage
        no{indexno,5} = All{i,5}; %Index of presentation time window start
        indexno = indexno + 1;

    elseif strcmp(All{i,1}, 'Auto Reward') %If trial is AR, store relevant variables in cell array
        ar{indexar,1} = All{i,4}; %Lick-related voltages
        ar{indexar,2} = All{i,7}; %Voltage-related time in seconds
        ar{indexar,3} = All{i,8}; %Calcium signals
        ar{indexar,4} = All{i,12}; %Number and index of licks relative to voltage
        ar{indexar,5} = All{i,5}; %Index of presentation time window start
        ar{indexar,6} = All{i,11}; %Index of first lick outside of the grace period
        indexar = indexar + 1;
    end

    if i == 150
        indexh = indexh - 1; %As each iterating variable starts at 1, subtract one at the end
        indexm = indexm - 1; %As each iterating variable starts at 1, subtract one at the end
        indexf = indexf - 1; %As each iterating variable starts at 1, subtract one at the end
        indexno = indexno - 1; %As each iterating variable starts at 1, subtract one at the end
        indexar = indexar - 1; %As each iterating variable starts at 1, subtract one at the end
    end
end

if indexm > 0
    m(cellfun(@isempty,m)) = {NaN}; %If no licks are detected within the window, input a NaN instead of an empty cell
end

if indexno > 0
    no(cellfun(@isempty,no)) = {NaN}; %If no licks are detected within the window, input a NaN instead of an empty cell
end

%% Session Segmentation
if indexar > 1 && indexh < 1 %This trial output is suggestive of the Reward Session %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  REWARD  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Reward = 1; %Used for plotting the session appropriately
    NoGoTest = 0;
    Shaping = 0;
    ARGCaMP = padcat(ar{:,3}); %Concatenates all calcium signals
    ARLick = padcat(ar{:,1}); %Concatenates all licks
    ARLickTime = padcat(ar{:,4}); %Concatenates all lick indices
    sizear = size(ARLickTime); 
    for i = 1:indexar
        ARLickX(1:sizear(1),i) = i; %Creates a variable that will be used for the lick raster plot for AR
    end
    Startar = median([ar{:,5}]); %Calculates the median start index
    FirstLickar = mean([ar{:,6}]); %Calculates the average index of the first lick

    NoGCaMP = padcat(no{:,3}); %Concatenates all calcium signals
    NoLick = padcat(no{:,1}); %Concatenates all licks
    NoLickTime = padcat(no{:,4}); %Concatenates all lick indices
    sizeno = size(NoLickTime);
    for i = 1:indexno
        NoLickX(1:sizeno(1),i) = i; %Creates a variable that will be used for the lick raster plot for NoGo
    end
    Startno = median([no{:,5}]); %Calculates the median start index

elseif indexh > 1 && indexno > 1 %This trial output is suggestive of NoGo Testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  NOGO TESTING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    NoGoTest = 1; %Used for plotting the session appropriately
    Reward = 0;
    Shaping = 0;
    if indexh > 1 %If statement to catch if more than one hit trial is recorded
        HitGCaMP = padcat(h{:,3}); %Concatenates all calcium signals
        HitLick = padcat(h{:,1}); %Concatenates all licks
        HitLickTime = padcat(h{:,4}); %Concatenates all lick indices
        sizeh = size(HitLickTime);
        for i = 1:indexh
            HitLickX(1:sizeh(1),i) = i; %Creates a variable that will be used for the lick raster plot for Hit
        end
        Starth = median([h{:,5}]); %Calculates the median start index
        FirstLickh = mean([h{:,6}]); %Calculates the average index of the first lick
        HitRT = nonzeros(GoRT)'; %Combines all Hit reaction times
    elseif indexh == 1 %If statement to catch if only one hit trial is recorded
        HitGCaMP = h{:,3}; %Stores calcium signals
        HitLick = h{:,1}; %Stores licks
        HitLickTime = h{:,4}; %Stores lick indices
        FirstLickh = h{:,6}; %Stores first lick index
        Starth = h{:,5}; %Stores start index
    end

    if indexm > 1 %If statement to catch if more than one miss trial is recorded
        MissGCaMP = padcat(m{:,3}); %Concatenates all calcium signals
        MissLick = padcat(m{:,1}); %Concatenates all licks
        MissLickTime = padcat(m{:,4}); %Concatenates all lick indices
        sizem = size(MissLickTime);
        for i = 1:indexm
            MissLickX(1:sizem(1),i) = i; %Creates a variable that will be used for the lick raster plot for Miss
        end
        Startm = median([m{:,5}]); %Calculates the median start index
    elseif indexm == 1 %If statement to catch if only one miss trial is recorded
        MissGCaMP = m{:,3}; %Stores calcium signals
        MissLick = m{:,1}; %Stores licks
        MissLickTime = m{:,4}; %Stores lick indices
        sizem = size(MissLickTime);
        MissLickX(1:sizem(1)) = 1;
        Startm = h{:,5}; %Stores start index
    end

    if indexf > 1
        FAGCaMP = padcat(f{:,3}); %Concatenates all calcium signals
        FALick = padcat(f{:,1}); %Concatenates all licks
        FALickTime = padcat(f{:,4}); %Concatenates all lick indices
        sizef = size(FALickTime);
        for i = 1:indexf
            FALickX(1:sizef(1),i) = i; %Creates a variable that will be used for the lick raster plot for FA
        end
        Startf = median([f{:,5}]); %Calculates the median start index
        FirstLickf = mean([f{:,6}]); %Calculates the average index of the first lick
        FART = nonzeros(FArt)'; %Combines all FA reaction times
    elseif indexf == 1
        FAGCaMP = f{:,3}; %Stores calcium signals
        FALick = f{:,1}; %Stores licks
        FALickTime = f{:,4}; %Stores lick indices
        sizef = size(FALickTime);
        FALickX(1:sizef(1)) = 1;
        FirstLickf = f{:,6}; %Stores first lick index
        Startf = f{:,5}; %Stores start index
    end

    if indexno > 1
        NoGCaMP = padcat(no{:,3}); %Concatenates all calcium signals
        NoLick = padcat(no{:,1}); %Concatenates all licks
        NoLickTime = padcat(no{:,4}); %Concatenates all lick indices
        sizeno = size(NoLickTime);
        for i = 1:indexno
            NoLickX(1:sizeno(1),i) = i; %Creates a variable that will be used for the lick raster plot for NoGo
        end
        Startno = median([no{:,5}]); %Calculates the median start index
    elseif indexno == 1
        NoGCaMP = no{:,3}; %Stores calcium signals
        NoLick = no{:,1}; %Stores licks
        NoLickTime = no{:,4}; %Stores lick index
        Startno = no{:,5}; %Stores start index
    end
    
    Hitperc = Hits / (Hits + Misses) - 0.001; %Calculate Hit Rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    meanHitRT = nanmean(HitRT); %Calculates mean HitRT
    FAperc = FAs / (FAs + NoGos); %Calculate FA Rate
    meanFART = nanmean(FART); %Calculates mean FART
    Sens = norminv(Hitperc) - norminv(FAperc); %Calculates d' (or sensitivity)
    Bias = 0.5*(norminv(Hitperc) + norminv(FAperc)); %Calculates bias
    
    FinalBehavior = [Hitperc; FAperc; Sens; Bias; meanHitRT; meanFART]; %Concatenates all final data into single variable

elseif indexh > 1 && indexno < 1 %This trial output is suggestive of Shaping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SHAPING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Shaping = 1;
    Reward = 0;
    NoGoTest = 0;
    HitGCaMP = padcat(h{:,3}); %Concatenates all calcium signals
    HitLick = padcat(h{:,1}); %Concatenates all licks
    HitLickTime = padcat(h{:,4}); %Concatenates all lick indices
    sizeh = size(HitLickTime); 
    for i = 1:indexh
        HitLickX(1:sizeh(1),i) = i; %Creates a variable that will be used for the lick raster plot for AR
    end
    Starth = median([h{:,5}]); %Calculates the median start index
    FirstLickh = mean([h{:,6}]); %Calculates the average index of the first lick
    HitRT = nonzeros(GoRT)'; %Combines all Hit reaction times

    if indexm > 0
        MissGCaMP = padcat(m{:,3}); %Concatenates all calcium signals
        MissLick = padcat(m{:,1}); %Concatenates all licks
        MissLickTime = padcat(m{:,4}); %Concatenates all lick indices
        sizem = size(MissLickTime);
        for i = 1:indexm
            MissLickX(1:sizem(1),i) = i; %Creates a variable that will be used for the lick raster plot for NoGo
        end
        Startm = median([m{:,5}]); %Calculates the median start index
    end

    Hitperc = Hits / (Hits + Misses) - 0.001; %Calculate Hit Rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    meanHitRT = nanmean(HitRT); %Calculates mean HitRT
    FAperc = NaN;
    Sens = NaN;
    Bias = NaN;
    meanFART = NaN;

    FinalBehavior = [Hitperc; FAperc; Sens; Bias; meanHitRT; meanFART]; %Concatenates all final data into single variable
end

%% Calculate Paradigm-Related Measurements
if NoGoTest == 1
    %Lick rate relative to texture presentation (2s pre and post) for NoGo
    %Testing
    temp = LPTend - Starth;
    t2 = Starth - temp;

    if indexh > 0
        for i = 1:length(HitLickTime)
            PreLickh = numel(HitLickTime(HitLickTime >= t2 & HitLickTime <= Starth)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickh = numel(HitLickTime(HitLickTime >= Starth & HitLickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        preh = PreLickh / temp; %Calculates the lick rate (in Hz) for pre time for Hits
        posth = PostLickh / temp; %Calculates the lick rate (in Hz) for post time for Hits
    else
        preh = NaN;
        posth = NaN;
    end
    
    if indexm > 0
        for i = 1:length(MissLickTime)
            PreLickm = numel(MissLickTime(MissLickTime >= t2 & MissLickTime <= Startm)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickm = numel(MissLickTime(MissLickTime >= Startm & MissLickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        prem = PreLickm / temp; %Calculates the lick rate (in Hz) for pre time for Misses
        postm = PostLickm / temp; %Calculates the lick rate (in Hz) for post time for Misses
    else
        prem = NaN;
        postm = NaN;
    end
    
    if indexf > 0
        for i = 1:length(FALickTime)
            PreLickf = numel(FALickTime(FALickTime >= t2 & FALickTime <= Startf)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickf = numel(FALickTime(FALickTime >= Startf & FALickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        pref = PreLickf / temp; %Calculates the lick rate (in Hz) for pre time for FAs
        postf = PostLickf / temp; %Calculates the lick rate (in Hz) for post time for FAs
    else
        pref = NaN;
        postf = NaN;
    end
    
    if indexno > 0
        for i = 1:length(NoLickTime)
            PreLickno = numel(NoLickTime(NoLickTime >= t2 & NoLickTime <= Startno)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickno = numel(NoLickTime(NoLickTime >= Startno & NoLickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        preno = PreLickno / temp; %Calculates the lick rate (in Hz) for pre time  for NoGos
        postno = PostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos
    else
        preno = NaN;
        postno = NaN;
    end

%Lick rate relative to texture presentation (2s pre and post) for Reward
%Sessions
elseif Reward == 1
    temp = LPTend - Startar;
    t3 = Startar - temp; %This variable marks 2s before texture presentation

    if indexar > 0
        for i = 1:length(ARLickTime)
            PreLickar = numel(ARLickTime(ARLickTime >= t3 & ARLickTime <= Startar)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickar = numel(ARLickTime(ARLickTime >= Startar & ARLickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        prear = PreLickar / temp; %Calculates the lick rate (in Hz) for pre time for Hits
        postar = PostLickar / temp; %Calculates the lick rate (in Hz) for post time for Hits
    else
        prear = NaN;
        postar = NaN;
    end

    if indexno > 0
        for i = 1:length(NoLickTime)
            PreLickno = numel(NoLickTime(NoLickTime >= t3 & NoLickTime <= Startno)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            PostLickno = numel(NoLickTime(NoLickTime >= Startno & NoLickTime <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        preno = PreLickno / temp; %Calculates the lick rate (in Hz) for pre time  for NoGos
        postno = PostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos
    else
        preno = NaN;
        postno = NaN;
    end
end

if Reward == 1
    if indexar > 0
        for ii = 1:indexar
            [Pksar,Locsar] = findpeaks(ARGCaMP(:,ii),'MinPeakHeight',prctile(ARGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaAR{ii} = [Pksar Locsar]; %Save the amplitude and corresponding index into a new variable
            CaARtemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
            for iii = 1:length(CaAR{1,ii}) %Iterate through the list of peaks detected during a trial
                if CaAR{1,ii}(iii,2) <= GCaMPstart + LPTend && CaAR{1,ii}(iii,2) >= GCaMPstart - LPTend
                    CaARtemp(iii,1:2) = CaAR{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
                end
            end
        [~,CaARtempMax] = max(CaARtemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaARAmp(ii,1:2) = CaARtemp(CaARtempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaARAmp = mean(CaARAmp(:,1));
    MeanCaARLatency = mean(CaARAmp(:,2));
    elseif indexar == 0
        CaARAmp = 0;
        MeanCaARAmp = 0;
        MeanCaARLatency = 0;
    end

    if indexno > 0
        for ii = 1:indexno
            [PksNo,LocsNo] = findpeaks(NoGCaMP(:,ii),'MinPeakHeight',prctile(NoGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaNoGo{ii} = [PksNo LocsNo]; %Save the amplitude and corresponding index into a new variable
            CaNoGotemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
    
        for iii = 1:length(CaNoGo{1,ii}) %Iterate through the list of peaks detected during a trial
            if CaNoGo{1,ii}(iii,2) <= GCaMPstart + LPTend && CaNoGo{1,ii}(iii,2) >= GCaMPstart - LPTend 
                CaNoGotemp(iii,1:2) = CaNoGo{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
            end
        end
        [~,CaNoGotempMax] = max(CaNoGotemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaNoGoAmp(ii,1:2) = CaNoGotemp(CaNoGotempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaNoGoAmp = mean(CaNoGoAmp(:,1));
    MeanCaNoGoLatency = mean(CaNoGoAmp(:,2));
    elseif indexno == 0
        CaNoGoAmp = 0;
        MeanCaNoGoAmp = 0;
        MeanCaNoGoLatency = 0;
    end
end

%Calculate amplitude and latency of largest calcium signal within +/- 2s of
%the texture presentation
if NoGoTest == 1
    if indexh > 0
        for ii = 1:indexh
            [PksH,LocsH] = findpeaks(HitGCaMP(:,ii),'MinPeakHeight',prctile(HitGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaHit{ii} = [PksH LocsH]; %Save the amplitude and corresponding index into a new variable
            CaHittemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
            for iii = 1:length(CaHit{1,ii}) %Iterate through the list of peaks detected during a trial
                if CaHit{1,ii}(iii,2) <= GCaMPstart + LPTend && CaHit{1,ii}(iii,2) >= GCaMPstart - LPTend
                    CaHittemp(iii,1:2) = CaHit{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
                end
            end
        [~,CaHittempMax] = max(CaHittemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaHitAmp(ii,1:2) = CaHittemp(CaHittempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaHitAmp = mean(CaHitAmp(:,1));
    MeanCaHitLatency = mean(CaHitAmp(:,2));
    elseif indexh == 0
        CaHitAmp = 0;
        MeanCaHitAmp = 0;
        MeanCaHitLatency = 0;
    end
    
    if indexm > 0
        for ii = 1:indexm
            [PksM,LocsM] = findpeaks(MissGCaMP(:,ii),'MinPeakHeight',prctile(MissGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaMiss{ii} = [PksM LocsM]; %Save the amplitude and corresponding index into a new variable
            CaMisstemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
            for iii = 1:length(CaMiss{1,ii}) %Iterate through the list of peaks detected during a trial
                if CaMiss{1,ii}(iii,2) <= GCaMPstart + LPTend && CaMiss{1,ii}(iii,2) >= GCaMPstart - LPTend
                    CaMisstemp(iii,1:2) = CaMiss{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
                end
            end
        [~,CaMisstempMax] = max(CaMisstemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaMissAmp(ii,1:2) = CaMisstemp(CaMisstempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaMissAmp = mean(CaMissAmp(:,1));
    MeanCaMissLatency = mean(CaMissAmp(:,2));
    elseif indexm == 0
        CaMissAmp = 0;
        MeanCaMissAmp = 0;
        MeanCaMissLatency = 0;
    end
    
    if indexf > 0
        for ii = 1:indexf
            [PksFA,LocsFA] = findpeaks(FAGCaMP(:,ii),'MinPeakHeight',prctile(FAGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaFA{ii} = [PksFA LocsFA]; %Save the amplitude and corresponding index into a new variable
            CaFAtemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
            for iii = 1:length(CaFA{1,ii}) %Iterate through the list of peaks detected during a trial
                if CaFA{1,ii}(iii,2) <= GCaMPstart + LPTend && CaFA{1,ii}(iii,2) >= GCaMPstart - LPTend
                    CaFAtemp(iii,1:2) = CaFA{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
                end
            end
        [~,CaFAtempMax] = max(CaFAtemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaFAAmp(ii,1:2) = CaFAtemp(CaFAtempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaFAAmp = mean(CaFAAmp(:,1));
    MeanCaFALatency = mean(CaFAAmp(:,2));
    elseif indexf == 0
        CaFAAmp = 0;
        MeanCaFAAmp = 0;
        MeanCaFALatency = 0;
    end
    
    if indexno > 0
        for ii = 1:indexno
            [PksNo,LocsNo] = findpeaks(NoGCaMP(:,ii),'MinPeakHeight',prctile(NoGCaMP(:,ii),90),'MinPeakWidth',2); %Find peaks within the trial window that are at or above the 90th percentile
            CaNoGo{ii} = [PksNo LocsNo]; %Save the amplitude and corresponding index into a new variable
            CaNoGotemp = [0 0]; %(Re)set the temporary variable in case multiple peaks are detected within the window
    
    
        for iii = 1:length(CaNoGo{1,ii}) %Iterate through the list of peaks detected during a trial
            if CaNoGo{1,ii}(iii,2) <= GCaMPstart + LPTend && CaNoGo{1,ii}(iii,2) >= GCaMPstart - LPTend 
                CaNoGotemp(iii,1:2) = CaNoGo{1,ii}(iii,1:2); %Capture the Ca2+ signals and timepoint if they are within +/- 2s window of the texture presentation
            end
        end
        [~,CaNoGotempMax] = max(CaNoGotemp(:,1)); %Take the maximal Ca2+ signal value within the +/- 2s window
        CaNoGoAmp(ii,1:2) = CaNoGotemp(CaNoGotempMax,:); %Append maximal Ca2+ signal and timepoint value into a single array
        end
    MeanCaNoGoAmp = mean(CaNoGoAmp(:,1));
    MeanCaNoGoLatency = mean(CaNoGoAmp(:,2));
    elseif indexno == 0
        CaNoGoAmp = 0;
        MeanCaNoGoAmp = 0;
        MeanCaNoGoLatency = 0;
    end
end
%% AUROC Analysis
if indexh > 0
    AllZHit = padcat(h{:,3})'; %Combine all ZMAD calcium signals for all hit trials
    AllZHitTrunc = AllZHit(:,1:6000); %Make sure that the window size is consistent for all trials
    SlidingSteps = 20; %Time value of sliding window
    WindowSize = 100;
    StartValue = 1000;
    EndValue = 5800;
    InitialBasalWindow = 1;
    EndBasalWindow = 100;
    WinCounter = 1;

    for yy = StartValue:SlidingSteps:EndValue
        WinTime(WinCounter,1) = yy;

        yy
        [hm hn] = size(AllZHitTrunc);
        
            for x = 1:hm
                y(x,1) = mean(AllZHitTrunc(x,InitialBasalWindow:EndBasalWindow));
                y2(x,1) = mean(AllZHitTrunc(x,yy:yy + WindowSize));
            end
            y3 = cat(1,y,y2); %Concatenate to prepare for the AUROC function
            
            categories2(length(y3)/2,1) = 0;
            categories2(length(y):length(y3),1) = 1;
            t = categories2;
    
            [tp,fp] = roc([t(x),y3(x)]);
            [A,Aci] = auc([t,y3],0.05,'hanley');
            AreaUCHit(1,WinCounter) = A;
    
            %Bootstrap test of difference from 0.5
            p = auc_bootstrap([t,y3]);
            confidenceP(1,WinCounter) = p;
            WinCounter = WinCounter + 1;

        clear y y2 y3 categories2
    end
    figure
    plot(WinTime,AreaUCHit)
    title('Hit AUROC')
    [HAUROCamp,HAUROCind] = max(AreaUCHit);
    HAUROCind = WinTime(HAUROCind);
end

if indexm > 0
    AllZMiss = padcat(m{:,3})'; %Combine all ZMAD calcium signals for all miss trials
    AllZMissTrunc = AllZMiss(:,1:6000);
    SlidingSteps = 20; %Time value of sliding window
    WindowSize = 100;
    StartValue = 1000;
    EndValue = 5800;
    InitialBasalWindow = 1;
    EndBasalWindow = 100;
    WinCounter = 1;

    for yy = StartValue:SlidingSteps:EndValue
        WinTime(WinCounter,1) = yy;
        
        yy
        [mm mn] = size(AllZMissTrunc);
        for x = 1:mm
            y(x,1) = mean(AllZMissTrunc(x,InitialBasalWindow:EndBasalWindow));
            y2(x,1) = mean(AllZMissTrunc(x,yy:yy+WindowSize));
        end

        y3 = cat(1,y,y2); %Concatenate to prepare for the AUROC function

        categories2(length(y3)/2,1) = 0;
        categories2(length(y):length(y3),1) = 1;
        t = categories2;
                
        [tp,fp] = roc([t(x),y3(x)]);
        [A,Aci] = auc([t,y3],0.05,'hanley');
        AreaUCMiss(1,WinCounter) = A;

        %Bootstrap test of difference from 0.5
        p = auc_bootstrap([t,y3]);
        confidenceP(1,WinCounter) = p;
        WinCounter = WinCounter + 1;

        clear y y2 y3 categories2
    end
    figure
    plot(WinTime,AreaUCMiss)
    title('Miss AUROC')
    [MAUROCamp,MAUROCind] = max(AreaUCMiss);
    MAUROCind = WinTime(MAUROCind);
end

if indexf > 0
    AllZFA = padcat(f{:,3})'; %Combine all ZMAD calcium signals for all FA trials
    AllZFATrunc = AllZFA(:,1:6000);
    SlidingSteps = 20; %Time value of sliding window
    WindowSize = 100;
    StartValue = 1000;
    EndValue = 5800;
    InitialBasalWindow = 1;
    EndBasalWindow = 100;
    WinCounter = 1;

    for yy = StartValue:SlidingSteps:EndValue
        WinTime(WinCounter,1) = yy;
        
        yy
        [fm fn] = size(AllZFATrunc);
        for x = 1:fm
            y(x,1) = mean(AllZFATrunc(x,InitialBasalWindow:EndBasalWindow));
            y2(x,1) = mean(AllZFATrunc(x,yy:yy+WindowSize));
        end

        y3 = cat(1,y,y2); %Concatenate to prepare for the AUROC function

        categories2(length(y3)/2,1) = 0;
        categories2(length(y):length(y3),1) = 1;
        t = categories2;
                
        [tp,fp] = roc([t(x),y3(x)]);
        [A,Aci] = auc([t,y3],0.05,'hanley');
        AreaUCFA(1,WinCounter) = A;

        %Bootstrap test of difference from 0.5
        p = auc_bootstrap([t,y3]);
        confidenceP(1,WinCounter) = p;
        WinCounter = WinCounter + 1;

        clear y y2 y3 categories2
    end
    figure
    plot(WinTime,AreaUCFA)
    title('FA AUROC')
    [FAUROCamp,FAUROCind] = max(AreaUCFA);
    FAUROCind = WinTime(FAUROCind);
end


if indexno > 0
    AllZNoGo = padcat(no{:,3})'; %Combine all ZMAD calcium signals for NoGo trials
    AllZNoGoTrunc = AllZNoGo(:,1:6000);
    SlidingSteps = 20; %Time value of sliding window
    WindowSize = 100;
    StartValue = 1000;
    EndValue = 5800;
    InitialBasalWindow = 1;
    EndBasalWindow = 100;
    WinCounter = 1;

    for yy = StartValue:SlidingSteps:EndValue
        WinTime(WinCounter,1) = yy;
        
        yy
        [nom non] = size(AllZNoGoTrunc);
        for x = 1:nom
            y(x,1) = mean(AllZNoGoTrunc(x,InitialBasalWindow:EndBasalWindow));
            y2(x,1) = mean(AllZNoGoTrunc(x,yy:yy+WindowSize));
        end

        y3 = cat(1,y,y2); %Concatenate to prepare for the AUROC function

        categories2(length(y3)/2,1) = 0;
        categories2(length(y):length(y3),1) = 1;
        t = categories2;
                
        [tp,fp] = roc([t(x),y3(x)]);
        [A,Aci] = auc([t,y3],0.05,'hanley');
        AreaUCNoGo(1,WinCounter) = A;

        %Bootstrap test of difference from 0.5
        p = auc_bootstrap([t,y3]);
        confidenceP(1,WinCounter) = p;
        WinCounter = WinCounter + 1;

        clear y y2 y3 categories2
    end
    figure
    plot(WinTime,AreaUCNoGo)
    title('NoGo AUROC')
    [NoAUROCamp,NoAUROCind] = max(AreaUCNoGo);
    NoAUROCind = WinTime(NoAUROCind);
end


%% Plotting Session Segmentation
if Reward == 1 %If the Reward contingency is detected in the previous if statement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  REWARD  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:6
        subplot(3,2,i) %Sets up 3x2 subplot (First row = lick raster; Second row = calcium signals of individual trials; Third row = average calcium trace)

        if i == 1
            scatter(ARLickTime,ARLickX,'|','k'); %Plots licks for each trial
            xline(Startar,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xlim([0 length(ARLick)]); %Limits the x-axis to the length of the longest AR trial
            ylim([0 ARs]); %Limits the y-axis to the number of AR trials
            ylabel('Trial'); %Labels y-axis trial
            title('Auto Reward'); %Labels title Auto Reward

        elseif i == 2
            scatter(NoLickTime,NoLickX,'|','k'); %Plots licks for each trial
            xline(Startno,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xlim([0 length(NoLick)]); %Limits the x-axis to the length of the longest NoGo trial
            ylim([0 NoGos]); %Limits the y-axis to the number of NoGo trials
            title('Correct Rejection'); %Labels title Correct Rejection

        elseif i == 3
            imagesc(ARGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line

        elseif i == 4
            imagesc(NoGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line

        elseif i == 5
            plot(nanmean(ARGCaMP')); %Plots the mean of AR calcium signals excluding NaNs
            xlim([0 length(ARGCaMP)]); %Limits the x-axis to the length of the longest AR trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            mygca(i) = gca; %Captures the y-axis to standardize later

        elseif i == 6
            plot(nanmean(NoGCaMP')); %Plots the mean of NoGo calcium signals excluding NaNs
            xlim([0 length(NoGCaMP)]); %Limits the x-axis to the length of the longest NoGo trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            mygca(i) = gca; %Captures the y-axis to standardize later
        end
    end
    
    yl = cell2mat(get(mygca(5:6),'Ylim')); %capture y-limit information for the average subplots
    ylnew = [min(yl(:,1)) max(yl(:,2))]; %capture minimum and maximum y limits for all average subplots
    set(mygca(5:6),'YLim',ylnew); %set y-axes for all average subplots
end

if NoGoTest == 1 %If the NoGo Testing contingency is detected in the previous if statement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  NOGO TESTING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:12
        subplot(3,4,i); %Sets up 3x4 subplot (First row = lick raster; Second row = calcium signals of individual trials; Third row = average calcium trace)

        if i == 1
            scatter(HitLickTime,HitLickX,'|','k'); %Plots licks for each trial
            xline(Starth,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xline(FirstLickh,'LineWidth',2,'color','m'); %Sets the average time of first lick
            xlim([0 length(HitLick)]); %Limits the x-axis to the length of the longest Hit trial
            ylim([0 Hits]); %Limits the y-axis to the number of Hit trials
            ylabel('Trial'); %Labels y-axis trial
            title('Hit'); %Labels title Hit

        elseif i == 2
            if indexm > 0
                scatter(MissLickTime,MissLickX,'|','k'); %Plots licks for each trial
                xline(Startm,'LineWidth',2,'color','r'); %Sets the presentation time start line
                xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
                xlim([0 length(MissLick)]); %Limits the x-axis to the length of the longest Miss trial
                ylim([0 Misses]); %Limits the y-axis to the number of Miss trials
            end
            title('Miss'); %Labels title Miss

        elseif i == 3
            scatter(FALickTime,FALickX,'|','k'); %Plots licks for each trial
            xline(Startf,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xline(FirstLickf,'LineWidth',2,'color','m'); %Sets the average time of first lick
            xlim([0 length(FALick)]); %Limits the x-axis to the length of the longest FA trial
            ylim([0 FAs]); %Limits the y-axis to the number of FA trials
            title('False Alarm'); %Labels title False Alarm

        elseif i == 4
            scatter(NoLickTime,NoLickX,'|','k'); %Plots licks for each trial
            xline(Startno,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xlim([0 length(NoLick)]); %Limits the x-axis to the length of the longest NoGo trial
            ylim([0 NoGos]); %Limits the y-axis to the number of NoGo trials
            title('Correct Rejection') %Labels title Correct Rejection

        elseif i == 5
            imagesc(HitGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            ylabel('Trial'); %Labels y-axis trial

        elseif i == 6
            if indexm > 0
                imagesc(MissGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            end
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line

        elseif i == 7
            imagesc(FAGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line

        elseif i == 8
            imagesc(NoGCaMP'); %Plots the heat plot of calcium signals for each individual trial
            clim([-2 3]); %Sets the colormap limits
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line

        elseif i == 9
            plot(nanmean(HitGCaMP')); %Plots the mean of Hit calcium signals excluding NaNs
            xlim([0 length(HitGCaMP)]); %Limits the x-axis to the length of the longest Hit trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            ylabel('ZMAD Amplitude'); %Labels y-axis ZMAD Amplitude
            mygca(i) = gca; %Captures the y-axis to standardize later

        elseif i == 10
            if indexm > 0
                plot(nanmean(MissGCaMP')); %Plots the mean of Miss calcium signals excluding NaNs
            xlim([0 length(MissGCaMP)]); %Limits the x-axis to the length of the longest Miss trial
            end
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            mygca(i) = gca; %Captures the y-axis to standardize later

        elseif i == 11
            plot(nanmean(FAGCaMP')); %Plots the mean of FA calcium signals excluding NaNs
            xlim([0 length(FAGCaMP)]); %Limits the x-axis to the length of the longest FA trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            mygca(i) = gca; %Captures the y-axis to standardize later

        elseif i == 12
            plot(nanmean(NoGCaMP')); %Plots the mean of NoGo calcium signals excluding NaNs
            xlim([0 length(NoGCaMP)]); %Limits the x-axis to the length of the longest NoGo trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            mygca(i) = gca; %Captures the y-axis to standardize later
        end
    end

    yl = cell2mat(get(mygca(9:12),'Ylim')); %capture y-limit information for the average subplots
    ylnew = [min(yl(:,1)) max(yl(:,2))]; %capture minimum and maximum y limits for all average subplots
    set(mygca(9:12),'YLim',ylnew); %set y-axes for all average subplots

    for i = 1:12 %Adds in a mostly transparent rectangle that symbolizes the grace period
        subplot(3,4,i)
    
        if i == 1
            if indexh > 0
                z1 = patch([Starth GraceEnd GraceEnd Starth],[0 0 indexh indexh],'c'); %Sets the x and y limits of the rectangle
                alpha(z1,0.2); %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 2
            if indexm > 0
                z2 = patch([Startm GraceEnd GraceEnd Startm],[0 0 indexm indexm],'c'); %Sets the x and y limits of the rectangle
                alpha(z2,0.2); %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 3
            if indexf > 0
                z3 = patch([Startf GraceEnd GraceEnd Startf],[0 0 indexf indexf],'c'); %Sets the x and y limits of the rectangle
                alpha(z3,0.2); %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 4
            if indexno > 0
                z4 = patch([Startno GraceEnd GraceEnd Startno],[0 0 indexno indexno],'c'); %Sets the x and y limits of the rectangle
                alpha(z4,0.2); %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 9
            if indexh > 0
                z9 = patch([GCaMPstart GCaMPstart+Grace GCaMPstart+Grace GCaMPstart],[ylnew(1) ylnew(1) ylnew(2) ylnew(2)],'c'); %Sets the x and y limits of the rectangle
                alpha(z9, 0.2) %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 10
            if indexm > 0
                z10 = patch([GCaMPstart GCaMPstart+Grace GCaMPstart+Grace GCaMPstart],[ylnew(1) ylnew(1) ylnew(2) ylnew(2)],'c'); %Sets the x and y limits of the rectangle
                alpha(z10,0.2) %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 11
            if indexf > 0
                z11 = patch([GCaMPstart GCaMPstart+Grace GCaMPstart+Grace GCaMPstart],[ylnew(1) ylnew(1) ylnew(2) ylnew(2)],'c'); %Sets the x and y limits of the rectangle
                alpha(z11,0.2) %Sets the transparency of the rectangle to 0.2
            end
    
        elseif i == 12
            if indexno > 0
                z12 = patch([GCaMPstart GCaMPstart+Grace GCaMPstart+Grace GCaMPstart],[ylnew(1) ylnew(1) ylnew(2) ylnew(2)],'c'); %Sets the x and y limits of the rectangle
                alpha(z12,0.1) %Sets the transparency of the rectangle to 0.2
            end
        end
    end
end


if Shaping == 1 %If the Shaping contingency is detected in the previous if statement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SHAPING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:6
        subplot(3,2,i)

        if i == 1
            scatter(HitLickTime,HitLickX,'|','k'); %Plots licks for each trial
            xline(Starth,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xline(FirstLickh,'LineWidth',2,'color','m'); %Sets the average time of first lick
            xlim([0 length(HitLick)]); %Limits the x-axis to the length of the longest Hit trial
            ylim([0 Hits]); %Limits the y-axis to the number of Hit trials
            ylabel('Trial'); %Labels y-axis trial
            title('Hit'); %Labels title Hit

        elseif i == 2
            if indexm > 0
                scatter(MissLickTime,MissLickX,'|','k'); %Plots licks for each trial
            xline(Startm,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            xlim([0 length(MissLick)]); %Limits the x-axis to the length of the longest NoGo trial
            ylim([0 Misses]); %Limits the y-axis to the number of NoGo trials
            end
            title('Miss'); %Labels title Correct Rejection

        elseif i == 3
            imagesc(HitGCaMP');
            clim([-2 3]);
            xline(GCaMPstart,'LineWidth',2,'color','r');
            xline(GCaMPstart+PTend,'LineWidth',2,'color','r');
            ylabel('Trial');

        elseif i == 4
            if indexm > 0
                imagesc(MissGCaMP');
                clim([-2 3]);
                xline(GCaMPstart,'LineWidth',2,'color','r');
                xline(GCaMPstart+PTend,'LineWidth',2,'color','r');
            end

        elseif i == 5
            plot(nanmean(HitGCaMP')); %Plots the mean of Hit calcium signals excluding NaNs
            xlim([0 length(HitGCaMP)]); %Limits the x-axis to the length of the longest Hit trial
            xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
            xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            ylabel('ZMAD Amplitude'); %Labels y-axis ZMAD Amplitude
            mygca(i) = gca; %Captures the y-axis to standardize later

        elseif i == 6
            if indexm > 0
                plot(nanmean(MissGCaMP')); %Plots the mean of Hit calcium signals excluding NaNs
                xlim([0 length(MissGCaMP)]); %Limits the x-axis to the length of the longest Hit trial
                xline(GCaMPstart,'LineWidth',2,'color','r'); %Sets the presentation time start line
                xline(GCaMPstart + PTend,'LineWidth',2,'color','r'); %Sets the presentation time end line
            end
            mygca(i) = gca; %Captures the y-axis to standardize later
        end
    end

    yl = cell2mat(get(mygca(5:6),'Ylim')); %capture y-limit information for the average subplots
    ylnew = [min(yl(:,1)) max(yl(:,2))]; %capture minimum and maximum y limits for all average subplots
    set(mygca(5:6),'YLim',ylnew); %set y-axes for all average subplots
end

%Stores all relevant data within a structure to be saved
Final.data = All;
if indexh > 0
    Final.Hits = h;
    Final.HAUROC = [HAUROCamp, HAUROCind];
end

if indexm > 1
    Final.Misses = m;
    Final.MissAUROC = [MAUROCamp, MAUROCind];
else
    Final.Misses = [];
    Final.MissAUROC = [];
end

if indexf > 0
    Final.FAs = f;
    Final.FAAUROC = [FAUROCamp, FAUROCind];
else
    Final.FAs = [];
    Final.FAAUROC = [];
end

if indexno > 0
    Final.NoGos = no;
    Final.NoAUROC = [NoAUROCamp, NoAUROCind];
else
    Final.NoGos = [];
    Final.NoAUROC = [];
end


if NoGoTest == 1
    Final.PreLick = [preh, prem, pref, preno];
    Final.PostLick = [posth, postm, postf, postno];
    Final.Behavior = FinalBehavior;
    Final.MeanCaSignals = [MeanCaHitAmp, MeanCaMissAmp, MeanCaFAAmp, MeanCaNoGoAmp];
    Final.MeanCaLatency = [MeanCaHitLatency, MeanCaMissLatency, MeanCaFALatency, MeanCaNoGoLatency];
    Final.RawCaHitSignal = CaHitAmp;
    Final.RawCaMissSignal = CaMissAmp;
    Final.RawCaFASignal = CaFAAmp;
    Final.RawCaNoGoSignal = CaNoGoAmp;
elseif Reward == 1
    Final.PreLick = [prear, preno];
    Final.PostLick = [postar, postno];
    Final.RawCaARSignal = CaARAmp;
    Final.RawCaNoGoSignal = CaNoGoAmp;
end

save('Segmentation.mat','Final');