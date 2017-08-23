#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;
use strict;
#use utf8::all;
use Mojo::JSON qw(decode_json encode_json);
use Data::Dumper;
use Text::CSV_XS;
use Encode;
use Data::Dumper qw(Dumper);


      my $dbh = DBI->connect("dbi:SQLite::memory:","","",{sqlite_unicode =>1, AutoCommit => 1, RaiseError => 1})
                or die $DBI::errstr;
      my $statement_a = qq{ATTACH DATABASE '../SQL_Backup/A01.db' as 'A01'};
      my $statement_b = qq{ATTACH DATABASE '../SQL_Backup/A02.db' as 'A02'};
      my $statement_c = qq{ATTACH DATABASE '../SQL_Backup/DW.db' as 'DW'};
		  my $statement_d = qq{ATTACH DATABASE '../SQL_Backup/A03.db' as 'A03'};
      my $statement_t = qq{ATTACH DATABASE ':memory:' AS 'TMP'};
      my $rows = $dbh->do($statement_a)           or die $dbh->errstr;
      $rows =   $dbh->do($statement_b)           or die $dbh->errstr;
      $rows = $dbh->do($statement_c)           or die $dbh->errstr;
	    $rows = $dbh->do($statement_d)           or die $dbh->errstr;
      $rows = $dbh->do($statement_t)           or die $dbh->errstr;

    #  $rows = $dbh->do($tmp_zjmx)           or die $dbh->errstr;
    #  $rows = $dbh->do($tmp_jfmx)           or die $dbh->errstr;
    #  $rows = $dbh->do($tmp_zgxx)           or die $dbh->errstr;
    #  $rows = $dbh->do($tmp_bjmx)           or die $dbh->errstr;
    #  $rows = $dbh->do($tmp_zgbd)           or die $dbh->errstr;
    #  $rows = $dbh->do($tmp_jfbl)           or die $dbh->errstr;

      my $tmp_zjmx = qq{CREATE TABLE TMP.Zjmx (
      	  id     INTEGER         PRIMARY KEY AUTOINCREMENT,
          zjq      DATE  NOT NULL,
          dwbm     CHAR(4) NOT NULL,
          dyyzrs   INT NOT NULL,
          dwjs     DECIMAL(12,2),
          grjs     DECIMAL(10,2),
          dwdy     DECIMAL(12,2),
          grdy     DECIMAL(10,2),
          dwbz     DECIMAL(12,2),
          grbz     DECIMAL(10,2),
          dwsz     DECIMAL(12,2),
          grsz     DECIMAL(10,2),
          dzsj     DATE
          )
      };
      my $tmp_jfmx = qq{CREATE TABLE TMP.Jfmx (

          zjq      DATE     NOT NULL,
          scbh     CHAR(12) NOT NULL,
          xm       CHAR(40) NOT NULL,
          dwbm     CHAR(5)  NOT NULL,
          jfgzjs   DECIMAL(10,2)    ,
          grjn     DECIMAL(10,2)    ,
          dwhz     DECIMAL(10,2)    ,
          bzys     INT              ,
          dzbz     BOOLEAN          ,
          dzsj     DATE

      )};
      my $tmp_zgxx = qq{CREATE TABLE TMP.Zgxx (

          scbh     CHAR(12) NOT NULL,
          sfzh     CHAR(19) ,
          xm       CHAR(40) NOT NULL,
          xb       CHAR(2)  ,
          mz       CHAR(20) ,
          csny     DATE     ,
          gzsj     DATE     ,
          dwbm     CHAR(5)  ,
          dwmc     CHAR(40) ,
          jfgzjs   DECIMAL(10,2)    ,
          grjn     DECIMAL(10,2)    ,
          dwhz     DECIMAL(10,2)    ,
          zzsj     DATE             ,
          zzflbz   CHAR(3)      ,
          zzyy     CHAR(40) ,
          aac001   CHAR(16)         ,
          aab001   CHAR(16)         ,

          PRIMARY KEY    (scbh ASC)

      )};
      my $tmp_bjmx = qq{CREATE TABLE TMP.Bjmx (

          jflx     CHAR(10) NOT NULL,
          scbh     CHAR(12)         ,
          xm       CHAR(40)         ,
          dwbm     CHAR(5)  ,
          dwmc     CHAR(40)         ,
          zjq      DATE     NOT NULL,
          sj1      DATE             ,
          sj2      DATE             ,
          jfgzjs   DECIMAL(12,2),
          dwjn     DECIMAL(12,2),
          grjn     DECIMAL(10,2)

      )};
      my $tmp_zgbd = qq{CREATE TABLE TMP.Zgbd (

          scbh     CHAR(12) NOT NULL,
          xm       CHAR(40) NOT NULL,
          dwbm     CHAR(5)  NOT NULL,
          bdsj     DATE     NOT NULL,
          ydwbm    CHAR(5)  NOT NULL,
          tsfl     CHAR(3)          ,
          jfgzjs   DECIMAL(10,2)

      )};
      my $tmp_jfbl = qq{CREATE TABLE TMP.Jfbl (

          sj1      DATE         NOT NULL,
          sj2      DATE         NOT NULL,
          dwbms    VARCHAR(255) NOT NULL,
          dwbl     DECIMAL(5,4) NOT NULL,
          grbl     DECIMAL(5,4) NOT NULL

      )};

