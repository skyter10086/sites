
use DBI;
use strict;
use Data::Dumper ;

my $driver   = "SQLite";
my $database_a = "DW.db";
my $userid = "";
my $password = "";
my $dsn_a = "DBI:$driver:dbname=$database_a";
my $dbh_a = DBI->connect($dsn_a, $userid, $password, {sqlite_unicode =>1, RaiseError => 1 })
               or die $DBI::errstr;

sub list_dwfl {
	
	my $stmt = qq{ SELECT dwfl FROM dwfl WHERE length(trim(dwfl))>0 group by dwfl};
	my $sth = $dbh_a->prepare($stmt);
	$sth->execute() or die $DBI::errstr;
	my $dwfl ;
	$sth->bind_columns(\$dwfl);
	my $i =0;
	my $arr = [];
	while ($sth->fetch) {
		$i++;
		push @{$arr} , {id=> $i, text => $dwfl} ;
	}
	
	return $arr;
	}

my $array_ref = list_dwfl();
print Data::Dumper->Dump($array_ref);
