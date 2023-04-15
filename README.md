# Kodi Game Addons built for LibreElec

## game.retroarch
This addon provides RetroArch on LibreElec x86-64 Generic build.
* Run on GBM/DRM with no dependencies on X11 nor Wayland
* Have support for gl/glcore/vulkan video drivers for Intel and Radeon GPUs
* Automatically stops and restarts Kodi when running RetroArch
* Can be launched
  * From Kodi in stand alone (from the Game menu)
  * From Kodi by selecting a ROM file (emulates a RetroPlayer Game Client)
  * From the command line by using `retroarch-ctl run optional_rom_path`
* Automatically import existing Kodi libretro cores into RetroArch
* RetroArch execution log accessible from `journalctl -u game.retroarch`

## game.libretro.mupen64plus-nx
This addon provides Mupen64Plus-Next libretro core for N64 roms
* Run on GBM/DRM with no dependencies on X11 nor Wayland
* Built with parallel/GlideN64/angrylion RSP support
  * Only angrylion works in Kodi RetroPlayer but they can all be used in RetroArch
