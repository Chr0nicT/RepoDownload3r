#!/bin/bash
clear
echo "[RepoDownload3r] Created By: @Chr0nicT"
echo "[RepoDownload3r] Deleting old files..."
rm -rf debs/ 2>/dev/null
rm -rf Packages 2>/dev/null
read -p "[RepoDownload3r] Repo URL: " url
echo "[RepoDownload3r] Attempting To Grab Packages List From: $url"

wget "$url/Packages" 2>/dev/null

if [ ! -f ./Packages ]; then
    echo "[RepoDownload3r] Packages File Not Found!"
    echo "[RepoDownload3r] Attempting To Grab Packages.bz2 From: $url"
    wget "$url/Packages.bz2" 2>/dev/null
    bzip2 -d Packages.bz2 2>/dev/null
fi
if [ ! -f ./Packages.bz2 ] && [ ! -f ./Packages ]; then
    echo "[RepoDownload3r] Packages.bz2 Not Found!"
    echo "[RepoDownload3r] Attempting To Grab Packages.gz From: $url"
    wget "$url/Packages.gz" 2>/dev/null
    gzip -d Packages.gz 2>/dev/null
fi

if [ -f ./Packages ]; then
    echo "[RepoDownload3r] Parsing Packages File..."
    grep 'Filename: ' Packages | awk -F'Filename: ' '{print $2}' > Packages.pp
    rm Packages
    sed -i -e "s#^#$url#" Packages.pp
    rm Packages.pp-e
    mv Packages.pp Packages
    echo "[RepoDownload3r] Finished Grabbing Package List!"
    echo "[RepoDownload3r] Downloading Files..."
    packages_lines=`cat Packages`
    packages_count=`wc -l Packages | awk '{print $1;}'`
    packages_done=1
    for package in $packages_lines;
    do
        echo "[RepoDownload3r] Downloading Packages $packages_done/$packages_count"
        wget -P ./debs/ $package 2>/dev/null
        let "packages_done++"
    done
    rm Packages
    echo "[RepoDownload3r] Finished! Files Saved Under: debs/"
else
    echo "[RepoDownload3r] Error Getting Packages List!"
    echo "[RepoDownload3r] Is $url A Real Repo?"
    exit 2
fi

exit 2
