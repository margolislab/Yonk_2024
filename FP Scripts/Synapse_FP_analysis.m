clear;
clc;
[path] = uigetdir;
cd(path);
SDKpath = 'C:\Users\ajy31\OneDrive - Rutgers University\Documents\a. Scripts\TDTMatlabSDK-master';
addpath(genpath(SDKpath));

%Import data file and segment out necessary information
Data = TDTbin2mat(path);
GCaMP = Data.streams.G__B.data.'; %Raw GCaMP signals
Iso = Data.streams.IsoB.data.'; %Raw Isosbestic signals
Fs = Data.streams.IsoB.fs; %Frame acqusition sampling
Ts = ((1:numel(Data.streams.G__B.data)) / Fs)'; %Calculate timestamps by Fs
%Events = Data.epocs.sqr_.onset; %TS of the events


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

%{
%Using the events timestamps, convert the timestamps into sampling
%frequency
Seconds=5;
Seconds2 = 10;
Before=round(Seconds*Fs);
After=round(Seconds2*Fs);

for i=1:length(Events)
    a=find(Events(i) < Ts(:,1));
    a=a(1,1);
    ZAlign(i,:)= Z(a-Before:a+After,1);
end

ZAlignMean = mean(ZAlign(2:end,:));
ZAlignstd = std(ZAlign(2:end,:));
%}


%Define an x vector that goes from -second to + the second
subplot(2,1,2);
plot(ZAlignMean);
%xlim([0 xlimits]);
xline(5086,'r','LineWidth',1)

subplot(2,1,1)
imagesc(ZAlign);
caxis([-0.5 3]);
%xlim([0 xlimits]);
%xline(5086,'r','LineWidth',1)
title('Aligned to Presentation Window Onset')
EventOutcome = {};