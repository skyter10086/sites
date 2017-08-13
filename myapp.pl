#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;
use strict;
#use utf8::all;
use Mojo::JSON qw(decode_json encode_json);
use Data::Dumper;
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
#$dbh->do("SET NAMES utf8");

# Documentation browser under "/perldoc"


get 'upload_file' => sub {
    my $c = shift;
    $c->render(template => 'upload_file');


};

post 'upload' => sub{
	my $c = shift;
	my $bxlx = $c->param('bxlx_select');
  # Check file size
  return $c->render(text => 'File is too big.', status => 200)
    if $c->req->is_limit_exceeded;

  # Process uploaded file
  return $c->redirect_to('upload_file')
    unless my $example = $c->param('file1');
  my $size = $example->size;
  my $name = $example->filename;
  #my $save_filename = 'd:/sites_up/tmp/test_tmpfile';
  #open my $fh , "+>" , $save_filename;
  #$example->move_to( $save_filename);
  #close $fh;
  $dbh->{AutoCommit} = 0;
 my $stmt = sprintf("INSERT INTO %s.Zjmx(dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj) VALUES (%s)",$bxlx,join(",", ('?') x 12));
 my $sth = $dbh->prepare($stmt);
#sub insert_with_csv{
  my $data = $example->slurp();
  my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $fh1, "<", \$data;
#my @foo;
while (my $row = $csv->getline ($fh1)) {
 #   push @foo, $row;
	next if grep /dwbm/ @$row ;
	$sth->execute(@{$row} ) or die $DBI::errstr ;
   }
 #}
=pod
 sub insert_with_while{
 
 while(<$fh>){
 next if  /dwbm/ ;
	#chomp;
	
	my @values = split /,/;
      $sth->execute(@values ) or die $DBI::errstr ;
}
}
insert_with_csv();
=cut

$dbh->commit;
$dbh->{AutoCommit} = 1;
#close $fh;

  $c->render(text => "Thanks for uploading [$size] byte file <$name> and have saved it to tmp directory. ");
   # $c->render(text => $example->slurp() );
};


get '/test_looptab' => sub {
  my $c = shift;
  my $url = $c->url_for('/table/')->to_abs;
  $c->stash(url_tab => $url);
  $c->render(template => 'test_looptable');

};

get '/dwfl/dwbms' => sub {
  my $c = shift;
	my $list = list_dwbm();
	$c->render(json => $list);
};

get '/dwfl/dwfls' => sub {
	my $c = shift;
	my $list = list_dwfl();
	$c->render(json => $list);

};
get '/zjqs/:bxlx' => sub {
	my $c = shift;
	my $bxlx = $c->param('bxlx');
	my $list = list_zjq($bxlx);
	$c->render(json => $list);

};
sub list_zjq {
	my $bx = shift;
  my $stmt = {
	  'A01' => qq{ SELECT zjq FROM A01.zjmx WHERE length(trim(zjq))>0 group by zjq},
	  'A02' => qq{ SELECT zjq FROM A02.zjmx WHERE length(trim(zjq))>0 group by zjq},
	   'A03' => qq{ SELECT zjq FROM A03.zjmx WHERE length(trim(zjq))>0 group by zjq},
	    'A04' => qq{ SELECT zjq FROM A04.zjmx WHERE length(trim(zjq))>0 group by zjq},
	  };
	  my $st = $stmt->{$bx};
	my $sth = $dbh->prepare($st);
	$sth->execute() or die $DBI::errstr;
	my $zjq ;
	$sth->bind_columns(\$zjq);
	my $i =0;
	my $arr = [];
	while ($sth->fetch) {
		$i++;
		push @{$arr} , {id=> $i, text => $zjq} ;
	}

	return $arr;
}

