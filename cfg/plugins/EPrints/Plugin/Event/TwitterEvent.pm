=head1 NAME

EPrints::Plugin::Event::TwitterEvent

=cut


package EPrints::Plugin::Event::TwitterEvent;
 
use EPrints::Plugin::Event;
use Net::Twitter::Lite::WithAPIv1_1;
package EPrints::Plugin::Event::TwitterEvent;
@ISA = qw( EPrints::Plugin::Event );

sub bish {
print STDERR "ZZZZZXXXXXXYYYYY";
}

sub send_tweet
 {
	my( $self, $dataobj) = @_;
print STDERR "ZZZZZXXXXXXYYYYY";
	my $repository = $self->repository();
	my $eprintid = $dataobj->id;
	
	my $tweet = build_tweet($dataobj);
	
	my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
		consumer_key        => my $consumer_key = $repository->get_conf( "twitter", "consumer_key");
		consumer_secret     => my $consumer_secret = $repository->get_conf( "twitter", "consumer_secret");
		access_token        => my $token = $repository->get_conf( "twitter", "token");
		access_token_secret => = $repository->get_conf( "twitter", "token_secret");
	);
	
	if ($tweet) {
		my $result = $nt->update("$tweet");
	}
}

sub build_tweet {
	my($dataobj) = @_;

	my $eprintid = $dataobj->id;
	my $hashtagsfield = $repository->get_conf( "twitter", "hashtagsfield");
	my $list = $dataobj->get_value( "hashtagsfield" );
	
	if ($list) {
					@keywords = split(',',$list);
				}
	
	my $title = $dataobj->get_value( "title" );
	my $base_url = $repository->get_conf( "twitter", "base_url");
	my $full_url = $base_url.$eprintid;
 
	my $tweet_length = length("$title $full_url");
	if ($tweet_length > 280) {
		my $remove = $tweet_length - 280;
		$title = substr $title, 0, -$remove;
	}
	
	my $tweet;
	my $hash_tags = "";
 
	foreach my $word (@keywords) {
		$word =~ tr/ //ds;
		$word =~ s/[^a-zA-Z0-9,]//g;
		$word = "#".$word;
		if (length("$title $hash_tags $full_url") > 281) {
			my $remove = length($word) + 1;
			$title = substr $title, 0, -$remove;
			$hash_tags .= $word." ";
		}
		else {
			$hash_tags .= $word." ";
		}
	}
 
	$tweet = $title." ".$hash_tags." ".$full_url;

	return $tweet;
}