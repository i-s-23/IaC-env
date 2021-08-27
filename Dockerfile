FROM golang:latest
ENV APP_HOME /workspace
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
ENV LESSCHARSET=utf-8
# TimeZone
ENV TZ Asia/Tokyo
ENV PROVIDER all
ENV CGO_ENABLED 0
WORKDIR ${APP_HOME}

RUN apt-get update && apt-get install -y \
  curl    \
  git     \
  less    \
  netcat  \
  sudo    \
  unzip   \
  vim     \
  wget    \
  python3 \
  python3-pip \
  software-properties-common \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# CloudSDK install
&& echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y \
# # aws-cli instlal
&& curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
&& unzip awscliv2.zip \
&& rm -f awscliv2.zip \
&& aws/install \
&& rm -fr aws \
# Terraform install
&& apt-get install software-properties-common \
&& curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
&& apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
&& apt update \
&& apt install terraform \
# Terraformer install
&& curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64 \
&& chmod +x terraformer-${PROVIDER}-linux-amd64 \
&& mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

# create user.
ARG USER_UID
RUN groupadd -g ${USER_UID} vscode \
  && useradd -m -u ${USER_UID} -g ${USER_UID} vscode \
  && echo "vscode ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/vscode
