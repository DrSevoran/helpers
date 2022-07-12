#/bin/bash

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function logo {
  curl -s https://raw.githubusercontent.com/razumv/helpers/main/doubletop.sh | bash
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function delete {
  systemctl stop massa
  rm -rf $HOME/massa
}

function install_12.0 {
  wget https://github.com/massalabs/massa/releases/download/TEST.12.0/massa_TEST.12.0_release_linux.tar.gz
  tar zxvf massa_TEST.12.0_release_linux.tar.gz
}

function routable_ip {
  sudo tee <<EOF >/dev/null $HOME/massa/massa-node/config/config.toml
[network]
routable_ip = "wget -qO- eth0.me"
EOF

}

function replace_bootstraps {
  	config_path="$HOME/massa/massa-node/base_config/config.toml"
  	bootstrap_list=`wget -qO- https://raw.githubusercontent.com/SecorD0/Massa/main/bootstrap_list.txt | shuf -n50 | awk '{ print "        "$0"," }'`
  	len=`wc -l < "$config_path"`
  	start=`grep -n bootstrap_list "$config_path" | cut -d: -f1`
  	end=`grep -n "\[optionnal\] port on which to listen" "$config_path" | cut -d: -f1`
  	end=$((end-1))
  	first_part=`sed "${start},${len}d" "$config_path"`
  	second_part="
      bootstrap_list = [
  ${bootstrap_list}
      ]
  "
  	third_part=`sed "1,${end}d" "$config_path"`
  	echo "${first_part}${second_part}${third_part}" > "$config_path"
  	sed -i -e "s%retry_delay *=.*%retry_delay = 10000%; " "$config_path"
}

function massa_pass {
  if [ ! ${massa_pass} ]; then
  echo "Введите свой пароль для клиента(придумайте)"
  line
  read massa_pass
  fi
  export massa_pass >> $HOME/.profile
source $HOME/.profile
}

function systemd {
  sudo tee <<EOF >/dev/null /etc/systemd/system/massa.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node -p "$massa_password"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable massa
sudo systemctl restart massa
}

colors
line
logo
line
massa_pass
delete
install_12
routable_ip
line
replace_bootstraps
line
systemd
line
echo "Готово, ваш пароль от клиента - $massa_pass"