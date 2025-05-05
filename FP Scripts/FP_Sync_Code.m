clear variables;
clc;
addpath('C:\Users\ajy31\Documents\a. Scripts')
[behaviorpath] = uigetdir;
cd(behaviorpath);

%Select file within specified directory and import data using readtable
file = uigetfile;
formatSpec= '%s%s%f%s';
Initial = readtable(file,'Format',formatSpec);


%Sets up variable used in the following for loop and creates a structure to
%store all data
datastructure = struct();

%Set up variables
Event = string(table2array(Initial(:,4)));
Time = string(table2array(Initial(:,2)));
Date = string(table2array(Initial(:,1)));
Trial = table2array(Initial(:,3));

%Split date: one column for month, one column for day, one column for year
DateSplit = split(Date,"/");

%Convert month to double
Month = str2double(DateSplit(2,1));

%Switch statement provides a shorthand for the month
switch Month
    case 1
        for i=1:length(DateSplit)
            DateSplit(i,1) = 'Jan';
        end

    case 2
        for i=1:length(DateSplit)
            DateSplit(i,1) = 'Feb';
        end
    
    case 3
        for i=1:length(DateSplit)
            DateSplit(i,1)="Mar";
        end

    case 4

        for i=1:length(DateSplit)
            DateSplit(i,1)="Apr";
        end

    case 5

        for i=1:length(DateSplit)
            DateSplit(i,1)="May";
        end

    case 6

        for i=1:length(DateSplit)
            DateSplit(i,1)="Jun";
        end

    case 7

        for i=1:length(DateSplit)
            DateSplit(i,1)="Jul";
        end

    case 8

        for i=1:length(DateSplit)
            DateSplit(i,1)="Aug";
        end

    case 9

        for i=1:length(DateSplit)
            DateSplit(i,1)="Sep";
        end

    case 10

        for i=1:length(DateSplit)
            DateSplit(i,1)="Oct";
        end

    case 11

        for i=1:length(DateSplit)
            DateSplit(i,1)="Nov";
        end

    case 12

        for i=1:length(DateSplit)
            DateSplit(i,1)="Dec";
        end
end

%Swap month and day columns
for i=1:length(DateSplit)
    swap = DateSplit(i,1);
    DateSplit(i,1) = DateSplit(i,2);
    DateSplit(i,2) = swap;
end

%Merge day, month, and year into single column and append dd-MMM-yyyy with
%timestamp data
FullDate = join(DateSplit,'-');
DateTime = strings(length(Date),1);

for i=1:length(Date)
    DateTime(i) = append(FullDate(i),Time(i));
end

%Convert string to datetime format
DateTime = datetime(DateTime,'TimeZone','local','Format','dd-MMM-yyy HH:mm:ss:SSSS');

%Merge datetime, events, and trial number into single variable
datastructure.DateTime = DateTime;
datastructure.Events = Event;
datastructure.Trial = Trial;

