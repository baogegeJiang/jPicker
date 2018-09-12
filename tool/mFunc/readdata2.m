function [ data] = readdata2( filename )
%to get a mat of cells from filename;

line=textread(filename,'%s','delimiter','\n','whitespace','');

N=size(line);

data=cell(0,0);

for i=1:N
    if length(line{i})==0
    continue;
    end
    temp=textscan(line{i},'%s');
     Temp=temp{1};
     data(i,1:length(Temp))=cellstr(Temp');
end

if N(1,1) ==0
    data{1,1}='0';
end

end

