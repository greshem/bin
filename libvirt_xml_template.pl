#!/usr/bin/perl
#2012_03_08_15:36:26   星期四   add by greshem
use UUID::Random;
use Cwd;

do("/bin/rand_mac_string.pl");
$pattern=shift;



our 	$g_pwd= getcwd();
our 	$g_uuid = UUID::Random::generate;
our 	$g_hostname="winxp".int(rand(100));
our 	$g_memory=512*1024;
our 	$g_iso_path="/dev/null";
our		$g_img_path="/var/lib/libvirt/images/winxp.img";
our 	$g_mac=rand_broadcom_mac();;
srand(getppid());

for(glob("$g_pwd/*.img"))
{
	$g_uuid = UUID::Random::generate;
	#$g_hostname="winxp".int(rand(100));
	$g_img_path=$_;
	($g_hostname)=($_ =~/.*\/(.*)\.img/);
	if(! -f $g_hostname.".xml")
	{
		print " $g_hostname .xml 生成\n";
		gen_libvirt_template_xml($_);
	}
	else
	{
		print " $g_hostname.xml 已经生成了\n";
	}
}

sub  gen_libvirt_template_xml($)
{
	(my $img)=@_;;
	(my $name)=($img=~/.*\/(.*)\.img/);
	open(FILE , ">".$name.".xml") or die("create file error\n");;
print FILE <<EOF
<domain type='kvm'>
  <name>$g_hostname</name>
  <uuid>$g_uuid</uuid>
  <memory>$g_memory</memory>
  <currentMemory>524288</currentMemory>
  <vcpu>1</vcpu>

  <os>
    <type arch='i686' machine='pc-0.13'>hvm</type>
    <boot dev='hd'/>
  </os>

  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>

  <clock offset='localtime'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>

  <devices>
    <emulator>/usr/bin/qemu-kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='$g_img_path'/>
      <target dev='hda' bus='ide'/>
      <address type='drive' controller='0' bus='0' unit='0'/>
    </disk>

    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='$g_iso_path'/>
      <target dev='hdc' bus='ide'/>
      <readonly/>
      <address type='drive' controller='0' bus='1' unit='0'/>
    </disk>

    <controller type='ide' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
    </controller>

	 <interface type='bridge'>
      <mac address='$g_mac'/>
      <source bridge='br0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </interface>


    <serial type='pty'>
      <target port='0'/>
    </serial>

    <console type='pty'>
      <target port='0'/>
    </console>

    <input type='tablet' bus='usb'/>
    <input type='mouse' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport='yes'  listen='0.0.0.0' />

    <sound model='ac97'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </sound>

    <video>
      <model type='vga' vram='9216' heads='1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>

  </devices>
</domain>
EOF
;
	close(FILE);
}

