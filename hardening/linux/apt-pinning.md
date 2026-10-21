# apt: three levels of "pinned"

```bash
# 1. exact version at install
sudo apt-get install nginx=1.24.0-2ubuntu7

# 2. stop unattended upgrades from moving it
sudo apt-mark hold nginx
apt-mark showhold

# 3. policy file: /etc/apt/preferences.d/nginx
Package: nginx
Pin: version 1.24.0-2ubuntu7
Pin-Priority: 1001
```

Check what would be installed and from where:

```bash
apt-cache policy nginx
```
