function [TT]=revamped_tdmsReader(folderPath,txt_filePath)

%{
function [textData,indexHigh,indexLow,eventTranspose,tdmsPaths,data,wobble]=revamped_tdmsReader(folderPath,txt_filePath)

OBJECTIVE: Read the 150 .tdms data files into matlab as a structure and
then allign the event number with the associated tdms sample run in order
to plot out the voltage accross the different events and timestamps.

%}

%'first' is a function that gets the index of the first instance in which 
% a value appears within a sorted array.

function[answer] = first(arr,x,n)

low = 1;
high= n;
res=-1;

while (low <= high)

        mid = ceil((low + high)/2);
 
        if arr(mid) > x

            high = mid - 1;

        elseif arr(mid) < x

            low = mid + 1;

        else
            res = mid;
            high = mid - 1;
        end
end

answer=res;

end

%Implementation of a Progress bar
tic
f = waitbar(0,'Please wait...');
pause(.5)

%Reads information about tdms data in tdms folder 
p=dir([folderPath '/*.tdms']);

%Create an array of filenames
for k=1:length(p)

    filename=[folderPath '/' p(k).name];

end

%Create a string array which will contain the tdms data paths
tdmsPaths=strings(150,1);

%Read data paths into string array
for w=1:150

tdmsPaths(w)=strcat(p(w).folder,'/',p(w).name);

end

%Convert string array into character array
tdmsPaths=convertStringsToChars(tdmsPaths);


%Create an array of structures.
for w=1:150

    data(w).sample=struct;

end

%Put the data from each tdms data sample into each individual branch
%structure connected to the main one

for w=1:150

    q=tdmsPaths{w};
    data(w).sample=TDMS_getStruct(q);
end

waitbar(.67,f,'Tdms Data Retrieved');

%Read the text data into the workspace
textData=text_file_reader(txt_filePath);

waitbar(0.75,f,'Text Data Retrieved');

%Retrieve the starting index of the event instances and store in indexLow

indexLow=zeros(1,150);

eventTranspose=textData.trialNum;
eventTranspose=transpose(eventTranspose);


for j=1:150

    indexLow(j)=first(eventTranspose,j,1000);

end

%Use indexLow to retrieve the timestamp and trial output data 
%that corresponds to a specific event and store them into a cell 150 by 3
%cell. The first column represents the datetime values and the second
%column represents the trial outputs. The third column will store an array
%of the voltage values present within the tdms file.

splitEvents=cell([150,4]);

for i=1:149
 
    splitEvents{i,1}=textData.timeStamp(indexLow(i):(indexLow(i+1)-1));
    splitEvents{i,2}=textData.trialOut(indexLow(i):(indexLow(i+1)-1));
    splitEvents{i,3}=data(i).sample.Untitled.Untitled.data;

end

splitEvents{150,1}=textData.timeStamp(indexLow(150):end);
splitEvents{150,2}=textData.trialOut(indexLow(150):end);
splitEvents{150,3}=data(150).sample.Untitled.Untitled.data;

for i=1:150
    splitEvents{i,3}=transpose(splitEvents{i,3});
end

%Create a linespace timestamp array which starts at the begining of the 

for i=1:150
    eventNum=splitEvents{i,1};
    n=length(eventNum);
    timeBegin=eventNum(1);
    timeEnd=eventNum(n);
    q=length(splitEvents{i,3});
    time=linspace(timeBegin,timeEnd,q);
    time.Format='dd-MMM-yyyy HH:mm:ss:SSSS';
    splitEvents{i,4}=transpose(time);
end

for i=1:150

    timetable1=timetable(splitEvents{i,1},splitEvents{i,2});
    timetable2=timetable(splitEvents{i,4},splitEvents{i,3});
    timetableRes=synchronize(timetable1,timetable2);
    tableRes=timetable2table(timetableRes);
    tableRes=fillmissing(tableRes,"previous");
    TT(i).sample=table2struct(tableRes);

end

waitbar(.80,f,'TDMS and Text data combined');

waitbar(90,f,'Saving Data');
name=input('Please provide a name for your data file.\n','s');
save(name,'TT');
waitbar(100,f,'Finished')
pause(1);
close(f)

toc


end