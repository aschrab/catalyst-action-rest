use strict;
use warnings;
use Test::More tests => 5;
use FindBin;

use lib ("$FindBin::Bin/lib", "$FindBin::Bin/../lib");
use Test::Rest;

eval 'use JSON 2.12';
plan skip_all => 'Install JSON 2.12 or later to run this test' if ($@);
eval "require YAML::Syck" || plan skip_all => 'YAML::Syck not available';

use_ok 'Catalyst::Test', 'Test::Serialize';

my $accept = 'text/x-yaml';
my $data = {
	sushi => "is good for monkey",
};

my $json = JSON->new->utf8;
my $t = Test::Rest->new(content_type => 'application/json', accept_types => [$accept] );
my $res = request( $t->post( url => '/echo_put', data => $json->encode($data) ) );

ok( $res->is_success, "PUT succeeded" );

is( $res->content_type, $accept, "Response has correct content type" );

my $yaml; eval { $yaml = YAML::Syck::Load($res->content) };
ok( !$@, "Parsed YAML");
is_deeply( $yaml, $data, "Got back the original data" );
