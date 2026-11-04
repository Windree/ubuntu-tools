## custom.ipxe

```
\#!ipxe

:custom_menu
menu Custom Local Tools
item pmagic_2026 Boot Parted Magic 2026.03.20 (RAM)
item back Back to Main Menu
choose target && goto ${target}

:back
chain menu.ipxe

:pmagic_2026
set pm_url http\://10.22.0.6:80/pmagic
imgfree
kernel ${pm_url}/bzImage edd=on vga=normal netsrc=wget neturl=${pm_url}/pmodules/ netargs="-U pmagicboot" boot=live initrd=initrd.img
initrd ${pm_url}/initrd.img
boot || goto custom_menu
```
 

## boot.cfg
```
\#!ipxe

:global_vars
\# set site name
set site_name netboot.xyz

\# !CUSTOM!
set menu custom-user
```
 

## menu.ipxe

 
```
\#!ipxe

:start
isset ${arch} && goto skip_arch_detect ||
cpuid --ext 29 && set arch x86_64 || set arch i386
iseq ${buildarch} arm64 && set arch arm64 ||
:skip_arch_detect
chain --autofree boot.cfg ||
echo Attempting to retrieve latest upstream version number...
chain --timeout 5000 https\://boot.netboot.xyz/version.ipxe ||
ntp 0.pool.ntp.org ||
iseq ${cls} serial && goto ignore_cls ||
set cls:hex 1b:5b:4a  # ANSI clear screen sequence - "^\[\[J"
set cls ${cls:string}

\#!CUSTOM!
chain custom.ipxe
```
 
```sh
$> find assets/
assets/
assets/pmagic
assets/pmagic/bzImage
assets/pmagic/pmodules
assets/pmagic/pmodules/PMAGIC_2026_03_20.SQFS
assets/pmagic/initrd.img
```

docker-compose.yml
```yaml
services:
 app:
   image: netbootxyz/netbootxyz:latest
   restart: unless-stopped
   ports:
     - "3000:3000"
     - "69:69/udp"
     - "80:80"
   volumes:
     - ./config:/config
     - ./assets:/assets
```

## VNC
```sh
DISPLAY=:0 xrandr --size 1920x1080

x11vnc -display :0 -forever -nopw -passwd part
```
