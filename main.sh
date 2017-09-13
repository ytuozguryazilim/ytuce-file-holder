#!/bin/bash

# Global Degiskenler
LINK="https://www.ce.yildiz.edu.tr/personal/furkan"
FileLink=$LINK/file

# Sitenin kaynak kodunu indiriyoruz. Certificate hatasi aldigimiz icin bu parametreyi kullaniyoruz.
wget --no-check-certificate $FileLink -O source.html

# Kaynak Koddan linkleri cikariyoruz.
cat source.html | grep -o "$FileLink.*><div" | sed 's/"><div class="iconimage"><\/div><div//' > links.txt

cat links.txt
