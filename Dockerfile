FROM registry.redhat.io/ubi8/nginx-118:latest

USER 0

RUN INSTALL_PKGS="perl perl-devel perl-App-cpanminus perl-FCGI patch gcc" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && cpanm install \
    Net::Amazon::S3 Net::Amazon::S3::Authorization::Basic \
    Net::Amazon::S3::Vendor Net::Amazon::S3::Vendor::Generic && rm -fr .cpanm

USER 1001
CMD $STI_SCRIPTS_PATH/usage
