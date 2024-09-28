# BlackHat Hacking: A Demo

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

#### Public Network
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
#### Private Network
- Backend app
    - Idk

- Super Secret Database Server
    - PostgreSQL
    - Should be a credential file or something similar in `/root`
    - Then we use those credentials to dump the database
