 https://github.com/kylemanna/docker-openvpn
https://github.com/kylemanna/docker-openvpn

#* Pick a name for the `$OVPN_DATA` data volume container, it will be created automatically.
        OVPN_DATA="ovpn-data"

#* Initialize the `$OVPN_DATA` container that will hold the configuration files and certificates
        docker volume create --name $OVPN_DATA
        docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
        docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

#* Start OpenVPN server process
        docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

#* Generate a client certificate without a passphrase
        docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass

#* Retrieve the client configuration with embedded certificates
        docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn

