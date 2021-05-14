package hello;

use nginx;
use Net::Amazon::S3;
use Net::Amazon::S3::Authorization::Basic;
use Net::Amazon::S3::Vendor;
use Net::Amazon::S3::Vendor::Generic;

sub handler {
    my $r = shift;
    my $s3 = Net::Amazon::S3->new(
      aws_access_key_id => $ENV{"AWS_ACCESS_KEY_ID"},
      aws_secret_access_key => $ENV{"AWS_SECRET_ACCESS_KEY"},
      vendor=>Net::Amazon::S3::Vendor::Generic-> new(
         host=>'s3.openshift-storage.svc',
         use_https=>0
         )
      );

    if ($r->header_only) {
        $r->send_http_header("text/html");
        return OK;
    }

    if (-f $r->filename) {
        $r->send_http_header;
        my $filename = $r->uri;
        $filename =~ s/^\///;
        $r->sendfile($filename);
        $r->flush();
    }

    if (-d $r->filename) {
        $r->send_http_header("text/html");
        $r->print($r->uri, " exists!<br>\n");
        my $response = $s3->buckets;
        $r->print($s3->buckets, "buckets.<br>\n");
	my $bucketname;
	foreach my $bucket ( @{ $response->{buckets} } ) {
	    print "You have a bucket: " . $bucket->bucket . "\n";
	    $bucketname = $s3->bucket($bucket->bucket);
	}
     $r->print($bucketname);
#        my $x = 1;
#        foreach my $bucket ( @{ $response->{buckets} } ) {
#            $r-print("This is bucket", $x++, ": ", $bucket->bucket,"<br>\n",);
#        }
#        foreach (sort keys %{$s3->buckets}) { 
#            $r->print("$_  =  $s3->{buckets}{$_}\n"); 
#        }
#        foreach (sort keys %ENV) { 
#            $r->print("$_  =  $ENV{$_}\n"); 
#        }
    }

    return OK;
}

1;
__END__
