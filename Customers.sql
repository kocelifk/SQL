https://medium.com/@kocelifk/sql-b3648218d30f

--Customers tablosundan adı ‘A’ harfi ile başlayan kişileri çeken sorguyu yazınız.--
SELECT * FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%'


--1990 ve 1995 yılları arasında doğan müşterileri çekiniz. 1990 ve 1995 yılları dahildir--
 SELECT * FROM CUSTOMERS WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31' ORDER BY BIRTHDATE


--İstanbul’da yaşayan kişileri Join kullanarak getiren sorguyu yazınız.
 SELECT CUSTOMERS.*, CITY FROM CUSTOMERS INNER JOIN CITIES  ON CUSTOMERS.CITYID = CITIES.ID WHERE CITIES.CITY = 'İSTANBUL'


 --İstanbul’da yaşayan kişileri subquery kullanarak getiren sorguyu yazınız.--
 SELECT * FROM CUSTOMERS  WHERE CUSTOMERS.CITYID IN (SELECT ID FROM CITIES  WHERE CITY='İSTANBUL') -- şehirler tablosunda bulunan Id sütunu değeri ile müşteriler tablosunda bulunan şehir id'nin eşleştiği, şehir adını İstanbul olduğu satırları göster

 --Hangi şehirde kaç müşterimizin olduğu bilgisini getiren sorguyu yazınız.-- 
 SELECT CITIES.CITY AS ŞEHİR, COUNT(CUSTOMERS.ID) AS MÜŞTERİ_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY ORDER BY MÜŞTERİ_SAYISI

 --10’dan fazla müşterimiz olan şehirleri müşteri sayısı ile birlikte müşteri sayısına göre fazladan aza doğru sıralı şekilde getiriniz.--
 SELECT CITY AS ŞEHİR, (SELECT COUNT(*) AS MÜŞTERİ_SAYISI FROM CUSTOMERS WHERE CITYID = CITIES.ID) AS MÜŞTERİ_SAYISI FROM CITIES WHERE (SELECT COUNT(*)  FROM CUSTOMERS WHERE CITYID = CITIES.ID) > 10 ORDER BY MÜŞTERİ_SAYISI DESC

 --Hangi şehirde kaç erkek, kaç kadın müşterimizin olduğu bilgisini şekildeki gibi getiren sorguyu yazınız.--
 SELECT CITIES.CITY AS ŞEHİR, CUSTOMERS.GENDER AS CİNSİYET, COUNT(CUSTOMERS.ID) AS MÜŞTERİ_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY, CUSTOMERS.GENDER ORDER BY CITIES.CITY, CUSTOMERS.GENDER

 --Customers tablosuna yaş grubu için yeni bir alan ekleyiniz. Bu işlemi hem management studio ile hem de sql kodu ile yapınız.Alanı adı AGEGROUP veritipi Varchar(50) --
  ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)

--Customers tablosuna eklediğiniz AGEGROUP alanını 20-35 yaş arası,36-45 yaş arası,46-55 yaş arası,55-65 yaş arası ve 65 yaş üstü olarak güncelleyiniz.--

UPDATE CUSTOMERS SET AGEGROUP='20-35 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35

UPDATE CUSTOMERS SET AGEGROUP='36-45 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

UPDATE CUSTOMERS SET AGEGROUP='46-55 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55

UPDATE CUSTOMERS SET AGEGROUP='55-65 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65

UPDATE CUSTOMERS SET AGEGROUP='65 YAS ÜSTÜ' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) > 65


--İstanbul’da yaşayıp ilçesi ‘Kadıköy’ dışında olanları listeleyiniz.--
 SELECT * FROM CUSTOMERS WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY='İSTANBUL') AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIKÖY')


--Her ilde en çok müşteriye sahip olduğumuz ilçeleri müşteri sayısına göre çoktan aza doğru sıralı şekilde şekildeki gibi getirmek için gereken sorguyu yazınız.

 SELECT CITY AS ŞEHİR, DISTRICT AS SEMT, COUNT(CUSTOMERS.ID) AS MÜŞTERİ_SAYISI
 FROM CUSTOMERS 
 INNER JOIN CITIES  ON CITIES.ID = CUSTOMERS.CITYID
 INNER JOIN DISTRICTS ON DISTRICTS.ID = CUSTOMERS.DISTRICTID
 GROUP BY CITIES.CITY, DISTRICTS.DISTRICT
 ORDER BY COUNT(CUSTOMERS.ID) DESC


 --15. Müşterilerin doğum günlerini resimdeki gibi haftanın günü olarak getiren sorguyu yazınız.--
SELECT   CUSTOMERS.CUSTOMERNAME AS MÜŞTERİ_ADI, DATENAME(DW, BIRTHDATE) AS DOĞUM_GÜNÜ, BIRTHDATE AS DOĞUM_TARİHİ FROM CUSTOMERS
