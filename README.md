# elementary tweaks
elementary tweaks is a system settings panel for elementary OS **Loki** that lets you easily and safely customise your desktop's appearance 


![sample](docs/screenshot.png)

 
## What's New?
- Fully updated and working to reflect the changes of elementary OS Loki
- elementary-tweaks now looks more "elementary"! We've rebuilt elementary tweaks from the ground up to make it look like a native plug for your settings settings.
- Fixed: Removed theme-patcher and other more dangerous settings that were [causing problems](https://github.com/I-hate-farms/elementary-tweaks/issues/14)

[Previous Changelog](CHANGELOG.md)

## Installation

```
sudo add-apt-repository ppa:philip.scott/elementary-tweaks && sudo apt-get update
sudo apt-get install elementary-tweaks
```

If you have never added a PPA on Loki before, you might need to run this command first: 
```
sudo apt-get install software-properties-common
```

### How to build
```
sudo apt-get install libgconf2-dev libpolkit-gobject-1-dev libswitchboard-2.0-dev elementary-sdk
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr ../
make 
    
sudo make install 
switchboard
```

### Special Thanks
This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable" Langfermann, PerfectCarl, Marvin Beckers and additional [contributors](CONTRIBUTORS).