%%
% %Allow user to choose path to TDT files
% addpath('C:\Users\ajy31\Documents\a. Scripts\TDTMatlabSDK-master');
% [calciumpath] = uigetdir;
% cd(calciumpath);
% PhotoData = TDTbin2mat(calciumpath);
% 
% %Segment out full GCaMP signal and individual sample point to determine
% %duration of recording (in ms)
% Events = PhotoData.epocs.sqr_.onset;
% GCaMP = PhotoData.streams.G__A.data; %Full raw GCaMP signal
% Iso = PhotoData.streams.IsoA.data;
% Fs = PhotoData.streams.IsoA.fs; %Individual sample
% Ts = ((1:numel(PhotoData.streams.G__A.data)) / Fs); %Calculate timestamps by Fs
% 
% % %Create an array with timestamps (in ms) that correspond to GCaMP signals
% % IndTime = length(GCaMP)*Fs;
% % PhotoTime = 0:Fs:IndTime;
% % 
% % %Calculate the difference between the GCaMP signal length and the
% % %calculated time.
% % GCaMP = double(GCaMP);
% % Iso = double(PhotoData.streams.IsoA.data);
% % FP = [PhotoTime(1:end-1); GCaMP; Iso].';
% % FP = FP(3000:end,:);
% % 
% % %Potentially cutoff and reshape the FP array due to initial jump in Ca2+
% % %signal from LEDs being turned on
% % CutoffTime = (length(GCaMP)-3000)*Fs;
% % NewPhotoTime = 0:Fs:CutoffTime;
% % NewPhotoTime = transpose(NewPhotoTime);
% % FP(:,1) = NewPhotoTime;
% 
% %Downsample the time, the raw GCaMP, and the isosbestic signal by a factor
% %of 10
% DsG = downsample(GCaMP,10);
% DsI = downsample(Iso,10);
% DTs = downsample(Ts,10);
% DFs = Fs/10;
% 
% list = {DsG,DsI};
% for i=1:length(list)
%     BestFitG = polyfit(DTs,list{i},2);
%     TLG = ((BestFitG(1,1)*(DTs.^2)) + (BestFitG(1,2)*DTs) + (BestFitG(1,3)));
%     DetrendSignals{i} = list{i}-TLG;
%     clear TLG BestFitG
% end
% 
% %Normalize the values for Z score and MAD Z score calculations
% meanBaseG = mean(DetrendSignals{1});
% medianBaseG = median(DetrendSignals{1});
% madBaseG = mean(mad(DetrendSignals{1}));
% stdBaseG = std(DetrendSignals{1});
% meanBaseI = mean(DetrendSignals{2});
% medianBaseI = median(DetrendSignals{2});
% madBaseI = mean(mad(DetrendSignals{2}));
% stdBaseI = std(DetrendSignals{2});
% 
% ZGCaMP = (DetrendSignals{1} - meanBaseG)/stdBaseG;
% ZIso = (DetrendSignals{2} - meanBaseI)/stdBaseI;
% ZmadGCaMP = (DetrendSignals{1} - medianBaseG)/madBaseG;
% ZmadIso = (DetrendSignals{2} - medianBaseI)/madBaseI;
% 
% %Subtract the isosbestic signal from the GCaMP signal
% Z = ZmadGCaMP - ZmadIso;
% Z = Z.';
% DTs = DTs.';
% 
% All = [DTs Z];
% 
% %%
% if Downsample == 1
% %Construct list for detrending GCaMP and Iso signals via line of best fit
%     Group = 10; %Downsample Factor
%     DTs(:,1) = Ts(1:Group:end);
%     DFs = Fs/Group;
%    
%     %Construct a downsampled GCaMP/Iso list for detrending via line of best fit
%     list={DSGCaMP,DSIso};
%     for i=1:length(list)
%        BestFitG= polyfit(DTs,list{i},2);
%        TLG = ((BestFitG(1,1)*(DTs.^2)) + (BestFitG(1,2)*DTs) + (BestFitG(1,3)));
%        DetrendSignals{i} = list{i}-TLG;
%        clear TLG BestFitG
%     end
% 
%     %Normalize the values for Z score and MAD Z score calculations
%     meanBaseG = mean(DetrendSignals{1});
%     medianBaseG = median(DetrendSignals{1});
%     madBaseG = mean(mad(DetrendSignals{1}));
%     stdBaseG = std(DetrendSignals{1});
%     meanBaseI = mean(DetrendSignals{2});
%     medianBaseI = median(DetrendSignals{2});
%     madBaseI = mean(mad(DetrendSignals{2}));
%     stdBaseI = std(DetrendSignals{2});
% 
%     ZGCaMP = (DetrendSignals{1} - meanBaseG)/stdBaseG;
%     ZIso = (DetrendSignals{2} - meanBaseI)/stdBaseI;
%     ZmadGCaMP = (DetrendSignals{1} - medianBaseG)/madBaseG;
%     ZmadIso = (DetrendSignals{2} - medianBaseI)/madBaseI;
% 
%     %Subtract the isosbestic signal from the GCaMP signal
%     Z = ZmadGCaMP - ZmadIso;
% 
%     %Using the events timestamps, convert the timestamps into sampling
%     %frequency
%     Seconds=10;
%     Before=round(Seconds*DFs);
%     After=round(Seconds*DFs);
% 
%     for i=2:length(Events)
%         a=find(Events(i) < DTs(:,1));
%         a=a(1,1);
%         ZAlign(i,:)= Z(a-Before:a+After,1);
%     end
% 
%     ZAlignMean = mean(ZAlign(2:end,:));
%     ZAlignstd = std(ZAlign(2:end,:));
% 
%     %Define an x vector that goes from -second to + the second
%     figure(1)
%     subplot(2,1,2);
%     plot(ZAlignMean);
%     xlim([0 2034])
%     subplot(2,1,1)
%     imagesc(ZAlign);
%     clim([-1 4])
%     title('Aligned to Presentation Window Onset')
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%
% 
% digitsFromEnd = 6;
% id = 1;
% Hits = [];
% Misses = [];
% FAs = [];
% NoGos = [];
% 
% 
% 
% %Set up data structure
% datastructure = setfield(datastructure,'Filename',[txtfile.name(end-19:end)]);
% datastructure = setfield(datastructure,'Events',Event);
% datastructure = setfield(datastructure,'Time',Time);
% datastructure = setfield(datastructure,'Trials',Trial);
% datastructure.All = [Date Time Trial];
% digitsTime = strlength(datastructure.Time(1,1));
% 
% 
% for i = 1:size(datastructure.Events)
%         if strcmp(datastructure.Events(i),'Begin Trial + Recording') || strcmp(datastructure.Events(i),'Begin Trial w/o Recording') || strcmp(datastructure.Events(i),'Begin Trial / Recording')
%             item = {num2str(id) num2str(datastructure.Trials(i)) '' '' '' '' '' '' '' '' '' ''};
%             Data = [Data; item];
%             id = id + 1;
%         elseif strcmp(datastructure.Events(i),'End Trial')
%             time = datastructure.Time{i};
%             time = char(time);
%             time = time(1:8);
%             Data{id,3} = time;
%         elseif strfind(datastructure.Events{i},'Te') == 1
%             Data{id,4} = datastructure.Events{i};
%         elseif strfind(datastructure.Events{i},'Go') == 1
%             if strfind(datastructure.Events{i-2},'Auto Reward') == 1
%             Data{id,12} = '1';
%             Data{id,5} = datastructure.Events{i-2};
%             else
%                 Data{id,5} = datastructure.Events(i);
%                 Data{id,7} = '1';
%                 tGo = datastructure.Time{i,1};
%                 tGo = str2num(tGo(digitsTime - digitsFromEnd:digitsTime));
%                 for j = i-4:i
%                     if strfind(datastructure.Events{j},'Stimulus') == 1
%                         tStim = datastructure.Time{j,1};
%                         break
%                     end
%                 end
%                 tStim = str2double(tStim(digitsTime-digitsFromEnd:digitsTime));
%                 GoTime = tGo-tStim;
%                 if GoTime < 0
%                     tStim = 60 - tStim;
%                     GoTime = tGo + tStim;
%                 end
%                 Data{id,6} = num2str(GoTime);
%             end
%         elseif strfind(datastructure.Events{i},'Re') == 4
%             Data{id,5} = datastructure.Events{i};
%             Data{id,9} = '1';
%         elseif strfind(datastructure.Events{i},'No') == 1
%             Data{id,5} = datastructure.Events{i};
%             Data{id,8} = '1';
%         elseif strfind(datastructure.Events{i},'In') == 1
%             Data{id,5} = datastructure.Events{i};
%             Data{id,10} = '1';
%             tFA = datastructure.Time{i,1};
%             tFA = str2double(tFA(digitsTime - digitsFromEnd:digitsTime));
%             for j = i-3:i
%                 if strfind(datastructure.Events{j},'Stimulus') == 1
%                     tStim = datastructure.Time{j,1};
%                     break
%                 end
%             end
%             tStim = str2double(tStim(digitsTime - digitsFromEnd:digitsTime));
%             FAtime = tFA - tStim;
%             if FAtime < 0
%                 tStim = 60 - tStim;
%                 FAtime = tFA + tStim;
%             end
%             Data{id,11} = num2str(FAtime);
%         end
% end
%     
% datastructure.Data = Data;
% datastructure.DataAnalysis = str2double(Data);
% datastructure.DataAnalysis(2,1:2) = 1;
% datastructure.DataAnalysis(isnan(datastructure.DataAnalysis)) = 0;
% 
% 
% save('Multi_Behavior_Sort.mat','datastructure');
% %%
% % datastructure.Session1.BaseData = [];
% % RTs = [sum(datastructure.Session1.DataAnalysis(2:end,6) >= 0.001), sum(datastructure.Session1.DataAnalysis(2:end,11) > 0.001)];
% % BaseTrials = size(datastructure.Session1.DataAnalysis);
% % BaseTrials = ((BaseTrials(1,1) - 1) - sum(datastructure.Session1.DataAnalysis(2:end,12)));
% % perc_Gos = (sum(datastructure.Session1.DataAnalysis(2:end,7)) / BaseTrials(1,1))* 100;
% % perc_NoGos = ((sum(datastructure.Session1.DataAnalysis(2:end,8)) / BaseTrials(1,1)) * 100);
% % perc_FAs = ((sum(datastructure.Session1.DataAnalysis(2:end,10)) / BaseTrials(1,1)) * 100);
% % perc_Miss = ((sum(datastructure.Session1.DataAnalysis(2:end,9)) / BaseTrials(1,1)) * 100);
% % meanGoRT = (sum(datastructure.Session1.DataAnalysis(2:end,6) / RTs(1,1)));
% % meanFART = (sum(datastructure.Session1.DataAnalysis(2:end,11) / RTs(1,2)));
% % datastructure.Session1.BaseData = [perc_Gos; perc_NoGos; perc_Miss; perc_FAs; meanGoRT; meanFART];
% % 
% % %Calculate Baseline Hit Rate, FA Rate, Bias, and d' for Sess 1
% % datastructure.Session1.FinalData(1,1) = ((datastructure.Session1.BaseData(1,1)) / (datastructure.Session1.BaseData(1,1) + datastructure.Session1.BaseData(3,1))) - 0.0001;
% % datastructure.Session1.FinalData(1,2) = ((datastructure.Session1.BaseData(4,1)) / (datastructure.Session1.BaseData(4,1) + datastructure.Session1.BaseData(2,1))) + 0.0001;
% % datastructure.Session1.FinalData(1,3) = (norminv(datastructure.Session1.FinalData(1,1)) - norminv(datastructure.Session1.FinalData(1,2)));
% % datastructure.Session1.FinalData(1,4) = 0.5 * (norminv(datastructure.Session1.FinalData(1,1)) + norminv(datastructure.Session1.FinalData(1,2)));
% % datastructure.Session1.FinalData(1,5) = datastructure.Session1.BaseData(5,1);
% % datastructure.Session1.FinalData(1,6) = datastructure.Session1.BaseData(6,1);