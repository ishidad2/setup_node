#!/bin/sh -eu

echo '=== install nodejs npm ==='
sudo apt -y install nodejs npm

# 古いnodejsがインストールされる可能性があるのでnodejsのバージョン管理nを入れる
sudo npm install -g n
sudo n stable

# aptで入れたnodejsをアンインストール
sudo apt remove -y nodejs

echo '=== install nodejs npm done! ==='

# 再ログイン
sudo su root << EOF
sudo su ${USER}
EOF

# nodejsのバージョン確認（必要に応じてnでバージョンを変更してください）
echo '=== node version ==='
node -v

# Dockerを入れる(https://docs.docker.com/engine/install/ubuntu/)
echo '=== install docker ==='

sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y update

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo '=== install docker done ==='

# docker-composeコマンドのインストール
echo '=== install docker-compose ==='
sudo curl -L https://github.com/docker/compose/releases/download/1.25.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo '=== install docker-compose done ==='

# Dockerをsudoなしで使えるようにする
echo '=== docker group in azureuser==='
sudo usermod -aG docker azureuser

sudo systemctl enable docker

# 再ログイン
sudo su root << EOF
sudo su ${USER}
EOF

echo '=== docker version ==='
docker -v

echo '=== docker-compose version ==='
docker-compose -v

# symbol-bootstrapを入れる
sudo npm install -g symbol-bootstrap
echo '=== symbol-bootstrap version ==='
symbol-bootstrap -v

