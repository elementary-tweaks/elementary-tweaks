# elementary tweaks
elementary tweaks is a system settings panel for elementary OS **Juno** that lets you easily and safely customise your desktop's appearance 

Future releases and support for elementary OS **Odin** is available here: https://github.com/pantheon-tweaks/pantheon-tweaks/

![sample](docs/screenshot.png)


## Installation

```
sudo add-apt-repository ppa:philip.scott/elementary-tweaks
sudo apt install elementary-tweaks
```

If you have never added a PPA on Juno before, you might need to run this command first: 
```
sudo apt install software-properties-common
```

### How to build
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

