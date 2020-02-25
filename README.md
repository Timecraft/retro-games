# Retro Games
## A to-be elementary OS app for running libretro cores
### Built on retro-gtk

### Building, Testing, and Installation
#### Dependencies
- valac
- libgtk-3-dev
- libgranite-dev
- libretro-gtk-0.14-dev
- libmanette-0.2-dev
- libxml2-dev
- elementary-sdk
- meson

##### A one liner
```bash
sudo apt install valac libgtk-3-dev libgranite-dev libretro-gtk-0.14-dev libmanette-0.2-dev libxml2-dev elementary-sdk meson
```

#### Installation
Use `meson` to build.

`meson build --prefix=/usr`

Change into `build` directory and use `ninja` to compile.

`cd build`

`ninja`

Install using `ninja install`, then run with `com.github.timecraft.retro`. There is currently no way to run it from the launcher.

`sudo ninja install`

`com.github.timecraft.retro`

#### Debugging

There isn't really much as far as debugging messages go, and the only way to launch it (currently) is through the terminal.

##### Nothing more to show for now
