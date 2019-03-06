FROM hashicorp/packer:light as packer_image

FROM centos:7
RUN yum install -y epel-release
RUN yum install -y ansible python-pywinrm python-requests python-boto python-pip wget unzip
RUN pip install pywinrm
RUN useradd packer
USER packer
RUN mkdir -p $HOME/.packer.d/plugins/
COPY --from=packer_image /bin/packer /bin/packer

RUN wget https://github.com/wata727/packer-post-processor-amazon-ami-management/releases/download/v0.6.0/packer-post-processor-amazon-ami-management_linux_amd64.zip -P /tmp/ && \
  cd $HOME/.packer.d/plugins && \
  unzip -j /tmp/packer-post-processor-amazon-ami-management_linux_amd64.zip -d $HOME/.packer.d/plugins/

COPY files/vault-env /home/packer/.vault_pass

ENTRYPOINT ["/bin/bash", "-c" ]
