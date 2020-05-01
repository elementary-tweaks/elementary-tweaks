# elementary tweaks
elementary tweaks is a system settings panel for elementary OS **Juno** that lets you easily and safely customise your desktop's appearance 


![sample](docs/screenshot.png)

 
## What's New?
- Fully updated and working to reflect the changes of elementary OS Juno
- elementary-tweaks now looks more "elementary"! We've rebuilt elementary tweaks from the ground up to make it look like a native plug for your system's settings.
- Fixed: Removed theme-patcher and other more dangerous settings that were [causing problems](https://github.com/I-hate-farms/elementary-tweaks/issues/14)

[Previous Changelog](CHANGELOG.md)

## Installation
### From PPA (recommended)
If you have never added a PPA on Juno before, you might need to run this command first: 

```
sudo apt install software-properties-common
```

Add the PPA of elementary tweaks and then install it:

```
sudo add-apt-repository ppa:philip.scott/elementary-tweaks
sudo apt install elementary-tweaks
```

Open System Settings and there should be a new Plug named "Tweaks".

### From Source Code
If you want to install from source code, clone this repository and then run the following commands:

```
sudo apt install libgconf2-dev libpolkit-gobject-1-dev libswitchboard-2.0-dev elementary-sdk
meson build --prefix=/usr
cd build
ninja

sudo ninja install
io.elementary.switchboard
```

### Special Thanks
This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable" Langfermann, PerfectCarl, Marvin Beckers and additional [contributors](CONTRIBUTORS).

