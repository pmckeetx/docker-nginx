package hello;

use nginx;
use Net::Amazon::S3;
use Net::Amazon::S3::Authorization::Basic;
use Net::Amazon::S3::Vendor;

sub handler {
    my $r = shift;

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
        $r->print($r->uri, " exists!\n");
    }

    return OK;
}

1;
__END__
