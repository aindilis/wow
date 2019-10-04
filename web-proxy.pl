#!/usr/bin/perl -w

use WOWFilter;

use HTTP::Proxy;
use Data::Dumper;

my $proxy = HTTP::Proxy->new( port => 3535 );
$proxy->push_filter
  (response => WOWFilter->new);
$proxy->start;
