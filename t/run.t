# -*-perl-*-
use utf8;
use Test::More;
use Encode qw{ encode };

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

           'AoA' => [ [ 'int' ] ],

           'AoH' => [
                     {
                      fullname => 'text', user => 'word', uid => 'int' }
                    ],

           'HoH' => {
                     father   => { fullname => 'text', user => 'word' },
                     son      => { fullname => 'text', user => 'word' },
                     daughter => { fullname => 'text', user => 'word' },
                    },

           'r1' => 'range(80-90)',
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

            'AoA' => [
                      [ qw{ 10 11 12 13 } ],
                      [ qw{ 20 21 22 23 } ],
                      [ qw{ 30 31 32 33 } ],
                     ],

            'AoH' => [
                      {
                       fullname => 'Homer Simpson', user => 'homer', uid => 100 },
                      {
                       fullname => 'Bart Simpson',  user => 'bart',  uid => 101 },
                      {
                       fullname => 'Lisa Simpson',  user => 'lisa',  uid => 102 },
                     ],

            'HoH' => {
                      father =>   { fullname => 'Homer Simpson', user => 'homer' },
                      son =>      { fullname => 'Bart Simpson',  user => 'bart'  },
                      daughter => { fullname => 'Lisa Simpson',  user => 'lisa'  },
                     },

            'r1' => 85,
           };

my $v = new_ok('Data::Validate::Struct', [ $ref ]);
ok ($v->validate($cfg), "validate a reference against a OK config");


# check failure matching
my @failure = (
               {
                cfg  => q(acht),
                type => q(int),
                descr => 'int',
                errors => 1,
               },

               {
                cfg  => q(27^8),
                type => q(number),
                descr => 'number',
                errors => 1,
               },

               {
                cfg  => q(two words),
                type => q(word),
                descr => 'word',
                errors => 1,
               },

               {
                cfg  => qq(<<EOF\nzeile1\nzeile2\nzeile3\nEOF\n),
                type => q(line),
                descr => 'line',
                errors => 1,
               },

               {
                cfg  => q(ätz),
                type => q(hostname),
                descr => 'hostname',
                errors => 1,
               },

               {
                cfg  => q(gibtsnet123456790.intern),
                type => q(resolvablehost),
                descr => 'resolvablehost',
                errors => 1,
               },

               {
                cfg  => q(äüö),
                type => q(user),
                descr => 'user',
                errors => 1,
               },

               {
                cfg  => q(äüö),
                type => q(group),
                descr => 'group',
                errors => 1,
               },

               {
                cfg  => q(234234444),
                type => q(port),
                descr => 'port',
                errors => 1,
               },

               {
                cfg  => q(unknown:/unsinnüäö),
                type => q(uri),
                descr => 'uri',
                errors => 1,
               },

               {
                cfg  => q(1.1.1.1/33),
                type => q(cidrv4),
                descr => 'cidrv4',
                errors => 1,
               },

               {
                cfg  => q(300.1.1.1),
                type => q(ipv4),
                descr => 'ipv4',
                errors => 1,
               },

               {
                cfg  => q(üäö),
                type => q(fileexists),
                descr => 'fileexists',
                errors => 1,
               },

               {
                cfg  => q(not quoted),
                type => q(quoted),
                descr => 'quoted',
                errors => 1,
               },

               {
                cfg  => q(no regex),
                type => q(regex),
                descr => 'regex',
                errors => 1,
               },

               {
                cfg  => q($contains some $vars),
                type => q(novars),
                descr => 'novars',
                errors => 1,
               },

               {
                cfg  => q(2001:db8::dead::beef),
                type => q(ipv6),
                descr => 'ipv6',
                errors => 1,
               },

               {
                cfg  => q(2001:db8:dead:beef::1/129),
                type => q(cidrv6),
                descr => 'cidrv6',
                errors => 1,
               },

               {
                cfg => [
                        [ qw{ 10 11 12 13 } ],
                        [ qw{ 'twenty' 21 22 23 } ],
                        [ qw{ 30 31 32.0 33 } ],
                       ],

                type => [ [ 'int' ] ],

                descr => 'array of arrays',
                errors => 2,
               },

               {
                cfg => [
                        {
                         fullname => 'Homer Simpson', user => 'homer', uid => 100 },
                        {
                         fullname => 'Bart Simpson',  user => ':bart',  uid => 101 },
                        {
                         fullname => 'Lisa Simpson',  user => 'lisa',  uid => '102' },
                       ],

                type => [
                         {
                          fullname => 'text', user => 'word', uid => 'int' }
                        ],

                descr => 'array of hashes',
                errors => 1,
               },

               {
                cfg => {
                        father   => { fullname => 'Homer Simpson', user => 'homer', uid => 100 },
                        son      => { fullname => 'Bart Simpson',  user => 'bart',  uid => 'one hundred one' },
                        daughter => { fullname => 'Lisa Simpson',  user => 'lisa:', uid => 'one hundred two' },
                       },

                type => {
                         father   => { fullname => 'text', user => 'word', uid => 'int' },
                         son      => { fullname => 'text', user => 'word', uid => 'int' },
                         daughter => { fullname => 'text', user => 'word', uid => 'int' },
                        },

                descr => 'hash of hashes',
                errors => 3,
               },

               {
                cfg => {
                        name    => 'Foo Bar',
                        age     => 42,
                       },

                type => {
                         name    => 'text',
                         age     => 'int',
                         address => 'text',
                        },

                descr => 'Missing required field',
                errors => 1,
               },

               {
                cfg => 100,
                type => 'range(200-1000)',
                descr => 'value outside dynamic range',
                errors => 1,
               },

              );

