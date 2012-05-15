#!/usr/bin/perl

#!/usr/bin/perl

use strict;
use DBD::mysql;
use Data::Dumper;

use setup;
our $dbh;

my ($race_id)=@ARGV;

my $persons;
my $st1 = $dbh->prepare("select distinct p.id, p.family_name, p.given_name, p.club, r.class from person p, result r where p.id=r.person_id");
$st1->execute();
while (my $h = $st1->fetchrow_hashref) {
  $persons->{$h->{id}}=$h;
}

my $results;

my $straces = $dbh->prepare("select race_id from series_race where series_id=? order by id");
$straces->execute($race_id);
my @races;
while (my $h = $straces->fetchrow_arrayref()) {
  push @races, $h->[0];
}

my $stclasses = $dbh->prepare("select name from class");
$stclasses->execute();
my @classes;
while (my $h = $stclasses->fetchrow_arrayref()) {
  push @classes, $h->[0];
}


my $st2 = $dbh->prepare("select r.status, r.person_id, r.race_id, r.class, r.time_sec, r.time, r.points from result r, series_race sr, series s where r.race_id=sr.race_id and sr.series_id=s.id and s.id=?");
$st2->execute($race_id);

my $p_in_class;

while (my $h = $st2->fetchrow_hashref) {
  if (!defined $results->{$h->{id}}) {
    $results->{$h->{person_id}}={};
    $p_in_class->{$h->{class}}->{$h->{person_id}}++;
    push @{$persons->{$h->{person_id}}->{points}}, $h->{points};
    push @{$persons->{$h->{person_id}}->{times}}, $h->{time};
  }
  $results->{$h->{person_id}}->{$h->{race_id}} = $h;
}

print "<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n";
print <<EOF;
<style type="text/css">

caption, h3 { color: #333; }
h2 { color: #7e3d25; }

div#main {
   font-family: Arial,sans-serif;
   background: white url("http://eventor.orientering.no/Images/MainBackground.png") repeat-x;
   border-bottom: 1px solid #BFBFBF;
   padding: 8px 32px 24px 32px;
}

footer {
   display:block;
   font-size:50%;
   margin-top: 3em;
}

 /*** sample table to demonstrate CSS3 formatting ***/
        table.formatHTML5 {
            border-collapse:collapse;
            text-align:left;
            color: #606060;
        }
 
        /*** table's thead section, head row style ***/
        table.formatHTML5 thead tr td  {
            background-color: White;
            vertical-align:middle;
            padding: 0.6em;
            font-size:0.8em;
        }
 
        /*** table's thead section, coulmns header style ***/
        table.formatHTML5 thead tr th
        {
            padding: 0.5em;
            /* add gradient */
            background-color: #474747;
            background: -webkit-gradient(linear, left top, left bottom, from(#474747), to(#909090));
            background: -moz-linear-gradient(top, #474747, #909090);
            color: #ffffff;
        }
 
        /*** table's tbody section, odd rows style ***/
        table.formatHTML5 tbody tr:nth-child(odd) {
           background-color: #fafafa;
        }
 
 
        /*** table's tbody section, even rows style ***/
        table.formatHTML5 tbody tr:nth-child(even) {
            background-color: #efefef;
        }
        table.formatHTML5 td.number { text-align: right; width:5ex; padding-left: 1ex; }
        table.formatHTML5 td.name { width: 20em; }
        table.formatHTML5 td.club { width: 10em; }
 </style>
EOF
print "</head><body><div id=\"main\">\n";

print "<h2>Unionsmatch 2012 - Rangering etter to l&oslash;p</h2>\n";

foreach my $cl (@classes) {
  print "<div id=\"$cl\"><h3>$cl</h3>\n";
  my @persons = keys %{$p_in_class->{$cl}};
  my %res;
  foreach my $pid (@persons) {
    my $p = $persons->{$pid};
    my @points = sort num @{$p->{points}};
    my $sum = $points[0] + $points[1];
    $p->{sum} = $sum;
    $res{$pid} = $sum;
  }
  my @persons_ordered = sort { $res{$b}<=>$res{$a} } @persons;
  print "<table class='result formatHTML5'>\n";
  print "<caption>Resultater for $cl</caption>\n";
  print "<colgroup /><colgroup/><colgroup span=\"3\"/><colgroup />\n";
  print "<thead><tr><th>Navn</th><th>Klubb</th><th colspan=\"3\">Poeng</th><th>Sum</th></tr></thead><tbody>\n";
  my $n = 0;
  foreach my $pid (@persons_ordered) {
    $n++;
    my $nmod=$n%2;
    my $p = $persons->{$pid};
    printf "<tr><td class=\"name\">%s</td><td class=\"club\">%s</td><td class=\"number\" title=\"%s\">%.1f</td><td class=\"number\" title=\"%s\">%.1f</td><td class=\"number\" title=\"%s\">%.1f</td><td class=\"number\">%.1f</td></tr>\n", "$p->{given_name} $p->{family_name}",$p->{club},
      $p->{times}->[0],$p->{points}->[0],
      $p->{times}->[1],$p->{points}->[1],
      $p->{times}->[2],$p->{points}->[2],
	$p->{sum};
  }
  print "</tbody></table></div>\n";
}

print "<footer>". `date  ` ."</footer>\n";

print "</div></body></html>\n";

sub num {
  return $b<=>$a;
}
