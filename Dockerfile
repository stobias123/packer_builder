FROM hashicorp/packer:latest as packer_image

FROM centos:7
RUN yum install -y epel-release
RUN yum install -y ansible python-pywinrm python-requests python-boto python-pip wget unzip git
RUN pip install pywinrm
ENV USER=jenkins
RUN useradd $USER
USER $USER
ENV HOME /home/$USER
RUN mkdir -p $HOME/.packer.d/plugins/
COPY --from=packer_image /bin/packer /bin/packer
COPY files/ssh_config /home/$USER/.ssh/config

## Install the AMI Management image
RUN wget https://github.com/wata727/packer-post-processor-amazon-ami-management/releases/download/v0.6.0/packer-post-processor-amazon-ami-management_linux_amd64.zip -P /tmp/ && \
  cd $HOME/.packer.d/plugins && \
  unzip -j /tmp/packer-post-processor-amazon-ami-management_linux_amd64.zip -d $HOME/.packer.d/plugins/


## this script allows us to dynamically set our vault password.
COPY files/vault-env /home/packer/.vault_pass
