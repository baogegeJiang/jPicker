for i=1:length(day)
    i
    for j=1:length(day(i).quake)
        day(i).quake(j).PS(1:4)=day(i).quake(j).PS(1:4)*0;
    end
    [loc res]=locQuake(day(i).quake,2);
    for j=1:length(day(i).quake)
        if res(j)<3
           day(i).quake(j).PS(1:4)=loc(1:4,j);
        end
    end
    [loc res]=locQuake(day(i).quake,2);
    for j=1:length(day(i).quake)
           day(i).quake(j).PS(1:4)=loc(1:4,j);
    end
end
