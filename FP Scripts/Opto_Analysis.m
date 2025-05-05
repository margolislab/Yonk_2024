%{
---------------------------------------------------------------------------------------------------------------------------------------------------------
Full Optogenetic Analyis Script
Written by: Alex Yonk
Modified by: Logan Pasternak & Sofia Juliani
Last modification date: 2023-05-30

OBJECTIVE = Combine data from TDMS (licks), behavioral output (text file),
and signals collected within the Tucker-Davis Technologies Synapse software
(pupil dynamics and whisker dynamics) for correlational analysis based on 
trial outcome (Hit, Miss, False Alarm, and Correct Rejection).
---------------------------------------------------------------------------------------------------------------------------------------------------------
%}

%% Data importation %%
clear; %Clear all variables
clc; %Clear command window
TDMSstructpath = 'C:\Users\ajy31\OneDrive - Rutgers University\Documents\a. Scripts\TDMS_getStruct'; %Hardcode the location of the TDMS_getStruct variable
addpath(genpath(TDMSstructpath)); %Add the TDMS struct folder to the path

%Permits user to select TDMS folder
disp('Please select tdms folder');
[TDMSpath] = uigetdir; %Permits user to choose the TDMS folder

padcatpath = 'C:\Users\ajy31\OneDrive - Rutgers University\Documents\a. Scripts\PADCAT';
addpath(genpath(padcatpath));

%Permits user to select the TDMS file to the related folder
disp('Please select the related tdms text file');
[file, Textpath] = uigetfile('*.txt'); %Permits user to select related TDMS text file
txtpath = fullfile(Textpath,file);

%Permits user to select the Opto folder related to the TDMS data
disp('Please select the related optogenetic video folder');
[Optopath] = uigetdir; %Permits user to select related opto folder
SDKpath = 'C:\Users\ajy31\OneDrive - Rutgers University\Documents\a. Scripts\TDTMatlabSDK-master'; %Hardcode the location of the TDTbin2mat folder
addpath(genpath(SDKpath)); %Add the TDTbin2mat folder to the path

%Permits user to choose if optogenetic stimulation was performed
Decision = str2num(cell2mat(inputdlg('Was optogenetic actuation employed during this session? If yes, input 1: ')));

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
cd(Optopath);
OptoData = TDTbin2mat(Optopath);
Events = OptoData.epocs.sqr_.onset; %TS of the events

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

trueTDMS = cell([150,1]); %Even-numbered indices are invalid, so they are removed
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

%Creates the All variable to store all related data
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
%the Synapse data
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

%Converts the time in seconds to match the Synapse time
for i = 1:150
    for ii = 1:length(All{i,2})
        All{i,7} = All{i,2} - All{i,2}(stimulusIndex(i));
    end
end

%% Behavioral Analysis Segmentation
%All variable contains all task-related data
%Column 1 --> Trial Outcome
%Column 2 --> Time Concatenation of Event Flags
%Column 3 --> Behavioral Event Flags
%Column 4 --> Voltage Values related to each Event Flag
%Column 5 --> Synchronization point with Synapse software (When the texture
    %reaches its destination within the whisker field)
%Column 6 --> Time of synchronization point in Synapse time
%Column 7 --> Time of behavioral flags in relation to synchronization point

% Permits user to input upper and lower thresholds for lick data
uplim = input('Please provide upper limit for lick data: ');
lowlim = input('Please provide lower limit for lick data: ');
All(:,8:12) = {[]}; %Adds empty cells within array for concatenating future arrays

for i = 1:150
    keyend = find(All{i,7} >= 2); %Capture when 2s post texture presentation
    LPTend(i) = keyend(1,1);
end
LPTend = median(LPTend); %Find median value of texture presentation
TextStart = median(cell2mat(All(:,5))); %Indicates when the presentation window starts
temp = LPTend - TextStart; %Calculate the amount of samples that equals 2s
PreLick = TextStart - temp; %Subtract the 2s sample amount from the median texture presentation start

