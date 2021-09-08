#!/bin/bash

set -eo pipefail

if [[ "$1" == "show-sha" ]]; then
  VERSION="${2:-master}"
  VERSION_DATE=""

  tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
  cd "$tmp_dir/"
  trap 'cd ; rm -rf $tmp_dir' EXIT

  perform() {
    git clone "git://git.proxmox.com/git/$1.git" 2>/dev/null
    if [[ -z "$VERSION_TIMESTAMP" ]]; then
      REVISION=$(git -C "$1" rev-parse "$VERSION")
      VERSION_TIMESTAMP=$(git -C "$1" log -1 --format=%ct "$VERSION")
    else
      while read TIMESTAMP REVISION; do
        if [[ $TIMESTAMP -le $VERSION_TIMESTAMP ]]; then
          break
        fi
      done < <(git -C "$1" log --format="%ct %H")
    fi

    echo "perform $1 $REVISION # $(git -C "$1" log -1 --format="%cd" $REVISION)"
  }
else
  if [[ -n "$1" ]]; then
    cd "$1"
  fi

  perform() {
    if [[ ! -d "$1" ]]; then
      git clone "git://git.proxmox.com/git/$1.git"
    else
      git -C "$1" fetch
    fi
    git -C "$1" checkout "$2"
  }
fi

perform proxmox-backup 497a7b3f8e40bc28c7a81dce060b84c59517918b # Wed Sep 22 2021 11:36:42 +0200
perform proxmox 3cd221c16380b33451bfd4db827cde3d96918376 # Tue Sep 21 2021 06:45:28 +0200
perform proxmox-fuse a2933ee6e7b20cec1bc790b375471e1487004652 # Tue Jul 6 08:56:37 2021 +0200
perform proxmox-apt f9c6f7a18c4d7a1ab4141a186d7807972678b42d # Tue Aug 24 2021 15:41:08 +0200
perform proxmox-openid-rs 8d0c0ed699c3d5c2c8e414fdec9a191110aced50 # Wed Aug 25 2021 10:41:25 +0200
perform pxar e5a2495ed3d047db4f2918122662cf8495a34ac1 # Mon May 17 14:09:19 2021 +0200
perform proxmox-mini-journalreader 5ce05d16f63b5bddc0ffffa7070c490763eeda22 # Fri May 14 16:57:03 2021 +0200
perform proxmox-widget-toolkit 088a3ed9e9de7df7d3256a6a7b9cc5ff34714e3b # Tue Jul 27 16:41:08 2021 +0200
perform extjs 58b59e2e04ae5cc29a12c10350db15cceb556277 # Wed Jun 2 16:18:48 2021 +0200
perform proxmox-i18n 8f9be470a8ce95cc83fdc35fab143928021e6640 # Wed Sep 1 13:11:37 2021 +0200
perform pve-xtermjs 3b087ebf80621a39e2977cad327056ff4b425efe # Fri May 14 14:50:51 2021 +0200
perform proxmox-acme-rs f28a85da5e9658b84956136d2789a0596c0abbc9 # Fri Jun 11 14:00:55 2021 +0200
perform libjs-qrcodejs 1cc4649f55853d7d890aa444a7a58a8466f10493 # Sun Nov 22 18:57:27 2020 +0100
perform proxmox-acme 66f04388e483743cd1fe772bc628ccc110329db9 # Wed Aug 11 12:26:39 2021 +0200
perform pve-eslint ef0a5638b025ec9b9e3aa4df61a5b3b6bd471439 # Wed Jun 9 16:40:31 2021 +0200
