#!/bin/bash

# Global Degiskenler
FLAG=0
MUST_BE_DOWNLOAD=("rar" "pdf")
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

# Linkleri kontrol ediyoruz. Eger icinde indirilecek uzanti varsa indiriyoruz.
# Yoksa icindeki diger linklere gidiyoruz. Suanlik ilk sayfadaki dosyayi indiricez.
for link in `cat links.txt`
do
    learn_extension_in_string $link
    FLAG=0
    for ext in ${MUST_BE_DOWNLOAD[@]}
    do
        if test "$ext" = $EXTENSION; then
            FLAG=1
        fi
    done
    if [ "$FLAG" = "1" ]
    then
        echo "Tmm indir, panpa"
        echo $link
        wget --no-check-certificate $link
    fi
done
