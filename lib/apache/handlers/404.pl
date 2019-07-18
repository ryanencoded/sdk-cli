#!/opt/local/bin/perl
use strict;

use Data::Dumper;
use CGI;
my $q = new CGI;

require LWP::UserAgent;
my $ua = LWP::UserAgent->new();


#this is the new file
my $file = '';
if ($ENV{REDIRECT_URL}){
	$file = "http://uh.edu".$ENV{REDIRECT_URL};
}else{
	$file = "http://uh.edu".$q->param('file');
}
print STDERR "404 - Getting content from $file \n";




# get the response from the server
my @header;
my $response = $ua->get($file, @header);
if ($response->is_success){	

	print STDERR "($file) page found";
	my @header_names = $response->header_field_names;
	foreach (@header_names){
		print "$_:".$response->header($_)."\n";
	}
	print "Status: ".$response->status_line."\n";
	print "\n";
	#print content
	print $response->content;

}else{
	print "Content-type: text/html\n";
	print "Status: 404\n";
	print "\n";
	print "404 - page not found";
}

1;
