# Kodi Game Addons built for LibreElec

## game.retroarch
This addon provides RetroArch on [LibreElec x86-64 Generic](https://libreelec.tv/downloads/generic/) build.
* Run on GBM/DRM with no dependencies on X11 nor Wayland
* Have support for gl/glcore/vulkan video drivers
  * Vulkan drivers included for Intel and Radeon GPUs
* Can be launched
  * From Kodi in stand alone (from the Game menu)
  * From Kodi by selecting a ROM file (emulates a RetroPlayer Game Client)
  * From the command line by using `retroarch-ctl run optional_rom_path`
* Automatically stops and restarts Kodi when running RetroArch (required to free up GBM/DRM for RetroArch)
* RetroArch config path is `/storage/.kodi/userdata/addon_data/game.retroarch/.config/retroarch/`
* RetroArch execution log accessible from `journalctl -u game.retroarch`

### Settings
* **Download RetroArch Assets** : automatically download RetroArch assets and autoconfig on RetroArch start
* **Link libretro Cores** : automatically import existing Kodi libretro cores into RetroArch
* **Enable CPU/GPU performance mode** : set CPU and GPU performance mode when RetroArch is running
* **Kodi Restart Action** : launch an action after Kodi restarts, such as
  * **Window** : Open the specified Kodi window
  * **Builtin Function** : run a Kodi builtin function, e.g. `RunAddon(script.games.rom.collection.browser)`
  * **Script** : execute a custom shell script or executable

## game.libretro.mupen64plus-nx
This addon provides Mupen64Plus-Next libretro core for N64 roms
* Run on GBM/DRM with no dependencies on X11 nor Wayland
* Built with parallel/GlideN64/angrylion RSP support
  * Only angrylion works in Kodi RetroPlayer but they can all be used in RetroArch
