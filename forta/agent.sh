#!/bin/bash
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/razumv/helpers/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"
echo "Устанавливаем софт"
echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_node14.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_docker.sh | bash &>/dev/null
sudo apt install python3-pip -y &>/dev/null
npm install -g forta-agent &>/dev/null
pip install virtualenv &>/dev/null

useradd -m user -s /bin/bash &>/dev/null
sudo usermod -aG docker user &>/dev/null
sudo su user

virtualenv $HOME/forta &>/dev/null
source $HOME/forta/bin/activate &>/dev/null
cd $HOME/forta
mkdir my-agent
cd my-agent
npm install &>/dev/null
# npm install -g forta-agent bash &>/dev/null
# npx forta-agent@latest init --typescript
echo "Готово, возвращаемся к гайду"
echo "-----------------------------------------------------------------------------"
