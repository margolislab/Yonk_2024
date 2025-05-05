function[tdms_Data,fp_Data,timeTDMS,bigEmpty,eventNum,fpTimes]=fiberphoto_tdms(fiberphoto_datapath,combined_datapath)
%{

GOAL: 
    
    Comepare the instances in which an event starts for 'sqr_' and the
    combined tdms/text data. Use this to create a conversion sheet where
    any time that doesn't sink up with instances in which the text says
    'Begin Trial' is filled with a NaN. Use the data in the text file along
    with linear interpolation in order to fill in the NaNs. There should be
    150 onset values in correspondance with the number of tdms trial events. 
    Offsets are not considered. Consider all fiber-photo data starting at 
    the inital onset and ending at the ending onset. Use linear
    interpolation in order to acquire any missing fiber photo data. Put the
    fiber-photo data alongside the tdms data inside a struct.

INPUT:
        combined_datapath: a character array which represents the path which
        points to the combined tdms data structure.

        fiberphoto_datapath: a character array which represent the path
        which points to the fiber photometry data structure.

OUTPUT:
        output: a combined structure which contains our desired combined
        data. The data should be synchronized such that post hoc analysis
        can be undertaken.

%}

%Read in the tdms data using the load command and name
%the struct 'tdms_Data'

cd(combined_datapath)
file = uigetfile;
tdms_Data=load(file);

%Read in the fiber photometry data using the load command and name
%the struct 'fp_Data'
cd(fiberphoto_datapath);
SDKpath = 'C:\Users\alexy\OneDrive\Documents\z. Downloads';
addpath(genpath(SDKpath));

%Import data file and segment out necessary information
Data = TDTbin2mat(fiberphoto_datapath);

%Retrieve the inital timestamp of each event store those values in an array

for i=1:150

    oldTime(i)=tdms_Data.TT(i).sample(1).Time;
 
end

%Convert the datetime array into a char array

j=char(oldTime);


%Extract the hours, minutes, seconds, and fractions of a second from the
%timestamps

for i=1:150

    hr(i,1)=j(i,13);
    hr(i,2)=j(i,14);
    min(i,1)=j(i,16);
    min(i,2)=j(i,17);
    sec(i,1)=j(i,19);
    sec(i,2)=j(i,20);
    f(i,1)=j(i,22);
    f(i,2)=j(i,23);
    f(i,3)=j(i,24);
    f(i,4)=j(i,25);


end

    H=strcat(hr(:,1),hr(:,2));
    M=strcat(min(:,1),min(:,2));
    S=strcat(sec(:,1),sec(:,2));
    F=strcat(f(:,1),f(:,2),f(:,3),f(:,4));

%Convert the char arrays for Hour, Min, Second, and Fractions of second into
%integer values.

hh=str2num(H);
mm=str2num(M);
ss=str2num(S);
ffff=str2num(F);

%Convert the integer values of the minutes and hours into seconds and
%convert the fractions so that the integer value is placed as the mantissa

for i=1:150

    ffff(i)=ffff(i)/10000;
    mm(i)=mm(i)*60;
    hh(i)=hh(i)*3600;

end

%Calculate the tdms time array in seconds using the data above.
%Calculate the difference between the first value of timeTDMS and the first
%value of the onset square wave data and store the value in variable d.
%Subtract all the timeTDMS values by d. Now timeTDMS has its start
%sychronized with the onset square wave and we can begin comparing
%timevalues. 

timeTDMS=hh+mm+ss+ffff;

d=timeTDMS(1)-Data.epocs.sqr_.onset(1);

timeTDMS=timeTDMS-d;

%Find elements of tdmsData that does not exist in fp_Data

l=length(timeTDMS);
w=length(Data.epocs.sqr_.onset);

bigEmpty=[];
eventNum=[];

for i=1:l

    match=false;

    for j=1:w
      
        if abs(timeTDMS(i)-Data.epocs.sqr_.onset(j))<0.005*max(timeTDMS(i),Data.epocs.sqr_.onset(j))

        match=true;

        break;

        end

    end

    if match==false
        eventNum=[eventNum;i];
        bigEmpty=[bigEmpty;timeTDMS(i)];

    end

end

fpTimes=Data.epocs.sqr_.onset;

for i=1:length(eventNum)

    temp=fpTimes(i:end);
    fpTimes(i:end)=[];
    fpTimes(i)=bigEmpty(i);
    fpTimes=[fpTimes,temp];
    
end


%daTruth=interp1(timeTDMS,fp_Data.data.epocs.sqr_.onset,bigEmpty);

%{
%Retrieve timestamp for initialization of fiber-photo recording

init=data2.data.info.utcStartTime;

%Retrieve timestamp for termination of fiber-photo recording

term=data2.data.info.utcStopTime;

%Retrieve date of experiment

date=data2.data.info.date;

%Produce initial and ending timestamp of experiment by concatenating the character
%stings for both date and initial timestamp with a space. Then convert
%concatenated characater array into a datetime format which matches with
%data1.

perfectStart=strcat(date,{' '},init);

perfectEnd=strcat(date,{' '},term);

datetime_start=datetime(perfectStart,'TimeZone','local','Format','dd-MMM-yyyy HH:mm:ss:SSSS');

datetime_end=datetime(perfectEnd,'TimeZone','local','Format',"dd-MMM-yyyy HH:mm:ss:SSSS");

%Retrieve the length of a stream
l=length(data2.data.streams.Dv3B.data);

%Create a datetime array which starts at datetime_start and ends at
%datetime_end using the linespace arrray
timespan=linspace(datetime_start,datetime_end,l);

timespanTranspose=transpose(timespan);

%Retrieve the data for Dv3B from data2 struct and store in variable
data_Dv3B=data2.data.streams.Dv3B.data;

transposeDv3B=transpose(data_Dv3B);

%Retrieve the data for Dv2A from data2 struct and store in variable
data_Dv2A=data2.data.streams.Dv2A.data;

transposeDv2A=transpose(data_Dv2A);

%Retrieve the data for Dv1A from data2 struct and store in variable
data_Dv1A=data2.data.streams.Dv1A.data;

transposeDv1A=transpose(data_Dv1A);

%Retrieve the data for Fi1r from data2 struct and store in variable
%data_Fi1r=data2.data.streams.Fi1r.data;

%NOTE: The size of Fi1r is 2*5809669. The rest of the streams are of size
%1*968320. Thus, I have to find out a way to include Fi1r on a latter date.

%Create a table which contains the timestamp data and the stream data 

stream_timetable=timetable(timespanTranspose,transposeDv1A,transposeDv2A,transposeDv3B);
%}


end