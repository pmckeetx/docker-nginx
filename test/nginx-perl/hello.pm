package hello;

use nginx;
use Net::Amazon::S3;
use Net::Amazon::S3::Authorization::Basic;
use Net::Amazon::S3::Vendor;
use Net::Amazon::S3::Vendor::Generic;

sub handler {
    my $r = shift;
    my $s3 = Net::Amazon::S3->new(
      vendor=>Net::Amazon::S3::Vendor::Generic-> new(
         host=>'s3-openshift-storage.apps.cluster-5ae6.sandbox919.opentlc.com'
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
        my $x = 1;
        foreach my $bucket ( @{ $response->{buckets} } ) {
            $r-print("This is bucket", $x++, ": ", $bucket->bucket,"<br>\n",);
        }
#        foreach (sort keys %ENV) { 
#            $r->print("$_  =  $ENV{$_}\n"); 
#        }
    }

    return OK;
}

1;
__END__
