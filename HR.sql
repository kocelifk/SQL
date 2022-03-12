--2. Þirketimizde halen çalýþmaya devam eden çalýþanlarý nlistesini getiren sorgu hangisidir? 
--Not:Ýþten çýkýþ tarihi boþ olanlar çalýþmaya devam eden çalýþanlardýr.
SELECT * FROM PERSON WHERE OUTDATE IS NULL


--3. Þirketimizde departman bazlý halen çalýþmaya devam eden çalýþan sayýsýný getiren sorguyu yazýnýz?

SELECT DEPARTMENT AS DEPARTMAN_ADI, COUNT(PERSON.ID) AS WORKER_PERSON_COUNT FROM PERSON
INNER JOIN DEPARTMENT D ON D.ID = PERSON.DEPARTMENTID  --person ve departman tablolarýnýn baðlanmasý
WHERE PERSON.OUTDATE IS NULL --halen çalýþmaya devam etmesi
GROUP BY DEPARTMENT --departman bazlý

--4. Þirketimizde departman bazlý halen çalýþmaya devam KADIN ve ERKEK sayýlarýný getiren sorguyu yazýnýz.

SELECT *, -- Departman adýný getirmesi için * 
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='E' AND  OUTDATE IS NULL) AS ERKEK_SAYISI, --halen çalýþmaya devam eden erkek sayýsý
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='K' AND  OUTDATE IS NULL) AS KADIN_SAYISI --halen çalýþmaya devam eden kadýn sayýsý
FROM DEPARTMENT


--5. Þirketimizin Planlama departmanýna yeni bir þef atamasý yapýldý ve maaþýný belirlemek istiyoruz.
--Planlama departmaný içi nminimum, maximum ve ortalama þef maaþý getiren sorgu hangisidir? (Not:iþten çýkmýþ olan personel maaþlarý da dahildir.)

SELECT POSITION.POSITION AS POZÝSYON , MIN(PERSON.SALARY) AS MÝNÝMUM_MAAS,
MAX(PERSON.SALARY) AS MAXIMUM_MAAS,
AVG(PERSON.SALARY) AS ORTALAMA_MAAS
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
WHERE POSITION = 'PLANLAMA ÞEFÝ'
GROUP BY POSITION.POSITION


--6. Her bir pozisyonda mevcut halde çalýþanlar olarak kaç kiþi ve ortalama maaþlarýnýn ne kadar olduðunu listelettirmek istiyoruz. 
--Sonucu getiren sorguyu yazýnýz.
SELECT POSITION AS POZÝSYON, COUNT(*) AS KÝSÝ_SAYISI, AVG(PERSON.SALARY) AS ORTALAMA_MAAS 
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
GROUP BY POSITION ORDER BY KÝSÝ_SAYISI


--7.Yýllara göre iþe alýnan personel sayýsýný kadýn ve erkek bazýnda listelettiren sorguyu yazýnýz.

SELECT DISTINCT YEAR(PERSONTABLE.INDATE) YIL,  --INDATE: iþe giriþ tarihi; DISTINCT eklenmediði durumda ayný yýlý birden fazla kez gösteriyor
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E'AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS ERKEK_SAYISI,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS KADIN_SAYISI
FROM PERSON PERSONTABLE ORDER BY YIL




--8. Maaþ ortalamasý 5.500 TL’den fazla olan departmanlarý listeleyecek sorguyu yazýnýz. 

SELECT DEPARTMENT, AVG(PERSON.SALARY) AS ORTALAMA_MAAS FROM DEPARTMENT INNER JOIN PERSON ON PERSON.DEPARTMENTID = DEPARTMENT.ID
GROUP BY DEPARTMENT.DEPARTMENT -- departman adýna göre 
HAVING AVG(PERSON.SALARY) > 5500 --maaþ ortalamasý 5500 den fazla


--9. Her personelin adýný, pozisyonunu baðlý olduðu birim yöneticisinin adýný ve pozisyonunu yönetici pozisyonunu getiren sorguyu yazýnýz.
SELECT 
PER2.NAME_ + ' ' + PER2.SURNAME AS PERSONEL_AD_SOYAD, POS1.POSITION AS PERSONEL_POZISYON,
PER1.NAME_ + ' ' + PER1.SURNAME AS YÖNETÝCÝ_ADI ,POS2.POSITION AS YÖNETÝCÝ_POZÝSYONU
FROM PERSON PER2
INNER JOIN POSITION POS1 ON POS1.ID = PER2.POSITIONID --personelin pozisyonu
INNER JOIN PERSON PER1 ON PER2.MANAGERID = PER1.ID --personelin yöneticisi
INNER JOIN POSITION POS2 ON POS2.ID = PER1.POSITIONID --personelin yöneticisinin pozisyonu
ORDER BY PERSONEL_AD_SOYAD

--10. Departmanlarýn ortalama kýdemini ay olarak hesaplayacak sorguyu yazýnýz. 


SELECT  DEPARTMENT, AVG(WORKINGTIME) AS AYLIK_KIDEM
FROM
(
SELECT DEPARTMENT,

CASE WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH, INDATE, OUTDATE) --ay bazýnda iþe giriþ ve iþten çýkýþ(iþten çýkmýþ olanlarý seçerek) kýdem hesaplamak
ELSE DATEDIFF (MONTH,INDATE,GETDATE())-- ay bazýndan iþe giriþ tarihinden bugünün zamanýný(iþten çýkmamýþlarý hesaplamak için) baz alarak kýdem hesaplamak

END AS WORKINGTIME --aylýk kýdem hesaplama sonucunu working time deðiþkenine atamak
FROM PERSON INNER JOIN DEPARTMENT ON PERSON.DEPARTMENTID = DEPARTMENT.ID) T GROUP BY DEPARTMENT

