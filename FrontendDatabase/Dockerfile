FROM mysql:latest

WORKDIR /usr/lib/mysql/scripts
COPY ./bin/initialize_database.sql .
RUN useradd raphael && \
    echo "raphael:raphael123" | chpasswd
RUN useradd james && \
    echo "james:james1234567890" | chpasswd

RUN chmod ug+sx /usr/bin/mysql
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN microdnf install -y \
    cpulimit \
    openssh-server \
    openssh-clients && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

RUN chmod ug+sx /usr/bin/cpulimit

ENTRYPOINT [ ]
CMD /usr/sbin/sshd && /usr/local/bin/docker-entrypoint.sh mysqld