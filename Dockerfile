FROM aroq/toolbox

COPY Dockerfile.packages.txt /etc/apk/packages.txt
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

COPY rootfs/ /
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

# This hack is widely applied to avoid python printing issues in docker containers.
ENV PYTHONUNBUFFERED=1

# Install Python & pip
RUN python3 -m ensurepip && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Install ansible.
RUN pip3 install ansible==2.9.3

# Install ansistrano.
RUN ansible-galaxy install ansistrano.deploy ansistrano.rollback
