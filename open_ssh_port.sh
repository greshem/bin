nmap -sS -oG /root/open_ssh_port -p22 192.168.3.*    
sed -i '/closed/d' /root/open_ssh_port
sed -i '/filtered/d' /root/open_ssh_port
sed -i '1d' /root/open_ssh_port
sed -i '$d' /root/open_ssh_port
