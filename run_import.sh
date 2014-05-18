#perl import.pl data/lk-2014.xml 7 D13-14 "D 13-14" 
#perl import.pl data/lk-2014.xml 7 H13-14 "H 13-14" 
#perl import.pl data/lk-2014.xml 7 D15-16 "D 15-16" 
#perl import.pl data/lk-2014.xml 7 H15-16 "H 15-16" 

#perl import.pl data/kvm-2014.xml 8 D13-14 "D1314"
#perl import.pl data/kvm-2014.xml 8 H13-14 "H1314"
#perl import.pl data/kvm-2014.xml 8 D15-16 "D1516"
#perl import.pl data/kvm-2014.xml 8 H15-16 "H1516"

perl import.pl data/grom-2014.xml 9 D13-14 "D13-14"
perl import.pl data/grom-2014.xml 9 H13-14 "H13-14"
perl import.pl data/grom-2014.xml 9 D15-16 "D15-16"
perl import.pl data/grom-2014.xml 9 H15-16 "H15-16"


perl calc.pl 7 D13-14
perl calc.pl 7 H13-14
perl calc.pl 7 D15-16
perl calc.pl 7 H15-16

perl calc.pl 8 D13-14
perl calc.pl 8 H13-14
perl calc.pl 8 D15-16
perl calc.pl 8 H15-16


perl calc.pl 9 D13-14
perl calc.pl 9 H13-14
perl calc.pl 9 D15-16
perl calc.pl 9 H15-16

perl present.pl 3 
 