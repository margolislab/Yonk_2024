clear;
clc;

%Hard-code in HEKA_Importer location for automated addition to the path
HEKApath = 'C:\Users\ajy31\OneDrive - Rutgers University\Documents\a. Scripts';
addpath(genpath(HEKApath));

%Load in file and save imported data into new variable ('data')
file = uigetfile;
filename = file(1:end-4);
HEKA_Importer(file)
all = ans;
clear ans;

%Create data structure to save all pertinent information and save project
%number as an overarching structure variable and preallocate nested
%structure variables
Data = struct();
Data.Projects = max(all.RecTable{:,1});
for i = 1:Data.Projects
    if i == 1
        Data.Proj1 = [];
        Data.Proj1.Expts = 0;
    elseif i == 2
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
    elseif i == 3
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
    elseif i == 4
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
    elseif i == 5
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
    elseif i == 6
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
    elseif i == 7
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
    elseif i == 8
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
    elseif i == 9
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
    elseif i == 10
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
    elseif i == 11
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj11 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
        Data.Proj11.Expts = 0;
    elseif i == 12
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj11 = [];
        Data.Proj12 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
        Data.Proj11.Expts = 0;
        Data.Proj12.Expts = 0;
    elseif i == 13
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj11 = [];
        Data.Proj12 = [];
        Data.Proj13 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
        Data.Proj11.Expts = 0;
        Data.Proj12.Expts = 0;
        Data.Proj13.Expts = 0;
    elseif i == 14
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj11 = [];
        Data.Proj12 = [];
        Data.Proj13 = [];
        Data.Proj14 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
        Data.Proj11.Expts = 0;
        Data.Proj12.Expts = 0;
        Data.Proj13.Expts = 0;
        Data.Proj14.Expts = 0;
    elseif i == 15
        Data.Proj1 = [];
        Data.Proj2 = [];
        Data.Proj3 = [];
        Data.Proj4 = [];
        Data.Proj5 = [];
        Data.Proj6 = [];
        Data.Proj7 = [];
        Data.Proj8 = [];
        Data.Proj9 = [];
        Data.Proj10 = [];
        Data.Proj11 = [];
        Data.Proj12 = [];
        Data.Proj13 = [];
        Data.Proj14 = [];
        Data.Proj15 = [];
        Data.Proj1.Expts = 0;
        Data.Proj2.Expts = 0;
        Data.Proj3.Expts = 0;
        Data.Proj4.Expts = 0;
        Data.Proj5.Expts = 0;
        Data.Proj6.Expts = 0;
        Data.Proj7.Expts = 0;
        Data.Proj8.Expts = 0;
        Data.Proj9.Expts = 0;
        Data.Proj10.Expts = 0;
        Data.Proj11.Expts = 0;
        Data.Proj12.Expts = 0;
        Data.Proj13.Expts = 0;
        Data.Proj14.Expts = 0;
        Data.Proj15.Expts = 0;
    end
end

%Determine sampling frequency for each experiment type
timerow = 2;
Time(1,1) = 0;
SF = (1/all.RecTable{1,19})*1000; %This value must be set as the sampling frequency (20kHz)
for i = 1:99999
    Time(timerow,1) = 0 + SF;
    SF = SF + 0.05;
    timerow = timerow + 1;
end
Data.Time = Time;

%Determine the number of experiments for each project and save information
%into each project's nested structure
for i = 1:height(all.RecTable{:,2})
    if strcmp(all.RecTable{i,2}, 'Exp-1')
        Data.Proj1.Expts = Data.Proj1.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-2')
        Data.Proj2.Expts = Data.Proj2.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-3')
        Data.Proj3.Expts = Data.Proj3.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-4')
        Data.Proj4.Expts = Data.Proj4.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-5')
        Data.Proj5.Expts = Data.Proj5.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-6')
        Data.Proj6.Expts = Data.Proj6.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-7')
        Data.Proj7.Expts = Data.Proj7.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-8')
        Data.Proj8.Expts = Data.Proj8.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-9')
        Data.Proj9.Expts = Data.Proj9.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-10')
        Data.Proj10.Expts = Data.Proj10.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-11')
        Data.Proj11.Expts = Data.Proj11.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-12')
        Data.Proj12.Expts = Data.Proj12.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-13')
        Data.Proj13.Expts = Data.Proj13.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-14')
        Data.Proj14.Expts = Data.Proj14.Expts + 1;
    elseif strcmp(all.RecTable{i,2}, 'Exp-15')
        Data.Proj15.Expts = Data.Proj15.Expts + 1;
    end
end

