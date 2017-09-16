#!/bin/bash

### Global Degiskenler
ICONS=("fileicon" "foldericon" "passwordfileicon" "passwordfoldericon")
MUST_BE_DOWNLOAD=("rar" "pdf" "txt" "c" "zip" "gz" "doc" "docx")
EXTENSION=""
LINK="https://www.ce.yildiz.edu.tr/personal/"
PERSONSLINK="https://www.ce.yildiz.edu.tr/subsites"
SETUPPATH="ceytu"
NON_PERSONS=("fkord" "filiz" "kazim" "ekoord" "fkoord" "skoord" "pkoord" "lkoord" "mevkoord" "mkoord" "sunat" "burak"  "BTYLkoord" "tkoord")

### Fonksiyonlar
function learn_extension_in_string() {
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
    learn_extension_in_string $1
    for ext in ${MUST_BE_DOWNLOAD[@]}
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
# Pdf, rar dosyasini indir.
function download_file() {
    echo "[+] download_file() fonksiyonu calistirildi."
    local link=$1
    wget --no-check-certificate $link
}
function parse_link() {
    # Kaynak Koddan linkleri cikariyoruz.
    echo "[+] parse_link() fonksiyonu calistirildi."
    local path=$1
    cat $path/source.html | grep "class=\"fileicon\"" | grep -o "$LINK.*><div" | sed 's/"><div class="iconimage"><\/div><div//' >> $path/links.txt
    cat $path/source.html | grep "class=\"foldericon\"" | grep -o "$LINK.*><div" | sed 's/"><div class="iconimage"><\/div><div//' >> $path/links.txt
    cat $path/source.html | grep "class=\"passwordfileicon\"" | grep -o "$LINK.*><div" | sed 's/"><div class="iconimage"><\/div><div//' >> $path/passwordlinks.txt
    cat $path/source.html | grep "class=\"passwordfoldericon\"" | grep -o "$LINK.*><div" | sed 's/"><div class="iconimage"><\/div><div//' >> $path/passwordlinks.txt
}
# Gecici dosyalari sil.
function delete_tmp_file() {
    echo "[+] delete_tmp_file() fonksiyonu calistirildi."
    rm source.html links.txt 2> /dev/null
}

# Recursive sekilde linklerin kaynak kodlarindaki linkleri takip edicek.
function recursive_link_follow() {
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
        flag=$?
        echo "Flag: " $flag
        if [ "$flag" = "34" ]; then # Demekki indirilebilir dosya.
            echo "Tmm indir. Panpa! :" $href
            #download_file $href
        else # Demekki baska bir dizine gidiyoruz. Baska bir dizine gectigimiz icin onun dizinini olusturmaliyiz.
            filename=${href##*/}
            mkdir $path/$filename
            recursive_link_follow $href $path/$filename
        fi
    done
}

# Sitenin kisiler sayfasinin kaynak kodunu indiriyoruz. Sonra parse ediyoruz.
function personalslinks() {
    echo "[+] personalslinks() fonksiyonu calistirildi."
    wget --no-check-certificate $PERSONSLINK -O ~/$SETUPPATH/source.html
    result=$(cat ~/$SETUPPATH/source.html | grep -o "/personal.*><img" | sed 's/"><img//' | sed 's/\/personal\///' | sort | uniq )
    for personal in $result
    do
        if [[ " ${NON_PERSONS[*]} " == *"$personal"* ]]
        then
            echo "YES, your arr contains $personal"
        else
            echo "NO, your arr does not contain $personal"
            echo $personal | sed 's/^/https\:\/\/www\.ce\.yildiz\.edu\.tr\/personal\//' >> ~/$SETUPPATH/personalslinks.txt
        fi
    done
}

# Main kisim.
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
