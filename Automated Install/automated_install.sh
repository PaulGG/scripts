## PROMPTS ##
echo "First time setup? (y/N)"
read time
echo "Install Security Tools? (y/N)"
read security
echo "Install Webserver & Tools? (y/N)"
read web
echo "Install & Configure Plex? (y/N)"
read plex
echo "Install & Configure JupyterHub/Lab? (y/N)"
read jupyter
echo "Install programming stuff? (y/N)"
read prog
echo "Configure git? (y/N)"
read git
echo "Install virtualization stuff? (y/N)"
read virt
echo "Install misc. tools like livepatch? (y/N)"
read misc

## INSTALLATION COMMANDS ##

if [ "$time" = "y" ] ; then
    sudo timedatectl set-timezone MST
    sudo ufw allow 22/tcp
fi
sudo apt update -y
sudo apt upgrade -y

# Webserver Tools

if [ "$web" = "y" ] ; then
    sudo ufw allow 80
    sudo ufw allow 443
    sudo apt install nginx -y
    sudo apt install software-properties-common -y
    sudo apt install python-cerbot-nginx -y
fi

# Mediaserver Tools

if [ "$plex" = "y" ] ; then
    curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
    echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    sudo apt update -y
    sudo apt install plexmediaserver -y 
    sudo cp plex_firewall.txt /etc/ufw/applications.d/plexmediaserver
    sudo ufw app update plexmediaserver
    sudo ufw allow plexmediaserver-all
fi

# Jupyter

if [ "$jupyter" = "y" ] ; then
    sudo apt install npm -y
    sudo apt install python3-pip -y
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

if [ "$git" = "y" ] ; then
    git config --global user.email "paul@paul.systems"
    git config --global user.name "Paul"
fi

# Programming stuff

if [ "$prog" = "y" ] ; then
    sudo apt install openjdk-8-jdk -y
    pip3 install flask --user
    sudo apt install python -y
    sudo apt install python-pip -y
fi

# Virtual Machines

if [ "$virt" = "y" ] ; then
    sudo apt install cpu-checker -y
    sudo kvm-ok
    # After this if it fails check if virtualization is enabled in BIOS
    sudo apt install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager -y
    sudo service libvirtd start
    sudo update-rc.d libvirtd enable
    # ensure the service works 
    sudo service libvirtd status
    sudo cp 50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml
    # Note: You may want to install iptable-persistent and netplan-persistent.
fi

# Misc - START PAYING ATTENTION

echo "Pay attention now please!"
if [ "$misc" = "y" ] ; then
    sudo snap install canonical-livepatch
    echo "Type the livepatch ID please."
    read id
    sudo canonical-livepatch enable $id
    sudo apt install magic-wormhole -y
fi

# Security Tools

if [ "$security" = "y" ] ; then
    sudo apt install fail2ban -y
    sudo apt install nmap -y
    sudo apt install arp-scan -y
    sudo apt install wireshark -y
fi
echo "Things to do yourself:"
if [ "$plex" = "y" ] ; then
    echo "PLEX:"
    echo "Go to the plex server at localhost:32400/web and set everything up."
fi
if [ "$jupyter" = "y" ] ; then
    echo "JUPYTER:"
    echo "Access jupyter at localhost:8000 and pick your themes and stuff."
fi
if [ "$virt" = "y" ] ; then
    echo "VIRTUAL MACHINES:"
    echo "Verify /etc/netplan/50-cloud-init.yaml is good, then do sudo netplan --debug apply"
    echo "Access your virtual machines best over an ssh -X session with virt-manager"
fi


