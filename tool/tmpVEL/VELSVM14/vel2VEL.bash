#14 1 4 1648 27.39 40.6429N 114.4296E   3.35   3.29    147      1.10
work_dir=/home/jiangyr/VEL/
file=${work_dir}vel_reloc.CNV;
nfile=${work_dir}reloc_lst;
if [[ -e $nfile ]];then
rm $nfile
fi
cat $file | while read line ; do
pd=`echo $line | cut -b 1`
if [[ $pd != 1 ]];then
continue; 
fi
year=`echo $line | cut -b 1-2`;
year=20$year;
mon=`echo $line | cut -b 3-4`;
day=`echo $line | cut -b 5-6`;
hour=`echo $line | cut -b 8-9`;
min=`echo $line | cut -b 10-11`;
sec=`echo $line | cut -b 13-17`;
la=`echo $line | cut -b 18-24`;
lo=`echo $line | cut -b 27-34`;
dep=`echo $line | cut -b 39-43`;
mag=`echo $line | cut -b 46-50`;
echo $la
echo $year $mon $day $hour $min $sec $la $lo $dep $mag  >> $nfile;
done
