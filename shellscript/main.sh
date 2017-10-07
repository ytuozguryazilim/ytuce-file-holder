#!/usr/bin/env bash
#=======================================#
# Filename: ytuce-file-holder           #
# Description: track files in ytuce     #
# Maintainer: undefined                 #
# License: GPL3.0                       #
# Version: 2.0.0                        #
#=======================================#
source ./util.sh
function main() {
    local argument=$1
    local teachername=$2
    case "$argument" in
        -h | --help )
            usage; exit 0
        ;;
        -i | --init )
            init
        ;;
        -t | --teacher )
            teacher $teachername "init"
            [[ "$?" = "1" ]] && echo "Boyle bir hoca yok!"
        ;;
        --all-teacher-names )
            get_all_teacher_names_then_save
        ;;
        -u | --update )
            update
        ;;
        -c | --control )
            control
        ;;
        --test )
            test_is_link_a_file
        ;;
        -f | --feature )
            make_unique_lines_all_teachers
        ;;
        * )
            echo "Error: unknown parameter \"$1\""
            usage
            exit 1
        ;;
    esac
}

main $@
