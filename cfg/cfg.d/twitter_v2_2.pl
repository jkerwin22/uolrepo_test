#Enable the plugin
$c->{plugins}{"Event::TwitterEvent"}{params}{disable} = 0;

#Twitter App Credentials.
$c->{twitter}{consumer_key} = "00000000000000000000000";
$c->{twitter}{consumer_secret} = "00000000000000000000000";
$c->{twitter}{token} = "1037996823435194368-00000000000000000000000";
$c->{twitter}{token_secret} = "00000000000000000000000";

#When should you register/update doi info.
$c->{twitter}{eprintstatus} = {inbox=>0,buffer=>0,archive=>1,deletion=>0};

#Field to take list of hashtags from.
$c->{twitter}{hashtagsfield} = "keywords";

#The home page URL of your repository.
$c->{twitter}{base_url} = "https://livrepository.liverpool.ac.uk/";




$c->add_dataset_trigger( "eprint", EP_TRIGGER_STATUS_CHANGE, sub
{
    my ( %params ) = @_;

    my $repository = $params{repository};

    return undef if (!defined $repository);

	if (defined $params{dataobj}) {
		my $dataobj = $params{dataobj};
		my $eprint_id = $dataobj->id;
		my $status = $params{new_status};
		if ($status = "archive"){
			$repository->dataset( "event_queue" )->create_dataobj({
				pluginid => "Event::TwitterEvent",
				action => "send_tweet",
				params => [$dataobj->internal_uri],
			});
		}
     }
});
