#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;
use strict;
use utf8::all;
use Mojo::JSON qw(decode_json encode_json);
use Data::Dumper;

my $driver   = "SQLite";
my $database = "A01.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, {sqlite_unicode =>1, RaiseError => 1 })
               or die $DBI::errstr;
#$dbh->do("SET NAMES utf8");
my $database_a = "DW.db";
my $dsn_a = "DBI:$driver:dbname=$database_a";
my $dbh_a = DBI->connect($dsn_a, $userid, $password, {sqlite_unicode =>1, RaiseError => 1 })
               or die $DBI::errstr;


# Documentation browser under "/perldoc"
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


get '/table/:id' => sub {
	my $c = shift;
	my $id = $c->param('id');
	#my $dwbm = $c->param('dwbm');
	#my $dwmc = $c->param('dwmc');
	#my $dwjn = 
	my $href = query_zjid('id',$id);
	#CORE::dump($href);
	#my $dwbm = $href->{'dwbm'};
	#my $zjq = $href->{'zjq'};
	#$c->stash($href);
	$c->stash(
		dwbm => $href->{dwbm},
		zjq => $href->{zjq},
		dyyzrs => $href->{dyyzrs},
		dwjs => $href->{dwjs},
		grjs => $href->{grjs},
		dwdy => $href->{dwdy},
		grdy => $href->{grdy},
		dwbz => $href->{dwbz},
		grbz => $href->{grbz},
		dwsz => $href->{dwsz},
		grsz => $href->{grsz},
		dzsj => $href->{dzsj},
	
	);
	$c->render(template => 'table');

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


sub query_dwbm {
	my $dwbm = shift;
	my $stmt = qq{ SELECT * FROM dwfl WHERE dwbm=?};
	my $sth = $dbh_a->prepare($stmt);
	$sth->execute(qq{$dwbm}) or die $DBI::errstr;
	my $row_ref = $sth->fetchrow_hashref() ;
	
	
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
              dwfl => qq{SELECT scbh, sfzh, xm, xb,  dwbm, gzsj, zzflbz FROM Zgxx WHERE sfzh = ? },
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
			  id => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM Zjmx WHERE id=?},
              dwbm => qq{SELECT id, dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj FROM Zjmx WHERE dwbm=? },
              dwfl => qq{SELECT scbh, sfzh, xm, xb,  dwbm, gzsj, zzflbz FROM Zgxx WHERE sfzh = ? },
              dwxz => qq{SELECT scbh, sfzh, xm, xb,  dwbm, gzsj, zzflbz FROM Zgxx WHERE scbh = ?},
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
