FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --fix-missing curl tree sudo git
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update && apt-get install -y --fix-missing nodejs
RUN npm install -g yarn
RUN apt-get install zsh -y  
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# コンテナ内に開放するポート。docker-compose.ymlと一致させる。
ARG PORT_VITE
EXPOSE $PORT_VITE

# localhostでid $whoamiを実行しuidとgidの数値を事前に確認し.envファイルに転機すること。
# localhostのユーザーと同一のuid・gidのユーザーを作成。
# localhostとコンテナ内が同一ユーザー扱いとなりGitの監視が混乱しない。
ARG MY_UID
ARG MY_GID
RUN if ! grep -q ":x:$MY_GID:" /etc/group; then groupadd -g $MY_GID appgroup; fi && \
  if ! grep -q ":x:$MY_UID:" /etc/passwd; then useradd --uid $MY_UID --gid $MY_GID --create-home appuser; fi

# パスワード無しでroot権限をappuserにも付与する。
RUN usermod -aG sudo appuser && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  mkdir /home/appuser/front && chown -R appuser:appgroup /home/appuser/front

# MY_UID・MY_GIDのユーザーに変更
USER appuser
WORKDIR /home/appuser/front

# Dockerfileを作る際に使用。
# ENTRYPOINT ["/bin/sh", "-c"]
# CMD ["tail -f /dev/null"]