#!/bin/bash

### Global Degiskenler
MUST_BE_DOWNLOAD=("rar" "pdf")
EXTENSION=""
LINK="https://www.ce.yildiz.edu.tr/personal/furkan/file"


### Fonksiyonlar
# String icinden nokta uzantili uzantiyi cikariyoruz.
function learn_extension_in_string() {
    echo "[+] learn_extension_in_string() fonksiyonu calistirildi."
    local link=$1
    EXTENSION=${link##*.}
}
# Sitenin kaynak kodunu indiriyoruz. Certificate hatasi aldigimiz icin bu parametreyi kullaniyoruz.
function download_source_code() {
    echo "[+] download_source_code() fonksiyonu calistirildi."
    local link=$1
    wget --no-check-certificate $link -O source.html
}

# Pdf, rar dosyasini indir.
function download_file() {
    echo "[+] download_file() fonksiyonu calistirildi."
    local link=$1
    wget --no-check-certificate $link
}

# Kaynak Koddan linkleri cikariyoruz.
function parse_link() {
    echo "[+] parse_link() fonksiyonu calistirildi."
    local link=$1
    cat source.html | grep -o "$link.*><div" | sed 's/"><div class="iconimage"><\/div><div//' > links.txt
}

# Gecici dosyalari sil.
function delete_tmp_file() {
    echo "[+] delete_tmp_file() fonksiyonu calistirildi."
    rm source.html links.txt 2> /dev/null
}

# Linkin indirilebilir bir dosya oldugunu kontrol ediyoruz.
function is_link_a_file() {
    echo "[+] is_link_a_file() fonksiyonu calistirildi."
    local flag=0
    learn_extension_in_string $1
    for ext in ${MUST_BE_DOWNLOAD[@]}
    do
        if test "$ext" = $EXTENSION; then
            flag=1
        fi
    done
    return $flag
}

# Main kisim.
function main() {
    echo "[+] main() fonksiyonu calistirildi."
    download_source_code $LINK
    parse_link $LINK
    # Linkleri kontrol ediyoruz. Eger icinde indirilecek uzanti varsa indiriyoruz.
    # Yoksa icindeki diger linklere gidiyoruz. Suanlik ilk sayfadaki dosyayi indiricez.
    for link in `cat links.txt`
    do
        is_link_a_file $link
        if [ "$?" = "1" ]
        then
            echo "Tmm indir, panpa"
            echo $link
            download_file $link
        fi
    done
    delete_tmp_file
}

main
