 /interface bridge  
 add l2mtu=1598 name=bridge-local  
 /interface wireless  
 set 0 band=2ghz-b/g/n country=spain disabled=no ht-rxchains=0,1 ht-txchains=\  
  0,1 l2mtu=2290 tx-power=17 tx-power-mode=all-rates-fixed mode=ap-bridge \  
  wireless-protocol=802.11  
 /interface ethernet  
 set 0 name=ether1-gateway  
 set 1 name=ether2-master-local  
 set 2 master-port=ether2-master-local name=ether3-slave-local  
 set 3 master-port=ether2-master-local name=ether4-slave-local  
 set 4 master-port=ether2-master-local name=ether5-slave-local  
 /interface vlan  
 add interface=ether1-gateway l2mtu=1594 name=vlan2 vlan-id=2  
 add interface=ether1-gateway l2mtu=1594 name=vlan3 vlan-id=3  
 add interface=ether1-gateway l2mtu=1594 name=vlan6 vlan-id=6  
 /interface pppoe-client  
 add add-default-route=yes allow=pap,chap disabled=no interface=vlan6 max-mru=\  
  1492 max-mtu=1492 name=pppoe-out1 password=adslppp use-peer-dns=yes user=\  
  adslppp@telefonicanetpa  
 /interface wireless security-profiles  
 set [ find default=yes ] authentication-types=wpa2-psk group-ciphers=\  
  aes-ccm mode=dynamic-keys unicast-ciphers=aes-ccm \  
  wpa-pre-shared-key=mikrotik wpa2-pre-shared-key=mikrotik  
 /ip pool  
 add name=dhcp ranges=192.168.1.201-192.168.1.249  
 add name=vpn ranges=192.168.3.10-192.168.3.20  
 /ip dhcp-server  
 add address-pool=dhcp disabled=no interface=bridge-local name=dhcp1  
 /ppp profile  
 set 1 dns-server=192.168.3.250 local-address=192.168.3.250 remote-address=vpn  
 /interface bridge filter  
 add action=drop chain=output dst-address=239.0.0.0/8 ip-protocol=udp \  
  mac-protocol=ip out-interface=wlan1  
 /interface bridge port  
 add bridge=bridge-local interface=ether2-master-local  
 add bridge=bridge-local interface=wlan1  
 /interface pptp-server server  
 set authentication=mschap2 enabled=yes  
 /ip address  
 add address=192.168.1.1/24 comment="default configuration" interface=ether2-master-local  
 add address=192.168.100.10/24 interface=ether1-gateway  
 /ip dhcp-client  
 add add-default-route=no disabled=no interface=vlan3 use-peer-ntp=no  
 /ip dhcp-server option  
 add code=240 name=option_para_deco value=\  
  "':::::239.0.2.10:22222:v6.0:239.0.2.30:22222'"   
 /ip dhcp-server network  
 add address=192.168.1.0/24 dns-server=192.168.1.1 gateway=192.168.1.1 \  
  netmask=24  
 add address=192.168.1.199/32 dhcp-option=option_para_deco dns-server=\  
  172.26.23.3 gateway=192.168.1.1 netmask=24  
 /ip dns  
 set allow-remote-requests=yes  
 /ip dns static  
 add address=192.168.1.1 name=router  
 /ip firewall filter  
 add chain=input in-interface=vlan2  
 add chain=input comment="default configuration" protocol=icmp  
 add chain=input comment="default configuration" connection-state=established  
 add chain=input comment="default configuration" connection-state=related  
 add chain=input disabled=yes dst-port=23,80 in-interface=pppoe-out1 protocol=\  
  tcp  
 add chain=input dst-port=8291 in-interface=pppoe-out1 protocol=tcp  
 add chain=input dst-port=1723 in-interface=pppoe-out1 protocol=tcp  
 add action=drop chain=input comment="default configuration" in-interface=\  
  pppoe-out1  
 add chain=forward comment="default configuration" connection-state=\  
  established  
 add chain=forward comment="default configuration" connection-state=related  
 add action=drop chain=forward comment="default configuration" \  
  connection-state=invalid  
 /ip firewall mangle  
 add action=set-priority chain=postrouting new-priority=4 out-interface=vlan3  
 add action=set-priority chain=postrouting new-priority=4 out-interface=vlan2  
 add action=set-priority chain=postrouting new-priority=1 out-interface=\  
  pppoe-out1  
 /ip firewall nat  
 add action=masquerade chain=srcnat comment="default configuration" \  
  out-interface=pppoe-out1  
 add action=masquerade chain=srcnat comment="default configuration" \  
  out-interface=ether1-gateway  
 add action=masquerade chain=srcnat comment="default configuration" \  
  out-interface=vlan2  
 add action=masquerade chain=srcnat comment="default configuration" \  
  out-interface=vlan3  
 add action=dst-nat chain=dstnat dst-address-type=local in-interface=\  
  vlan2 comment="VOD" to-addresses=192.168.1.199  
 add action=dst-nat chain=dstnat disabled=yes dst-port=80 in-interface=\  
  pppoe-out1 protocol=tcp to-addresses=192.168.1.125  
 add action=dst-nat chain=dstnat disabled=yes dst-port=21 in-interface=\  
  pppoe-out1 protocol=tcp to-addresses=192.168.1.125  
 /ip route  
 add distance=255 gateway=255.255.255.255  
 /ip upnp  
 set enabled=yes  
 /ip upnp interfaces  
 add interface=bridge-local type=internal  
 add interface=pppoe-out1 type=external  
 /routing igmp-proxy interface  
 add alternative-subnets=0.0.0.0/0 interface=vlan2 upstream=yes  
 add interface=bridge-local  
 /routing rip interface  
 add interface=vlan3 passive=yes receive=v2  
 add interface=vlan2 passive=yes receive=v2  
 /routing rip network  
 add network=10.0.0.0/8  
 add network=172.26.0.0/16  
 /system clock  
 set time-zone-name=Europe/Madrid  
 /system ntp client  
 set enabled=yes primary-ntp=163.117.202.33 secondary-ntp=\  
  89.248.104.162  
