 use DBI;
 
use Text::CSV_XS;
 
 
 my $dbh = DBI->connect("dbi:SQLite::memory:","","",{sqlite_unicode =>1, AutoCommit => 1, RaiseError => 1})
                     or die $DBI::errstr;
      my $statement_a = qq{ATTACH DATABASE 'A01.db' as 'A01'};
      my $statement_b = qq{ATTACH DATABASE 'A02.db' as 'A02'};
      my $statement_c = qq{ATTACH DATABASE 'DW.db' as 'DW'};
		my $statement_d = qq{ATTACH DATABASE 'A03.db' as 'A03'};
      my $rows = $dbh->do($statement_a)           or die $dbh->errstr;
      $rows =   $dbh->do($statement_b)           or die $dbh->errstr;
      $rows = $dbh->do($statement_c)           or die $dbh->errstr;
	  $rows = $dbh->do($statement_d)           or die $dbh->errstr;
  my $save_filename = 'd:/sites_up/tmp/test_tmpfile';
  open my $fh , "<" , $save_filename;
  #$example->move_to( $save_filename);
  #close $fh;
  #my $data = $example->slurp();
 # my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
#open my $fh, "<", \$data;
#my @foo;
#while (my $row = $csv->getline ($fh)) {
 #   push @foo, $row;
 #   }
 $dbh->{AutoCommit} = 0;
 my $bxlx= "A03";
 my $stmt = sprintf("INSERT INTO %s.Zjmx(dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj) VALUES (%s)",$bxlx,join(",", ('?') x 12));
 print "The stmt is $stmt"," \n";
 my $sth = $dbh->prepare($stmt);
 
 while(<$fh>){
 next if  /^dwbm/ ;
	
	print $_,"\n";
	my @values = split /,/;
      $sth->execute(@values) or die $DBI::errstr ;
}
$dbh->commit;
$dbh->{AutoCommit} = 1;
close $fh;

#  $c->render(text => "Thanks for uploading [$size] byte file <$name> and have saved it to tmp directory. ");
   # $c->render(text => $example->slurp() );

