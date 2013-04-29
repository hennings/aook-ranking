#!/usr/bin/perl

use strict;
use DBD::mysql;
use XML::XPath;


use setup;
our $dbh;

my ($file, $race_id, $class, $classInFile, $eventRaceId) = @ARGV;

print "** Importing $race_id / $class from $file\n";

my $xp = XML::XPath->new(filename => $file);
my $ns = $xp->find("/ResultList/ClassResult[EventClass/ClassShortName='$classInFile']/PersonResult"); 



my $st = $dbh->prepare("delete from result where race_id=? and class=?");
$st->execute($race_id, $class);

my $sti = $dbh->prepare("insert into result (id, race_id, person_id, time, status, class, time_sec) values (0, ?,?,?,?,?,?)");

my $stf = $dbh->prepare("select id from person where eventor_id=?");
my $stip = $dbh->prepare("insert into person (id, family_name, given_name, club, club_id, eventor_id, created) values (0,?,?,?,?,?,null)");

my %aookClub = (26=>26,32=>32,33=>33,57=>57,58=>58,62=>62,71=>71,78=>78,80=>80,83=>83,89=>89,91=>91,107=>107,108=>108,110=>110,114=>114,125=>125,127=>127,128=>128,144=>144,150=>150,163=>163,172=>172,176=>176,181=>181,182=>182,188=>188,203=>203,205=>205,209=>209,227=>227,229=>229,232=>232,234=>234,236=>236,240=>240,245=>245,258=>258,268=>268,271=>271,272=>272,273=>273,281=>281,290=>290,308=>308,310=>310,313=>313,323=>323,342=>342,343=>343,362=>362,363=>363,373=>373,388=>388,400=>400,401=>401,402=>402,533=>533);

foreach my $node ($ns->get_nodelist) {
  my $given = $node->findvalue("Person/PersonName/Given");
  my $famname = $node->findvalue("Person/PersonName/Family");
  my $id = $node->findvalue("Person/PersonId");
  my $club = $node->findvalue("Organisation/Name");
  my $clubId = $node->findvalue("Organisation/OrganisationId");

  my $time; my @status; my $status;

  if (defined $eventRaceId) {
      $time = $node->findvalue("RaceResult[EventRace/EventRaceId=$eventRaceId]/Result/Time");
      @status = $node->findnodes("RaceResult[EventRace/EventRaceId=$eventRaceId]/Result/CompetitorStatus")->get_nodelist;
      if (!@status) {
	  warn "Problems with runner: $given $famname ($id)\n";
	  next;
      }
      $status = $status[0]->getAttribute("value");
  } else {
      $time = $node->findvalue("Result/Time");
      @status = $node->findnodes("Result/CompetitorStatus")->get_nodelist;
      if (!@status) {
	  warn "Problems with runner: $given $famname ($id)\n";
	  next;
      }
      $status = $status[0]->getAttribute("value");
  }


  next unless $aookClub{$clubId};

  my $myId;
  $stf->execute($id);
  my $h = $stf->fetchrow_hashref;
  if ($h->{id}) {
    $myId = $h->{id};
  } else {
    $stip->execute($famname, $given, $club,$clubId, $id);
    $myId = $dbh->{'mysql_insertid'};
  }
  print "$famname, $given (E$id - $myId)\t$club ($clubId)\t  \t$time \t$status\n";

  $sti->execute($race_id, $myId, $time, $status, $class, hms2sec($time));

}


sub hms2sec {
  my ($t)=@_;
  if ($t=~ /^(\d+):(\d+)$/) {
    return $2+$1*60;
  }
  if ($t=~ /(\d+):(\d+):(\d+)$/) {
    return $3+$2*60+$1*60*60;
  }
  return 0;
}



#
#PersonResult
# Person/PersonName/Family
# Person/PersonName/Given
# Person/PersonId
# Result/Time  
# Result/CompetitorStatus

__END__

create table person (
  id int auto_increment primary key,
  family_name varchar(255),
  given_name varchar(255),
  club varchar(255),
  club_id int,
  created timestamp
);

create table race(
  id int auto_increment primary key,
  name varchar(255),
  race_date date,
  season int(4)       	   
);

create table result (
  id int auto_increment primary key,
  race_id int,
  person_id int,
  time varchar(255),
  status varchar(20),
  points float,
  foreign key (race_id) references race,
  foreign key (person_id) references person
);

create table series (
  id int auto_increment primary key,
  name varchar(255)
);

create table series_race (
  id int auto_increment primary key,
  series_id int,
  race_id int,
  foreign key (series_id) references series,
  foreign key (race_id) references race
);
