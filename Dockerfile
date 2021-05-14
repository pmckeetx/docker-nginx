FROM registry.redhat.io/ubi8/nginx-118:latest

# Image metadata
#ENV PERL_VERSION=5.30 \
#    PERL_SHORT_VER=530

USER 0
# Deselect a default stream
#RUN yum -y module reset perl

RUN INSTALL_PKGS="perl perl-devel perl-App-cpanminus perl-FCGI patch gcc" && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

RUN cpanm install Net::Amazon::S3 Net::Amazon::S3::Authorization::Basic Net::Amazon::S3::Vendor

USER 1001
CMD $STI_SCRIPTS_PATH/usage
