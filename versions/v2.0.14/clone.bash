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

perform proxmox-backup 9e7132c0b3ed987de340fae052e71f594d2b4838 # Fri, 12 Nov 2021 08:12:18 +0100
perform proxmox 28e1d4c342f31f3a8aca627d039b5d2666e2f25e # Fri, 12 Nov 2021 09:24:17 +0100 
perform proxmox-fuse a2933ee6e7b20cec1bc790b375471e1487004652 # Tue Jul 6 08:56:37 2021 +0200
perform proxmox-apt c7b17de1b5fec5807921efc9565917c3d6b09417 # Mon, 11 Oct 2021 12:00:19 +0200
perform proxmox-openid-rs 8471451a7b262c754435e4b4d55a989eb39df94e # Thu, 21 Oct 2021 07:15:11 +0200
perform pxar e5a2495ed3d047db4f2918122662cf8495a34ac1 # Mon May 17 14:09:19 2021 +0200
perform proxmox-mini-journalreader 5ce05d16f63b5bddc0ffffa7070c490763eeda22 # Fri May 14 16:57:03 2021 +0200
perform proxmox-widget-toolkit ceff5d3fc037d18c01a3c36acabc8c5713279f3d # Thu, 11 Nov 2021 21:11:19 +0100
perform extjs 58b59e2e04ae5cc29a12c10350db15cceb556277 # Wed Jun 2 16:18:48 2021 +0200
perform proxmox-i18n 8f9be470a8ce95cc83fdc35fab143928021e6640 # Wed Sep 1 13:11:37 2021 +0200
perform pve-xtermjs 3b087ebf80621a39e2977cad327056ff4b425efe # Fri May 14 14:50:51 2021 +0200
perform proxmox-acme-rs cb89d97df137781f1cb0fe7fff2bc27bb8043205 # Thu, 21 Oct 2021 12:14:10 +0100
perform libjs-qrcodejs 1cc4649f55853d7d890aa444a7a58a8466f10493 # Sun Nov 22 18:57:27 2020 +0100
perform proxmox-acme 300242d78bd63e91d0bc452e6284dafbec1043b1 # Fri, 8 Oct 2021 11:17:02 +0200
perform pve-eslint ef0a5638b025ec9b9e3aa4df61a5b3b6bd471439 # Wed Jun 9 16:40:31 2021 +0200
