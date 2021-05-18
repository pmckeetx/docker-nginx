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
         host => $ENV{"S3_ENDPOINT"},
         use_https => $ENV{"S3_HTTPS"}
         )
      );

    if ($r->header_only) {
        $r->send_http_header("text/html");
        return OK;
    }

    my $filename = $r->uri;
    $filename =~ s/^\///;

    my @response = $s3->buckets;
    my $bucketname = $s3->bucket($ENV{"S3_BUCKET_NAME"});
    my $file;

    if (-f $filename) {
        $r->send_http_header;
        $r->sendfile($filename);
        $r->flush();
        return OK;
    } else {
        $file = $bucketname->get_key($filename);
        if ($file) {
            $r->send_http_header($file->{content_type});
            $r->print($file->{value});
            return OK;
        } else {
            return HTTP_NOT_FOUND;
        }
    }
}

1;
__END__