%Preallocate cell data based on number of cells recorded
for ii = 1:Data.Projects
    if ii == 1
        for i = 1:Data.Proj1.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt1.ExptID1 = char(all.RecTable{i,10});
                Data.Proj1.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt1.Stim1 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt2.ExptID2 = char(all.RecTable{i,10});
                Data.Proj1.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt2.Stim2 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt3.ExptID3 = char(all.RecTable{i,10});
                Data.Proj1.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt3.Stim3 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt4.ExptID4 = char(all.RecTable{i,10});
                Data.Proj1.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt4.Stim4 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt5.ExptID5 = char(all.RecTable{i,10});
                Data.Proj1.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt5.Stim5 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt6.ExptID6 = char(all.RecTable{i,10});
                Data.Proj1.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt6.Stim6 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt7.ExptID7 = char(all.RecTable{i,10});
                Data.Proj1.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt7.Stim7 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt8.ExptID8 = char(all.RecTable{i,10});
                Data.Proj1.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt8.Stim8 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt9.ExptID9 = char(all.RecTable{i,10});
                Data.Proj1.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt9.Stim9 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt10.ExptID10 = char(all.RecTable{i,10});
                Data.Proj1.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt10.Stim10 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt11.ExptID11 = char(all.RecTable{i,10});
                Data.Proj1.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt11.Stim11 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt12.ExptID12 = char(all.RecTable{i,10});
                Data.Proj1.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt12.Stim12 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt13.ExptID13 = char(all.RecTable{i,10});
                Data.Proj1.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt13.Stim13 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt14.ExptID14 = char(all.RecTable{i,10});
                Data.Proj1.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt14.Stim14 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt15.ExptID15 = char(all.RecTable{i,10});
                Data.Proj1.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt15.Stim15 = all.RecTable.stimWave{i,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt16.ExptID16 = char(all.RecTable{i,10});
                Data.Proj1.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt16.Stim16 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt17.ExptID17 = char(all.RecTable{i,10});
                Data.Proj1.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt17.Stim17 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt18.ExptID18 = char(all.RecTable{i,10});
                Data.Proj1.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt18.Stim18 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt19.ExptID19 = char(all.RecTable{i,10});
                Data.Proj1.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt19.Stim19 = all.RecTable.stimWave{i,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj1.Expt20.ExptID20 = char(all.RecTable{i,10});
                Data.Proj1.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{i,1}) * 1000;
                Data.Proj1.Expt20.Stim20 = all.RecTable.stimWave{i,1}.DA_3;
            end
        end

    elseif ii == 2
        iii = Data.Proj1.Expts + 1;
        for i = 1:Data.Proj2.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj2.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj2.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj2.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj2.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj2.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj2.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj2.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj2.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj2.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj2.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj2.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj2.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj2.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj2.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj2.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj2.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj2.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj2.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj2.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj2.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj2.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj2.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 3
        iii = Data.Proj1.Expts + Data.Proj2.Expts + 1;
        for i = 1:Data.Proj3.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj3.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj3.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj3.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj3.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj3.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj3.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj3.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj3.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj3.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj3.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj3.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj3.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj3.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj3.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj3.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj3.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj3.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj3.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj3.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj3.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj3.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj3.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 4
        iii = Data.Proj1.Expts + Data.Proj2.Expts + Data.Proj3.Expts + 1;
        for i = 1:Data.Proj4.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj4.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj4.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj4.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj4.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj4.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj4.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj4.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj4.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj4.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj4.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj4.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj4.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj4.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj4.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj4.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj4.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj4.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj4.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj4.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj4.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj4.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj4.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 5
        iii = Data.Proj1.Expts + Data.Proj2.Expts + Data.Proj3.Expts + Data.Proj4.Expts + 1;
        for i = 1:Data.Proj5.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj5.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj5.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj5.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj5.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj5.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj5.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj5.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj5.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj5.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj5.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj5.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj5.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj5.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj5.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj5.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj5.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj5.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj5.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj5.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj5.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj5.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj5.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 6
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts + 1;
        for i = 1:Data.Proj6.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj6.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj6.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj6.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj6.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj6.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj6.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj6.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj6.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj6.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj6.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj6.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj6.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj6.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj6.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj6.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj6.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj6.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj6.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj6.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj6.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj6.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj6.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
          iii = iii + 1;
        end

    elseif ii == 7
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts + 1;
        for i = 1:Data.Proj7.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj7.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj7.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj7.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj7.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj7.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj7.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj7.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj7.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj7.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj7.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj7.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj7.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj7.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj7.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj7.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj7.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj7.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj7.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj7.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj7.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj7.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj7.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 8
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts + 1;
        for i = 1:Data.Proj8.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj8.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj8.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj8.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj8.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj8.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj8.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj8.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj8.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj8.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj8.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj8.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj8.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj8.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj8.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj8.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj8.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj8.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj8.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj8.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj8.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj8.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj8.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 9
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts + 1;
        for i = 1:Data.Proj9.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj9.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj9.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj9.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj9.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj9.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj9.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj9.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj9.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj9.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj9.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj9.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj9.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj9.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj9.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj9.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj9.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj9.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj9.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj9.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj9.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj9.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj9.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 10
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts + 1;
        for i = 1:Data.Proj10.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj10.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj10.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj10.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj10.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj10.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj10.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj10.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj10.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj10.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj10.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj10.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj10.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj10.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj10.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj10.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj10.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj10.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj10.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj10.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj10.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj10.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj10.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 11
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts+Data.Proj10.Expts + 1;
        for i = 1:Data.Proj11.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj11.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj11.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj11.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj11.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj11.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj11.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj11.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj11.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj11.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj11.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj11.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj11.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj11.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj11.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj11.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj11.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj11.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj11.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj11.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj11.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj11.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj11.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 12
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts+Data.Proj10.Expts+Data.Proj11.Expts + 1;
        for i = 1:Data.Proj12.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj12.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj12.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj12.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj12.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj12.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj12.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj12.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj12.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj12.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj12.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj12.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj12.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj12.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj12.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj12.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj12.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj12.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj12.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj12.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj12.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj12.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj12.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 13
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts+Data.Proj10.Expts+Data.Proj11.Expts+Data.Proj12.Expts + 1;
        for i = 1:Data.Proj13.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj13.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj13.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj13.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj13.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj13.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj13.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj13.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj13.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj13.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj13.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj13.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj13.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj13.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj13.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj13.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj13.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj13.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj13.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj13.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj13.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj13.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj13.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 14
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts+Data.Proj10.Expts+Data.Proj11.Expts+Data.Proj12.Expts+Data.Proj13.Expts + 1;
        for i = 1:Data.Proj14.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj14.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj14.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj14.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj14.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj14.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj14.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj14.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj14.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj14.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj14.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj14.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj14.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj14.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj14.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj14.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj14.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj14.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj14.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj14.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj14.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj14.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj14.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end

    elseif ii == 15
        iii = Data.Proj1.Expts + Data.Proj2.Expts+Data.Proj3.Expts+Data.Proj4.Expts+Data.Proj5.Expts+Data.Proj6.Expts+Data.Proj7.Expts+Data.Proj8.Expts+Data.Proj9.Expts+Data.Proj10.Expts+Data.Proj11.Expts+Data.Proj12.Expts+Data.Proj13.Expts+Data.Proj14.Expts + 1;
        for i = 1:Data.Proj15.Expts
            if i == 1 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt1.ExptID1 = char(all.RecTable{iii,10});
                Data.Proj15.Expt1.Exp1 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt1.Stim1 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 2 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt2.ExptID2 = char(all.RecTable{iii,10});
                Data.Proj15.Expt2.Exp2 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt2.Stim2 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 3 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt3.ExptID3 = char(all.RecTable{iii,10});
                Data.Proj15.Expt3.Exp3 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt3.Stim3 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 4 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt4.ExptID4 = char(all.RecTable{iii,10});
                Data.Proj15.Expt4.Exp4 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt4.Stim4 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 5 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt5.ExptID5 = char(all.RecTable{iii,10});
                Data.Proj15.Expt5.Exp5 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt5.Stim5 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 6 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt6.ExptID6 = char(all.RecTable{iii,10});
                Data.Proj15.Expt6.Exp6 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt6.Stim6 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 7 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt7.ExptID7 = char(all.RecTable{iii,10});
                Data.Proj15.Expt7.Exp7 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt7.Stim7 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 8 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt8.ExptID8 = char(all.RecTable{iii,10});
                Data.Proj15.Expt8.Exp8 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt8.Stim8 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 9 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt9.ExptID9 = char(all.RecTable{iii,10});
                Data.Proj15.Expt9.Exp9 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt9.Stim9 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 10 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt10.ExptID10 = char(all.RecTable{iii,10});
                Data.Proj15.Expt10.Exp10 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt10.Stim10 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 11 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt11.ExptID11 = char(all.RecTable{iii,10});
                Data.Proj15.Expt11.Exp11 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt11.Stim11 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 12 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt12.ExptID12 = char(all.RecTable{iii,10});
                Data.Proj15.Expt12.Exp12 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt12.Stim12 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 13 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt13.ExptID13 = char(all.RecTable{iii,10});
                Data.Proj15.Expt13.Exp13 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt13.Stim13 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 14 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt14.ExptID14 = char(all.RecTable{iii,10});
                Data.Proj15.Expt14.Exp14 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt14.Stim14 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 15 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt15.ExptID15 = char(all.RecTable{iii,10});
                Data.Proj15.Expt15.Exp15 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt15.Stim15 = all.RecTable.stimWave{iii,1}.DA_3;
                
            elseif i == 16 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt16.ExptID16 = char(all.RecTable{iii,10});
                Data.Proj15.Expt16.Exp16 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt16.Stim16 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 17 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt17.ExptID17 = char(all.RecTable{iii,10});
                Data.Proj15.Expt17.Exp17 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt17.Stim17 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 18 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt18.ExptID18 = char(all.RecTable{iii,10});
                Data.Proj15.Expt18.Exp18 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt18.Stim18 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 19 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt19.ExptID19 = char(all.RecTable{iii,10});
                Data.Proj15.Expt19.Exp19 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt19.Stim19 = all.RecTable.stimWave{iii,1}.DA_3;

            elseif i == 20 && length(all.RecTable.Rs{i,1}) == 1
                Data.Proj15.Expt20.ExptID20 = char(all.RecTable{iii,10});
                Data.Proj15.Expt20.Exp20 = cell2mat(all.RecTable.dataRaw{iii,1}) * 1000;
                Data.Proj15.Expt20.Stim20 = all.RecTable.stimWave{iii,1}.DA_3;
            end
         iii = iii + 1;
        end
    end
end
save(filename,'Data','filename')