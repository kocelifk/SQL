
--2. Customers tablosundan ad� �A� harfi ile ba�layan ki�ileri �eken sorguyu yaz�n�z.--
SELECT * FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%'


--3. 1990 ve 1995 y�llar� aras�nda do�an m��terileri �ekiniz. 1990 ve 1995 y�llar� dahildir--
 SELECT * FROM CUSTOMERS WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31' ORDER BY BIRTHDATE


--4. �stanbul�da ya�ayan ki�ileri Join kullanarak getiren sorguyu yaz�n�z.
 SELECT CUSTOMERS.*, CITY FROM CUSTOMERS INNER JOIN CITIES  ON CUSTOMERS.CITYID = CITIES.ID WHERE CITIES.CITY = '�STANBUL'


 --5. �stanbul�da ya�ayan ki�ileri subquery kullanarak getiren sorguyu yaz�n�z.--
 SELECT * FROM CUSTOMERS  WHERE CUSTOMERS.CITYID IN (SELECT ID FROM CITIES  WHERE CITY='�STANBUL') -- �ehirler tablosunda bulunan Id s�tunu de�eri ile m��teriler tablosunda bulunan �ehir id'nin e�le�ti�i, �ehir ad�n� �stanbul oldu�u sat�rlar� g�ster

 --6. Hangi �ehirde ka� m��terimizin oldu�u bilgisini getiren sorguyu yaz�n�z.-- 
 SELECT CITIES.CITY AS �EH�R, COUNT(CUSTOMERS.ID) AS M��TER�_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY ORDER BY M��TER�_SAYISI

 --7. 10�dan fazla m��terimiz olan �ehirleri m��teri say�s� ile birlikte m��teri say�s�na g�re fazladan aza do�ru s�ral� �ekilde getiriniz.--
 SELECT CITY AS �EH�R, (SELECT COUNT(*) AS M��TER�_SAYISI FROM CUSTOMERS WHERE CITYID = CITIES.ID) AS M��TER�_SAYISI FROM CITIES WHERE (SELECT COUNT(*)  FROM CUSTOMERS WHERE CITYID = CITIES.ID) > 10 ORDER BY M��TER�_SAYISI DESC

 --8. Hangi �ehirde ka� erkek, ka� kad�n m��terimizin oldu�u bilgisini �ekildeki gibi getiren sorguyu yaz�n�z.--
 SELECT CITIES.CITY AS �EH�R, CUSTOMERS.GENDER AS C�NS�YET, COUNT(CUSTOMERS.ID) AS M��TER�_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY, CUSTOMERS.GENDER ORDER BY CITIES.CITY, CUSTOMERS.GENDER

 --9. Customers tablosuna ya� grubu i�in yeni bir alan ekleyiniz. Bu i�lemi hem management studio ile hem de sql kodu ile yap�n�z.Alan� ad� AGEGROUP veritipi Varchar(50) --
  ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)

--10. Customers tablosuna ekledi�iniz AGEGROUP alan�n� 20-35 ya� aras�,36-45 ya� aras�,46-55 ya� aras�,55-65 ya� aras� ve 65 ya� �st� olarak g�ncelleyiniz.--

UPDATE CUSTOMERS SET AGEGROUP='20-35 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35

UPDATE CUSTOMERS SET AGEGROUP='36-45 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

UPDATE CUSTOMERS SET AGEGROUP='46-55 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55

UPDATE CUSTOMERS SET AGEGROUP='55-65 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65

UPDATE CUSTOMERS SET AGEGROUP='65 YAS �ST�' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) > 65


--11. �stanbul�da ya�ay�p il�esi �Kad�k�y� d���nda olanlar� listeleyiniz.--
 SELECT * FROM CUSTOMERS WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY='�STANBUL') AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIK�Y')


--12. M��terilerimizin telefon numalar�n�n operat�r bilgisini getirmek istiyoruz. --
--TELNR1 ve TELNR2 alanlar�n�n yan�na operat�r numaras�n� (532),(505) gibi getirmek istiyoruz. --
--Bu sorgu i�in gereken SQL c�mlesini yaz�n�z.--



--13. M��terilerimizin telefon numaralar�n�n operat�r bilgisini getirmek istiyoruz.
--�rne�in telefon numaralar� �50� yada �55� ile ba�layan �X� operat�r�  �54� ile ba�layan �Y� operat�r� �53� ile ba�layan �Z� operat�r� olsun. 
--Burada hangi operat�rden ne kadar m��terimiz oldu�u bilgisini getirecek sorguyu yaz�n�z.





--14. Her ilde en �ok m��teriye sahip oldu�umuz il�eleri m��teri say�s�na g�re �oktan aza do�ru s�ral� �ekilde �ekildeki gibi getirmek i�in gereken sorguyu yaz�n�z.

 SELECT CITY AS �EH�R, DISTRICT AS SEMT, COUNT(CUSTOMERS.ID) AS M��TER�_SAYISI
 FROM CUSTOMERS 
 INNER JOIN CITIES  ON CITIES.ID = CUSTOMERS.CITYID
 INNER JOIN DISTRICTS ON DISTRICTS.ID = CUSTOMERS.DISTRICTID
 GROUP BY CITIES.CITY, DISTRICTS.DISTRICT
 ORDER BY COUNT(CUSTOMERS.ID) DESC


 --15. M��terilerin do�um g�nlerini resimdeki gibi haftan�n g�n� olarak getiren sorguyu yaz�n�z.--
SELECT   CUSTOMERS.CUSTOMERNAME AS M��TER�_ADI, DATENAME(DW, BIRTHDATE) AS DO�UM_G�N�, BIRTHDATE AS DO�UM_TAR�H� FROM CUSTOMERS
