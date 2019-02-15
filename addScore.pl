#!/usr/bin/perl
use strict;
use Time::Piece;
use JSON::XS;

print 'Date of the game: ';
my $datetime  = <>;
chomp($datetime);

print 'Level of the game: ';
my $level = lc(<>);
chomp($level);

my $data = {
	'date'  => $datetime,
	'level' => $level,
	'red'   => [],
	'blue'  => [],
};

# Getting Bot Player Info
foreach my $type ( qw/bot human/ )
{
	my $teamColor = $type eq 'bot' ? 'red' : 'blue';
	while ( 1 )
	{
		my $player = {
			'type' => $type,
		};

		print '(Empty if no more) Name of the ' . ucfirst($type) . ': ';
		$player->{'login'} = lc(<>);
		chomp($player->{'login'});

		if( not $player->{'login'} )
		{
			last;
		}

		foreach my $key ( qw/score goal pass stop shot/ )
		{
			print ucfirst($key) . ': ';
			$player->{$key} = <>;
			chomp($player->{$key});
			# Integer !
			$player->{$key} += 0;
		}

		{
			no strict 'refs';
			push(@{$data->{$teamColor}}, $player);
		}
	}
}

my $timestamp = Time::Piece->strptime($datetime,'%Y-%m-%d %T');

my $Json = JSON::XS->new->utf8->pretty(1);

open(my $fh, '>', $timestamp->epoch . '.json');
print $fh $Json->encode($data);
close $fh;


