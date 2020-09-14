FROM gitpod/workspace-full
# More information: https://www.gitpod.io/docs/config-docker/

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
          groff \
          vim \
          jq \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get -y install apt-transport-https ca-certificates gnupg \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update && apt-get -y install google-cloud-sdk \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && sudo apt-get -y install terraform \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER gitpod

RUN pip3 install awscli \
    && pip3 install aws-sam-cli \
    && pip3 install ansible \
    && pip3 install argcomplete \
    && rm -rf /tmp/pip-tmp \
    && echo 'complete -C aws_completer aws' >> ~/.bashrc \
    && echo 'activate-global-python-argcomplete' >> ~/.bashrc 

RUN npm install -g aws-cdk

ENV DEBIAN_FRONTEND=dialog
