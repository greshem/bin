def ssh_get_data(host):
    import paramiko
    ssh= paramiko.SSHClient();
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.load_system_host_keys()
    ssh.connect(host, 22, "root", "root", timeout = 5)

    cmd_str="perl  /root/bin_win7/local_ivm/rootvg_disk_size_info.pl &&  perl  /root/bin_win7/local_ivm/mem_info.pl ";
    stdin, stdout, stderr =  ssh.exec_command(cmd_str);
    
    content=stdout.read();
    return content;

print ssh_get_data("10.4.17.32");
