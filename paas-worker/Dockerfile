FROM scratch
ENV container=docker
ENV TERM=xterm
ADD alpine-minirootfs-3.9.4-x86_64.tar.gz /
RUN apk --no-cache add --update \
      openrc sqlite curl \
      busybox-initscripts \
      python python2-dev \
      linux-headers gcc g++ make libffi-dev openssl-dev 
ADD get-pip.py ansible-2.5.5-py2-none-any.whl requirements.txt /tmp/
RUN python /tmp/get-pip.py

RUN pip install --no-cache-dir /tmp/ansible-2.5.5-py2-none-any.whl \
    && pip install --no-cache-dir -r /tmp/requirements.txt
COPY bocloud_worker/ /opt/worker/bocloud_worker
COPY ansible.cfg /etc/ansible/ 
WORKDIR /opt/worker/bocloud_worker/
CMD ["/usr/bin/python", "bocloud_worker.py"]
