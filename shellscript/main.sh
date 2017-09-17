#!/usr/bin/env bash
#=======================================#
# Filename: ytuce-file-holder           #
# Description: track files in ytuce     #
# Maintainer: undefined                 #
# License: GPL3.0                       #
# Version: 1.2.0                        #
#=======================================#

### Global Variables ###
NON_PERSONS=("fkord" "ekoord" "fkoord" "skoord" "pkoord" "lkoord" "mevkoord" "mkoord" "BTYLkoord" "tkoord"
             "filiz" "kazim" "sunat" "burak" )
ICONS=("fileicon" "foldericon" # Parola konulmamis dosya ve dizin.
       "passwordfileicon" "passwordfoldericon") # Parolasi olan dosya ve dizin.
DOWNLOADABLE_FILE_EXTENSIONS=("rar" "zip" "gz" # Arsivlenmis ve Sıkıştırılmış dosyalar.
                              "pdf" "doc" "docx" "ppt" "png" "jpg" "jpe" # Dokumanlar ve resimler.
                              "java" "cpp" "c" "asm" "txt") # Kodlar.
PROFILES_URL="https://www.ce.yildiz.edu.tr/subsites"
LINK="https://www.ce.yildiz.edu.tr/personal/"
SETUPPATH="all-ytuce-files"
EXTENSION=""

function get_file_extension() {
    # String icinden nokta uzantili uzantiyi cikariyoruz.
    # Misal soyle bir linkimiz var: "https://www.ce.yildiz.edu.tr/personal/furkan/Hibernate.rar",
    # bu linkin icinden en sagdaki noktanin sagindaki string'i "EXTENSION" degiskenine yaziyoruz.
    # Yani "EXTENSION" degiskenine "rar" yaziyoruz.
    echo "[+] learn_extension_in_string() fonksiyonu calistirildi."
    local link=$1
    EXTENSION=${link##*.}
}
function is_link_a_file() {
    # Linkin indirilebilir bir dosya olup olmadigini kontrol ediyoruz.
    # Ilk linkin uzantisini ogreniyoruz. Sonrasinda Indirilecek dosya olup olmadigini kontrol ediyoruz.
    # Eger indirilecek dosya ise 34 donuyoruz, degil ise 0 donuyoruz.
    # https://superuser.com/questions/195598/test-if-element-is-in-array-in-bash
    echo "[+] is_link_a_file() fonksiyonu calistirildi."
    get_file_extension $1
    if [[ ${DOWNLOADABLE_FILE_EXTENSIONS[$EXTENSION]} ]]; then return 34; fi
    return 0
}
function download_source_code() {
    # Sitenin kaynak kodunu indiriyoruz.
    # "wget" kullandigimizda certificate hatasi aldigimiz icin "--no-check-certificate" parametresi ile kullaniyoruz.
    # https://serverfault.com/questions/409020/how-do-i-fix-certificate-errors-when-running-wget-on-an-https-url-in-cygwin-wind
    echo "[+] download_source_code() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    wget --no-check-certificate $link -O $path/source.html
}
function download_file() {
    # Dosya indiriliyor.
    echo "[+] download_file() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    local filename=${link##*/}
    wget --no-check-certificate $link -O $path/$filename
}
function parse_link() {
  # Kaynak koddan class ismi uyusanlar hedef dosyasina yaziliyor.
  echo "[+] parse_link() fonksiyonu calistirildi."
	local $sourcefile=$1
	local $classname=$2
	local $targetfile=$3
	cat $sourcefile \
      | grep "class=\"$classname\"" \
      | grep -o "$LINK.*><div" \
      | sed 's/"><div class="iconimage"><\/div><div//' \
            >> $targetfile
}
function parse_all_links() {
    # Kaynak Koddan linkleri cikariyoruz.
    # https://stackoverflow.com/questions/229551/string-contains-in-bash
    echo "[+] parse_all_links() fonksiyonu calistirildi."
    local path=$1
    for classname in "${ICONS[@]}"; do
        if [[ $classname == *"password"* ]]; then # "$classname" degiskeninin icinde "password" diye bir string var mi?
            parse_link $path/source.html $classname $path/passwordlinks.txt
        else
            parse_link $path/source.html $classname $path/links.txt
        fi
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
    echo $link $path
    download_source_code $link $path
    parse_all_links $path
    cat $path/links.txt
    for href in $(cat $path/links.txt); do
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
function all_teacher_names() {
    # Sitenin kisiler sayfasinin kaynak kodunu indiriyoruz. Sonra parse ediyoruz.
    # Burdaki tum personal isimleri aliniyor. Sonra hoca olanlar "teachernames.txt" dosyasina ekleniyor.
    echo "[+] all_teacher_names() fonksiyonu calistirildi."
    wget --no-check-certificate $PROFILES_URL -O ~/$SETUPPATH/personalssource.html
    result=$(cat ~/$SETUPPATH/personalssource.html \
                 | grep -o "/personal.*><img" \
                 | sed 's/"><img//' \
                 | sed 's/\/personal\///' \
                 | sort \
                 | uniq )
    for personalname in $result
    do
        if [[ ${NON_PERSONS[$personalname]} ]]; then
            echo "Boyle bir hoca yok!"
        else
            echo "Aynen boyle bir hoca var!"
            echo ${personalname} >> ~/$SETUPPATH/teachernames.txt
        fi
    done
    delete_tmp_file
}
function teacher() {
    # Sadece arguman olarak alinan hoca ismi ile hocanin dosyalari indiriliyor.
    echo "[+] teacher() fonksiyonu calistirildi."
    local teachername=$1
    local teacherlink=${LINK}${teachername}
    mkdir ~/$SETUPPATH/$teachername
    recursive_link_follow $teacherlink/file ~/$SETUPPATH/$teachername
}
function init() {
    # Ilk olarak tum hoca isimleri ogreniliyor("teachernames.txt").
    # Sonrasinda tum hocalarin dosyalari indiriliyor.
    echo "[+] init() fonksiyonu calistirildi."
    mkdir ~/$SETUPPATH
    all_teacher_names
    for teachername in $(cat ~/$SETUPPATH/teachernames.txt); do
        echo "########### Hocanin Ismi: " $teachername
        teacher $teachername
    done
}
function usage() {
    echo "./main.sh "
    echo -e "\t-h --help                  : scriptin kilavuzu."
    echo -e "\t-i --init                  : butun hocalarin dosyalarini sifirdan indir."
    echo -e "\t-t --teacher [HocaninIsmi]  : belli bir hocanin dosyalari indir."
    echo ""
}
function main() {
    local argument=$1
    local teachername=$2
    case "$argument" in
        -h | --help )
            usage
            exit 0
            ;;
        -i | --init )
            init
            ;;
        -t | --teacher )
            teacher $teachername
            ;;
        * )
            echo "Error: unknown parameter \"$1\""
            usage
            exit 1
            ;;
    esac
}

main $@
