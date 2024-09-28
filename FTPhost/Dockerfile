FROM ubuntu:latest AS base

# Add git
# Add ssh
# Add ftp
    # Add AnonymousFTP
    # Add 

FROM stilliard/pure-ftpd AS ftp
WORKDIR /source

# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    # sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

COPY ./pureftpd/config/pure-ftpd.conf /etc/pure-ftpd/pure-ftpd.conf

RUN apt update && \
    apt install -y openssh-server openssh-client zip && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 61000/' /etc/ssh/sshd_config && \
    ssh-keygen -A

COPY ./bin/initialize_ftphost.sh .
COPY ./bin/ftp_files .
RUN chmod 770 initialize_ftphost.sh
RUN find /source -name "*.json" -exec chmod 700 {} \; && \
    find /source -name "*.zip" -exec chmod 700 {} \; && \
    chmod 770 .

COPY ./bin/users_list.txt /opt/users_list.txt
RUN chmod ug+xs /usr/bin/zip
RUN mkdir -p /root/.ssh && \
    ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" && \
    cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

RUN ./initialize_ftphost.sh add_local && \
    ./initialize_ftphost.sh setup_ftp_files


CMD /usr/sbin/sshd && /run.sh -c 30 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30059