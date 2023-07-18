# rescue-copy-bash-script
Rescue Copy your LiquidWeb Cloud Block Storage script to a local disk

Re: LiquidWeb's Cloud Block Storage Service Degradation

https://status.liquidweb.com/incidents/k9vnl23nmz0z

### Problem

Accessing some files in Liquid Web's CBS volumes will cause your server/process to hang.

### Work Around

I'm attempting to trim my storage and move over the most-necessary files.

## Installation

```
wget https://raw.githubusercontent.com/lets-make-dev/rescue-copy-bash-script/main/rescue-copy.sh
nano rescue-copy.sh # 👈 change the source and destination paths
chmod +x rescue-copy.sh
touch failed-copy.txt
```

### Usage

```
./rescue-copy
```
