
--2. Customers tablosundan adý ‘A’ harfi ile baþlayan kiþileri çeken sorguyu yazýnýz.--
SELECT * FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%'


--3. 1990 ve 1995 yýllarý arasýnda doðan müþterileri çekiniz. 1990 ve 1995 yýllarý dahildir--
 SELECT * FROM CUSTOMERS WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31' ORDER BY BIRTHDATE


--4. Ýstanbul’da yaþayan kiþileri Join kullanarak getiren sorguyu yazýnýz.
 SELECT CUSTOMERS.*, CITY FROM CUSTOMERS INNER JOIN CITIES  ON CUSTOMERS.CITYID = CITIES.ID WHERE CITIES.CITY = 'ÝSTANBUL'


 --5. Ýstanbul’da yaþayan kiþileri subquery kullanarak getiren sorguyu yazýnýz.--
 SELECT * FROM CUSTOMERS  WHERE CUSTOMERS.CITYID IN (SELECT ID FROM CITIES  WHERE CITY='ÝSTANBUL') -- þehirler tablosunda bulunan Id sütunu deðeri ile müþteriler tablosunda bulunan þehir id'nin eþleþtiði, þehir adýný Ýstanbul olduðu satýrlarý göster

 --6. Hangi þehirde kaç müþterimizin olduðu bilgisini getiren sorguyu yazýnýz.-- 
 SELECT CITIES.CITY AS ÞEHÝR, COUNT(CUSTOMERS.ID) AS MÜÞTERÝ_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY ORDER BY MÜÞTERÝ_SAYISI

 --7. 10’dan fazla müþterimiz olan þehirleri müþteri sayýsý ile birlikte müþteri sayýsýna göre fazladan aza doðru sýralý þekilde getiriniz.--
 SELECT CITY AS ÞEHÝR, (SELECT COUNT(*) AS MÜÞTERÝ_SAYISI FROM CUSTOMERS WHERE CITYID = CITIES.ID) AS MÜÞTERÝ_SAYISI FROM CITIES WHERE (SELECT COUNT(*)  FROM CUSTOMERS WHERE CITYID = CITIES.ID) > 10 ORDER BY MÜÞTERÝ_SAYISI DESC

 --8. Hangi þehirde kaç erkek, kaç kadýn müþterimizin olduðu bilgisini þekildeki gibi getiren sorguyu yazýnýz.--
 SELECT CITIES.CITY AS ÞEHÝR, CUSTOMERS.GENDER AS CÝNSÝYET, COUNT(CUSTOMERS.ID) AS MÜÞTERÝ_SAYISI FROM CUSTOMERS INNER JOIN CITIES ON CITIES.ID = CUSTOMERS.CITYID GROUP BY CITIES.CITY, CUSTOMERS.GENDER ORDER BY CITIES.CITY, CUSTOMERS.GENDER

 --9. Customers tablosuna yaþ grubu için yeni bir alan ekleyiniz. Bu iþlemi hem management studio ile hem de sql kodu ile yapýnýz.Alaný adý AGEGROUP veritipi Varchar(50) --
  ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)

--10. Customers tablosuna eklediðiniz AGEGROUP alanýný 20-35 yaþ arasý,36-45 yaþ arasý,46-55 yaþ arasý,55-65 yaþ arasý ve 65 yaþ üstü olarak güncelleyiniz.--

UPDATE CUSTOMERS SET AGEGROUP='20-35 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35

UPDATE CUSTOMERS SET AGEGROUP='36-45 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

UPDATE CUSTOMERS SET AGEGROUP='46-55 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55

UPDATE CUSTOMERS SET AGEGROUP='55-65 YAS' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65

UPDATE CUSTOMERS SET AGEGROUP='65 YAS ÜSTÜ' WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) > 65


--11. Ýstanbul’da yaþayýp ilçesi ‘Kadýköy’ dýþýnda olanlarý listeleyiniz.--
 SELECT * FROM CUSTOMERS WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY='ÝSTANBUL') AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIKÖY')


--12. Müþterilerimizin telefon numalarýnýn operatör bilgisini getirmek istiyoruz. --
--TELNR1 ve TELNR2 alanlarýnýn yanýna operatör numarasýný (532),(505) gibi getirmek istiyoruz. --
--Bu sorgu için gereken SQL cümlesini yazýnýz.--



--13. Müþterilerimizin telefon numaralarýnýn operatör bilgisini getirmek istiyoruz.
--Örneðin telefon numaralarý “50” yada “55” ile baþlayan “X” operatörü  “54” ile baþlayan “Y” operatörü “53” ile baþlayan “Z” operatörü olsun. 
--Burada hangi operatörden ne kadar müþterimiz olduðu bilgisini getirecek sorguyu yazýnýz.





--14. Her ilde en çok müþteriye sahip olduðumuz ilçeleri müþteri sayýsýna göre çoktan aza doðru sýralý þekilde þekildeki gibi getirmek için gereken sorguyu yazýnýz.

 SELECT CITY AS ÞEHÝR, DISTRICT AS SEMT, COUNT(CUSTOMERS.ID) AS MÜÞTERÝ_SAYISI
 FROM CUSTOMERS 
 INNER JOIN CITIES  ON CITIES.ID = CUSTOMERS.CITYID
 INNER JOIN DISTRICTS ON DISTRICTS.ID = CUSTOMERS.DISTRICTID
 GROUP BY CITIES.CITY, DISTRICTS.DISTRICT
 ORDER BY COUNT(CUSTOMERS.ID) DESC


 --15. Müþterilerin doðum günlerini resimdeki gibi haftanýn günü olarak getiren sorguyu yazýnýz.--
SELECT   CUSTOMERS.CUSTOMERNAME AS MÜÞTERÝ_ADI, DATENAME(DW, BIRTHDATE) AS DOÐUM_GÜNÜ, BIRTHDATE AS DOÐUM_TARÝHÝ FROM CUSTOMERS
