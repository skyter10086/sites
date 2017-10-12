use DBI;
use utf8;
use strict;
use Data::Dumper;
use DateTime ;

my $driver   = "SQLite"; 
my $database = "A01.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
               or die $DBI::errstr;

sub queryInfo {
    my ($kk,$vv) = @_;
    my $hr = {
                xm => qq{SELECT scbh, sfzh, xm, xb,  dwbm FROM Zgxx WHERE xm=?},
                sfzh => qq{SELECT scbh, sfzh, xm, xb,  dwbm FROM Zgxx WHERE sfzh = ? },
                scbh => qq{SELECT scbh, sfzh, xm, xb,  dwbm FROM Zgxx WHERE scbh = ?},
             };


    
    #        print "$qualifier\n";
    my $stmt = $hr->{$kk};
    #print "$stmt\n";
    my $sth = $dbh->prepare($stmt);
    $sth->execute(qq{$vv}) or die $DBI::errstr;
    my $arr = $sth->fetchrow_arrayref();
}
print Data::Dumper->Dump(queryInfo("xm","张磊"));
my $ref = queryInfo("xm","张磊");
my $arref = ['a' , 34 ,2, DateTime->new( year=> 1983, month => 10 ,day =>10)];
print "\n";
print $ref,"\n";
print Data::Dumper->Dump($arref);