#$dbh->do("SET NAMES utf8");

# Documentation browser under "/perldoc"
sub trans_code {
	my ($mydata) = @_; #传入object
  #print $mydata;
	#my $data = $obj->slurp;
	#print Dumper($mydata);
	#$mydata = Encode::encode("UTF-8",Encode::decode("gbk",$mydata)) unless my $flag = Encode::is_utf8($mydata);
	#print Dumper($mydata);
  #unless (my $flag = Encode::is_utf8(Encode::decode('UTF-8',$mydata))){
  #  print 'not utf8!',"\n";

  #}
  $mydata = Encode::encode("UTF-8",Encode::decode("gbk",$mydata));
    $mydata =~ s/'//mg;
    $mydata =~ s/"//mg;
	#print Dumper($mydata);
	return $mydata; # =～ 不是赋值语句，不写return 就变成了1
}

sub out_aoh_json{
  my $ref_data = shift;
  #print Dumper($ref_data), "\n";
  open my $fh1, "<", $ref_data;
  my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
  	my ($i,@arr);
    $csv->header($fh1);
  	while (my $row = $csv->getline_hr($fh1)) {
      #print Dumper($row),"\n";
      push @arr,$row  ;
  	#next if grep /dwbm/ ,@$row ;
  	#$sth->execute(@{$row} ) or  die " Can't execute the statement which $i record of $flag :  $DBI::errstr";
  	$i++;
  	if ($i==10) {
      print "almost done!\n";
      last;
  	}

     }
     print Dumper(\@arr),"\n";
     return \@arr;
=pod
  my $aoh = Text::CSV_XS::csv(in => $fh1,
               headers => "auto");
  my $line_count = @{$aoh};
  #my %hash ;
  return $aoh if $aoh;
=cut

=pod
  if ($aoh && ($line_count>0)) {
  %hash = (
      total => $line_count,
      rows => $aoh,

  );
} else {
  %hash = (
        total => 0,
        rows => [],
  );}
return  \%hash;
=cut
}

sub deal_with_csv {

	my ($bxlx,$flag, $ref_data) = @_;
	my $stmt = {
         'zjmx' => sprintf("INSERT INTO %s.Zjmx(dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj) VALUES (%s)",$bxlx,join(",", ('?') x 12)),
				 'jfmx' => sprintf("INSERT INTO %s.Jfmx(zjq,scbh,xm,dwbm,jfgzjs,grjn,dwhz,bzys,dzbz,dzsj) VALUES (%s)",$bxlx,join(",", ('?') x 10)),
				 'bjmx' => sprintf("INSERT INTO %s.Bjmx(jflx,scbh,xm,dwbm,dwmc,zjq,sj1,sj2,jfgzjs,dwjn,grjn) VALUES (%s)",$bxlx,join(",", ('?') x 11)),
         'zgxx' => sprintf("INSERT INTO %s.Zgxx(scbh,sfzh,xm,xb,mz,csny,gzsj,dwbm,dwmc,jfgzjs,grjn,dwhz,zzsj,zzflbz,zzyy,aac001,aab001) VALUES (%s)",$bxlx,join(",", ('?') x 17)),
         'zgbd' => sprintf("INSERT INTO %s.Zgbd(scbh,xm,dwbm,bdsj,ydwbm,tsfl,jfgzjs) VALUES (%s)",$bxlx,join(",", ('?') x 7)),
         'jfbl' => sprintf("INSERT INTO %s.Jfbl(sj1,sj2,dwbms,dwbl,grbl) VALUES (%s)",$bxlx,join(",", ('?') x 5)),
		};
	my $sth = $dbh->prepare_cached($stmt->{$flag});

	my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
	open my $fh1, "<", $ref_data;

	my $i;
	while (my $row = $csv->getline ($fh1)) {

	next if grep /dwbm/ ,@$row ;
	$sth->execute(@{$row} ) or  die " Can't execute the statement which $i record of $flag :  $DBI::errstr";
	$i++;
	if ($i%10000==0 && $i>10000) {
			dbh->commit or die;
	}
   }

$dbh->commit or die;

close $fh1;
return "向 $flag 插入了 $i 条数据 ";
}

