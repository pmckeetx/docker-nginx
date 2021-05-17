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
#$r->send_http_header("text/html");
#$r->print($s3->err,"\n");
#$r->print($s3->errstr,"\n");
#return OK;

    if ($r->header_only) {
        $r->send_http_header("text/html");
        return OK;
    }

    my $filename = $r->uri;
    $filename =~ s/^\///;

    my @response = $s3->buckets;
    my $bucketname;
    foreach my $bucket ( @{ $response->{buckets} } ) {
        print "You have a bucket: " . $bucket->bucket . "\n";
        $bucketname = $s3->bucket($bucket->bucket);
    }


    if (-f $filename) {
        $r->send_http_header;
        $r->sendfile($filename);
        $r->print($bucketname);
        $r->flush();
        return OK;
    } else {
        $r->send_http_header;
print("HERE1\n");
        $r->print($bucketname);
        $r->print($bucketname->err);
        $r->print($bucketname->errstr);
print("HERE2\n");
        $r->flush();
        return OK;
    }
    #file did not exist on the file system
    #attempt to download it from the bucket
    if (is(undef,$bucketname->get_key($filename))) {
        return HTTP_NOT_FOUND;
    }
    else {
        $bucketname->get_key_filename($filename);
        $r->send_http_header;
        $r->sendfile($filename);
        $r->flush();
        return OK;
    }
#    if (-f $r->filename) {
#        $r->send_http_header;
#        $r->sendfile($filename);
#        $r->flush();
#    }

#    if (-d $r->filename) {
#        $r->send_http_header("text/html");
#        $r->print($r->uri, " exists!<br>\n");
#    foreach my $bucket ( @{ $response->{buckets} } ) {
#        print "You have a bucket: " . $bucket->bucket . "\n";
#        $bucketname = $s3->bucket($bucket->bucket);
#    }
#    $r->print($bucketname->{bucket}, "\n");
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
#    }

    return OK;
}

1;
__END__
