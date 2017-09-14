#!/bin/bash

### Global Degiskenler
MUST_BE_DOWNLOAD=("rar" "pdf" "txt" "c" "zip" "gz")
EXTENSION=""
LINK="https://www.ce.yildiz.edu.tr/personal/furkan"
SETUPPATH="ceytu"

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
    local path=$2
    wget --no-check-certificate $link -O $path/source.html
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
    local path=$1
    cat $path/source.html | grep -o "$LINK.*><div" | sed 's/"><div class="iconimage"><\/div><div//' > $path/links.txt
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

# Recursive sekilde linklerin kaynak kodlarindaki linkleri takip edicek.
function recursive_link_follow() {
    echo "[+] recursive_link_follow() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    echo $link $path
    download_source_code $link $path
    parse_link $path
    cat $path/links.txt
    for href in $(cat $path/links.txt); do
        # Burda "href" in geri tusu olup olmadigini kontrol etmeliyiz.
        is_link_a_file $href
        if [ "$?" = "1" ]; then # Demekki indirilebilir dosya.
            echo "Tmm indir. Panpa! :" $href
            #download_file $href
        else # Demekki baska bir dizine gidiyoruz. Baska bir dizine gectigimiz icin onun dizinini olusturmaliyiz.
            filename=${href##*/}
            mkdir $path/$filename
            recursive_link_follow $href $path/$filename
        fi
    done
}

# Main kisim.
function main() {
    echo "[+] main() fonksiyonu calistirildi."
    personalname=${LINK##*/}
    mkdir -p ~/$SETUPPATH/$personalname
    recursive_link_follow $LINK/file ~/$SETUPPATH/$personalname
    #delete_tmp_file
}

main
