#!/bin/bash

### Global Degiskenler
NON_PERSONS=("fkord" "filiz" "kazim" "ekoord" "fkoord" "skoord" "pkoord" "lkoord" "mevkoord" "mkoord" "sunat" "burak"  "BTYLkoord" "tkoord")
ICONS=("fileicon" "foldericon" "passwordfileicon" "passwordfoldericon")
DOWNLOADABLE_FILE_EXTENSIONS=("rar" "zip" "gz" # Arsivlenmis ve Sıkıştırılmış dosyalar.
                              "pdf" "doc" "docx" "ppt" "png" "jpg" "jpe" # Dokumanlar ve resimler.
                              "java" "cpp" "c" "asm" "txt") # Kodlar.
PROFILES_URL="https://www.ce.yildiz.edu.tr/subsites"
LINK="https://www.ce.yildiz.edu.tr/personal/"
SETUPPATH="all-ytuce-files"
EXTENSION=""

function get_file_extension() {
    # String icinden nokta uzantili uzantiyi cikariyoruz. Misal soyle bir linkimiz var: "https://www.ce.yildiz.edu.tr/personal/furkan/Hibernate.rar",
    # bu linkin icinden en sagdaki noktanin sagindaki string'i "EXTENSION" degiskenine yaziyoruz. Yani "EXTENSION" degiskenine "rar" yaziyoruz.
    echo "[+] learn_extension_in_string() fonksiyonu calistirildi."
    local link=$1
    EXTENSION=${link##*.}
}
function is_link_a_file() {
    # Linkin indirilebilir bir dosya olup olmadigini kontrol ediyoruz. Ilk linkin uzantisini ogreniyoruz.
    # Sonrasinda Indirilecek dosya olup olmadigini kontrol ediyoruz. Eger indirilecek dosya ise 34 donuyoruz, degil ise 0 donuyoruz.
    echo "[+] is_link_a_file() fonksiyonu calistirildi."
    get_file_extension $1
    for ext in ${DOWNLOADABLE_FILE_EXTENSIONS[@]}
    do
        if test "$ext" = $EXTENSION; then
            return 34
        fi
    done
    return 0
}
function download_source_code() {
    # Sitenin kaynak kodunu indiriyoruz. "wget" kullandigimizda certificate hatasi aldigimiz icin "--no-check-certificate" parametresi ile kullaniyoruz.
    echo "[+] download_source_code() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    wget --no-check-certificate $link -O $path/source.html
}

function download_file() {
    # Dosyalar indiriliyor.
    echo "[+] download_file() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    local filename=${link##*/}
    wget --no-check-certificate $link -O $path/$filename
}

function parse_link() {
    # Kaynak Koddan linkleri cikariyoruz.
    echo "[+] parse_link() fonksiyonu calistirildi."
    local path=$1
    for i in {0..1}; do
        cat $path/source.html \
            | grep "class=\"${ICONS[$i]}\"" \
            | grep -o "$LINK.*><div" \
            | sed 's/"><div class="iconimage"><\/div><div//' >> $path/links.txt
        cat $path/source.html \
            | grep "class=\"${ICONS[$i+2]}\"" \
            | grep -o "$LINK.*><div" \
            | sed 's/"><div class="iconimage"><\/div><div//' >> $path/passwordlinks.txt
    done
}

function delete_tmp_file() {
    # Gecici dosyalari sil...
    echo "[+] delete_tmp_file() fonksiyonu calistirildi."
    find ~/$SETUPPATH \( -name "source.html" -o -name "links.txt" -o -name "passwordlinks.txt" \) -type f -delete 2> /dev/null
}

function recursive_link_follow() {
    # Recursive sekilde linklerin kaynak kodlarindaki linkleri takip edicek.
    echo "[+] recursive_link_follow() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    local flag=0
    echo $link $path
    download_source_code $link $path
    parse_link $path
    cat $path/links.txt
    for href in $(cat $path/links.txt); do
        # Burda "href" in geri tusu olup olmadigini kontrol etmeliyiz.
        is_link_a_file $href
        if [ "$?" = "34" ]; then # Demekki indirilebilir dosya.
            echo "Tmm indir. Panpa! :" $href
            download_file $href $path
        else # Demekki baska bir dizine gidiyoruz. Baska bir dizine gectigimiz icin onun dizinini olusturmaliyiz.
            filename=${href##*/}
            mkdir $path/$filename
            recursive_link_follow $href $path/$filename
        fi
    done
}

function personalslinks() {
    # Sitenin kisiler sayfasinin kaynak kodunu indiriyoruz. Sonra parse ediyoruz.
    echo "[+] personalslinks() fonksiyonu calistirildi."
    wget --no-check-certificate $PROFILES_URL -O ~/$SETUPPATH/personalssource.html
    result=$(cat ~/$SETUPPATH/personalssource.html \
                 | grep -o "/personal.*><img" \
                 | sed 's/"><img//' \
                 | sed 's/\/personal\///' \
                 | sort \
                 | uniq )
    for personal in $result
    do
        if [[ " ${NON_PERSONS[*]} " == *"$personal"* ]]
        then
            echo "YES, your arr contains $personal"
        else
            echo "NO, your arr does not contain $personal"
            echo ${LINK}${personal} >> ~/$SETUPPATH/personalslinks.txt
        fi
    done
    delete_tmp_file
}

function main() {
    echo "[+] main() fonksiyonu calistirildi."
    mkdir ~/$SETUPPATH
    personalslinks
    for personallink in $(cat ~/$SETUPPATH/personalslinks.txt); do
        echo "##########: " $personallink
        personalname=${personallink##*/}
        mkdir ~/$SETUPPATH/$personalname
        recursive_link_follow $personallink/file ~/$SETUPPATH/$personalname
    done
}

main
