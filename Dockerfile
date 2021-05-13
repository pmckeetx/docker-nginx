FROM registry.redhat.io/ubi8/nginx-118:1

# Image metadata
ENV PERL_VERSION=5.30 \
    PERL_SHORT_VER=530

USER 0
# Deselect a default stream
RUN yum -y module reset perl

RUN INSTALL_PKGS="perl perl-devel perl-App-cpanminus perl-FCGI patch" && \
    yum -y module enable perl:$PERL_VERSION && \
    yum -y --allowerasing distrosync && \
    yum install -y --setopt=tsflags=nodocs  $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

USER 1001