sub list_dwfl {

	my $stmt = qq{ SELECT dwfl FROM DW.dwfl WHERE length(trim(dwfl))>0 group by dwfl};
	my $sth = $dbh->prepare($stmt);
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
  sub list_dwbm {

  	my $stmt = qq{ SELECT dwbm FROM DW.dwfl WHERE length(trim(dwbm))>0 group by dwbm order by dwbm};
  	my $sth = $dbh->prepare($stmt);
  	$sth->execute() or die $DBI::errstr;
  	my $dwbm;
  	$sth->bind_columns(\$dwbm);
  	my $i =0;
  	my $arr = [];
  	while ($sth->fetch) {
  		$i++;
  		push @{$arr} , {id=> $i, text => $dwbm} ;
  	}

  	return $arr;
  	}


get '/search' => sub {
    my $c = shift;
    #$c->render(json => queryZjmx($k,$v));
    $c->render(template => 'search');
};

get '/dwfl/dwbm/:dwbm' => sub {
	my $c = shift;
	my $dwbm = $c->param('dwbm');
	$c->render(json => query_dwbm($dwbm));

	};


get '/table/:bxlx/:id' => sub {
	my $c = shift;
  my $bxlx = $c->param('bxlx');
	my $id = $c->param('id');
	#my $dwbm = $c->param('dwbm');
	#my $dwmc = $c->param('dwmc');
	#my $dwjn =
	#my $href = query_zjid('id',$id);
	#CORE::dump($href);
	#my $dwbm = $href->{'dwbm'};
	#my $zjq = $href->{'zjq'};
	$c->stash(id => $id);
  $c->stash(bxlx =>$bxlx);
	#$c->stash(
	#	dwbm => $href->{dwbm},
	#	zjq => $href->{zjq},
	#	dyyzrs => $href->{dyyzrs},
	#	dwjs => $href->{dwjs},
	#	grjs => $href->{grjs},
	#	dwdy => $href->{dwdy},
	#	grdy => $href->{grdy},
	#	dwbz => $href->{dwbz},
	#	grbz => $href->{grbz},
	#	dwsz => $href->{dwsz},
	#	grsz => $href->{grsz},
	#	dzsj => $href->{dzsj},

	#);
	$c->render(template => 'table');

};

get '/zjmx/:bxlx/:id' => sub {
	my $c = shift;
	my $id = $c->param('id');
  my $bxlx = $c->param('bxlx');
	my $href = query_zjid($bxlx,$id);
	$c->render(json => $href );

	};

post '/query' => sub {
    my $c = shift;
    my $k = $c->param('key');
    my $v = $c->param('val');

    #my $z = queryInfo($k,$v);
    $c->render(json => queryInfo($k,$v));
    #$c->stash(frameworks => queryInfo($k,$v));
    #$c->render(template => 'datag');
    #$c->stash(description => 'web framework');
    #$c->stash(frameworks  => ['Catalyst', 'Mojolicious'， 1 ，20]);
    #$c->stash(spinoffs    => {minion => 'job queue'});
    #$c->render(template => 'data');

};

post '/query_zjd' => sub {
    my $c = shift;
    my $k = $c->param('key');
    my $v = $c->param('val');
    my $z = $c->param('zjq');
    my $b = $c->param('bxlx');
    #my $z = queryInfo($k,$v);
    $c->render(json => query_zjmx($k,$v,$z,$b));
    #$c->stash(frameworks => queryInfo($k,$v));
    #$c->render(template => 'datag');
    #$c->stash(description => 'web framework');
    #$c->stash(frameworks  => ['Catalyst', 'Mojolicious'， 1 ，20]);
    #$c->stash(spinoffs    => {minion => 'job queue'});
    #$c->render(template => 'data');

};

get '/' => sub {
    my $c = shift;
    $c->render(template => 'layout');
};
get '/block_search' => sub{
	my $c = shift;
	$c->stash(head_name => '职工参保',description => '新增或恢复参保',search_name => 'scbh',search_caption => '手册编号');
    $c->render(template => 'search_block');
};

get '/frame/zgcb' => sub {
	my $c = shift;
	#$c->stash(head_name => '职工参保',description => '新增或恢复参保',search_name => 'scbh',search_caption => '手册编号');
	$c->render(template => 'zgcb');
	};

get '/get_tree' => sub {
	my $c = shift;
	my $arr_ref = [
		{
			text => "职工管理",
			children => [
				{   text => "职工参保",
				    attributes => {url => "/frame/zgcb"},
				},
				{   text => "职工中断",
					attributes => {url => "/frame/zgzd"},
				},
				{   text => "职工内调",
					attributes => {url => '/frame/zgnd'},
				},
				{   text => "职工基本信息变更",
					attributes => {url => "frame/zgxxbg"},
				},
			],
		},

		{
			text => "险种管理",
			children => [
			    {   text => "征集比例",
					attributes => {url => '/frame/zjbl'},
				},
				{   text => "单位基数",
					attributes => {url => '/frame/dwjs'},
				},
				{   text => "个人基数",
					attributes => {url => '/frame/grjs'},
				},
			],
		},

		{
			text => "补征管理",
			children => [
			{   text => "单位补征",
				attributes => {url => '/frame/dwbz'},
			},
			{   text => "个人补征",
				attributes => {url => '/frame/grbz'},
			},
			],
		},

		{
			text => "征集数据",
			children => [
				{   text => "单位数据",
					attributes => {url => '/frame/zjdwsj'},
				},
				{   text => "个人数据",
					attributes => {url => '/frame/zjgrsj'},
				},
			],
		},

	];
	$c->render(json => $arr_ref);
};

post '/service/zg/xcb' => sub {
	my $c = shift;



	};

get '/test' => sub {
	my $c = shift;
	$c->render(template => 'tt');

	};

get '/zjbl/:bxlx/:zjq' => sub {
		my $c = shift;
		my $bx = $c->param('bxlx');
		my $zjq = $c->param('zjq');
		my $bl = query_bl($bx,$zjq);
		$c->render( json => $bl);
};
sub query_bl {
	my ($bxlx,$zjq) = @_;
	my $stmt = sprintf("SELECT dwbl,grbl FROM %s.Jfbl WHERE '%s'>=sj1 and '%s'<=sj2 ",$bxlx,$zjq,$zjq);
	my $sth = $dbh->prepare($stmt);
	$sth->execute() or die $DBI::errstr;
	my $row_ref = $sth->fetchrow_hashref() ;


	}

sub query_dwbm {
	my $dwbm = shift;
	my $stmt = qq{ SELECT * FROM DW.dwfl WHERE dwbm=?};
	my $sth = $dbh->prepare($stmt);
	$sth->execute(qq{$dwbm}) or die $DBI::errstr;
	my $row_ref = $sth->fetchrow_hashref() ;


	}
  sub query_zjmx {
      my ($key,$val,$zjq,$bxlx) = @_;
=pod
      $bxlx = 'A01' unless $bxlx;
      $key = 'dwbm' unless $key;
      $zjq = '2017-01-01' unless $zjq;
      $val = 'A_01' unless $val;
=cut

     return unless ($key || $val || $zjq || $bxlx);


      my $stmt =sprintf("SELECT  id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM %s.Zjmx WHERE zjq = ?  and dwbm in (SELECT dwbm FROM DW.dwfl where %s = ?) AND dyyzrs>0",$bxlx,$key);



      #        print "$qualifier\n";
      # my $stmt = $hr->{$kk};
      #print "$stmt\n";
                  my $sth = $dbh->prepare($stmt);
                  $sth->execute(qq{$zjq},qq{$val}) or die $DBI::errstr;
      #my $arr = $sth->fetchall_hashref();
       my $arr = [];
      while ( my $row_ref = $sth->fetchrow_hashref() ) {
      push @$arr , $row_ref;
  }
      my $rv = $sth->rows;
      my %hash ;
      if ($arr && ($rv>0)) {
      %hash = (
  				total => $rv,
  				rows => $arr,

      );
  	} else {
  		%hash = (
  					total => 0,
  					rows => [],
  		);}
  	return  \%hash;
     }

sub queryInfo {
    my ($kk,$vv) = @_;
    my $hr = {
                xm => qq{SELECT scbh,aac001, sfzh, xm, xb,  dwbm, dwmc, gzsj, zzflbz, jfgzjs, grjn, dwhz FROM Zgxx WHERE xm=?},
                sfzh => qq{SELECT scbh, aac001,sfzh, xm, xb,  dwbm, dwmc, gzsj, zzflbz, jfgzjs, grjn, dwhz FROM Zgxx WHERE sfzh = ? },
                scbh => qq{SELECT scbh, aac001,sfzh, xm, xb,  dwbm, dwmc, gzsj, zzflbz, jfgzjs, grjn, dwhz FROM Zgxx WHERE scbh = ?},
             };



    #        print "$qualifier\n";
    my $stmt = $hr->{$kk};
    #print "$stmt\n";
                my $sth = $dbh->prepare($stmt);
                $sth->execute(qq{$vv}) or die $DBI::errstr;
    #my $arr = $sth->fetchall_hashref();
     my $arr = [];
    while ( my $row_ref = $sth->fetchrow_hashref() ) {
    push @$arr , $row_ref;
}
    my $rv = $sth->rows;
    my %hash ;
    if ($arr && ($rv>0)) {
    %hash = (
				total => $rv,
				rows => $arr,

    );
	} else {
		%hash = (
					total => 0,
					rows => [],
		);}
	return  \%hash;
   }





get '/frame/zjdwsj' => sub {
  my $c = shift;
  $c->render(template => 'search_zjmx');
};

post '/query_zjmx' => sub {
  my $c = shift;
  my $k = $c->param('key');
  my $v = $c->param('val');
  #my $z = queryInfo($k,$v);
  $c->render(json => queryZjmx($k,$v));

};

sub queryZjmx {
  my ($kk,$vv) = @_;
  my $hr = {
			  id => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM Zjmx WHERE id=?},
              dwbm => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM Zjmx WHERE dwbm=? },
              zjq => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM Zjmx WHERE zjq = ? },
              dwxz => qq{SELECT scbh, sfzh, xm, xb,  dwbm, gzsj, zzflbz FROM Zgxx WHERE scbh = ?},
           };



  #        print "$qualifier\n";
  my $stmt = $hr->{$kk};
  #print "$stmt\n";
              my $sth = $dbh->prepare($stmt);
              $sth->execute(qq{$vv}) or die $DBI::errstr;
  #my $arr = $sth->fetchall_hashref();
  #my $hash_ref = $sth->fetchall_hashref();

   my $arr = [];
    while ( my $row_ref = $sth->fetchrow_hashref() ) {
    push @$arr , $row_ref;
}
    my $rv = $sth->rows;
    my %hash ;
    if ($arr && ($rv>0)) {
    %hash = (
				total => $rv,
				rows => $arr,

    );
	} else {
		%hash = (
					total => 0,
					rows => [],
		);}
	return  \%hash;
   }

   sub query_zjid {
  my ($kk,$vv) = @_;
  my $hr = {
			  A01 => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM A01.Zjmx WHERE id=?},
        A02 => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM A02.Zjmx WHERE id=?},
        A03 => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM A03.Zjmx WHERE id=?},
        A04 => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM A04.Zjmx WHERE id=?},
           };



  #        print "$qualifier\n";
  my $stmt = $hr->{$kk};
  #print "$stmt\n";
              my $sth = $dbh->prepare($stmt);
              $sth->execute(qq{$vv}) or die $DBI::errstr;
  #my $arr = $sth->fetchall_hashref();
  #my $hash_ref = $sth->fetchall_hashref();
	my $row_ref = $sth->fetchrow_hashref() ;

	return  $row_ref;
   }

=pod
   sub res_hr{
	    while ( my $row_ref = $sth->fetchrow_hashref() ) {
             return $row_ref;
        }
    }

    my $do = {
			id => \&res_hr,
			dwbm => \&res_jsn,

		};
		$do->{$kk}();
=cut




app->start;
