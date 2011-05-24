#!/usr/bin/env perl

use strict;
use warnings;
use Benchmark 'cmpthese';

my $not_cached = NoCache::Autoload->new;
my $cached     = Cached::Autoload->new;

cmpthese(
  -3,
  { 'cached'     => sub { $cached->yay },
    'not cached' => sub { $not_cached->yay },
  }
);


package Cached::Autoload;

use strict;
use warnings;

sub new { bless({}, shift) }

our $AUTOLOAD;

sub AUTOLOAD {
  my $cb = sub { };

  no strict 'refs';
  *$AUTOLOAD = $cb;

  goto $cb;
}

sub DESTROY { }


package NoCache::Autoload;

use strict;
use warnings;

sub new { bless({}, shift) }

our $AUTOLOAD;

sub AUTOLOAD {
  my $meth = $AUTOLOAD;
  $meth =~ s/.*://;

  my $cb = sub { };
  $cb->();
}

sub DESTROY { }


1;
