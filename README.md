# vmnet

In order to periodically check and recover VM network loss (in development environment on local computer), you should:
* assign static IP to VM guest (now 192.168.1.199)
* tune /etc/sudoers for run sudo "bundle exec..." without password prompt - add line like this (see detailed [explanation](http://askubuntu.com/questions/159007/how-do-i-run-specific-sudo-commands-without-a-password)): 
```
    khataev iMac.nDrew = (root) NOPASSWD: /Users/khataev/.rbenv/shims/bundle
```
* add crontab job:
with
```
  crontab -e
```
and add line
```
* * * * * /bin/bash -l -c 'cd /Users/khataev/Documents/development/rails/vmnet && sudo bundle exec bin/rails runner -e development '\''Vman.check_ping_guest'\'''
```
