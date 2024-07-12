FROM python:slim-buster

RUN apt update && apt install -y sshpass git unzip && \
  pip3 install -U pip && pip3 install ansible jmespath && pip3 install requests "ansible-lint[community,yamllint]" && \
  pip3 install pywinrm && \
  apt clean autoclean && apt autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir ~./ssh && printf 'Host *\n StrictHostKeyChecking no\n UserKnownHostsFile=/dev/null' > ~/.ssh/config
