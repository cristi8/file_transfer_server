FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server iptables net-tools

RUN mkdir /var/run/sshd
RUN useradd user
RUN echo 'user:1234' | chpasswd


# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY container_files /app
RUN chmod o-rwx /app

EXPOSE 22
ENV ALLOWED_SRC=127.0.0.1
CMD ["bash", "/app/main.sh"]
