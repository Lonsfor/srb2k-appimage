#! /bin/bash

set -x
set -e

sudo apt-get update -y -qq && sudo apt-get upgrade -y -qq
sudo apt-get install -y -qq --no-install-recommends build-essential git nasm libpng-dev zlib1g-dev libsdl2-dev libsdl2-mixer-dev libgme-dev libopenmpt-dev libcurl4-openssl-dev rapidjson-dev cmake fuse3 pkg-config


git clone --branch master --single-branch --no-tags https://github.com/discord/discord-rpc.git
cd discord-rpc
mkdir build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr
sudo cmake --build . --config Release --target install
cd ../..


git clone --branch master --single-branch --no-tags -n https://github.com/STJr/Kart-Public.git kart
cd kart
git checkout 20a5adde02d134a1badaf22fa6f680eba0580308
patch src/d_netfil.c < ../d_netfil.c.patch
LIBGME_CFLAGS= LIBGME_LDFLAGS=-lgme make -C src/ LINUX64=1 NOUPX=1 NOOBJDUMP=1 HAVE_DISCORDRPC=1
cd ..

git clone --branch Galaxy-Redux --single-branch --no-tags -n https://git.do.srb2.org/Galactice/Kart-Public.git galaxy
cd galaxy
git checkout ef8e6abebd9db6d4e7ee3e13767f16ff634acfd3
patch src/d_netfil.c < ../d_netfil.c.patch
LIBGME_CFLAGS= LIBGME_LDFLAGS=-lgme make -C src/ LINUX64=1 NOUPX=1 NOOBJDUMP=1 HAVE_DISCORDRPC=1
cd ..

git clone --branch Glalxy --single-branch --no-tags -n https://git.do.srb2.org/haya_/Kart-Public.git HEP
cd HEP
git checkout 4b8471c232f2024a679b546259d3b6dd943dc095
patch src/d_netfil.c < ../d_netfil.c.patch
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
install -Dm644 org.srb2.SRB2Kart.metainfo.xml AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

./linuxdeploy-x86_64.AppImage --appdir AppDir

export NEWVERSION=1.6-git-$(cd kart && git rev-parse --short HEAD)
export NEWCOMMITANDDATE=$(cd kart && git show --summary --pretty='format:"1.6-git-%h" date="%cs"')
sed -i 's/VERSION/'"$NEWVERSION"'/g' AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
sed -i 's/COMMITANDDATE/'"$NEWCOMMITANDDATE"'/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/HOMEPAGELINK/https\:\/\/mb.srb2.org\/addons\/srb2kart.2435\//g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/SOURCELINK/https\:\/\/git.do.srb2.org\/KartKrew\/Kart-Public/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-noassets-x86_64.AppImage.zsync" AppDir srb2kart-noassets-x86_64.AppImage

wget -q https://github.com/STJr/Kart-Public/releases/download/v1.6/AssetsLinuxOnly.zip
mkdir -p AppDir/usr
mkdir -p games/SRB2Kart
unzip AssetsLinuxOnly.zip -d games/SRB2Kart *.kart *.srb mdls*
chmod +w games/SRB2Kart/mdls
cp -r games AppDir/usr

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-x86_64.AppImage.zsync" AppDir srb2kart-x86_64.AppImage


install -Dm755 galaxy/bin/Linux64/Release/lsdl2srb2kart AppDir/usr/bin/srb2kart
install -Dm644 org.srb2.SRB2Kart.desktop AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
install -Dm644 org.srb2.SRB2Kart.metainfo.xml AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

export NEWVERSION=1.6-galaxy-$(cd galaxy && git rev-parse --short HEAD)
export NEWCOMMITANDDATE=$(cd galaxy && git show --summary --pretty='format:"1.6-galaxy-%h" date="%cs"')
sed -i 's/VERSION/'"$NEWVERSION"'/g' AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
sed -i 's/COMMITANDDATE/'"$NEWCOMMITANDDATE"'/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/HOMEPAGELINK/https\:\/\/mb.srb2.org\/addons\/srb2kart-galaxy.4500\//g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/SOURCELINK/https\:\/\/git.do.srb2.org\/Galactice\/Kart-Public/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-galaxy-x86_64.AppImage.zsync" AppDir srb2kart-galaxy-x86_64.AppImage

rm -rf AppDir/usr/games

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-galaxy-noassets-x86_64.AppImage.zsync" AppDir srb2kart-galaxy-noassets-x86_64.AppImage


install -Dm755 HEP/bin/Linux64/Release/lsdl2srb2kart AppDir/usr/bin/srb2kart
install -Dm644 org.srb2.SRB2Kart.desktop AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
install -Dm644 org.srb2.SRB2Kart.metainfo.xml AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

export NEWVERSION=1.6-HEP-$(cd galaxy && git rev-parse --short HEAD)
export NEWCOMMITANDDATE=$(cd HEP && git show --summary --pretty='format:"1.6-HEP-%h" date="%cs"')
sed -i 's/VERSION/'"$NEWVERSION"'/g' AppDir/usr/share/applications/org.srb2.SRB2Kart.desktop
sed -i 's/COMMITANDDATE/'"$NEWCOMMITANDDATE"'/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/HOMEPAGELINK/https\:\/\/mb.srb2.org\/addons\/hayas-expansion-pak.5254\//g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml
sed -i 's/SOURCELINK/https\:\/\/git.do.srb2.org\/haya_\/Kart-Public/g' AppDir/usr/share/metainfo/org.srb2.SRB2Kart.metainfo.xml

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-HEP-noassets-x86_64.AppImage.zsync" AppDir srb2kart-HEP-noassets-x86_64.AppImage

cp -r games AppDir/usr
wget -O AppDir/usr/games/SRB2Kart/snowy_files.kart "https://drive.google.com/uc?export=download&id=1luvNekal7yFMAvwa7sTywaEB1akHFdP3"

./appimagetool-x86_64.AppImage -n -u "gh-releases-zsync|lonsfor|srb2k-appimage|latest|srb2kart-HEP-x86_64.AppImage.zsync" AppDir srb2kart-HEP-x86_64.AppImage
