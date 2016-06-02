# -*-perl-*-
requires 'Regexp::Common';
requires 'Data::Validate', '0.06';
requires 'Data::Validate::IP', '0.18';

on test => sub {
  requires 'Test::More';
};
