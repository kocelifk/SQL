https://medium.com/@kocelifk/sql-b3648218d30f

--Şirketimizde halen çalışmaya devam eden çalışanları nlistesini getiren sorgu hangisidir? 
--Not:İşten çıkış tarihi boş olanlar çalışmaya devam eden çalışanlardır.
SELECT * FROM PERSON WHERE OUTDATE IS NULL


--Şirketimizde departman bazlı halen çalışmaya devam eden çalışan sayısını getiren sorguyu yazınız?

SELECT DEPARTMENT AS DEPARTMAN_ADI, COUNT(PERSON.ID) AS WORKER_PERSON_COUNT FROM PERSON
INNER JOIN DEPARTMENT D ON D.ID = PERSON.DEPARTMENTID  --person ve departman tablolarının bağlanması
WHERE PERSON.OUTDATE IS NULL --halen çalışmaya devam etmesi
GROUP BY DEPARTMENT --departman bazlı

--Şirketimizde departman bazlı halen çalışmaya devam KADIN ve ERKEK sayılarını getiren sorguyu yazınız.

SELECT *, -- Departman adını getirmesi için * 
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='E' AND  OUTDATE IS NULL) AS ERKEK_SAYISI, --halen çalışmaya devam eden erkek sayısı
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='K' AND  OUTDATE IS NULL) AS KADIN_SAYISI --halen çalışmaya devam eden kadın sayısı
FROM DEPARTMENT


--Şirketimizin Planlama departmanına yeni bir şef ataması yapıldı ve maaşını belirlemek istiyoruz.
--Planlama departmanı içi nminimum, maximum ve ortalama şef maaşı getiren sorgu hangisidir? (Not:işten çıkmış olan personel maaşları da dahildir.)

SELECT POSITION.POSITION AS POZİSYON , MIN(PERSON.SALARY) AS MİNİMUM_MAAS,
MAX(PERSON.SALARY) AS MAXIMUM_MAAS,
AVG(PERSON.SALARY) AS ORTALAMA_MAAS
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
WHERE POSITION = 'PLANLAMA ŞEFİ'
GROUP BY POSITION.POSITION


--Her bir pozisyonda mevcut halde çalışanlar olarak kaç kişi ve ortalama maaşlarının ne kadar olduğunu listelettirmek istiyoruz. 
--Sonucu getiren sorguyu yazınız.
SELECT POSITION AS POZİSYON, COUNT(*) AS KİSİ_SAYISI, AVG(PERSON.SALARY) AS ORTALAMA_MAAS 
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
GROUP BY POSITION ORDER BY KİSİ_SAYISI


--Yıllara göre işe alınan personel sayısını kadın ve erkek bazında listelettiren sorguyu yazınız.

SELECT DISTINCT YEAR(PERSONTABLE.INDATE) YIL,  --INDATE: işe giriş tarihi; DISTINCT eklenmediği durumda aynı yılı birden fazla kez gösteriyor
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E'AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS ERKEK_SAYISI,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS KADIN_SAYISI
FROM PERSON PERSONTABLE ORDER BY YIL



--Maaş ortalaması 5.500 TL’den fazla olan departmanları listeleyecek sorguyu yazınız. 

SELECT DEPARTMENT, AVG(PERSON.SALARY) AS ORTALAMA_MAAS FROM DEPARTMENT INNER JOIN PERSON ON PERSON.DEPARTMENTID = DEPARTMENT.ID
GROUP BY DEPARTMENT.DEPARTMENT -- departman adına göre 
HAVING AVG(PERSON.SALARY) > 5500 --maaş ortalaması 5500 den fazla


--Her personelin adını, pozisyonunu bağlı olduğu birim yöneticisinin adını ve pozisyonunu yönetici pozisyonunu getiren sorguyu yazınız.
SELECT 
PER2.NAME_ + ' ' + PER2.SURNAME AS PERSONEL_AD_SOYAD, POS1.POSITION AS PERSONEL_POZISYON,
PER1.NAME_ + ' ' + PER1.SURNAME AS YÖNETİCİ_ADI ,POS2.POSITION AS YÖNETİCİ_POZİSYONU
FROM PERSON PER2
INNER JOIN POSITION POS1 ON POS1.ID = PER2.POSITIONID --personelin pozisyonu
INNER JOIN PERSON PER1 ON PER2.MANAGERID = PER1.ID --personelin yöneticisi
INNER JOIN POSITION POS2 ON POS2.ID = PER1.POSITIONID --personelin yöneticisinin pozisyonu
ORDER BY PERSONEL_AD_SOYAD

--Departmanların ortalama kıdemini ay olarak hesaplayacak sorguyu yazınız. 


SELECT  DEPARTMENT, AVG(WORKINGTIME) AS AYLIK_KIDEM
FROM
(
SELECT DEPARTMENT,

CASE WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH, INDATE, OUTDATE) --ay bazında işe giriş ve işten çıkış(işten çıkmış olanları seçerek) kıdem hesaplamak
ELSE DATEDIFF (MONTH,INDATE,GETDATE())-- ay bazından işe giriş tarihinden bugünün zamanını(işten çıkmamışları hesaplamak için) baz alarak kıdem hesaplamak

END AS WORKINGTIME --aylık kıdem hesaplama sonucunu working time değişkenine atamak
FROM PERSON INNER JOIN DEPARTMENT ON PERSON.DEPARTMENTID = DEPARTMENT.ID) T GROUP BY DEPARTMENT

