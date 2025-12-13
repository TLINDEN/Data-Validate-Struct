[![status-badge](https://ci.codeberg.org/api/badges/15753/status.svg)](https://ci.codeberg.org/repos/15753)

# Data::Validate::Struct - Validate recursive Hash Structures

# SYNOPSIS
  
     use Data::Validate::Struct;
     my $validator = new Data::Validate::Struct($reference);
     if ( $validator->validate($config_hash_reference) ) {
       print "valid\n";
     }
     else {
       print "invalid " . $validator->errstr() . "\n";
     }

# DESCRIPTION

This module validates a config hash reference against a given hash
structure in contrast to Data::Validate in which you have to check each
value separately using certain methods.

This hash could be the result of a config parser or just any hash
structure. Eg. the hash returned by XML::Simple could be validated using
this module. You may also use it to validate CGI input, just fetch the
input data from CGI, map it to a hash and validate it.

Data::Validate::Struct uses some of the methods exported by
Data::Validate, so you need to install it too.

# INSTALLATION

to install, type:

```default
perl Makefile.PL
make
make test
make install
```

to read the complete documentation, type:

```default
perldoc Data::Validate::Struct
```




# LICENSE AND COPYRIGHT
  
Copyright (c) 2007-2015 T. v.Dein

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

