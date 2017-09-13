#!/bin/bash


# Global Degiskenler
EXTENSION=""
LINK="https://www.ce.yildiz.edu.tr/personal/furkan"
FileLink=$LINK/file


# Fonksiyonlar
function learn_extension_in_string() {  # String icinden nokta uzantili uzantiyi cikariyoruz.
    local link=$1
    EXTENSION=${link##*.}
}

# Sitenin kaynak kodunu indiriyoruz. Certificate hatasi aldigimiz icin bu parametreyi kullaniyoruz.
wget --no-check-certificate $FileLink -O source.html

# Kaynak Koddan linkleri cikariyoruz.
cat source.html | grep -o "$FileLink.*><div" | sed 's/"><div class="iconimage"><\/div><div//' > links.txt

for link in `cat links.txt`
do
    learn_extension_in_string $link
    echo $EXTENSION
done
