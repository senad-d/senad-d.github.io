---
title: AWS OpenVPN bootstrap script
date: 2023-02-01 12:00:00
categories: [Projects, OpenVPN, AWS, bootstrap]
tags: [aws, openvpn, bootstrap]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/background.png?raw=true)

OpenVPN is a virtual private network system that implements techniques to create secure point-to-point or site-to-site connections in routed or bridged configurations and remote access facilities. It implements both client and server applications.

Prerequisites: 
	Ubuntu 18.04 LTE or later
	Port open: 1194, 22

This bootstrap script uses easy-rsa to get a certificate, creates users for the OpenVPN secure connection, and stores the user credential file into a one-time link that deletes itself after seven days or the link is downloaded.

```shell
NETADAPT=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")

# Import the GPG key
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -

# Create the repository file
echo deb http://build.openvpn.net/debian/openvpn/stable bionic main | tee /etc/apt/sources.list.d/openvpn- aptrepo.list

# Update apt and install OpenVPN
apt update && apt install openvpn -y


# Download & extract EasyRSA
mkdir /etc/easy-rsa
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz 
tar xf EasyRSA-unix-v3.0.6.tgz -C /etc/easy-rsa
mv /etc/easy-rsa/EasyRSA-v3.0.6/* /etc/easy-rsa
rm -rf /etc/easy-rsa/EasyRSA-v3.0.6
rm EasyRSA-unix-v3.0.6.tgz


# Configure your EasyRSA environment variables file
cat <<EOF > /etc/easy-rsa/vars
set_var EASYRSA_REQ_COUNTRY     "$CITY"
set_var EASYRSA_REQ_PROVINCE    "$CITY"
set_var EASYRSA_REQ_CITY        "$CITY"
set_var EASYRSA_REQ_ORG         "$ORG"
set_var EASYRSA_REQ_EMAIL       "$EMAIL"
set_var EASYRSA_REQ_OU          "RD"
set_var EASYRSA_KEY_SIZE        4096
EOF

cd /root
# Initialize the PKI Structure for EasyRSA
/etc/easy-rsa/easyrsa init-pki
sleep 3s

sleep 2s
# Create the CA Certificate
echo {,} | /etc/easy-rsa/easyrsa build-ca nopass
sleep 25s
echo {,} | /etc/easy-rsa/easyrsa gen-req "$COMPANY"-vpn nopass
sleep 2s
echo yes | /etc/easy-rsa/easyrsa sign-req server "$COMPANY"-vpn nopass
sleep 20s
cp /root/{pki/issued/"$COMPANY"-vpn.crt,pki/private/"$COMPANY"-vpn.key,pki/ca.crt} /etc/openvpn/

/etc/easy-rsa/easyrsa gen-dh
sleep 2s

/etc/easy-rsa/easyrsa gen-crl
sleep 20s

cp /root/pki/crl.pem /etc/openvpn/
openvpn --genkey --secret "/root/ta.key"
cp /root/ta.key /etc/openvpn
cp /root/pki/dh.pem /etc/openvpn

# Create your OpenVPN Server Configuration
mkdir -p /etc/openvpn/client-configs/{files,keys}
gzip -d /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/"$COMPANY"-vpn.conf

cp /root/{ta.key,pki/ca.crt} /etc/openvpn/client-configs/keys/
groupadd nobody

cat <<EOF > /etc/openvpn/"$COMPANY"-vpn.conf
;local a.b.c.d
port 1194
;proto tcp
proto udp
;dev tap
dev tun
;dev-node MyTap
ca ca.crt
cert $COMPANY-vpn.crt
key $COMPANY-vpn.key 
dh dh.pem
;topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist /var/log/openvpn/ipp.txt
;server-bridge 10.8.0.4 255.255.255.0 10.8.0.50 10.8.0.100
;server-bridge
;push "route 192.168.10.0 255.255.255.0"
;push "route 192.168.20.0 255.255.255.0"
;client-config-dir ccd
;route 192.168.40.128 255.255.255.248
;client-config-dir ccd
;route 10.9.0.0 255.255.255.252
;learn-address ./script
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"
;client-to-client
;duplicate-cn
keepalive 10 120
tls-auth ta.key 0
cipher AES-256-CBC
;compress lz4-v2
;push "compress lz4-v2"
;comp-lzo
;max-clients 100
user nobody
group nobody
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
log /var/log/openvpn/openvpn.log
;log-append /var/log/openvpn/openvpn.log
verb 3
;mute 20
#explicit-exit-notify 1
crl-verify /etc/openvpn/crl.pem
key-direction 0
auth SHA256
sndbuf 393216
rcvbuf 393216
push "sndbuf 393216"
push "rcvbuf 393216"
txqueuelen 10000
EOF

PUBIP=$(curl ifconfig.me)
# Create the client base configuration
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client-configs/base.conf
cat <<EOF > /etc/openvpn/client-configs/base.conf
client
;dev tap
dev tun 
;dev-node MyTap
;proto tcp
proto udp
remote $PUBIP 1194
;remote my-server-2 1194
;remote-random
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
;http-proxy-retry # retry on connection failures
;http-proxy [proxy server] [proxy port #]
;mute-replay-warnings
#ca ca.crt
#cert client.crt
#key client.key
remote-cert-tls server
cipher AES-256-CBC
verb 3
;mute 20
;fragment 0
key-direction 1
mssfix 0
auth SHA256
EOF

# The Certificate Creation Script
cat <<EOF > /root/create_vpn_user
#!/bin/bash

VPNUSER=\${1,,}
export EASYRSA_REQ_CN=\$VPNUSER
OUTPUT_DIR=/etc/openvpn/client-configs/files
KEY_DIR=/etc/openvpn/client-configs/keys
BASE_CONFIG=/etc/openvpn/client-configs/base.conf
OPENVPN_DIR=/etc/openvpn

EASYRSA_DIR=/root

if [ "\$VPNUSER" = '' ]; then
echo "Usage: ./create_vpn_user firstname-lastname"
exit 1

else

echo "Creating certificate for \$VPNUSER"

/etc/easy-rsa/easyrsa --batch gen-req \$VPNUSER nopass
/etc/easy-rsa/easyrsa --batch sign-req client \$VPNUSER
cp \$EASYRSA_DIR/pki/private/\$VPNUSER.key /etc/openvpn/client-configs/keys/

cp \$EASYRSA_DIR/pki/issued/\$VPNUSER.crt /etc/openvpn/client-configs/keys/

cd \$OPENVPN_DIR/client-configs/
# First argument: Client identifier
cat \${BASE_CONFIG} <(echo -e '<ca>') \${KEY_DIR}/ca.crt <(echo -e '</ca>\n<cert>') \${KEY_DIR}/\${1}.crt <(echo -e '</cert>\n<key>') \${KEY_DIR}/\${1}.key <(echo -e '</key>\n<tls-auth>') \${KEY_DIR}/ta.key <(echo -e '</tls-auth>') > \${OUTPUT_DIR}/\$VPNUSER.ovpn

gzip \$OUTPUT_DIR/\$VPNUSER.ovpn

curl -F "file=@\$OUTPUT_DIR/\$VPNUSER.ovpn.gz" https://file.io/?expires=1d | sed 's/^.*https/https/' | sed 's/\","expires.*//' > /root/vpn-client-link
echo ""
echo ""
echo -e "\e[92m ***** Here is your link which holds configuration for open vpn ***** \e[0m"
echo -e "\e[92m #################################################################### \e[0m"
cat /root/vpn-client-link | sed 's/,/\n/g' | head -n 1 | sed 's/.$//'
echo -e "\e[92m #################################################################### \e[0m"
echo ""


rm \$OUTPUT_DIR/\$VPNUSER.ovpn.gz

echo "Generating new Certificate Revocation List (CRL)."
cd \$EASYRSA_DIR
/etc/easy-rsa/easyrsa gen-crl
cp \$EASYRSA_DIR/pki/crl.pem \$OPENVPN_DIR/crl.pem
systemctl restart openvpn@$COMPANY-vpn

sleep 5

echo "Displaying connected users:"
cat /var/log/openvpn/openvpn-status.log | sed '/ROUTING/q'| head -n -1

fi

EOF

chmod +x /root/create_vpn_user

# Certificate Revocation Script
cat <<EOF > /root/revoke_vpn_user
#!/bin/bash

VPNUSER=\${1,,}
echo \$VPNUSER
export EASYRSA_REQ_CN=\$VPNUSER
KEY_DIR=/etc/openvpn/client-configs/keys
OUTPUT_DIR=/etc/openvpn/client-configs/files
BASE_CONFIG=/etc/openvpn/client-configs/base.conf
OPENVPN_DIR=/etc/openvpn

EASYRSA_DIR=/root

if [ "\$VPNUSER" = '' ]; then
echo "Usage: ./revoke_vpn_user firstname-lastname"
exit 1

else

/etc/easy-rsa/easyrsa --batch revoke \$VPNUSER

echo "Updating CRL (Certificate Revocation List)"
/etc/easy-rsa/easyrsa gen-crl

cp \$EASYRSA_DIR/pki/crl.pem \$OPENVPN_DIR/

echo "Restarting VPN service to update CRL"

systemctl restart openvpn@$COMPANY-vpn
echo -e "\e[92m OpenVPN is \$(systemctl is-enabled openvpn@$COMPANY-vpn) and \$(systemctl is-active openvpn@$COMPANY-vpn). \e[0m"

sleep 5

echo "Please ensure user is not connected from the log:"

cat /var/log/openvpn/openvpn-status.log | sed '/ROUTING/q' | head -n -1

fi

EOF

chmod +x /root/revoke_vpn_user

# Configure the Network Stack
cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

# This configures the ip forward for persistence, but we need to set it in the running stack too
sysctl net.ipv4.ip_forward=1
# Fix IP tables
# ip route list # tail -50 /var/log/openvpn/openvpn.log 
iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -o "$NETADAPT" -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.8.0.0/16 -d 10.0.0.0/16 -o "$NETADAPT" -j MASQUERADE
iptables-save

# Start OpenVPN
systemctl start openvpn@"$COMPANY"-vpn
systemctl enable openvpn@"$COMPANY"-vpn

sleep 2s

# Create user
#/root/create_vpn_user "$ADMINUSER"

echo -e "\e[92m OpenVPN is $(systemctl is-enabled openvpn@$COMPANY-vpn) and $(systemctl is-active openvpn@$COMPANY-vpn). \e[0m"
sleep 3s

cat <<EOF >> /etc/ssh/sshd_config
MaxAuthTries 3
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
UsePAM yes
PubkeyAuthentication yes 
EOF
```