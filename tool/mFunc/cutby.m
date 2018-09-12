function [ str_cell ] = cutby( str,intv )
%to cut a string by intv cutby(str,intv);

l=length(str);m=length(intv);str_cell=cell(0,0);count=0;pre=1;

for i=1:l-m+1
    
   if strcmp(intv,str(i:i+m-1)) 
       
       if pre<=i-1
           count=count+1;
           str_cell{count,1}=str(pre:i-1);
       end
       
       pre=i+m;continue;
       
   end
   
   if i==l-m+1
       count=count+1;
       str_cell{count,1}=str(pre:l);
   end
   
end
        


