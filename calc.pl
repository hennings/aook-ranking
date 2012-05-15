#!/usr/bin/perl

use Data::Dumper;
use DBD::mysql;
use XML::XPath;
use setup;

our $dbh;
my ($race_id, $class) = @ARGV;

print "*** Calc points for $class in $race_id\n";

my $sth = $dbh->prepare("select id, person_id,time,status, time_sec from result where race_id=? and class=? order by class,time");
$sth->execute($race_id, $class);

my $h;
my @rows;

my @times;
while ($h = $sth->fetchrow_arrayref) {
  my $r = {"id"=>$h->[0], "pid"=>$h->[1], "time"=>$h->[2], "status"=>$h->[3],
	  "time_sec"=>$h->[4] };
  
  if ($r->{"status"}=~ /OK/i) {
    push (@rows, $r);
    
    push (@times, $r->{"time_sec"} );

  }

}

my @ordered = (sort {$a<=>$b} @times)[0..2];
print join(";", @ordered)."\n";
my $sum = 0.0; my $n = 0;

foreach (@ordered) {
  if ($_>0) {
    $sum+=$_;
    $n++;
  }
}

my $avg = $sum/$n;

print "Avg: $avg\n";

my $stu = $dbh->prepare("update result set points=? where id=?");

foreach my $r (@rows) {
  my $t = $r->{"time_sec"};
  my $points = 1600/0.6 + ((-1000)/(0.6*$avg))*$t;
  if ($points>0) {
    $r->{"points"} = $points;
  } else {
    $r->{"points"} = 0;
  }
  $stu->execute($r->{"points"}, $r->{"id"});
}

# =MAX(0;(1600/0.6)+((-1000)/(0.6*avg))*t)

