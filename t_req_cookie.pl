use Mojolicious::Sessions;

my $sessions = Mojolicious::Sessions->new({
  user => 'xiaoming',
  id => '0123',
});
$sessions->cookie_name('myapp');
$sessions->cookie_domain('localhost');
$sessions->default_expiration(86400);
my $name = $sessions->cookie_name;
my $path = $sessions->cookie_path;
my $domain = $sessions->cookie_domain;
print "cookie_name : $name \n";
print "cookie_path : $path \n";
print "cookie_domain : $domain \n";
print "user : $sessions->{user} \n";
