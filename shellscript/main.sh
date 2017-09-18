#!/usr/bin/env bash
#=======================================#
# Filename: ytuce-file-holder           #
# Description: track files in ytuce     #
# Maintainer: undefined                 #
# License: GPL3.0                       #
# Version: 1.4.0                        #
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
FILENAME=""
DIRNAME=""

function delete_tmp_file() {
    # Gecici dosyalari sil...
    echo "[+] delete_tmp_file() fonksiyonu calistirildi."
    find ~/$SETUPPATH \( -name "source.html" -o -name "links.txt" -o -name "passwordlinks.txt" \) -type f -delete 2> /dev/null
}
function download_file() {
    # Dosya indiriliyor.
    echo "[+] download_file() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    wget --no-check-certificate $link -O $path
}
function test_is_link_a_file() {
    local testinputs=("https://www.ce.yildiz.edu.tr/personal/furkan/Hibernate.rar"
                      "https://www.ce.yildiz.edu.tr/personal/furkan/Bbg2")
    for testinput in "${testinputs[@]}" ;do
        echo "$testinput linkinin sonucu: "
        is_link_a_file $testinput
        if [[ "$?" = "34" ]]; then
            echo "True"
        else
            echo "False"
        fi
    done
}
function is_link_a_file() {
    # Linkin indirilebilir bir dosya olup olmadigini kontrol ediyoruz.
    # Ilk linkin uzantisini ogreniyoruz. String icinden nokta uzantili uzantiyi cikariyoruz.
    # Misal soyle bir linkimiz var: "https://www.ce.yildiz.edu.tr/personal/furkan/Hibernate.rar",
    # bu linkin icinden en sagdaki noktanin sagindaki string'i "extension" degiskenine yaziyoruz.
    # Yani "extension" degiskenine "rar" yaziyoruz.
    # Sonrasinda Indirilecek dosya olup olmadigini kontrol ediyoruz.
    # Eger indirilecek dosya ise 34 donuyoruz, degil ise 0 donuyoruz.
    # https://stackoverflow.com/questions/14366390/check-if-an-element-is-present-in-a-bash-array
    echo "[+] is_link_a_file() fonksiyonu calistirildi."
    local link=$1
    local extension=${link##*.}
    if [[ " ${DOWNLOADABLE_FILE_EXTENSIONS[@]} " = *" $extension "* ]]; then return 34; fi
    return 0
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
    local sourcefilename=$2
    local linksfilename=$3
    local passwordlinksfilename=$4
    for classname in "${ICONS[@]}"; do
        if [[ $classname == *"password"* ]]; then # "$classname" degiskeninin icinde "password" diye bir string var mi?
            parse_link $path/$sourcefilename $classname $path/$passwordlinksfilename
        else
            parse_link $path/$sourcefilename $classname $path/$linksfilename
        fi
    done
}
function download_source_code() {
    # Linkin kaynak kodunu indiriyoruz.
    # "wget" kullandigimizda certificate hatasi aldigimiz icin "--no-check-certificate" parametresi ile kullaniyoruz.
    # https://serverfault.com/questions/409020/how-do-i-fix-certificate-errors-when-running-wget-on-an-https-url-in-cygwin-wind
    echo "[+] download_source_code() fonksiyonu calistirildi."
    local link=$1
    local path=$2
    wget --no-check-certificate $link -O $path
}
function recursive_link_follow() {
    # Recursive sekilde linklerin kaynak kodlarindaki linkleri takip edicek.
    echo "[+] recursive_link_follow() fonksiyonu calistirildi."
    local commandname=$1
    local teachername=$2
    local link=$3
    local path=$4
    download_source_code $link $path/source.html
    parse_all_links $path source.html links.txt passwordlinks.txt
    cat $path/links.txt
    for href in $(cat $path/links.txt); do
        is_link_a_file $href
        FILENAME=${href##*/}
        DIRNAME=${href##*/}
        if [ "$?" = "34" ]; then # Demekki indirilebilir dosya.
            echo "Tmm indir. Panpa! :" $href
            if [[ "$commandname" == "init" ]]; then
                echo $path/$FILENAME $href >> ~/$SETUPPATH/$teachername/filelist.txt
                download_file $href $path/$FILENAME
            else if [[ "$commandname" == "update" ]]; then
                echo $path/$FILENAME $href >> ~/$SETUPPATH/$teachername/updatefilelist.txt
            fi
        else # Demekki baska bir dizine gidiyoruz. Baska bir dizine gectigimiz icin onun dizinini olusturmaliyiz.
            mkdir $path/$DIRNAME
            recursive_link_follow $commandname $teachername $href $path/$DIRNAME
        fi
    done
}
function teacher() {
    # Sadece arguman olarak alinan hoca ismi ile hocanin dosyalari indiriliyor.
    echo "[+] teacher() fonksiyonu calistirildi."
    local teachername=$1
    local teacherlink=${LINK}${teachername}
    local teacherpath=~/$SETUPPATH/$teachername
    local commandname=$2
    [[ grep "^${teachername}$" ~/$SETUPPATH/teachernames.txt ]] || return 1 # Argumanin hoca olup olmadigini kontrol ediliyor.
    echo $teachername $teacherlink $teacherpath
    mkdir $teacherpath
    if [[ "$commandname" == "init" ]]; then
        touch $teacherpath/filelist.txt
    else if [[ "$commandname" == "update" ]]; then
        touch $teacherpath/updatefilelist.txt
    fi
    recursive_link_follow $commandname $teachername $teacherlink/file $teacherpath
}
function all_teacher_names() {
    # Sitenin kisiler sayfasinin kaynak kodunu indiriyoruz. Sonra parse ediyoruz.
    # Burdaki tum personal isimleri aliniyor. Sonra hoca olanlar "teachernames.txt" dosyasina ekleniyor.
    echo "[+] all_teacher_names() fonksiyonu calistirildi."
    download_source_code $PROFILES_URL ~/$SETUPPATH/personalssource.html
    result=$(cat ~/$SETUPPATH/personalssource.html \
                 | grep -o "/personal.*><img" \
                 | sed 's/"><img//' \
                 | sed 's/\/personal\///' \
                 | sort \
                 | uniq )
    for personalname in $result
    do
        if [[ ! " ${NON_PERSONS[*]} " == *" $personalname "* ]]; then
            # echo "Aynen boyle bir hoca var!: $personalname"
            echo ${personalname} >> ~/$SETUPPATH/teachernames.txt
        fi
    done
}
function init() {
    # Ilk olarak tum hoca isimleri ogreniliyor("teachernames.txt").
    # Sonrasinda tum hocalarin dosyalari indiriliyor.
    echo "[+] init() fonksiyonu calistirildi."
    mkdir ~/$SETUPPATH
    all_teacher_names
    for teachername in $(cat ~/$SETUPPATH/teachernames.txt); do
        echo "########### Hocanin Ismi: " $teachername
        teacher $teachername "init"
        if [[ "$?" = "1" ]]; then
            echo "Boyle bir hoca yok!"
        fi
    done
}

function update() {
    # Butun hocalarin dosyalarini guncellenir.
    echo "[+] update() fonksiyonu calistirildi."
    for teachername in $(cat ~/$SETUPPATH/teachernames.txt); do
        echo "########### Hocanin Ismi: " $teachername
        teacher $teachername "update"
        if [[ "$?" = "1" ]]; then
            echo "Boyle bir hoca yok!"
        fi
        # Burda updatefilelist.txt ve filelist.txt karsilastiracagiz.
        # Farkli olan link ve dosyalari indiricez. Ve filelist.txt dosyasina ekleyecegiz.
        # Sonrasinda updatefilelist.txt dosyasini silicez.
    done
}
function usage() {
    echo "./main.sh "
    echo -e "\t-h --help                  : scriptin kilavuzu."
    echo -e "\t-i --init                  : butun hocalarin dosyalarini sifirdan indir."
    echo -e "\t-t --teacher [HocaninIsmi] : belli bir hocanin dosyalari indir."
    echo -e "\t--all-teacher-names        : butun hoca isimleri teachernames.txt dosyasina kaydeder."
    echo -e "\t-u --uptate                : hocalarin dosyalari guncellenir."
    echo -e "\t--test                     : test fonksiyonlar calistirilir."
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
            if [[ "$?" = "1" ]]; then
                echo "Boyle bir hoca yok!"
            fi
            ;;
        -u | --update )
            update
            if [[ "$?" = "1" ]]; then
                echo "Boyle bir hoca yok!"
            fi
            ;;
        --test )
            test_is_link_a_file
            ;;
        * )
            echo "Error: unknown parameter \"$1\""
            usage
            exit 1
            ;;
    esac
}

main $@