post 'fake_upfile' => sub {
	my $c = shift;
	#my $file = $c->param('file');
	#my $bxlx = 'TMP';
	#my $type = $c->param('type');

	return $c->render(text => 'File is too big.', status => 200)
    if $c->req->is_limit_exceeded;
   my $file = $c->param('file');
   if (!$file) {
     print "the file not exist!\n";
    #return $c->redirect_to('upload_file') ;
   }

    my $data = $file->slurp();
    $data = trans_code($data);
    my $result = out_aoh_json(\$data);

    $c->render(json =>  $result);

};

post 'upfile' => sub {
	my $c = shift;
	#my $file = $c->param('file');
	my $bxlx = $c->param('bxlx');
	my $type = $c->param('type');

	return $c->render(text => 'File is too big.', status => 200)
    if $c->req->is_limit_exceeded;
    my $file = $c->param('file');
#   {print "the f did not send!\n"; return $c->redirect_to('upload_file')} unless (my $file = $c->param('file'));
    unless ($file) {
      print 'File is null!\n';
      return $c->redirect_to('upload_file');
    }
    $dbh->{AutoCommit} = 0;
    my $data = $file->slurp();
    $data = trans_code($data);
    my $result = deal_with_csv($bxlx,$type,\$data);
    $dbh->{AutoCommit} = 1;
    $c->render(text =>  $result);

};


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
    #unless (my $zjmx = $c->param('file1')) && (my $jfmx = $c->param('file2')) && (my $bjmx = $c->param('file3'));
    unless my $zjmx = $c->param('file1');
  #my $size = $example->size;
  #my $name = $example->filename;

  #my $save_filename = 'd:/sites_up/tmp/test_tmpfile';
  #open my $fh , "+>" , $save_filename;
  #$example->move_to( $save_filename);
  #close $fh;
  $dbh->{AutoCommit} = 0;

  #my $zjmx_data = trans_code($zjmx);

  #my $jfmx_data = trans_code($jfmx->slurp());
  #my $bjmx_data = trans_code($bjmx->slurp());


  #my $res_jfmx = deal_with_csv($bxlx,'个人缴费明细',\$jfmx_data);
  #my $res_bjmx = deal_with_csv($bxlx,'补缴明细',\$bjmx_data);
 my $stmt = sprintf("INSERT INTO %s.Zjmx(dwbm, zjq, dyyzrs, dwjs, grjs, dwdy, grdy,dwbz,grbz,dwsz,grsz,dzsj) VALUES (%s)",$bxlx,join(",", ('?') x 12));
 my $sth = $dbh->prepare($stmt);
#sub insert_with_csv{

  my $data = $zjmx->slurp();
  #print Dumper($data);
  #my $data2 = $jfmx->slurp();
  #my $data3 = $bjmx->slurp();
  #dump $obj->slurp
  #my $dump_1 = Data::Dumper::Dump($data);
  $data = trans_code($data);
  #$data = Encode::encode("UTF-8",Encode::decode("gbk",$data)) unless my $flag1 = Encode::is_utf8($data);
  #$data =~ s/'//mg;
  #$data =~ s/"//mg;
  #print Dumper $data;
=pod
  $data2 = Encode::encode("UTF-8",Encode::decode("gbk",$data2)) unless my $flag2 = Encode::is_utf8($data2);
  $data2 =~ s/'//mg;
  $data2 =~ s/"//mg;

  $data3 = Encode::encode("UTF-8",Encode::decode("gbk",$data3)) unless my $flag3 = Encode::is_utf8($data3);
  $data3 =~ s/'//mg;
  $data3 =~ s/"//mg;
=cut
	#my $d = $zjmx->slurp();
	#my $data = trans_code($d);
	my $res_1 = deal_with_csv($bxlx,'单位缴费明细',\$data);
  #my $res_2 = deal_with_csv($bxlx,'个人缴费明细',\$data2);
  #my $res_3 = deal_with_csv($bxlx,'补缴明细',\$data3);
  #my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
#open my $fh1, "<", \$data;
#my @foo;
#my $i;
#while (my $row = $csv->getline ($fh1)) {
 #   push @foo, $row;

#	next if grep /dwbm/ ,@$row ;
#	$sth->execute(@{$row} ) or die $DBI::errstr ;
#	$i++;
#	$dbh->commit if $i%10000==0 && $i>10000;
#  }
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

#$dbh->commit;
$dbh->{AutoCommit} = 1;
#close $fh;

  $c->render(json => {'file1' => $res_1});
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

    return $c->render(json => {total => 0, rows => []}) unless ($k || $v || $z || $b);
    return $c->render(json => query_zjmx($k,$v,$z,$b));
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
				{   text => "数据上传",
					attributes => {url => '/upload_file'},
				},
				{   text => "征集单查询及打印",
					attributes => {url => '/test_looptab'},
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
