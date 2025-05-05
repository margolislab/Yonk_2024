EF = [];
EN = [];
EM = [];
EH = [];
NF = [];
NN = [];
NM = [];
NH = [];

disp('When you have finished inputting the data, enter dbcont to continue')
keyboard()

%Adds NaNs if the number of naive vs. expert sesssions is different
if length(NH) ~= length(EH)
    a = length(NH);
    b = length(EH);
    if a > b
        EH(end+1:a) = nan;
    elseif a < b
        NH(end+1:b) = nan;
    end
end

if length(NM) ~= length(EM)
    c = length(NM);
    d = length(EM);
    if c > d
        EM(end+1:c) = nan;
    elseif c < d
        NM(end+1:d) = nan;
    end
end

if length(NF) ~= length(EF)
    e = length(NF);
    f = length(EF);
    if e > f
        EF(end+1:e) = nan;
    elseif e < f
        NF(end+1:f) = nan;
    end
end

if length(NN) ~= length(EN)
    g = length(NN);
    h = length(EN);
    if g > h
        EN(end+1:g) = nan;
    elseif g < h
        NN(end+1:h) = nan;
    end
end



for i = 1:4
    subplot(1,4,i)
    if i == 1
        boxplot([NH,EH],'Labels',{'Naive','Expert'});
        hold on
        scatter(1,NH,'k')
        scatter(2,EH,'k')
        title('Hit')
        mygca(i) = gca;
    elseif i == 2
        boxplot([NM,EM],'Labels',{'Naive','Expert'});
        hold on
        scatter(1,NM,'k')
        scatter(2,EM,'k')
        title('Miss')
        mygca(i) = gca;
    elseif i == 3
        boxplot([NF,EF],'Labels',{'Naive','Expert'})
        hold on
        scatter(1,NF,'k')
        scatter(2,EF,'k')
        title('False Alarm')
        mygca(i) = gca;
    elseif i == 4
        boxplot([NN,EN],'Labels',{'Naive','Expert'})
        hold on
        scatter(1,NN,'k')
        scatter(2,EN,'k')
        title('Correct Rejection')
        mygca(i) = gca;
    end
end

yl = cell2mat(get(mygca(1:4),'Ylim')); %capture y-limit information for the average subplots
ylnew = [min(yl(:,1)) max(yl(:,2))]; %capture minimum and maximum y limits for all average subplots
set(mygca(1:4),'YLim',ylnew); %set y-axes for all average subplots

figure;
for i = 1:4
    subplot(1,4,i)
    if i == 1
        plot(NH,'o-','color','r')
        hold on
        plot(9:16,EH,'o-','color','k')
        title('Hit')
        xlabel('Session #')
        mygca(i) = gca;

    elseif i == 2
        plot(NM,'o-','color','r')
        hold on
        plot(9:16,EM,'o-','color','k')
        title('Miss')
        xlabel('Session #')
        mygca(i) = gca;

    elseif i == 3
        plot(NF,'o-','color','r')
        hold on
        plot(9:16,EF,'o-','color','k')
        title('False Alarm')
        xlabel('Session #')
        mygca(i) = gca;

    elseif i == 4
        plot(NN,'o-','color','r')
        hold on
        plot(9:16,EN,'o-','color','k')
        title('Correct Rejection')
        xlabel('Session #')
        mygca(i) = gca;
    end
end

yl = cell2mat(get(mygca(1:4),'Ylim')); %capture y-limit information for the average subplots
ylnew = [min(yl(:,1)) max(yl(:,2))]; %capture minimum and maximum y limits for all average subplots
set(mygca(1:4),'YLim',ylnew); %set y-axes for all average subplots