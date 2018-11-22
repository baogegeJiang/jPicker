function [  ] = wfile( data,file)
[l,m]=size(data);
fp=fopen(file,'wt');
for i=1:l
    for j=1:m
        temp=data{i,j};
        if j==1
            fprintf(fp,'%s',temp);
        else
            fprintf(fp,' %s',temp);
        end
    end
    if i~=l
            fprintf(fp,'\n',temp);
    end
end
        
fclose(fp);

