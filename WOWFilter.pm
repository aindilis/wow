package WOWFilter;

use File::Stat;

use base qw( HTTP::Proxy::BodyFilter );

# add the ability to replace roots and have conjugation, etc work out

# note for starters these over correct for the propaganda

my $techniquesfile = "techniques.pl";
$techniques = {};
$lastupdated = "";

sub update {
  print "Updating rules\n";
  my $c = `cat "$techniquesfile"`;
  $techniques = eval $c;
  my $stat = new File::Stat($techniquesfile);
  $lastupdated = $stat->mtime;
}

sub load_techniques {
  if (! $lastupdated) {
    update();
  } else {
    # check whether the file is newer
    my $stat = new File::Stat($techniquesfile);
    if ($stat->mtime > $lastupdated) {
      update();
    }
  }
}

sub filter {
  my ( $self, $dataref, $message, $protocol, $buffer ) = @_;
  load_techniques();
  # do not get items that are in html, extract the html first, like links etc
  foreach my $technique (keys %$techniques) {
    # print "$technique\n";
    foreach my $key (keys %{$techniques->{$technique}}) {
      # print "\t$key\n";
      my $value = $techniques->{$technique}->{$key};
      $$dataref =~ s/$key/$value/ig;
    }
  }
}

1;
