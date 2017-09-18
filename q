[1mdiff --git a/shellscript/main.sh b/shellscript/main.sh[m
[1mindex 2a561d7..7450f8c 100755[m
[1m--- a/shellscript/main.sh[m
[1m+++ b/shellscript/main.sh[m
[36m@@ -166,28 +166,43 @@[m [mfunction init() {[m
         fi[m
     done[m
 }[m
[31m-function update_teacher_files() {[m
[31m-    # Bir hocanin dosyalari gunceller. Guncellerken links sayisinda degisiklige bakmali(Ama en icten baslamali).[m
[31m-    echo "[+] update_teacher_files() fonksiyonu calistirildi."[m
[32m+[m[32mfunction recursive_teacher_files_follow() {[m
[32m+[m[32m    # Recursive sekilde linklerin kaynak kodlarindaki linkleri takip edicek.[m
[32m+[m[32m    echo "[+] recursive_link_follow() fonksiyonu calistirildi."[m
     local teachername=$1[m
[31m-    local teacherlink=${LINK}${teachername}[m
[31m-    local teacherpath=~/$SETUPPATH/$teachername[m
[31m-    [[ grep "^${teachername}$" ~/$SETUPPATH/teachernames.txt ]] || return 1 # Argumanin hoca olup olmadigini kontrol ediliyor.[m
[31m-    echo $teachername $teacherlink $teacherpath[m
[31m-    download_source_code $teacherlink/file $teacherpath/source.html[m
[31m-    parse_all_links $teacherpath source.html newlinks.txt passwordlinks.txt[m
[31m-    # recursive_update_files[m
[31m-    # newlinks.txt ve links.txt karsilastirilacak.[m
[32m+[m[32m    local path=$2[m
[32m+[m[32m    local link=$3[m
[32m+[m[32m    local FILENAME=""[m
[32m+[m[32m    local DIRNAME=""[m
[32m+[m[32m    download_source_code $link/file $path/source.html[m
[32m+[m[32m    parse_all_links $path source.html links.txt passwordlinks.txt[m
[32m+[m[32m    cat $path/$linksfilename[m
[32m+[m[32m    for href in $(cat $path/$linksfilename); do[m
[32m+[m[32m        is_link_a_file $href[m
[32m+[m[32m        FILENAME=${href##*/}[m
[32m+[m[32m        DIRNAME=${href##*/}[m
[32m+[m[32m        if [ "$?" = "34" ]; then # Demekki indirilebilir dosya.[m
[32m+[m[32m            echo $path/$FILENAME $href >> ~/$SETUPPATH/$teachername/updatefilelist.txt[m
[32m+[m[32m        else # Demekki baska bir dizine gidiyoruz. Baska bir dizine gectigimiz icin onun dizinini olusturmaliyiz.[m
[32m+[m[32m            recursive_teacher_files_follow $teachername $path/$DIRNAME $href[m
[32m+[m[32m        fi[m
[32m+[m[32m    done[m
 }[m
 function update() {[m
     # Butun hocalarin dosyalarini gunceller.[m
     echo "[+] update() fonksiyonu calistirildi."[m
[32m+[m[32m    local teachername=""[m
[32m+[m[32m    local teacherlink=""[m
[32m+[m[32m    local teacherpath=""[m
     for teachername in $(cat ~/$SETUPPATH/teachernames.txt); do[m
         echo "########### Hocanin Ismi: " $teachername[m
[31m-        update_teacher_files $teachername[m
[31m-        if [[ "$?" = "1" ]]; then[m
[31m-            echo "Boyle bir hoca yok!"[m
[31m-        fi[m
[32m+[m[32m        teacherlink=${LINK}${teachername}[m
[32m+[m[32m        teacherpath=~/$SETUPPATH/$teachername[m
[32m+[m[32m        [[ grep "^${teachername}$" ~/$SETUPPATH/teachernames.txt ]] || return 1 # Argumanin hoca olup olmadigini kontrol ediliyor.[m
[32m+[m[32m        echo $teachername $teacherlink $teacherpath[m
[32m+[m[32m        touch ~/$teacherpath/updatefilelist.txt[m
[32m+[m[32m        recursive_teacher_files $teachername $teacherlink $teacherpath[m
[32m+[m[32m        # Burda updatefilelist.txt ve filelist.txt karsilastiracagiz.[m
     done[m
 }[m
 function usage() {[m
[36m@@ -217,6 +232,9 @@[m [mfunction main() {[m
             ;;[m
         -u | --update )[m
             update[m
[32m+[m[32m            if [[ "$?" = "1" ]]; then[m
[32m+[m[32m                echo "Boyle bir hoca yok!"[m
[32m+[m[32m            fi[m
             ;;[m
         --test )[m
             test_is_link_a_file[m
