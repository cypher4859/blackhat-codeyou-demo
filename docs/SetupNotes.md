# BlackHat Hacking: A Demo


## Things to do on Setup Day
1. Make sure every host is deployed via `terraform apply`
    - If it needs re-deployed, allocate at least 30minutes to do it
2. Make sure you can SSH into Kali
3. Make sure you can RDP into Kali
4. Ensure that Kali is updated with all the necessary packages, preferably with a GUI Desktop
5. Ensure that you can login via SSH to other hosts
6. If needed we can quickly spin up a new instance of kali using the backup image

## Possible Targets
### All users
#### Dotnet
raphael:raphael123
james:james1234567890
melissa:sdjfljkasdfj

#### FTP
admin:adkljeiasdkl8973
jimmy:jimmy123
john:asjkweioajsd123
hannah:pwoejklsadknihai32
blake:erjadsjiej
tim:starwarsday
melissa:sdjfljkasdfj
alice:alice

## Setup
### Public Network
- WebApp
    - ~~TODO~~: Setup CowabungaPizza
    - ~~TODO~~: pivot - Find the credentials for raphael, which should let you into the database
    - ~~TODO~~: Need to setup SSH
    - ~~TODO~~: Use `wget` gtfobin
    - Get root
        - setup id_rsa?

- WebApp Database [DONE]
    - Get in from Cowabunga-App
    - ~~TODO~~: Phase1 - Get access
        - Setup local users, 
            - one will be the entrypoint, can use this user to dump the `users` table in cowabunga database
            - one of them will be superadmin, can use this user to ssh into the host, SUID up
        - Expected to login via ssh or mysql from cowabunga app
        - SSH for james and raphael is working. Can pivot from user to admin inside sql.
    - ~~TODO~~: Phase2 - ~~mysql SUID~~ Won't work.
        - Need to find something else.
        - Added SUID cpulimit
        - /usr/bin/cpulimit -l 100 -- /bin/sh -p
    - Get root
        - TODO: Make sure as root that we can dump the whole database and setup persistence

- FTP FileServer
    - ~~TODO~~: Build it
        - ~~Got the pure-ftpd working~~
        - ~~Next is to add the users~~ # This needs to be done manually once, then it's persistent (volume)
        - ~~then build their files~~
        - ~~Add the files~~
        - ~~test it~~
        - ~~Add SSH~~
        - ~~Set SSH running on port 61000~~
        - ~~Test that we can login to all the ftp users~~ *-ish
    - ~~TODO~~ -> Phase 2: This should lead to logging in as a regular user
        - ~~SSH running on port 61000~~
        - ~~have an id_rsa sitting in root directory~~
    - ~~TODO~~ -> Phase 3: Need to do post-exploit to get root
        - ~~SUID use zip to download the root id_rsa key~~
        - ~~Can login with the ssh key afterwards~~
 
 - Jupyter
    - ~~TODO~~: test RCE via system shell
    - ~~TODO~~: SUID
        - Using `mawk` - Can do reads
        - Using `find` - Can get terminal
    - ~~TODO~~: Add loot
        - Add melissa:sdjfljkasdfj to jupyter with homedir
        - Make an dotnet env file
        - Make sure we can login from jupyter to CowabungaPizza

- SMTPD
    - TODO: [Docs on exploiting](https://github.com/vulhub/vulhub/tree/master/opensmtpd/CVE-2020-7247)
        - Show Exploit-db
        - curl download file
        - show downloading dependencies?
        - python
    - Have root

--- 
### Private Network
- Backend app
    - Idk

- Super Secret Database Server
    - PostgreSQL
    - Should be a credential file or something similar in `/root`
    - Then we use those credentials to dump the database

### Kali
- Once login then we need to do a:
```sh
# login as kali
sudo -i
apt upd ate && apt full-upgrade -y && apt install -y kali-linux-default


echo "[i] Installing Xfce4 & xrdp (this will take a while as well)"
sudo apt-get install -y kali-desktop-xfce xorg xrdp

echo "[i] Configuring xrdp to listen to port 3390 (but not starting the service)"
sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

wget https://gitlab.com/kalilinux/recipes/kali-scripts/-/raw/main/xfce4.sh
chmod +x xfce4.sh
sudo ./xfce4.sh
systemctl enable xrdp --now

# In the case of AWS
echo kali:kali | sudo chpasswd
```

### Terraform
- Build time: ~4m
- Destroy time: ~17m - 20m

### Setting up the VulnHub Instances
Source: https://docs.aws.amazon.com/vm-import/latest/userguide/import-vm-image.html
1. Go download the vulhub OVA file from vulhub
2. Upload to S3 bucket in the account
3. Make a containers.json (should be one in the `VulHub/` path)
4. `aws ec2 import-image --description "My server disks" --disk-containers "file://C:\import\containers.json"`