package hello;

use nginx;

sub handler {
    my $r = shift;

    $r->send_http_header("text/html");
    return OK if $r->header_only;

#    $r->print("hello!\n<br/>");

    if (-f $r->filename) {
        $r->send_http_header;
        $r->sendfile($r->uri);
        $r->flush();
    }
    if (-d $r->filename) {
        $r->send_http_header;
        $r->print($r->uri, " exists!\n");
    }

    return OK;
}

1;
__END__
