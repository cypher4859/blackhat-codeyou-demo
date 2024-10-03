# Walkthrough

## All users
### Dotnet
raphael:raphael123
james:james1234567890
melissa:sdjfljkasdfj

### FTP
admin:adkljeiasdkl8973
jimmy:jimmy123
john:asjkweioajsd123
hannah:pwoejklsadknihai32
blake:erjadsjiej
tim:starwarsday
melissa:sdjfljkasdfj
alice:alice

# Attacking the Machines
## Public Network
### WebApp - CowabungaPizza
Credit: [Melody Miller](https://github.com/8bitmel0dee/CowabungaPizza), did an excellent job of building this app as a capstone for Code:You in 2023

This app is mostly a way to link/lead over to the database which is the main piece we care about. This app has a single intentional flaw that I injected in. The Docker Image for this app contains a couple additions, namely:
- Users with semi-weak passwords (raphael, james, and melissa) who have access to the database
- Hardcoded credentials in an appsettings.json file.
- SSH is running though this isn't an inherent vulernability, simply a way to access the host once you get compromised credentials
- A SUID priv-esc capability using `wget`

It's expected that you can find `raphael`'s credentials on another host, pivot here to CowabungaPizza, compromise the database, and move onwards from there.


### WebApp Database - CowabungaPizza-db
This database is a MySQL database setup using the latest mysql image. It's primarily here to allow for a pivot from the WebApp once it's compromised although it's not __technically__ necessary to hit the WebApp first. Couple obvious vulnerabilities:
- Couple weak password users (raphael, james)
- Limited SUID of `mysql` though this is perhaps a red-herring
- SSH running on the host, only to allow logging in to the machine
- SUID Shell priv-esc using `cpulimit`
- Obviously unencrypted passwords in the database


### FTPServer - Based off an OSCP Challenge
The FTPServer is one of the "entry-point" machines in the subnet. Personally the toughest to get setup but most satisfying for newbies. It runs a pure-ftpd server to allow users to login and download files. There's a trick to it though which is that all the files/directories on the host are hidden so on the first login a newbie won't notice it. Should look simply like an empty ftp server. *NOTE*: The next step that I'd like to do but couldn't in the timeframe is to disallow the `ls` command; if you're working through this then I'd encourage *to not* use the `ls` command and see if you can arrive at the same conclusion. It's a little tricky :)
Couple note-worthy vulns:
- SUID priv-esc via `zip`
- SSH running on the host on a custom port outside the normal range that `nmap` scans for, only to allow logging in to the machine
- Multiple weak passwd users, each containing an FTP file
- `.<username>.json` file that contains hardcoded credentials for that user that is password protected. `alice` is the easiest. Once you pop one you can get the rest

### Jupyter
Credit: The code running on Jupyter is credited to [Don Bradshaw](https://github.com/DonBradshawUS/LexCrimeData)

The Jupyter Notebook service is meant as an entrypoint to the subnet as well to give an attacker a foothold. This makes use of the `LexCrimeData` project created by a previous student for their Capstone. This target is pretty simple; this version of Jupyter does allow for the spawning a user shell from the web interface. From there it's trivial to priv-escalate.
Note-worthy vulns:
- Spawn a user shell from the interface
- Limited SUID bit on `awk` and `mawk`
- SUID Shell via `find`
- Weak password on an auxiliary user
- Hardcoded credentials in a hidden config file in `/root/` directory
- User can be used to pivot to an additional host (CowabungaPizza)


### SMTPd Mail Server
This is a fun one. Found via Vulnhub. [Docs on exploiting](https://github.com/vulhub/vulhub/tree/master/opensmtpd/CVE-2020-7247).
Simply copy down the PoC and you can use it to target the host and get a root shell. Needs tested


## Private Network
### PostgreSQL Secret Database
This host is meant to be in a private subnet. The attacker should find which of the hosts actually has a second interface that they can route through to target this host. The data on this host includes SSNs, Bank accounts, etc. and is all mock data generated from Mockaroo.
Still needs work!
- Has super weak password