foreach my $test (@failure) {
  my $ref    = { v => $test->{type} };
  my $cfg    = { v => $test->{cfg}  };
  my $v      = Data::Validate::Struct->new($ref);
  #$v->debug();
  my $result = $v->validate($cfg);
  my $descr = encode('UTF-8',
                     exists $test->{descr} ? $test->{descr} : $test->{cfg}
                    );
  my $errors = exists $test->{errors} ? $test->{errors} : 1;
  unless ($result) {
    is @{$v->errors}, $errors, "Caught failure for '$descr'";
  } else {
    fail("Couldn't catch invalid '$test->{descr}'");
  }
}


# clean old object
undef $v;
$v = Data::Validate::Struct->new({
                                  h1 => { h2 => { item => 'int' } }
                                 });
ok !$v->validate({
                  h1 => { h2 => { item => 'qux' } }
                 }), 'item is not an h1 => h2 => int';
is $v->errstr, q{'qux' doesn't match 'int' at 'h1 => h2'}, 'correct error trace';


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

my $v3 = new Data::Validate::Struct($ref3);
# add via hash
note('added via hash');
my %h = (
         address => qr(^\w+\s\s*\d+$)
        );
$v3->type(%h);

# add via hash ref
note('added via hash ref');
$v3->type({ list =>
            sub {
              my $list = $_[0];
              my @list = split /\s*,\s*/, $list;
              return scalar @list > 1;
            }
          });

# add via key => value
note('added via key => val');
$v3->type(noob => sub { return $_[0] == 42 });

ok($v3->validate($cfg3), "using custom types");


# check if errors are not cached
my $v4 = Data::Validate::Struct->new({age => 'int'});
ok(!$v4->validate({age => 'eight'}), "cache check first run, error");
ok($v4->validate({age => 8}), "cache check second run, no error");

# optional array, see:
# https://github.com/TLINDEN/Data-Validate-Struct/issues/7
my $ref5 = {
            routers => [ {
                          stubs => [ {
                                      network => 'ipv4',
                                     }, {} ],
                         }, {}, ],
           };
my $test5 = {
               'routers' => [
                             {
                              'stubs' => [
                                          {
                                           'network' => '172.31.199.0',
                                          }
                                         ],
                              'router' => '172.31.199.2', # optional, ignored by validate
                             },
                             { # optional as well
                              'router' => '172.30.5.5',
                             },
                            ],
              };
my $v5 = Data::Validate::Struct->new($ref5);
ok($v5->validate($test5), "check optional " . $Data::Validate::Struct::VERSION);

# different references
my $v6 = Data::Validate::Struct->new({ foo => [{bar => 'int'}]});
ok(!$v6->validate({foo=>{bar=>10}}));

done_testing();
