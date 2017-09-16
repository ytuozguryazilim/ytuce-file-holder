# ytuce-file-holder
Her hocanin dosyalari takip eden ve indiren shell script

# Kurulum ve Deneme

```bash
$ git clone https://github.com/GnuYtuce/ytuce-file-holder
$ ### Shellscript'i calistirma
$ cd ytuce-file-holder/shellscript
$ ./main.sh > file.log 2>&1     # file.log  dosyasi olusturulur.
$ ### Python script'ini calistirma
$
```

### Task Listesi!!!
- [X] Repo ismi degistirildi.
- [X] Kisiler sayfasini crawler edip, buradaki linkleri "personslinks.txt" dosyasina kaydetmeliyiz, ama bazi isimleri engellenmeli("fkord filiz kazim ekoord ...").
- [X] Dongu kurarak tum kisilerin dosyalari takip edilmeli.
- [X] Dosyaya veya dizine parola koyuldugunu anlamaliyiz.(Bir usteki div tag'inin class'ina bakarak, parola olup olmadigini anliyoruz. Ve boyle yaparak artik geri tusuna bakmamiz gerekmiyor.)
- [X] "recursive_link_follow()" fonksiyonun icindeki "href" in geri tusu olup olmadigini kontrol etmeliyiz.
- [X] Karsilastirma yapilmali. Dosya takip sisteminde yok ise indirilmeli. Dosya var ise ayni isimdeki dosyayla karsilastirilmali(Suanlik dosya boyutuna gore). Farkli ise indirilerek ve dosya isminin sonuna tarih atilmali.(GIT kullanicaz panpa!)
- [X] Log dosyasina ciktilari yaz.
- [ ] Scripte disardan parametre girilecek sekilde duzenlenicek.(her sayfa veya her dosya indirmede arada belli saniye bekleyecek.)
- [ ] crontab olusturulacak.
- [ ] Her seferinde dosyalari takip etmek icin her sayfayi crawler etmemize gerek yok. 1 kere hepsini indiririz. Zaten takip eden "https://ytuce.maliayas.com/" sitesini takip ederiz.
- [ ] Ayri bir script yazilacak, 'git status' un durumunu kontrol edicek, eger bir degisiklik varsa commit aticak.
- [ ] Bazi hocalar haberler kismina dosyayi koyuyorlar ki her donem sonu silinsin. Ve bir daha ugrasmamak icin. Onun icin haberler kisminida ilerde takip etmeliyiz.
- [ ] Parola konmus dizin ve dosyalari indirmeye calisiriz.
- [X] Shell script ve python la gelistirme olucak. Isteyen 2 sinden birine destek olucak.
- [X] Ayri bir repo acilacak. Ve scriptler calistirilip dosyalar githuba yuklenicek. Ve repoyu github pages olarak sunariz.
