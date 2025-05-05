function [output]=text_file_reader(filePath)
%{
---------------------------------------------------------------------------
function call: [output]=text_file_reader(filePath)

input: (filePath)--> path to text file on your computer
output: struct containing array of datetime timestamps, trial numbers, and
        go no go outputs

---------------------------------------------------------------------------
%}
cd(filePath)
file = uigetfile;

formatSpec='%s%s%f%s';
T=readtable(file,'Format',formatSpec);
t1=T(:,1);
t2=T(:,2);
t3=T(:,3);
t4=T(:,4);

%String array of date
A1=table2array(t1);
A=string(A1);

%String array of timestamps
B1=table2array(t2);
B=string(B1);

%Array of current trial
C=table2array(t3);

%Go, no go array
D1=table2array(t4);
D=string(D1);

%Split date: one column for month, one column for day, one column for year
Q=split(A,"/");

%Get the month number and convert to a double
q=Q(2,1);
%fprintf("%s",q);
q=str2double(q);

%This switch statement will give a shorthand version of our month
switch q
    case 1
    
        for i=1:length(Q)
            Q(i,1)="Jan";
        end

    case 2

         for i=1:length(Q)
            Q(i,1)="Feb";
        end

    case 3

        for i=1:length(Q)
            Q(i,1)="Mar";
        end

    case 4

        for i=1:length(Q)
            Q(i,1)="Apr";
        end

    case 5

        for i=1:length(Q)
            Q(i,1)="May";
        end

    case 6

        for i=1:length(Q)
            Q(i,1)="Jun";
        end

    case 7

        for i=1:length(Q)
            Q(i,1)="Jul";
        end

    case 8

        for i=1:length(Q)
            Q(i,1)="Aug";
        end

    case 9

        for i=1:length(Q)
            Q(i,1)="Sep";
        end

    case 10

        for i=1:length(Q)
            Q(i,1)="Oct";
        end

    case 11

        for i=1:length(Q)
            Q(i,1)="Nov";
        end

    case 12

        for i=1:length(Q)
            Q(i,1)="Dec";
        end
end

%Swap columns containing month and day
for i=1:length(Q)
    temp=Q(i,1);
    Q(i,1)=Q(i,2);
    Q(i,2)=temp;
end

%Create a one column array of string in format dd-MMM-yyyy
K=join(Q,"-");

%Create an empty string array
R=strings(length(A),1);

%Append dd-MMM-yyyy with timestamp and place in array R
for i=1:length(A)
    R(i)=append(K(i),B(i));
end

%Convert string into datetime format

t=datetime(R,'TimeZone','local','Format','dd-MMM-yyyy HH:mm:ss:SSSS');

%Updated timestamp, array of trial numbers, and go no go values sent put
%into an output struct

output.timeStamp=t;
output.trialNum=C;
output.trialOut=D;

%Save combinedData as a .mat file
save('textData.mat','output');

end