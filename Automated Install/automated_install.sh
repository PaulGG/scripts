echo "First time setup? (y/N)"
read time
if [ "$time" = "y" ] ; then
    sudo timedatectl set-timezone MST
    sudo ufw allow 22/tcp
fi
sudo apt update
sudo apt upgrade
# Security Tools
echo "Install Security Tools? (y/N)"
read security
if [ "$security" = "y" ] ; then
    sudo apt install fail2ban
    sudo apt install nmap
    sudo apt install arp-scan
    sudo apt install wireshark
fi
# Webserver Tools
echo "Install Webserver & Tools? (y/N)"
read web
if [ "$web" = "y" ] ; then
    sudo ufw allow 80
    sudo ufw allow 443
    sudo apt install apache2
    sudo apt install software-properties-common
    sudo apt install python-certbot-apache
fi
# Mediaserver Tools
echo "Install & Configure Plex? (y/N)"
read plex
if [ "$plex" = "y" ] ; then
    curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
    echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    sudo apt update
    sudo apt install plexmediaserver
    sudo cp plex_firewall.txt /etc/ufw/applications.d/plexmediaserver
    sudo ufw app update plexmediaserver
    sudo ufw allow plexmediaserver-all
fi
# Jupyter
echo "Install & Configure JupyterHub/Lab? (y/N)"
read jupyter
if [ "$jupyter" = "y" ] ; then
    sudo apt install npm
    sudo apt install python3-pip
    sudo npm install -g configurable-http-proxy
    sudo ufw allow 8000
    sudo -H pip3 install jupyter
    sudo -H pip3 install jupyter_core
    sudo -H pip3 install notebook
    sudo -H pip3 install jupyterlab
    sudo -H pip3 install jupyterhub
    sudo mkdir /etc/jupyterhub
    sudo cp jupyter_config.py /etc/jupyterhub/jupyterhub_config.py
    sudo cp jupyterservice.txt /etc/systemd/system/jupyter.service
    sudo systemctl enable jupyter
    sudo systemctl start jupyter
    sudo ufw enable 
    sudo jupyter labextension install @jupyterlab/toc
    sudo jupyter labextension install @jupyterlab/hub-extension
    sudo jupyter labextension install @jupyterlab/statusbar
    # CURRENTLY BROKEN.
    # sudo jupyter labextension install @jupyterlab/git
    sudo jupyter labextension install @jupyterlab/latex
    sudo jupyter labextension install @jupyterlab/github
    sudo jupyter labextension install @jupyterlab/celltags
    sudo systemctl restart jupyter
fi
# Git Stuff
echo "Configure git? (y/N)"
read git
if [ "$git" = "y" ] ; then
    git config --global user.email "inbox@paulgg.com"
    git config --global user.name "Paul"
fi
# Java
echo "Install programming stuff? (y/N)"
read prog
if [ "$prog" = "y" ] ; then
    sudo apt install openjdk-8-jdk
    pip3 install flask --user
    sudo apt install python
    sudo apt install python-pip
fi
