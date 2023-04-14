FROM ubuntu:jammy AS builder


RUN apt-get update && apt-get install -y \
    vim wget curl bash git gh zip \
    make g++ nasm \
    meson cmake glslang-tools python3-mako pkg-config autoconf libtool \
    libasound2-dev libudev-dev libgbm-dev libdrm-dev \
    llvm libelf-dev byacc flex \
    libpng-dev libgif-dev libjpeg-dev libcdio-dev libcdio++-dev libcrossguid-dev liblzo2-dev libass-dev libcurl4-openssl-dev libfstrcmp-dev libssl-dev libsqlite3-dev libtinyxml-dev libinput-dev libxkbcommon-dev flatbuffers-compiler libflatbuffers-dev


ARG VULKAN=v1.3.204 \
    MESA=mesa-22.3.0 \
    RETROARCH=v1.15.0 \
    MUPEN64PLUS=develop \
    KODI=20.1-Nexus


RUN mkdir -p /buildkit/installdir \
 && cd /buildkit \
 && git config --global --add advice.detachedHead false \
 && git clone https://github.com/KhronosGroup/Vulkan-Headers.git --branch ${VULKAN} \
 && git clone https://github.com/KhronosGroup/Vulkan-Loader.git --branch ${VULKAN} \
 && git clone https://github.com/KhronosGroup/Vulkan-Tools.git --branch ${VULKAN} \
 && git clone https://gitlab.freedesktop.org/mesa/mesa.git --branch ${MESA} \
 && git clone https://github.com/libretro/RetroArch.git --branch ${RETROARCH} \
 && git clone https://github.com/libretro/mupen64plus-libretro-nx.git --branch ${MUPEN64PLUS} \
 && git clone https://github.com/xbmc/xbmc.git --branch ${KODI}


RUN cd /buildkit/Vulkan-Headers \
 && cmake -S . -B build/ -Wno-de \
 && cmake --install build --prefix /usr


RUN mkdir -p /buildkit/Vulkan-Loader/build \
 && cd /buildkit/Vulkan-Loader/build \
 && cmake .. \
        -DVULKAN_HEADERS_INSTALL_DIR=/usr \
        -DUPDATE_DEPS=OFF \
        -DBUILD_WSI_XCB_SUPPORT=OFF \
        -DBUILD_WSI_XLIB_SUPPORT=OFF \
        -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
        -DBUILD_WSI_DIRECTFB_SUPPORT=OFF \
 && make install


RUN mkdir -p /buildkit/Vulkan-Tools/build \
 && cd /buildkit/Vulkan-Tools/build \
 && cmake .. \
        -DVULKAN_HEADERS_INSTALL_DIR=/usr \
        -DBUILD_CUBE=OFF \
        -DBUILD_VULKANINFO=ON \
        -DBUILD_ICD=OFF \
        -DINSTALL_ICD=OFF \
        -DBUILD_WSI_XCB_SUPPORT=OFF \
        -DBUILD_WSI_XLIB_SUPPORT=OFF \
        -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
        -DBUILD_WSI_DIRECTFB_SUPPORT=OFF \
 && make install


RUN mkdir -p /buildkit/mesa/build \
 && cd /buildkit/mesa \
 && meson setup build/ \
        -Dlibdir=lib \
        -Ddatadir=lib \
        -Dvulkan-icd-dir=lib \
        -Dbuild-tests=false \
        -Ddri-drivers= \
        -Ddri3=disabled \
        -Degl=enabled \
        -Dgallium-drivers=iris,radeonsi \
        -Dgallium-extra-hud=false \
        -Dgallium-nine=false \
        -Dgallium-omx=disabled \
        -Dgallium-opencl=disabled \
        -Dgallium-va=disabled \
        -Dgallium-vdpau=disabled \
        -Dgallium-xa=disabled \
        -Dgbm=enabled \
        -Dgles1=disabled \
        -Dgles2=enabled \
        -Dglvnd=false \
        -Dglx=disabled \
        -Dlibunwind=disabled \
        -Dllvm=enabled \
        -Dlmsensors=disabled \
        -Dopengl=true \
        -Dosmesa=false \
        -Dplatforms= \
        -Dselinux=false \
        -Dzlib=enabled \
        -Dshader-cache=disabled \
        -Dshared-glapi=enabled \
        -Dvalgrind=disabled \
        -Dvulkan-drivers=amd,intel \
 && ninja -C build/ install


RUN cd /buildkit/RetroArch \
 && export CFLAGS="-DMESA_EGL_NO_X11_HEADERS -DEGL_NO_X11" \
 && export CXXFLAGS="-DMESA_EGL_NO_X11_HEADERS -DEGL_NO_X11" \
 && ./configure \
        --disable-x11 \
        --disable-ibxm \
        --disable-winrawinput \
        --enable-udev \
        --disable-rpiled \
        --disable-discord \
        --disable-cdrom \
        --disable-cheevos \
        --disable-accessibility \
        --disable-nvda \
        --disable-tinyalsa \
        --enable-alsa \
        --enable-egl \
        --enable-kms \
        --disable-opengl \
        --disable-opengl1 \
        --enable-opengl_core \
        --enable-opengles \
        --enable-opengles3 \
        --enable-opengles3_1 \
        --enable-opengles3_2 \
        --enable-vulkan \
 && make install


