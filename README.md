# ytuce-file-holder

Her hocanin dosyalari takip eden ve indiren script. Suanlik shell script calisiyor.
Yuksek ihtimal sadece shell script gelistirilecek.

# Kurulum ve Deneme

```bash
$ git clone https://github.com/GnuYtuce/ytuce-file-holder
$ mv ytuce-file-holder /usr/bin
$ ytuce-file-holder --update > file.log 2>&1     # file.log  dosyasi olusturulur.
```

# Kullanimi

```bash
$ ytuce-file-holder [-h|--help]     # Bu komutu calistir, parametre kullanimi anlatiliyor.
$ ytuce-file-holder -h
$ ytuce-file-holder --help
```

# Todos

- [ ] Commitler icin Github Botu olusturulmali.
- [ ] Daha Script kolay indirilip kullanilabilir olmali.
- [x] 2 kisima ayir, ilk link adreslerini ve path dosyaya kaydetsin. Sonra indirmeye baslasin.
- [x] Repo ismi degistirildi.
- [x] Kisiler sayfasini crawler edip, buradaki linkleri "personslinks.txt" dosyasina kaydetmeliyiz, ama bazi isimleri engellenmeli("fkord filiz kazim ekoord ...").
- [x] Dongu kurarak tum kisilerin dosyalari takip edilmeli.
- [x] Dosyaya veya dizine parola koyuldugunu anlamaliyiz.(Bir usteki div tag'inin class'ina bakarak, parola olup olmadigini anliyoruz. Ve boyle yaparak artik geri tusuna bakmamiz gerekmiyor.)
- [x] "recursive_link_follow()" fonksiyonun icindeki "href" in geri tusu olup olmadigini kontrol etmeliyiz.
- [x] Karsilastirma yapilmali. Dosya takip sisteminde yok ise indirilmeli. Dosya var ise ayni isimdeki dosyayla karsilastirilmali(Suanlik dosya boyutuna gore). Farkli ise indirilerek ve dosya isminin sonuna tarih atilmali.(GIT kullanicaz panpa!)
- [x] Log dosyasina ciktilari yaz.
- [ ] crontab olusturulacak.
- [ ] Her seferinde dosyalari takip etmek icin her sayfayi crawler etmemize gerek yok. 1 kere hepsini indiririz. Zaten takip eden "https://ytuce.maliayas.com/" sitesini takip ederiz. Belki site sadece hocalarin haberleri takip ediyordur.?
- [ ] Bazi hocalar haberler kismina dosyayi koyuyorlar ki her donem sonu silinsin. Ve bir daha ugrasmamak icin. Onun icin haberler kisminida ilerde takip etmeliyiz.
- [x] Ayri bir script yazilacak, 'git status' un durumunu kontrol edicek, eger bir degisiklik varsa commit aticak.(https://github.com/GnuYtuce/all-ytuce-files/blob/master/automatic-checking-changes.sh)
- [ ] Parola konmus dizin ve dosyalari indirmeye calisiriz.
- [x] Shell script ve python la gelistirme olucak. Isteyen 2 sinden birine destek olucak.
- [x] Ayri bir repo acilacak. Ve scriptler calistirilip dosyalar githuba yuklenicek. Ve repoyu github pages olarak sunariz.
- [ ] Scripte disardan parametre girilecek sekilde duzenlenicek.(her sayfa veya her dosya indirmede arada belli saniye bekleyecek.)
- [x] Script 3 is yapmali: 1.olarak tum kisilerin dosyalari indirmek, 2.ci olarak sadece belli bir kisiyinin dosyalari indirmek, 3.ci olarak dosyalari update etmek(yeni links.txt degisiklige gore.).
- [x] Diger repoya .gitignore eklenmeli: personalslinks.txt, source.html, links.txt, passwordlinks.txt dosyalari takip etmemeli.
- [ ] Belki hoca gecen seneki dosyanin aynisini bu sene farkli bir klasor attinda yuklerse onu farketmeliyiz. Ve indirmemeliyiz.
- [ ] Scriptin devamli calisabilecegi veya gun icinde belli bir zamanda calismasini saglayacak uygun ortam sagla. En az 5 gb yer olmasi lazim, ilerde dosya boyutu buyuyebilir.
