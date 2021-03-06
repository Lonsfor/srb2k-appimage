#! /bin/bash

set -x
set -e

sudo apt-get update -y -qq && sudo apt-get upgrade -y -qq
sudo apt-get install -y -qq --no-install-recommends build-essential git nasm libpng-dev zlib1g-dev libsdl2-dev libsdl2-mixer-dev libgme-dev libopenmpt-dev libcurl4-openssl-dev rapidjson-dev cmake fuse pkg-config

git clone --branch master --single-branch --no-tags https://github.com/discord/discord-rpc.git
cd discord-rpc
mkdir build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr
sudo cmake --build . --config Release --target install
cd ../..

git clone --branch master --single-branch --no-tags -n https://github.com/STJr/Kart-Public.git kart
cd kart
git checkout 750b8bfe2058d18f8bce52502c52b790df68a0c5
patch src/d_netfil.c < ../d_netfil.c.diff
LIBGME_CFLAGS= LIBGME_LDFLAGS=-lgme make -C src/ LINUX64=1 NOUPX=1 NOOBJDUMP=1 HAVE_DISCORDRPC=1
cd ..

git clone --branch moe-mansion --single-branch --no-tags -n https://gitlab.com/himie/kart-public.git moe
cd moe
git checkout 4849fb5c0e1b893347675387007389cc89c39f77
patch src/d_netfil.c < ../d_netfil.c.diff
LIBGME_CFLAGS= LIBGME_LDFLAGS=-lgme make -C src/ LINUX64=1 NOUPX=1 NOOBJDUMP=1 HAVE_DISCORDRPC=1
cd ..

wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
wget -q https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
chmod +x linuxdeploy*.AppImage
chmod +x appimagetool-x86_64.AppImage

install -Dm755 kart/bin/Linux64/Release/lsdl2srb2kart AppDir/usr/bin/srb2kart
install -Dm755 AppRun AppDir/
install -Dm644 kart/src/sdl/srb2icon.png AppDir/usr/share/icons/hicolor/64x64/apps/org.srb2.SRB2Kart.png
install -Dm644 kart/srb2.png AppDir/usr/share/icons/hicolor/256x256/apps/org.srb2.SRB2Kart.png
install -Dm644 org.srb2.SRB2Kart.desktop AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
install -Dm644 org.srb2.SRB2Kart.appdata.xml AppDir/usr/share/metainfo/org.srb2.SRB2Kart.appdata.xml

./linuxdeploy-x86_64.AppImage --appdir AppDir

export NEWVERSION=1.3-git-$(cd kart && git rev-parse --short HEAD)
export NEWCOMMITANDDATE=$(cd kart && git show --summary --pretty='format:"1.3-git-%h" date="%cs"')
sed -i 's/VERSION/'"$NEWVERSION"'/g' AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
sed -i 's/COMMITANDDATE/'"$NEWCOMMITANDDATE"'/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.appdata.xml

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-noassets-x86_64.AppImage.zsync" AppDir srb2kart-noassets-x86_64.AppImage

wget -q https://github.com/STJr/Kart-Public/releases/download/v1.3/srb2kart-v13-Installer.exe
mkdir -p AppDir/usr/games/SRB2Kart
unzip srb2kart-v13-Installer.exe -d AppDir/usr/games/SRB2Kart *.kart *.srb mdls*
chmod +w AppDir/usr/games/SRB2Kart/mdls

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-x86_64.AppImage.zsync" AppDir srb2kart-x86_64.AppImage

mv AppDir/usr/games/ ./

install -Dm755 moe/bin/Linux64/Release/lsdl2srb2kart AppDir/usr/bin/srb2kart
install -Dm644 org.srb2.SRB2Kart.desktop AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
install -Dm644 org.srb2.SRB2Kart.appdata.xml AppDir/usr/share/metainfo/org.srb2.SRB2Kart.appdata.xml

export NEWVERSION=1.3-moe-$(cd moe && git rev-parse --short HEAD)
export NEWCOMMITANDDATE=$(cd moe && git show --summary --pretty='format:"1.3-moe-%h" date="%cs"')
sed -i 's/VERSION/'"$NEWVERSION"'/g' AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
sed -i 's/COMMITANDDATE/'"$NEWCOMMITANDDATE"'/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.appdata.xml

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-moe-noassets-x86_64.AppImage.zsync" AppDir srb2kart-moe-noassets-x86_64.AppImage

mv ./games/ AppDir/usr/

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-moe-x86_64.AppImage.zsync" AppDir srb2kart-moe-x86_64.AppImage
