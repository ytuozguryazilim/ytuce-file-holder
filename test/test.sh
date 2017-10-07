#!/usr/bin/env bash
source ../shellscript/util.sh
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

function test_get_all_teacher_names_then_save() {
    # get_all_teacher_name_then_save fonksiyonu test
    # Test etmek icin "teachernames.txt" dosyasina ihtiyacimiz var.
    if [[ -e ~/$SETUPPATH/teachernames.txt ]]; then
        mv ~/$SETUPPATH/teachernames.txt ~/$SETUPPATH/oldteachernames.txt
        get_all_teacher_names_then_save
        diff ~/$SETUPPATH/teachernames.txt ~/$SETUPPATH/oldteachernames.txt
        if [[ "$?" = "0" ]]; then
            echo "[+] 2 dosyada ayni oldugu icin dogru calisiyor."
        else
            echo "[-] 2 dosyada farklidir."
        fi
        return 0
    else
        echo "Uzgunuz. 'teachernames.txt' dosyasi olmasi gerekiyor."
        return 1
    fi
}

echo "[+++++] Test file"
test_is_link_a_file
