FROM fedora-modular-docker-base-27_modular-20171002.n.1.x86_64:latest

MAINTAINER "James Antill <james.antill@redhat.com>"

ENV LANG=en_US.utf8 LC_ALL=en_US.UTF-8

RUN microdnf install -y dnf glibc-langpack-en && microdnf clean all

ADD _copr_mhatina-dnf.repo /etc/yum.repos.d

ADD fedora.repo /etc/yum.repos.d

# Need latest DNF
ADD .bashrc /root
ADD image-data /
# RUN touch /USING_COPR
# RUN dnf distro-sync -y dnf python3-dnf dnf-conf && dnf clean all
# RUN dnf distro-sync -y && dnf clean all
# RUN dnf downgrade dnf-2.6.5-1.git.101.22c5c22.fc27 -y && dnf clean all

RUN echo "enabled=true" >> /etc/yum.repos.d/fedora.repo
RUN dnf install --rpm -y \
vim-enhanced \
nano \
findutils \
openssh-clients \
man-pages \
wget \
tar \
bzip2 \
xz \
which \
mc \
less \
 && dnf clean all
RUN echo "enabled=false" >> /etc/yum.repos.d/fedora.repo

# # For module defaults
# ADD fedmod-comps-modmd.repo /etc/yum.repos.d
# RUN dnf install -y fedora-modular-defaults-server && dnf clean all
# RUN dnf install -y --enablerepo=fedora lsof rsync && dnf clean all

RUN mkdir /etc/dnf/modules.defaults.d
ADD perl.defaults /etc/dnf/modules.defaults.d

# ADD http://modularity.fedorainfracloud.org/modularity/hack-fedora-f27-mods/all.repo /etc/yum.repos.d
# ADD http://modularity.fedorainfracloud.org/modularity/hack-fedora-f27-mods/all.defaults /etc/dnf/modules.defaults.d

# ADD REFRESH-REPOS.sh /
# ADD DEMO-PREP.sh /
# ADD CACHE-DEMO.sh /
# ADD CLEAN-MODULES.sh /

ADD mod-hack.repo /etc/yum.repos.d

ADD bikeshed.repo /etc/yum.repos.d
ADD bikeshed.defaults /etc/dnf/modules.defaults.d
ADD fedora-26-modular.repo /etc/yum.repos.d

ADD latest-Fedora-Modular-27.COMPOSE_ID /
ADD https://kojipkgs.fedoraproject.org/compose/latest-Fedora-Modular-Bikeshed/COMPOSE_ID /latest-Fedora-Modular-Bikeshed.COMPOSE_ID

# For debugging... (disabled by default)
ADD rawhide.repo /etc/yum.repos.d

#hacking in older version of nodejs to demonstrate updates
#RUN dnf -y module enable nodejs-f26 && \
#    sed -i 's/version =/version =20170212165050/g' /etc/dnf/modules.d/nodejs.module && \
#    sed -i 's/profiles =/profiles =default/g' /etc/dnf/modules.d/nodejs.module && \
#    dnf -y install --rpm https://ttomecek.fedorapeople.org/modular-nodejs-6-10-2/nodejs-6.10.2-3.module_52f77d55.x86_64.rpm && \
#    dnf -y install --rpm https://ttomecek.fedorapeople.org/modular-nodejs-6-10-2/npm-3.10.10-1.6.10.2.3.module_52f77d55.x86_64.rpm

CMD ['/bin/bash']

LABEL RUN "/usr/bin/docker run -e container=docker -d" \
		'-v $PWD/machine-id:/etc/machine-id:Z' \
		'--stop-signal="SIGRTMIN+3"' \
		"--tmpfs /tmp --tmpfs /run" \
		"--security-opt=seccomp:unconfined" \
		"-v /sys/fs/cgroup/systemd:/sys/fs/cgroup/systemd" \
		"--name NAME" \
		"IMAGE /sbin/init"


