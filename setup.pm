use DBI;
our $dsn = "DBI:mysql:database=hs_aook_ranking"; #;host=prod3.spjelkavik.net;port=3306";
our  $dbh = DBI->connect($dsn, "hs", "st");

1;
