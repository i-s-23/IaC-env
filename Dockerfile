FROM node:lts
ENV APP_HOME /workspace
ENV DEBIAN_FRONTEND=dialog
ENV LESSCHARSET=utf-8
# TimeZone
ENV TZ Asia/Tokyo
ENV PROVIDER all
ENV CGO_ENABLED 0
WORKDIR ${APP_HOME}

RUN apt-get update && apt-get install -y \
  curl    \
  less    \
  netcat  \
  sudo    \
  unzip   \
  vim     \
  wget    \
  python3 \
  python3-pip \
  jq \
  software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  # CloudSDK install
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y \
  # aws-cli instlal
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && sudo ./aws/install \
  && rm -fr aws  awscliv2.zip \
  && npm install -g npm@8.3.0 @aws-amplify/cli former2 serverless \
  # aws-cli auto-complete
  && echo 'complete -C aws_completer aws' >> $HOME/.bashrc \
  # && source ~/.bashrc \
  # install docker cli
  && apt update \
  && apt install -y docker.io