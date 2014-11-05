# -*-perl-*-
use Test::More;

require_ok( 'Data::Validate::Struct' );

my $ref = {
	   'b1' => {
                    'b2' => {
			     'b3' => {
				      'item' => 'int'
				     }
                            }
		   },
	   'item' => [ 'number' ],
	   'v1' => 'int',
	   'v2' => 'number',
	   'v3' => 'word',
	   'v4' => 'line',
	   'v5' => 'text',
	   'v6' => 'hostname',
	   'v8' => 'user',
	   'v10' => 'port',
	   'v11' => 'uri',
	   'v12' => 'cidrv4',
	   'v13' => 'ipv4',
	   'v14' => 'path',
	   'v15' => 'fileexists',
	   'v16' => 'quoted',
	   'v171' => 'regex',
	   'v172' => 'regex',
	   'v18' => 'novars',
	   'v19' => 'ipv6',
	   'v20' => 'ipv6',
	   'v21' => 'ipv6',
	   'v22' => 'ipv6',
	   'v23' => 'ipv6',
           'v24' => 'ipv6',
           'v25' => 'ipv6',
           'v26' => 'cidrv6',

           'v27' => 'int | vars',
           'v28' => 'int | vars',

           'o1'  => 'int | optional',

           'AoH' => [
             { fullname => 'text', user => 'word', uid => 'int' }
           ],

            'AoA' => [ [ 'int' ] ],
	  };

my $cfg =  {
	    'b1' => {
		     'b2' => {
                              'b3' => {
				       'item' => '100'
                                      }
			     }
		    },
	    'item' => [
		       '10',
		       '20',
		       '30'
		      ],
	    'v1' => '123',
	    'v2' => '19.03',
	    'v3' => 'Johannes',
	    'v4' => 'this is a line of text',
	    'v5' => 'This is a text block
                     This is a text block',
	    'v6' => 'search.cpan.org',
	    'v8' => 'root',
	    'v10' => '22',
	    'v11' => 'http://search.cpan.org/~tlinden/?ignore&not=1',
	    'v12' => '192.168.1.101/18',
	    'v13' => '10.0.0.193',
	    'v14' => '/etc/ssh/sshd.conf',
	    'v15' => 'MANIFEST',
	    'v16' => '\' this is a quoted string \'',
	    'v171' => qr([0-9]+),
	    'v172' => 'qr([0-9]+)',
	    'v18' => 'Doesnt contain any variables',
	    'v19' => '3ffe:1900:4545:3:200:f8ff:fe21:67cf',
	    'v20' => 'fe80:0:0:0:200:f8ff:fe21:67cf',
	    'v21' => 'fe80::200:f8ff:fe21:67cf',
	    'v22' => 'ff02:0:0:0:0:0:0:1',
	    'v23' => 'ff02::1',
            'v24' => '::ffff:192.0.2.128',
            'v25' => '::',
            'v26' => '2001:db8:dead:beef::b00c/64',

            'v27' => '10',
            'v28' => '$ten',

            'AoH' => [
              { fullname => 'Homer Simpson', user => 'homer', uid => 100 },
              { fullname => 'Bart Simpson',  user => 'bart',  uid => 101 },
              { fullname => 'Lisa Simpson',  user => 'lisa',  uid => 102 },
            ],

            'AoA' => [
              [ qw{ 10 11 12 13 } ],
              [ qw{ 20 21 22 23 } ],
              [ qw{ 30 31 32 33 } ],
            ],

	   };

my $v = new_ok('Data::Validate::Struct', [ $ref ]);
ok ($v->validate($cfg), "validate a reference against a config " . $v->errstr());



# check failure matching
my @failure =
(
 { cfg  => q(acht),
   type => q(int)
 },

 { cfg  => q(27^8),
   type => q(number)
 },

 { cfg  => q(two words),
   type => q(word)
 },

 { cfg  => qq(<<EOF\nzeile1\nzeile2\nzeile3\nEOF\n),
   type => q(line)
 },

 { cfg  => q(ätz),
   type => q(hostname)
 },

 { cfg  => q(gibtsnet123456790.intern),
   type => q(resolvablehost)
 },

 { cfg  => q(äüö),
   type => q(user)
 },

 { cfg  => q(äüö),
   type => q(group)
 },

 { cfg  => q(234234444),
   type => q(port)
 },

 { cfg  => q(unknown:/unsinnüäö),
   type => q(uri)
 },

 { cfg  => q(1.1.1.1/33),
   type => q(cidrv4)
 },

 { cfg  => q(300.1.1.1),
   type => q(ipv4)
 },

 { cfg  => q(üäö),
   type => q(fileexists)
 },

 { cfg  => q(not quoted),
   type => q(quoted)
 },

 { cfg  => q(no regex),
   type => q(regex)
 },

 { cfg  => q($contains some $vars),
   type => q(novars)
 },

 { cfg  => q(2001:db8::dead::beef),
   type => q(ipv6)
 },

 { cfg  => q(2001:db8:dead:beef::1/129),
   type => q(cidrv6)
 },

 {
   cfg => [
    { fullname => 'Homer Simpson', user => 'homer', uid => 100 },
    { fullname => 'Bart Simpson',  user => 'bart',  uid => 101 },
    { fullname => 'Lisa Simpson',  user => 'lisa:',  uid => 102 },
   ],

   type => [
     { fullname => 'text', user => 'word', uid => 'int' }
   ],
 },

 {
   cfg => [
     [ qw{ 10 11 12 13 } ],
     [ qw{ 20 21 22 23 } ],
     [ qw{ 30 31 32.0 33 } ],
   ],

   type => [ [ 'int' ] ],
 },

);

foreach my $test (@failure) {
  my $ref    = { v => $test->{type} };
  my $cfg    = { v => $test->{cfg}  };
  my $v      = new Data::Validate::Struct($ref);
  if ($v->validate($cfg)) {
    fail("could not catch invalid '$test->{type}'");
  }
  else {
    pass("catched invalid '$test->{type}'");
  }
}



# adding custom type
my $ref3 = { 
  v1 => 'address',
  v2 => 'list',
  v3 => 'noob',
  v4 => 'nonoob',
};
my $cfg3 = { 
  v1 => 'Marblestreet 15',
  v2 => 'a1, b2, b3',
  v3 => 42,
  v4 => 43,
};

my $v3   = new Data::Validate::Struct($ref3);
$v3->type(
 (
  address => qr(^\w+\s\s*\d+$),
  list    =>
    sub {
      my $list = $_[0];
      my @list = split /\s*,\s*/, $list;
      if (scalar @list > 1) {
	return 1;
      }
      else {
	return 0;
      }
    },
  noob => sub { return $_[0] == 42 },
 )
);
ok($v3->validate($cfg3), "using custom types " . $v3->errstr());

done_testing();

