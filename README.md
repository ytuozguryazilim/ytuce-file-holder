# ytuce-file-holder

Her hocanin dosyalari takip eden ve indiren script. Suanlik shell script calisiyor.
Yuksek ihtimal sadece shell script gelistirilecek.

# Kurulum

```bash
$ sudo git clone https://github.com/GnuYtuce/ytuce-files.git /opt/ytuce-files
$ sudo chown -R $USER /opt/ytuce-files
$ git clone https://github.com/GnuYtuce/ytuce-file-holder /tmp/ytuce-file-holder
$ sudo mv /tmp/ytuce-file-holder/ytuce-file-holder.sh /usr/bin
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
- [ ] Script daha kolay indirilip kullanilabilir olmali.
- [x] 2 kisima ayir(update, upgrade), ilk link adreslerini ve path'leri dosyaya kaydetsin. Sonra indirmeye baslasin.
- [x] Karsilastirma yapilmali. Dosya takip sisteminde yok ise indirilmeli. Dosya var ise ayni isimdeki dosyayla karsilastirilmali(Suanlik dosya boyutuna gore). Farkli ise indirilerek ve dosya isminin sonuna tarih atilmali.(GIT kullanicaz panpa!)
- [ ] crontab olusturulacak.
- [ ] Her seferinde dosyalari takip etmek icin her sayfayi crawler etmemize gerek yok. 1 kere hepsini indiririz. Zaten takip eden "https://ytuce.maliayas.com/" sitesini takip ederiz. Belki site sadece hocalarin haberleri takip ediyordur.?
- [ ] Bazi hocalar haberler kismina dosyayi koyuyorlar ki her donem sonu silinsin. Ve bir daha ugrasmamak icin. Onun icin haberler kisminida ilerde takip etmeliyiz.
- [ ] Parola konmus dizin ve dosyalari indirmeye calisiriz.
- [ ] Scripte disardan parametre girilecek sekilde duzenlenicek.(her sayfa veya her dosya indirmede arada belli saniye bekleyecek.)
- [ ] Belki hoca gecen seneki dosyanin aynisini bu sene farkli bir klasor attinda yuklerse onu farketmeliyiz. Ve indirmemeliyiz.
- [ ] Scriptin devamli calisabilecegi veya gun icinde belli bir zamanda calismasini saglayacak uygun ortam sagla. En az 5 gb yer olmasi lazim, ilerde dosya boyutu buyuyebilir.
