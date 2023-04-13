FROM ubuntu:jammy AS builder

RUN apt-get update && apt-get install -y \
    vim wget bash git gh zip \
    make g++ nasm \
    meson cmake glslang-tools python3-mako pkg-config \
    libasound2-dev libudev-dev libgbm-dev libdrm-dev \
    llvm libelf-dev byacc flex



ARG VULKAN=v1.3.204
ARG MESA=mesa-22.3.0
ARG RETROARCH=v1.15.0
ARG MUPEN64PLUS=develop

RUN mkdir -p /buildkit/installdir \
 && cd /buildkit \
 && git config --global --add advice.detachedHead false \
 && git clone https://github.com/KhronosGroup/Vulkan-Headers.git --branch ${VULKAN} \
 && git clone https://github.com/KhronosGroup/Vulkan-Loader.git --branch ${VULKAN} \
 && git clone https://github.com/KhronosGroup/Vulkan-Tools.git --branch ${VULKAN} \
 && git clone https://gitlab.freedesktop.org/mesa/mesa.git --branch ${MESA} \
 && git clone https://github.com/libretro/RetroArch.git --branch ${RETROARCH} \
 && git clone https://github.com/libretro/mupen64plus-libretro-nx.git --branch ${MUPEN64PLUS}


RUN cd /buildkit/Vulkan-Headers \
 && cmake -S . -B build/ -Wno-de \
 && cmake --install build --prefix /usr


RUN mkdir -p /buildkit/Vulkan-Loader/build \
 && cd /buildkit/Vulkan-Loader/build \
 && cmake .. \
        -DCMAKE_INSTALL_PREFIX=/buildkit/installdir \
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
        -DCMAKE_INSTALL_PREFIX=/buildkit/installdir \
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
        -Dprefix=/buildkit/installdir \
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
 && export CFLAGS="-L/buildkit/installdir/lib -DMESA_EGL_NO_X11_HEADERS -DEGL_NO_X11" \
 && export CXXFLAGS="-L/buildkit/installdir/lib -DMESA_EGL_NO_X11_HEADERS -DEGL_NO_X11" \
 && ./configure \
        --prefix=/buildkit/installdir \
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


RUN cd /buildkit/mupen64plus-libretro-nx \
 && make \
        FORCE_GLES3=1 \
        HAVE_THR_AL=1 \
        HAVE_PARALLEL_RSP=1 \
        HAVE_PARALLEL_RDP=1 \
        LLE=1 \
        TARGET=/buildkit/installdir/lib/mupen64plus_next_libretro.so


COPY game.retroarch /buildkit/game.retroarch/

RUN cd /buildkit/installdir \
 && cp --parents lib/intel_icd.x86_64.json lib/libvulkan.so lib/libvulkan_intel.so lib/libvulkan_radeon.so lib/radeon_icd.x86_64.json bin/vulkaninfo bin/retroarch-cg2glsl bin/retroarch ../game.retroarch/ \
 && cd /buildkit/game.retroarch \
 && sed -i 's|/buildkit/installdir/lib/||' lib/*_icd.x86_64.json \
 && sed -i "s/%VERSION%/${RETROARCH}/" addon.xml \
 && cd /buildkit \
 && zip -r game.retroarch.zip game.retroarch


COPY game.libretro.mupen64plus-nx /buildkit/game.libretro.mupen64plus-nx/

RUN cd /buildkit/installdir \
 && cp lib/mupen64plus_next_libretro.so ../game.libretro.mupen64plus-nx/game.libretro.mupen64plus-nx.so \
 && cd /buildkit/game.libretro.mupen64plus-nx \
 && MUPEN_VERSION=$(git -C  /buildkit/mupen64plus-libretro-nx/ rev-parse --short HEAD) \
 && sed -i "s/%VERSION%/${MUPEN_VERSION}/" addon.xml \
 && cd /buildkit \
 && zip -r game.libretro.mupen64plus-nx.zip game.libretro.mupen64plus-nx


