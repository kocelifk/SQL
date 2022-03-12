--2. �irketimizde halen �al��maya devam eden �al��anlar� nlistesini getiren sorgu hangisidir? 
--Not:��ten ��k�� tarihi bo� olanlar �al��maya devam eden �al��anlard�r.
SELECT * FROM PERSON WHERE OUTDATE IS NULL


--3. �irketimizde departman bazl� halen �al��maya devam eden �al��an say�s�n� getiren sorguyu yaz�n�z?

SELECT DEPARTMENT AS DEPARTMAN_ADI, COUNT(PERSON.ID) AS WORKER_PERSON_COUNT FROM PERSON
INNER JOIN DEPARTMENT D ON D.ID = PERSON.DEPARTMENTID  --person ve departman tablolar�n�n ba�lanmas�
WHERE PERSON.OUTDATE IS NULL --halen �al��maya devam etmesi
GROUP BY DEPARTMENT --departman bazl�

--4. �irketimizde departman bazl� halen �al��maya devam KADIN ve ERKEK say�lar�n� getiren sorguyu yaz�n�z.

SELECT *, -- Departman ad�n� getirmesi i�in * 
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='E' AND  OUTDATE IS NULL) AS ERKEK_SAYISI, --halen �al��maya devam eden erkek say�s�
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = DEPARTMENT.ID AND GENDER='K' AND  OUTDATE IS NULL) AS KADIN_SAYISI --halen �al��maya devam eden kad�n say�s�
FROM DEPARTMENT


--5. �irketimizin Planlama departman�na yeni bir �ef atamas� yap�ld� ve maa��n� belirlemek istiyoruz.
--Planlama departman� i�i nminimum, maximum ve ortalama �ef maa�� getiren sorgu hangisidir? (Not:i�ten ��km�� olan personel maa�lar� da dahildir.)

SELECT POSITION.POSITION AS POZ�SYON , MIN(PERSON.SALARY) AS M�N�MUM_MAAS,
MAX(PERSON.SALARY) AS MAXIMUM_MAAS,
AVG(PERSON.SALARY) AS ORTALAMA_MAAS
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
WHERE POSITION = 'PLANLAMA �EF�'
GROUP BY POSITION.POSITION


--6. Her bir pozisyonda mevcut halde �al��anlar olarak ka� ki�i ve ortalama maa�lar�n�n ne kadar oldu�unu listelettirmek istiyoruz. 
--Sonucu getiren sorguyu yaz�n�z.
SELECT POSITION AS POZ�SYON, COUNT(*) AS K�S�_SAYISI, AVG(PERSON.SALARY) AS ORTALAMA_MAAS 
FROM POSITION INNER JOIN PERSON ON PERSON.POSITIONID = POSITION.ID
GROUP BY POSITION ORDER BY K�S�_SAYISI


--7.Y�llara g�re i�e al�nan personel say�s�n� kad�n ve erkek baz�nda listelettiren sorguyu yaz�n�z.

SELECT DISTINCT YEAR(PERSONTABLE.INDATE) YIL,  --INDATE: i�e giri� tarihi; DISTINCT eklenmedi�i durumda ayn� y�l� birden fazla kez g�steriyor
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E'AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS ERKEK_SAYISI,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(PERSONTABLE.INDATE)) AS KADIN_SAYISI
FROM PERSON PERSONTABLE ORDER BY YIL




--8. Maa� ortalamas� 5.500 TL�den fazla olan departmanlar� listeleyecek sorguyu yaz�n�z. 

SELECT DEPARTMENT, AVG(PERSON.SALARY) AS ORTALAMA_MAAS FROM DEPARTMENT INNER JOIN PERSON ON PERSON.DEPARTMENTID = DEPARTMENT.ID
GROUP BY DEPARTMENT.DEPARTMENT -- departman ad�na g�re 
HAVING AVG(PERSON.SALARY) > 5500 --maa� ortalamas� 5500 den fazla


--9. Her personelin ad�n�, pozisyonunu ba�l� oldu�u birim y�neticisinin ad�n� ve pozisyonunu y�netici pozisyonunu getiren sorguyu yaz�n�z.
SELECT 
PER2.NAME_ + ' ' + PER2.SURNAME AS PERSONEL_AD_SOYAD, POS1.POSITION AS PERSONEL_POZISYON,
PER1.NAME_ + ' ' + PER1.SURNAME AS Y�NET�C�_ADI ,POS2.POSITION AS Y�NET�C�_POZ�SYONU
FROM PERSON PER2
INNER JOIN POSITION POS1 ON POS1.ID = PER2.POSITIONID --personelin pozisyonu
INNER JOIN PERSON PER1 ON PER2.MANAGERID = PER1.ID --personelin y�neticisi
INNER JOIN POSITION POS2 ON POS2.ID = PER1.POSITIONID --personelin y�neticisinin pozisyonu
ORDER BY PERSONEL_AD_SOYAD

--10. Departmanlar�n ortalama k�demini ay olarak hesaplayacak sorguyu yaz�n�z. 


SELECT  DEPARTMENT, AVG(WORKINGTIME) AS AYLIK_KIDEM
FROM
(
SELECT DEPARTMENT,

CASE WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH, INDATE, OUTDATE) --ay baz�nda i�e giri� ve i�ten ��k��(i�ten ��km�� olanlar� se�erek) k�dem hesaplamak
ELSE DATEDIFF (MONTH,INDATE,GETDATE())-- ay baz�ndan i�e giri� tarihinden bug�n�n zaman�n�(i�ten ��kmam��lar� hesaplamak i�in) baz alarak k�dem hesaplamak

END AS WORKINGTIME --ayl�k k�dem hesaplama sonucunu working time de�i�kenine atamak
FROM PERSON INNER JOIN DEPARTMENT ON PERSON.DEPARTMENTID = DEPARTMENT.ID) T GROUP BY DEPARTMENT