RUN mkdir -p /buildkit/kodi-build \
 && cd /buildkit/kodi-build \
 && cmake \
  /buildkit/xbmc \
  -Wall \
  -DAPP_RENDER_SYSTEM=gles \
  -DCORE_PLATFORM_NAME=gbm \
  -DENABLE_AIRTUNES=off \
  -DENABLE_ALSA=off \
  -DENABLE_APP_AUTONAME=off \
  -DENABLE_ATOMIC=on \
  -DENABLE_AVAHI=off \
  -DENABLE_BLUETOOTH=off \
  -DENABLE_BLURAY=off \
  -DENABLE_CAP=off \
  -DENABLE_CCACHE=off \
  -DENABLE_CEC=off \
  -DENABLE_CLANGFORMAT=off \
  -DENABLE_DAV1D=off \
  -DENABLE_DBUS=off \
  -DENABLE_DVDCSS=off \
  -DENABLE_EGL=on \
  -DENABLE_GBM=on \
  -DENABLE_GOLD=off \
  -DENABLE_INTERNAL_CROSSGUID=off \
  -DENABLE_INTERNAL_SPDLOG=on \
  -DENABLE_INTERNAL_FLATBUFFERS=off \
  -DENABLE_INTERNAL_FMT=on \
  -DENABLE_INTERNAL_KISSFFT=on \
  -DENABLE_INTERNAL_RapidJSON=on \
  -DENABLE_INTERNAL_TAGLIB=on \
  -DENABLE_ISO9660PP=off \
  -DENABLE_LCMS2=off \
  -DENABLE_LIBDRM=on \
  -DENABLE_LIBINPUT=on \
  -DENABLE_LIRCCLIENT=off \
  -DENABLE_MDNS=off \
  -DENABLE_MICROHTTPD=off \
  -DENABLE_NFS=off \
  -DENABLE_OPENGLES=on \
  -DENABLE_OPTICAL=off \
  -DENABLE_PIPEWIRE=off \
  -DENABLE_PLIST=off \
  -DENABLE_PULSEAUDIO=off \
  -DENABLE_PYTHON=off \
  -DENABLE_SMBCLIENT=off \
  -DENABLE_SNDIO=off \
  -DENABLE_SSE2=off \
  -DENABLE_SSE3=off \
  -DENABLE_SSE4_1=off \
  -DENABLE_SSE=off \
  -DENABLE_SSSE3=off \
  -DENABLE_TESTING=off \
  -DENABLE_UDEV=on \
  -DENABLE_UDFREAD=off \
  -DENABLE_UPNP=off \
  -DENABLE_VAAPI=off \
  -DENABLE_XKBCOMMON=on \
  -DENABLE_XSLT=off \
&& make install


COPY . /buildkit/


RUN mkdir -p /buildkit/build \
 && sed -i "s/%VERSION%/${RETROARCH#v}/" /buildkit/game.retroarch/addon.xml \
 && cd /buildkit/build \
 && cmake /buildkit \
 && make \
 && cp /buildkit/build/game.retroarch.so /buildkit/game.retroarch/game.retroarch.so \
 && cd /usr/local \
 && cp --parents lib/intel_icd.x86_64.json lib/libvulkan.so lib/libvulkan_intel.so lib/libvulkan_radeon.so lib/radeon_icd.x86_64.json bin/vulkaninfo bin/retroarch-cg2glsl bin/retroarch /buildkit/game.retroarch/ \
 && cd /buildkit/game.retroarch \
 && sed -i 's|/usr/local/lib/||' lib/*_icd.x86_64.json \
 && cd /buildkit \
 && zip -r game.retroarch.zip game.retroarch


RUN cd /buildkit/mupen64plus-libretro-nx \
 && make \
        FORCE_GLES3=1 \
        HAVE_THR_AL=1 \
        HAVE_PARALLEL_RSP=1 \
        HAVE_PARALLEL_RDP=1 \
        LLE=1 \
        TARGET=/buildkit/game.libretro.mupen64plus-nx/game.libretro.mupen64plus-nx.so


RUN cd /buildkit/game.libretro.mupen64plus-nx \
 && MUPEN_VERSION=$(git -C  /buildkit/mupen64plus-libretro-nx/ rev-parse --short HEAD) \
 && sed -i "s/%VERSION%/${MUPEN_VERSION}/" addon.xml \
 && cd /buildkit \
 && zip -r game.libretro.mupen64plus-nx.zip game.libretro.mupen64plus-nx

