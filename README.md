## Setup Notes

Some notes getting the ladder to run on an EL7 machine.

### Prepare Ladder

```
yum install python-devel

cd /root/TFTFL-web

pip2.7 install virtualenv
virtualenv pyenv

source pyenv/bin/activate
pip install mako flask pyuwsgi requests

touch ladder.txt

python wsgi.py # runs server that works on localhost:5000, test this works from local VNC
```

### Add Systemd Service

- Service start script
```
cat << EOF > /root/TNTFL-web/start.sh
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

source pyenv/bin/activate
python wsgi.py
EOF

chmod +x /root/TNTFL-web/start.sh
```

- Systemd unit file
```
cat << EOF > /usr/lib/systemd/system/pongladder.service
[Unit]
Description=Table Tennis Ladder
Requires=network.target
After=network.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/root/TNTFL-web/start.sh
SuccessExitStatus=15

[Install]
WantedBy=multi-user.target
EOF

systemctl start pongladder
systemctl enable pongladder
```

### Reverse Proxy

```
yum install nginx
cat << EOF > /etc/nginx/conf.d/pongladder.conf
server {
    listen 80;

    location / {
      proxy_pass    http://localhost:5000;
    }
}
EOF

systemctl start nginx
systemctl enable nginx
```
