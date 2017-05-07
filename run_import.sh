
# 2017:
# 7546
# 7596
# 7484

perl import.pl data/asker-2017.xml 16 D13-14 "D 13-14"
perl import.pl data/asker-2017.xml 16 H13-14 "H 13-14"
perl import.pl data/asker-2017.xml 16 D15-16 "D 15-16"
perl import.pl data/asker-2017.xml 16 H15-16 "H 15-16"

for raceId in 16  ; do 
for class in D13-14 H13-14 D15-16 H15-16; do 

perl calc.pl $raceId $class

done
done


perl present.pl 6
 