if Decision == 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LED SEGEMENTATION ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:150 %As each condition is segmented into 50 trials
        upkey{i} = find(All{i,4} >= uplim); %Find all voltages that are equal to or above the upper threshold limit within the Baseline data
        lowkey{i} = find(All{i,4} <= lowlim); %Find all voltages that are equal to or below the lower threshold limit within the Baseline data
        lickkey{i} = sort([upkey{i}; lowkey{i}]); %Sort the upper and lower voltages into a single array
        All{i,12} = lickkey{i}; %Append all lick data into the BaselineData array
    end
    
    BaselineData = All(1:50,:); %Capture all data for the first 50 trials in the BaselineData variable
    indexhBase = 0; %Index to count number of hits during baseline
    indexmBase = 0; %Index to count number of misses during baseline
    indexfBase = 0; %Index to count number of FAs during baseline
    indexnoBase = 0; %Index to count number of NoGos during baseline
    indexarBase = 0; %Index to count number of ARs during baseline

    for i = 1:length(BaselineData)
        if strcmp(BaselineData{i,1},'Hit') %If Hit is detected
            BaseHitkey(i) = find(BaselineData{i,3} == 'Reward',1,'first'); %Capture the first instance of reward (indicative of a Hit trial)
            BaselineData{i,8} = nonzeros(BaseHitkey(i)); %Store all nonzero data within the baseline variable
            BaseHit(i,:) = BaselineData(i,:); %Move all related data into the BaseHit array
            indexhBase = indexhBase + 1; %Increment the index counting variable
        elseif strcmp(BaselineData{i,1},'Miss') %If Miss is detected
            BaselineData{i,9} = 1; %Placeholder value
            BaseMiss(i,:) = BaselineData(i,:); %Move all related data into the BaseMiss array
            indexmBase = indexmBase + 1; %Increment the index counting variable 
        elseif strcmp(BaselineData{i,1},'False Alarm') %If FA is detected
            BaseFAkey(i) = find(BaselineData{i,3} == 'Inappropriate Response',1,'first'); %Capture the first instance of Inappropriate Response (indicative of FA)
            BaselineData{i,10} = nonzeros(BaseFAkey(i)); %Store all nonzero data within the baseline variable
            BaseFA(i,:) = BaselineData(i,:); %Move all related data into the BaseFA array
            indexfBase = indexfBase + 1; %Increment the index counting variable
        elseif strcmp(BaselineData{i,1},'Correct Rejection') %If Correct Rejection is detected
            BaselineData{i,11} = 1; %Store placeholder variable
            BaseNo(i,:) = BaselineData(i,:); %Move all related data into the BaseNo array
            indexnoBase = indexnoBase + 1; %Increment the index counting variable
        elseif strcmp(BaselineData{i,1},'Auto Reward') %If AR is detected
            BaseARkey(i) = find(BaselineData{i,3} == 'Auto Reward',1,'first'); %Capture the first instance of Auto Reward (indicative of AR)
            BaselineData{i,12} = nonzeros(BaseARkey(i)); %Store all nonzero data within baseline variable
            BaseAR(i,:) = BaselineData(i,:); %Move all related data into the BaseAR array
            indexarBase = indexarBase + 1; %Increment the index counting variable
        end
    end
    
    if indexhBase > 0
        BaseHit = BaseHit(~cellfun(@isempty,BaseHit(:,1)),:); %Removes all nonzero rows from array
    end

    if indexmBase > 0
        BaseMiss = BaseMiss(~cellfun(@isempty,BaseMiss(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexfBase > 0
        BaseFA = BaseFA(~cellfun(@isempty,BaseFA(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexnoBase > 0
        BaseNo = BaseNo(~cellfun(@isempty,BaseNo(:,1)),:); %Removes all nonzero rows from array
    end

    if indexarBase > 0
        BaseAR = BaseAR(~cellfun(@isempty,BaseAR(:,1)),:); %Removes all nonzero rows from array
    end

    BaseHitRate = indexhBase / (indexhBase + indexmBase) - 0.001; %Calculate baseline hit rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    BaseFARate = indexfBase / (indexfBase + indexnoBase) - 0.001; %Calculate baseline FA rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    BaseSens = norminv(BaseHitRate) - norminv(BaseFARate); %Calculate baseline sensitivity
    BaseBias = 0.5*(norminv(BaseHitRate) + norminv(BaseFARate)); %Calculate baseline bias
    BaseFinal = [BaseHitRate; BaseFARate; BaseSens; BaseBias]; %Concatenate all variables into a single array

    Off = {}; %Create cell array to store Off-related data
    indexhOff = 0; %Index to count number of hits during Off
    indexmOff = 0; %Index to count number of misses during Off
    indexfOff = 0; %Index to count number of FAs during Off
    indexnoOff = 0; %Index to count number of NoGos during Off
    indexarOff = 0; %Index to count number of ARs during Off
    
    On = {}; %Create cell array to store On-related data
    indexhOn = 0; %Index to count number of hits during On
    indexmOn = 0; %Index to count number of misses during On
    indexfOn = 0; %Index to count number of FAs during On
    indexnoOn = 0; %Index to count number of NoGos during On
    indexarOn = 0; %Index to count number of ARs during On
    A = 0; %Set iterating variable to capture alternating Off-On blocks
    B = 1; %Set iterating variable to capture alternating Off-On blocks
    C = 10; %Set iterating variable to capture alternating Off-On blocks

    for i = 1:5 %As Off/On are segmented into 5 blocks of 10 trials (50 trials per condition)
        Off(B:C,:) = All(51+A:60+A,:); %Capture the first ten trials starting at trial 51 (On start)
        On(B:C,:) = All(61+A:70+A,:); %Capture the first ten trials starting at trial 61 (Off start)
        A = A + 20; %Increment the iterating variable by 20 (skipping over the following Off or On block)
        B = B + 10; %Increment the starting storing variable
        C = C + 10; %Increment the ending storing variable
    end

    for i = 1:length(Off) %For the Off trials
        if strcmp(Off{i,1},'Hit') %If Hit is detected
            OffHitkey(i) = find(Off{i,3} == 'Reward',1,'first'); %Capture the first instance of Reward (Indicative of Hit trial)
            Off{i,8} = nonzeros(OffHitkey(i)); %Store all nonzero data within the Off variable
            OffHit(i,:) = Off(i,:); %Move all related data into the OffHit array
            indexhOff = indexhOff + 1; %Increment the index counting variable
        elseif strcmp(Off{i,1},'Miss') %If Miss is detected
            Off{i,9} = 1; %Store placeholder variable
            OffMiss(i,:) = Off(i,:); %Move all related data into the OffMiss array
            indexmOff = indexmOff + 1; %Increment the index counting variable
        elseif strcmp(Off{i,1},'False Alarm') %If FA is detected
            OffFAkey(i) = find(Off{i,3} == 'Inappropriate Response',1,'first'); %Capture the first instance of Inappropriate Response (indicative of FA)
            Off{i,10} = nonzeros(OffFAkey(i)); %Store all nonzero data within the Off variable
            OffFA(i,:) = Off(i,:); %Move all related data into the OffFA array
            indexfOff = indexfOff + 1; %Increment the index counting variable
        elseif strcmp(Off{i,1},'Correct Rejection') %If CR is detected
            Off{i,11} = 1; %Store placeholder variable
            OffNo(i,:) = Off(i,:); %Move all related data into the OffNo array
            indexnoOff = indexnoOff + 1; %Increment the index counting variable
        elseif strcmp(Off{i,1},'Auto Reward') %If AR is detected
            OffARkey(i) = find(Off{i,3} == 'Auto Reward',1,'first'); %Capture the first instance of Auto Reward (indicative of AR)
            Off{i,12} = nonzeros(OffARkey(i)); %Store all nonzero data within the Off variable
            OffAR(i,:) = Off(i,:); %Move all related data into the OffAR array
            indexarOff = indexarOff + 1; %Increment the index counting variable
        end
    end
    
    if indexhOff > 0
    OffHit = OffHit(~cellfun(@isempty,OffHit(:,1)),:); %Removes all nonzero rows from array
    end

    if indexmOff > 0
        OffMiss = OffMiss(~cellfun(@isempty,OffMiss(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexfOff> 0
        OffFA = OffFA(~cellfun(@isempty,OffFA(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexnoOff > 0
        OffNo = OffNo(~cellfun(@isempty,OffNo(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexarOff > 0
        OffAR = OffAR(~cellfun(@isempty,OffAR(:,1)),:); %Removes all nonzero rows from array
    end

    OffHitRate = indexhOff / (indexhOff + indexmOff) - 0.001; %Calculate Off hit rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    OffFARate = indexfOff / (indexfOff + indexnoOff) - 0.001; %Calculate Off FA rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    OffSens = norminv(OffHitRate) - norminv(OffFARate); %Calculate Off sensitivity
    OffBias = 0.5*(norminv(OffHitRate) + norminv(OffFARate)); %Calculate Off bias
    OffFinal = [OffHitRate; OffFARate; OffSens; OffBias]; %Concatenate all variables into a single array

    for i = 1:length(On) %For the On trials
        if strcmp(On{i,1},'Hit') %If Hit is detected
            OnHitkey(i) = find(On{i,3} == 'Reward',1,'first'); %Capture the first instance of Reward (Indicative of Hit trial)
            On{i,8} = nonzeros(OnHitkey(i)); %Store all nonzero data within the On variable
            OnHit(i,:) = On(i,:); %Move all related data into the OnHit array
            indexhOn = indexhOn + 1; %Increment the index counting variable
        elseif strcmp(On{i,1},'Miss') %If Miss is detected
            On{i,9} = 1; %Store placeholder variable
            OnMiss(i,:) = On(i,:); %Move all related data into the OnMiss array
            indexmOn = indexmOn + 1; %Increment the index counting variable
        elseif strcmp(On{i,1},'False Alarm') %If FA is detected
            OnFAkey(i) = find(On{i,3} == 'Inappropriate Response',1,'first'); %Capture the first instance of Inappropriate Response (indicative of FA)
            On{i,10} = nonzeros(OnFAkey(i)); %Store all nonzero data within the On variable
            OnFA(i,:) = On(i,:); %Move all related data into the OnFA array
            indexfOn = indexfOn + 1; %Increment the index counting variable
        elseif strcmp(On{i,1},'Correct Rejection') %If CR is detected
            On{i,11} = 1; %Store placeholder variable
            OnNo(i,:) = On(i,:); %Move all related data into the OnNo array
            indexnoOn = indexnoOn + 1; %Increment the index counting variable
        elseif strcmp(On{i,1},'Auto Reward') %If AR is detected
            OnARkey(i) = find(On{i,3} == 'Auto Reward',1,'first'); %Capture the first instance of Auto Reward (indicative of AR)
            On{i,12} = nonzeros(OnARkey(i)); %Store all nonzero data within the On variable
            OnAR(i,:) = On(i,:); %Move all related data into the OnAR array
            indexarOn = indexarOn + 1; %Increment the index counting variable
        end
    end

    if indexhOn > 0
        OnHit = OnHit(~cellfun(@isempty,OnHit(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexmOn > 0
        OnMiss = OnMiss(~cellfun(@isempty,OnMiss(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexfOn > 0
        OnFA = OnFA(~cellfun(@isempty,OnFA(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexnoOn > 0
        OnNo = OnNo(~cellfun(@isempty,OnNo(:,1)),:); %Removes all nonzero rows from array
    end
    
    if indexarOn > 0
        OnAR = OnAR(~cellfun(@isempty,OnAR(:,1)),:); %Removes all nonzero rows from array
    end

    OnHitRate = indexhOn / (indexhOn + indexmOn) - 0.001; %Calculate On hit rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    OnFARate = indexfOn / (indexfOn + indexnoOn) - 0.001; %Calculate On FA rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    OnSens = norminv(OnHitRate) - norminv(OnFARate); %Calculate On sensitivity
    OnBias = 0.5*(norminv(OnHitRate) + norminv(OnFARate)); %Calculate On bias
    OnFinal = [OnHitRate; OnFARate; OnSens; OnBias]; %Concatenate all variables into a single array

    Behavior = [BaseHitRate OffHitRate OnHitRate; BaseFARate OffFARate OnFARate; BaseSens OffSens OnSens; BaseBias OffBias OnBias]; %Concatenate all behavioral results into a single array (Baseline, Off, and On)

    if indexmBase > 0
        BaseMiss(cellfun(@isempty,BaseMiss)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end
    if indexmOff > 0
        OffMiss(cellfun(@isempty,OffMiss)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end
    if indexmOn > 0
        OnMiss(cellfun(@isempty,OnMiss)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end
    
    if indexnoBase > 0
        BaseNo(cellfun(@isempty,BaseNo)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end
    if indexnoOff > 0
        OffNo(cellfun(@isempty,OffNo)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end
    if indexnoOn >0
        OnNo(cellfun(@isempty,OnNo)) = {NaN}; %If no licks are detected, input a NaN to replace the empty cell
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:50
        BaseHitLick = padcat(BaseHit{:,12}); %Concatenate all licks into an array
        sizeBH = size(BaseHitLick); %Create a variable that matches the size of the lick array
        BHLick = padcat(BaseHit{:,4}); %Stores trial lengths
        for ii = 1:indexhBase
            BaseHitLickX(1:sizeBH(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
        end

        OffHitLick = padcat(OffHit{:,12}); %Concatenate all licks into an array
        sizeOfH = size(OffHitLick); %Create a variable that matches the size of the lick array
        OfHLick = padcat(OffHit{:,4}); %Stores trial lengths
        for ii = 1:indexhOff
            OffHitLickX(1:sizeOfH(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
        end

        OnHitLick = padcat(OnHit{:,12}); %Concatenate all licks into an array
        sizeOnH = size(OnHitLick); %Create a variable that matches the size of the lick array
        OnHLick = padcat(OnHit{:,4}); %Stores trial lengths
        for ii = 1:indexhOn
            OnHitLickX(1:sizeOnH(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
        end
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MISS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if indexmBase > 1
            BaseMissLick = padcat(BaseMiss{:,12}); %Concatenate all licks into an array
            sizeBM = size(BaseMissLick); %Create a variable that matches the size of the lick array
            BaseMLick = padcat(BaseMiss{:,4}); %Stores trial lengths
            for ii = 1:indexmBase
                BaseMissLickX(1:sizeBM(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexmBase == 1
            BaseMissLick = BaseMiss{:,12};
            sizeBaseM = size(BaseMissLick);
            BaseMLick = BaseMiss{:,4};
            for ii = 1:indexmBase
                BaseMissLickX(1:sizeBaseM(1),ii) = ii;
            end
        end

        if indexmOff > 1
            OffMissLick = padcat(OffMiss{:,12}); %Concatenate all licks into an array
            sizeOfM = size(OffMissLick); %Create a variable that matches the size of the lick array
            OfMLick = padcat(OffMiss{:,4}); %Stores trial lengths
            for ii = 1:indexmOff
                OffMissLickX(1:sizeOfM(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexmOff == 1
            OffMissLick = OffMiss{:,12};
            sizeOfM = size(OffMissLick);
            OfMLick = OffMiss{:,4};
            for ii = 1:indexmOff
                OffMissLickX(1:sizeOfM(1),ii) = ii;
            end
        end

        if indexmOn > 1
            OnMissLick = padcat(OnMiss{:,12}); %Concatenate all licks into an array
            sizeOnM = size(OnMissLick); %Create a variable that matches the size of the lick array
            OnMLick = padcat(OnMiss{:,4}); %Stores trial lengths
            for ii = 1:indexmOn
                OnMissLickX(1:sizeOnM(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexmOn == 1
            OnMissLick = OnMiss{:,12};
            sizeOnM = size(OnMissLick);
            OnMLick = OnMiss{:,4};
            for ii = 1:indexmOn
                OnMissLickX(1:sizeOnM(1),ii) = ii;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FALSE ALARM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if indexfBase > 1
            BaseFALick = padcat(BaseFA{:,12}); %Concatenate all licks into an array
            sizeBaseF = size(BaseFALick); %Create a variable that matches the size of the lick array
            BaseFLick = padcat(BaseFA{:,4}); %Stores trial lengths
            for ii = 1:indexfBase
                BaseFALickX(1:sizeBaseF(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexfBase == 1
            BaseFALick = BaseFA{:,12};
            sizeBaseF = size(BaseFALick);
            BaseFLick = BaseFA{:,4};
            for ii = 1:indexfBase
                BaseFALickX(1:sizeBaseF(1),ii) = ii;
            end
        end

        if indexfOff > 1
            OffFALick = padcat(OffFA{:,12}); %Concatenate all licks into an array
            sizeOfF = size(OffFALick); %Create a variable that matches the size of the lick array
            OfFLick = padcat(OffFA{:,4}); %Stores trial lengths
            for ii = 1:indexfOff
                OffFALickX(1:sizeOfF(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexfOff == 1
            OffFALick = OffFA{:,12};
            sizeOfF = size(OffFALick);
            OfFLick = OffFA{:,4};
            for ii = 1:indexfOff
                OffFALickX(1:sizeOfF(1),ii) = ii;
            end
        end

        if indexfOn > 1
            OnFALick = padcat(OnFA{:,12}); %Concatenate all licks into an array
            sizeOnF = size(OnFALick); %Create a variable that matches the size of the lick array
            OnFLick = padcat(OnFA{:,4}); %Stores trial lengths
            for ii = 1:indexfOn
                OnFALickX(1:sizeOnF(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexfOn == 1
            OnFALick = OnFA{:,12};
            sizeOnF = size(OnFALick);
            OnFLick = OnFA{:,4};
            for ii = 1:indexfOn
                OnFALickX(1:sizeOnF(1),ii) = ii;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NO GO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if indexnoBase > 1
            BaseNoLick = padcat(BaseNo{:,12}); %Concatenate all licks into an array
            sizeBaseNo = size(BaseNoLick); %Create a variable that matches the size of the lick array
            BaseNoL = padcat(BaseNo{:,4}); %Stores trial lengths
            for ii = 1:indexnoBase
                BaseNoLickX(1:sizeBaseNo(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexnoBase == 1
            BaseNoLick = BaseNo{:,12};
            sizeBaseNo = size(BaseNoLick);
            BaseNoL = BaseNo{:,4};
            for ii = 1:indexnoBoase
                BaseNoLickX(1:sizeBaseNo(1),ii) = ii;
            end
        end

        if indexnoOff > 1
            OffNoLick = padcat(OffNo{:,12}); %Concatenate all licks into an array
            sizeOfNo = size(OffNoLick); %Create a variable that matches the size of the lick array
            OfNoLick = padcat(OffNo{:,4}); %Stores trial lengths
            for ii = 1:indexnoOff
                OffNoLickX(1:sizeOfNo(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexnoOff == 1
            OffNoLick = OffNo{:,12};
            sizeOfNo = size(OffNoLick);
            OfNoLick = OffNo{:,4};
            for ii = 1:indexnoOff
                OffNoLickX(1:sizeOfNo(1),ii) = ii;
            end
        end

        if indexnoOn > 1
            OnNoLick = padcat(OnNo{:,12}); %Concatenate all licks into an array
            sizeOnNo = size(OnNoLick); %Create a variable that matches the size of the lick array
            ONoLick = padcat(OnNo{:,4}); %Stores trial lengths
            for ii = 1:indexnoOn
                OnNoLickX(1:sizeOnNo(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexnoOn == 1
            OnNoLick = OnNo{:,12};
            sizeOnNo = size(OnNoLick);
            ONoLick = OnNo{:,4};
            for ii = 1:indexnoOn
                OnNoLickX(1:sizeOnNo(1),ii) = ii;
            end
        end
    end

    for i = 1:8
        subplot(2,4,i) %Sets up 2x4 subplot(First row = LED Off; Second row = LED On)

        if i == 1
            scatter(OffHitLick,OffHitLickX,'|','k'); %Plots licks for each trial
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            xlim([0 length(OfHLick)]); %Limits the x-axis to the length of the longest Hit trial
            ylabel('Lick Rate (Hz)'); %Labels y-axis "Lick Rate (Hz)"
            title('Hit') %Sets the title "Hit"
        
        elseif i == 2
            if indexmOff >= 1
                scatter(OffMissLick,OffMissLickX,'|','k'); %Plots licks for each trial
                xlim([0 length(OfMLick)]); %Limits the x-axis to the length of the longest Miss trial
            end
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            title('Miss') %Sets the title "Miss"

        elseif i == 3
            if indexfOff >= 1
                scatter(OffFALick,OffFALickX,'|','k'); %Plots licks for each trial
                xlim([0 length(OfFLick)]); %Limits the x-axis to the length of the longest False Alarm trial
            end
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            title('False Alarm') %Sets the title "False Alarm"

        elseif i == 4
            if indexnoOff >= 1
                scatter(OffNoLick,OffNoLickX,'|','k'); %Plots licks for each trial
                xlim([0 length(OfNoLick)]); %Limits the x-axis to the length of the longest Correct Rejection trial
            end
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            title('Correct Rejection') %Sets the title "Correct Rejection"

        elseif i == 5
            scatter(OnHitLick,OnHitLickX,'|','k'); %Plots licks for each trial
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            xlim([0 length(OnHLick)]); %Limits the x-axis to the length of the longest Hit trial
            ylabel('Lick Rate (Hz)'); %Labels y-axis "Lick Rate (Hz)"

        elseif i == 6
            if indexmOn >= 1
                scatter(OnMissLick,OnMissLickX,'|','k'); %Plots licks for each trial
                xlim([0 length(OnMLick)]); %Limits the x-axis to the length of the longest Miss trial
            end
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line

        elseif i == 7
            if indexfOn >= 1
                scatter(OnFALick,OnFALickX,'|','k'); %Plots licks for each trial
                xlim([0 length(OnFLick)]); %Limits the x-axis to the length of the longest False Alarm trial
            end
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line

        elseif i == 8
            if indexnoOn >= 1
                scatter(OnNoLick,OnNoLickX,'|','k'); %Plots licks for each trial
                xlim([0 length(ONoLick)]); %Limits the x-axis to the length of the longest Correct Rejection trial
            xline(LPTend,'LineWidth',2,'color','r'); %Sets the presentation window end line
            xline(TextStart,'LineWidth',2,'color','r'); %Sets the presentation window start line
            end
        end
    end

    %2s Pre and Post Lick Rate
    if indexhBase > 0
        for i = 1:length(BaseHitLick)
            BasePreLickh = numel(BaseHitLick(BaseHitLick >= PreLick & BaseHitLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickh = numel(BaseHitLick(BaseHitLick>= TextStart & BaseHitLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepreh = BasePreLickh / temp; %Calculates the lick rate (in Hz) for pre time for Hits in the Baseline condition
        Baseposth = BasePostLickh / temp; %Calculates the lick rate (in Hz) for post time for Hits in the Baseline condition
    else
        Basepreh = NaN;
        Baseposth = NaN;
    end

    if indexmBase > 0
        for i = 1:length(BaseMissLick)
            BasePreLickm = numel(BaseMissLick(BaseMissLick >= PreLick & BaseMissLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickm = numel(BaseMissLick(BaseMissLick >= TextStart & BaseMissLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Baseprem = BasePreLickm / temp; %Calculates the lick rate (in Hz) for pre time for Miss in the Baseline condition
        Basepostm = BasePostLickm / temp; %Calculates the lick rate (in Hz) for post time for Miss in the Baseline condition
    else
        Baseprem = NaN;
        Basepostm = NaN;
    end

    if indexfBase > 0
        for i = 1:length(BaseFALick)
            BasePreLickf = numel(BaseFALick(BaseFALick >= PreLick & BaseFALick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickf = numel(BaseFALick(BaseFALick >= TextStart & BaseFALick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepref = BasePreLickf / temp; %Calculates the lick rate (in Hz) for pre time for FAs in the Baseline condition
        Basepostf = BasePostLickf / temp; %Calculates the lick rate (in Hz) for post time for FAs in the Baseline condition
    else
        Basepref = NaN;
        Basepostf = NaN;
    end

    if indexnoBase > 0
        for i = 1:length(BaseNoLick)
            BasePreLickno = numel(BaseNoLick(BaseNoLick >= PreLick & BaseNoLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickno = numel(BaseNoLick(BaseNoLick >= TextStart & BaseNoLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepreno = BasePreLickno / temp; %Calculates the lick rate (in Hz) for pre time for NoGos in the Baseline condition
        Basepostno = BasePostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos in the Baseline condition
    else
        Basepreno = NaN;
        Basepostno = NaN;
    end

    if indexhOff > 0
        for i = 1:length(OffHitLick)
            OffPreLickh = numel(OffHitLick(OffHitLick >= PreLick & OffHitLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OffPostLickh = numel(OffHitLick(OffHitLick >= TextStart & OffHitLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Offpreh = OffPreLickh / temp; %Calculates the lick rate (in Hz) for pre time for Hits in the Off condition
        Offposth = OffPostLickh / temp; %Calculates the lick rate (in Hz) for post time for Hits in the Off condition
    else
        Offpreh = NaN;
        Offposth = NaN;
    end

    if indexmOff > 0
        for i = 1:length(OffMissLick)
            OffPreLickm = numel(OffMissLick(OffMissLick >= PreLick & OffMissLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OffPostLickm = numel(OffMissLick(OffMissLick >= TextStart & OffMissLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Offprem = OffPreLickm / temp; %Calculates the lick rate (in Hz) for pre time for Misses in the Off condition
        Offpostm = OffPostLickm / temp; %Calculates the lick rate (in Hz) for post time for Misses in the Off condition
    else
        Offprem = NaN;
        Offpostm = NaN;
    end

    if indexfOff > 0
        for i = 1:length(OffFALick)
            OffPreLickf = numel(OffFALick(OffFALick >= PreLick & OffFALick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OffPostLickf = numel(OffFALick(OffFALick >= TextStart & OffFALick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Offpref = OffPreLickf / temp; %Calculates the lick rate (in Hz) for pre time for FAs in the Off condition
        Offpostf = OffPostLickf / temp; %Calculates the lick rate (in Hz) for post time for FAs in the Off condition
    else
        Offpref = NaN;
        Offpostf = NaN;
    end

    if indexnoOff > 0
        for i = 1:length(OffNoLick)
            OffPreLickno = numel(OffNoLick(OffNoLick >= PreLick & OffNoLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OffPostLickno = numel(OffNoLick(OffNoLick >= TextStart & OffNoLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Offpreno = OffPreLickno / temp; %Calculates the lick rate (in Hz) for pre time for NoGos in the Off condition
        Offpostno = OffPostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos in the Off condition
    else
        Offpreno = NaN;
        Offpostno = NaN;
    end

    if indexhOn > 0
        for i = 1:length(OnHitLick)
            OnPreLickh = numel(OnHitLick(OnHitLick >= PreLick & OnHitLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OnPostLickh = numel(OnHitLick(OnHitLick >= TextStart & OnHitLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Onpreh = OnPreLickh / temp; %Calculates the lick rate (in Hz) for pre time for Hits in the On condition
        Onposth = OnPostLickh / temp; %Calculates the lick rate (in Hz) for post time for Hits in the On condition
    else
        Onpreh = Nan;
        Onposth = NaN;
    end

    if indexmOn > 0
        for i = 1:length(OnMissLick)
            OnPreLickm = numel(OnMissLick(OnMissLick >= PreLick & OnMissLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OnPostLickm = numel(OnMissLick(OnMissLick >= TextStart & OnMissLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Onprem = OnPreLickm / temp; %Calculates the lick rate (in Hz) for pre time for Misses in the On condition
        Onpostm = OnPostLickm / temp; %Calculates the lick rate (in Hz) for post time for Misses in the On condition
    else
        Onprem = NaN;
        Onpostm = NaN;
    end

    if indexfOn > 0
        for i = 1:length(OnFALick)
            OnPreLickf = numel(OnFALick(OnFALick >= PreLick & OnFALick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OnPostLickf = numel(OnFALick(OnFALick >= TextStart & OnFALick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Onpref = OnPreLickf / temp; %Calculates the lick rate (in Hz) for pre time for FAs in the On condition
        Onpostf = OnPostLickf / temp; %Calculates the lick rate (in Hz) for post time for FAs in the On condition
    else
        Onpref = NaN;
        Onpostf = NaN;
    end


    if indexnoOn > 0
        for i = 1:length(OnNoLick)
            OnPreLickno = numel(OnNoLick(OnNoLick >= PreLick & OnNoLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            OnPostLickno = numel(OnNoLick(OnNoLick >= TextStart & OnNoLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Onpreno = OnPreLickno / temp; %Calculates the lick rate (in Hz) for pre time for NoGos in the On condition
        Onpostno = OnPostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos in the On condition
    else
        Onpreno = NaN;
        Onpostno = NaN;
    end

    Final.Behavior = Behavior;
    Final.BasePreLick = [Basepreh; Baseprem; Basepref; Basepreno];
    Final.BasePostLick = [Baseposth; Basepostm; Basepostf; Basepostno];
    Final.OffPreLick = [Offpreh; Offprem; Offpref; Offpreno];
    Final.OffPostLick = [Offposth; Offpostm; Offpostf; Offpostno];
    Final.OnPreLick = [Onpreh; Onprem; Onpref; Onpreno];
    Final.OnPostLick = [Onposth; Onpostm; Onpostf; Onpostno];

else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASELINE ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:150 %As each condition is segmented into 50 trials
        upkey{i} = find(All{i,4} >= uplim); %Find all voltages that are equal to or above the upper threshold limit within the Baseline data
        lowkey{i} = find(All{i,4} <= lowlim); %Find all voltages that are equal to or below the lower threshold limit within the Baseline data
        lickkey{i} = sort([upkey{i}; lowkey{i}]); %Sort the upper and lower voltages into a single array
        All{i,12} = lickkey{i}; %Append all lick data into the BaselineData array
    end
    
    indexhBase = 0; %Index to count number of hits during Baseline
    indexmBase = 0; %Index to count number of misses during Baseline
    indexfBase = 0; %Index to count number of FAs during Baseline
    indexnoBase = 0; %Index to count number of NoGos during Baseline
    indexarBase = 0; %Index to count number of ARs during baseline

    for i = 1:length(All)
        if strcmp(All{i,1},'Hit') %If Hit is detected
            BaseHitkey(i) = find(All{i,3} == 'Reward',1,'first'); %Capture the first instance of reward (indicative of a Hit trial)
            All{i,8} = nonzeros(BaseHitkey(i)); %Store all nonzero data within the baseline variable
            BaseHit(i,:) = All(i,:); %Move all related data into the BaseHit array
            indexhBase = indexhBase + 1; %Increment the index counting variable
        elseif strcmp(All{i,1},'Miss') %If Miss is detected
            All{i,9} = 1; %Placeholder value
            BaseMiss(i,:) = All(i,:); %Move all related data into the BaseMiss array
            indexmBase = indexmBase + 1; %Increment the index counting variable 
        elseif strcmp(All{i,1},'False Alarm') %If FA is detected
            BaseFAkey(i) = find(All{i,3} == 'Inappropriate Response',1,'first'); %Capture the first instance of Inappropriate Response (indicative of FA)
            All{i,10} = nonzeros(BaseFAkey(i)); %Store all nonzero data within the baseline variable
            BaseFA(i,:) = All(i,:); %Move all related data into the BaseFA array
            indexfBase = indexfBase + 1; %Increment the index counting variable
        elseif strcmp(All{i,1},'Correct Rejection') %If Correct Rejection is detected
            All{i,11} = 1; %Store placeholder variable
            BaseNo(i,:) = All(i,:); %Move all related data into the BaseNo array
            indexnoBase = indexnoBase + 1; %Increment the index counting variable
        elseif strcmp(All{i,1},'Auto Reward') %If AR is detected
            BaseARkey(i) = find(All{i,3} == 'Auto Reward',1,'first'); %Capture the first instance of Auto Reward (indicative of AR)
            All{i,12} = nonzeros(BaseARkey(i)); %Store all nonzero data within baseline variable
            BaseAR(i,:) = All(i,:); %Move all related data into the BaseAR array
            indexarBase = indexarBase + 1; %Increment the index counting variable
        end
    end

    for i = 1:150
        if indexhBase > 1
            BaseHitLick = padcat(BaseHit{:,12}); %Concatenate all licks into an array
            sizeBH = size(BaseHitLick); %Create a variable that matches the size of the lick array
            BHLick = padcat(BaseHit{:,4}); %Stores trial lengths
            for ii = 1:indexhBase
                BaseHitLickX(1:sizeBH(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexhBase == 1
            BaseHitLick = BaseHit{:,12};
            sizeBH = size(BaseHitLick);
            BHLick = BaseHit{:,4};
            for ii = 1:indexhBase
                BaseHitLickX(1:sizeBH(1),ii) = ii;
            end
        end

        if indexmBase > 1
            BaseMissLick = padcat(BaseMiss{:,12}); %Concatenate all licks into an array
            sizeBM = size(BaseMissLick); %Create a variable that matches the size of the lick array
            BaseMLick = padcat(BaseMiss{:,4}); %Stores trial lengths
            for ii = 1:indexmBase
                BaseMissLickX(1:sizeBM(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexmBase == 1
            BaseMissLick = BaseMiss{:,12};
            sizeBaseM = size(BaseMissLick);
            BaseMLick = BaseMiss{:,4};
            for ii = 1:indexmBase
                BaseMissLickX(1:sizeBaseM(1),ii) = ii;
            end
        end

        if indexfBase > 1
            BaseFALick = padcat(BaseFA{:,12}); %Concatenate all licks into an array
            sizeBaseF = size(BaseFALick); %Create a variable that matches the size of the lick array
            BaseFLick = padcat(BaseFA{:,4}); %Stores trial lengths
            for ii = 1:indexfBase
                BaseFALickX(1:sizeBaseF(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexfBase == 1
            BaseFALick = BaseFA{:,12};
            sizeBaseF = size(BaseFALick);
            BaseFLick = BaseFA{:,4};
            for ii = 1:indexfBase
                BaseFALickX(1:sizeBaseF(1),ii) = ii;
            end
        end

        if indexnoBase > 1
            BaseNoLick = padcat(BaseNo{:,12}); %Concatenate all licks into an array
            sizeBaseNo = size(BaseNoLick); %Create a variable that matches the size of the lick array
            BaseNoL = padcat(BaseNo{:,4}); %Stores trial lengths
            for ii = 1:indexnoBase
                BaseNoLickX(1:sizeBaseNo(1),ii) = ii; %Create a variable that matches the size of the lick array (column 1 = 1s, column 2 = 2s, column 3 = 3s, etc.)
            end
        elseif indexnoBase == 1
            BaseNoLick = BaseNo{:,12};
            sizeBaseNo = size(BaseNoLick);
            BaseNoL = BaseNo{:,4};
            for ii = 1:indexnoBoase
                BaseNoLickX(1:sizeBaseNo(1),ii) = ii;
            end
        end
    end


    if indexhBase > 0
        for i = 1:length(BaseHitLick)
            BasePreLickh = numel(BaseHitLick(BaseHitLick >= PreLick & BaseHitLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickh = numel(BaseHitLick(BaseHitLick>= TextStart & BaseHitLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepreh = BasePreLickh / temp; %Calculates the lick rate (in Hz) for pre time for Hits in the Baseline condition
        Baseposth = BasePostLickh / temp; %Calculates the lick rate (in Hz) for post time for Hits in the Baseline condition
    else
        Basepreh = NaN;
        Baseposth = NaN;
    end

    if indexmBase > 0
        for i = 1:length(BaseMissLick)
            BasePreLickm = numel(BaseMissLick(BaseMissLick >= PreLick & BaseMissLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickm = numel(BaseMissLick(BaseMissLick >= TextStart & BaseMissLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Baseprem = BasePreLickm / temp; %Calculates the lick rate (in Hz) for pre time for Miss in the Baseline condition
        Basepostm = BasePostLickm / temp; %Calculates the lick rate (in Hz) for post time for Miss in the Baseline condition
    else
        Baseprem = NaN;
        Basepostm = NaN;
    end

    if indexfBase > 0
        for i = 1:length(BaseFALick)
            BasePreLickf = numel(BaseFALick(BaseFALick >= PreLick & BaseFALick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickf = numel(BaseFALick(BaseFALick >= TextStart & BaseFALick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepref = BasePreLickf / temp; %Calculates the lick rate (in Hz) for pre time for FAs in the Baseline condition
        Basepostf = BasePostLickf / temp; %Calculates the lick rate (in Hz) for post time for FAs in the Baseline condition
    else
        Basepref = NaN;
        Basepostf = NaN;
    end

    if indexnoBase > 0
        for i = 1:length(BaseNoLick)
            BasePreLickno = numel(BaseNoLick(BaseNoLick >= PreLick & BaseNoLick <= TextStart)); %Calculates the number of licks detected from -2 to 0s relative to texture presentation
            BasePostLickno = numel(BaseNoLick(BaseNoLick >= TextStart & BaseNoLick <= LPTend)); %Calculates the number of licks detected from 0 to +2s relative to texture presentation
        end
        Basepreno = BasePreLickno / temp; %Calculates the lick rate (in Hz) for pre time for NoGos in the Baseline condition
        Basepostno = BasePostLickno / temp; %Calculates the lick rate (in Hz) for post time for NoGos in the Baseline condition
    else
        Basepreno = NaN;
        Basepostno = NaN;
    end

    BaseHitRate = indexhBase / (indexhBase + indexmBase) - 0.001; %Calculate Baseline hit rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    BaseFARate = indexfBase / (indexfBase + indexnoBase) - 0.001; %Calculate Baseline FA rate (subtracting 0.001 is necessary if the Hit Rate is 1.0)
    BaseSens = norminv(BaseHitRate) - norminv(BaseFARate); %Calculate Baseline sensitivity
    BaseBias = 0.5*(norminv(BaseHitRate) + norminv(BaseFARate)); %Calculate Baseline bias

    BaseFinal = [BaseHitRate; BaseFARate; BaseSens; BaseBias]; %Concatenate all variables into a single array


end
