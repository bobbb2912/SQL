use QLMB;

select * from Chuyenbay;
select * from Maybay;
select * from Nhanvien;
select * from Chungnhan;
go

--1. Cho biết thông tin về các nhân viên có lương < 10000
select * from Nhanvien
where Luong < 10000;
--2. Cho biết thông tin về các chuyến bay có độ dài đường bay nhỏ hơn 10000km và lớn hơn 8000km
select * from Chuyenbay
where DoDai between 8000 and 10000;
--3. Cho biết thông tin về các chuyến bay xuất phát từ Sài Gòn(SGN) đi BMV
select * from Chuyenbay
where GaDi = 'SGN' and GaDen = 'BMV';
--4. Có bao nhiêu chuyến bay xuất phát từ SGN
select count(MaCB) as Sochuyen from Chuyenbay
where GaDi = 'SGN';
--5. Có bao nhiêu loại máy bay Boeing
select count(Hieu) as Soloai from Maybay
where Hieu like ('%Boeing%');
--6. Cho biết tổng số lương phải trả cho các nhân viên
select SUM(Luong) as Tong_luong from Nhanvien
--7. Cho biết mã số và tên của các phi công lái máy Boeing
select distinct CN.MaNV, Ten from Chungnhan CN
join Maybay MB on CN.MaMB = MB.MaMB
join Nhanvien NV on CN.MaNV = NV.MaNV
where Hieu like ('%Boeing%');
--8. Cho biết mã số và tên của các phi công có thể lái được máy bay có mã số là 747
select NV.MaNV, Ten from Nhanvien NV
join Chungnhan CN on CN.MaNV = NV.MaNV
where MaMB = 747;
--9. Cho biết mã số của các loại máy bay mà nhân viên có họ Nguyễn có thể lái 
select  MB.MaMB from Maybay MB
join Chungnhan CN on CN.MaMB = MB.MaMB
join Nhanvien NV on CN.MaNV = NV.MaNV
where Ten like ('Nguyen%');
--10. Cho biết mã số của các phi công vừa lái được Boeing vừa lái được Airbus A320 
select MaNV from Chungnhan CN join Maybay MB on CN.MaMB = MB.MaMB
where Hieu like 'Boeing%' 
intersect 
select MaNV from Chungnhan CN join Maybay MB on CN.MaMB = MB.MaMB
where Hieu like 'Airbus A320';

--11. Cho biết các loại máy bay có thể thực hiện được chuyến bay VN280
select hieu from Maybay MB
where TamBay >= (select dodai from Chuyenbay where MaCB = 'VN280');
--12. Cho biết các chuyến bay có thể thực hiện bởi máy bay Airbus A320 
select MaCB from Chuyenbay
where DoDai <= (select tambay from Maybay where Hieu = 'Airbus A320');
--13. Với mỗi loại máy bay có phi công lái, cho biết mã số, loại máy bay và tổng số phi công có thể lái loại máy bay đó
select MB.MaMB, Hieu, count(maNV) as soluong from Maybay MB
join Chungnhan CN on MB.MaMB = CN.MaMB
group by MB.MaMB, Hieu;
--14. Giả sử một hành khách muốn đi thẳng từ ga A đến ga B rồi quay trở về ga A, Cho biết các đường bay nào có thể đáp ứng điều này.
select a.GaDen, a.GaDi from Chuyenbay a, Chuyenbay b
where a.GaDi = b.GaDen and b.GaDi = a.GaDen and a.GioDen < b.GioDi
--15. Với mỗi ga có chuyến bay xuất phát từ đó, cho biết có bao nhiêu chuyến bay khởi hành từ ga đó và cho biết tổng chi phí phải trả
select distinct GaDi, count(GaDi) as Soluong, Sum(ChiPhi) as ChiPhi from Chuyenbay 
group by GaDi;
--16. Với mỗi ga xuất phát, cho biết có bao nhiêu chuyến bay khởi hành trước 12:00
select Count(MaCB) as SoChuyenBay from Chuyenbay
where datepart(hour, GioDi) < 12;
--17. Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số phi công và tâm bay lớn nhất của các loại máy bay mà phi công có thể lái
select MaNV, max(TamBay) as tamBayMAX from Chungnhan CN
join Maybay MB on CN.MaMB = MB.MaMB
group by MaNV
having count(MaNV) > 3;
--18. Cho biết mã số của các phi công có thể lái được nhiều loại máy bay nhất
select MaNV, count(MaNV) as SoLoai from Chungnhan CN 
group by MaNV
having count(MaNV) = (select Max(Soluong.dem) from
(select count(MaNV) as dem from Chungnhan group by MaNV) as Soluong);
--19. Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất 
select MaNV, count(MaNV) as SoLoai from Chungnhan CN 
group by MaNV
having count(MaNV) = (select Min(Soluong.dem) from
(select count(MaNV) as dem from Chungnhan group by MaNV) as Soluong);
-- 20. Tìm chuyến bay có thể thực hiện bởi tất cả các loại máy bay Boeing 
select distinct CB.MaCB from Chuyenbay CB,Maybay MB
where DoDai <= (select min(Tambay) from Maybay) and Hieu like 'Boeing%';
--21. Tìm các chuyến bay có thể lái bởi các phi công có lương lớn hơn 100.000
select distinct MaCB from Chuyenbay CB
join Maybay MB on CB.DoDai <= MB.TamBay
join Chungnhan CN on CN.MaMB = MB.MaMB
join Nhanvien NV on NV.MaNV = CN.MaNV
where Luong > 100000;
--22.  Cho biết tên phi công có luong nhỏ hơn chi phí thấp nhất của đường bay từ SGN đến BMV 
select distinct Ten, Luong from Nhanvien NV, Chungnhan CN
where NV.MaNV = CN.MaNV and Luong < (select min(Chiphi) from Chuyenbay where GaDi = 'SGN' and GaDen = 'BMV');
--23. Cho biết mã số của các phi công có lương cao nhất
select distinct NV.maNV from Nhanvien NV join Chungnhan CN on NV.MaNV = CN.MaNV
where luong = (select max(luong) from Nhanvien);
--24. Cho biết mã số của các nhân viên có lương cao thứ nhì
select distinct MaNV, Luong from Nhanvien 
where luong = (select max(luong) from Nhanvien  
	where luong < (select max(luong) from Nhanvien NV));
--25. Cho biết tên và lương của các nhân viên không phải là phi công và có lương lớn hơn lương trung bình của tất cả các phi công
select distinct MaNV, Luong from Nhanvien
where  luong > (select avg(luong) from (select distinct NV.MaNV, luong from Nhanvien NV join Chungnhan CN on CN.MaNV = NV.MaNV) as LuongTb) and MaNV not in (select distinct MaNV from Chungnhan)
--26. Cho biết tên các phi công có thể lái các  máy bay có tầm bay lớn hơn 4800km nhưng không có chứng nhận lái máy bay Boeing

select distinct nv.MaNV, Ten from NhanVien nv, ChungNhan cn, MayBay mb
where cn.MaNV=nv.MaNV and cn.MaMB=mb.MaMB and TamBay > 4800
except
(select distinct nv.MaNV, Ten from NhanVien nv, ChungNhan cn, MayBay mb
where cn.MaNV=nv.MaNV and cn.MaMB=mb.MaMB and Hieu like 'Boeing%');
--27. Cho biết tên các phi công lái ít nhất 3 loại máy bay có tầm xa hơn 3200km
select NV.MaNV, Ten from Nhanvien NV
join Chungnhan CN on NV.MaNV = CN.MaNV
join Maybay MB on MB.MaMB = CN.MaMB
where TamBay > 3200
group by NV.MaNV, Ten
having count(NV.MaNV) > 3;
--28. Với mỗi nhân viên, cho biết mã số, tên nhân viên và tổng số loại máy bay Boeing mà nhân viên đó có thể lái
select NV.MaNV, Ten, count(NV.MaNV) as Soluong from Nhanvien NV
join Chungnhan CN on NV.MaNV = CN.MaNV
join Maybay MB on MB.MaMB = CN.MaMB
where Hieu like 'Boeing%'
group by NV.MaNV, Ten;
--29. Với mỗi loại máy bay, cho biết loại máy bay và tổng số phi công có thể lái loại máy bau đó
select Hieu, count(CN.MaNV) as Soluong from Maybay MB
join Chungnhan CN on CN.MaMB = MB.MaMB
group by Hieu;
--30. Với mỗi chuyến bay, cho biết mã số chuyến bay và tổng số phi công không thể lái chuyến bay đó 
--!!--
select  MaCB, count(NV.MaNV)as Soluong from Chuyenbay CB, Chungnhan CN, Maybay MB, Nhanvien NV
where CN.MaMB = MB.MaMB and NV.MaNV = CN.MaNV
group by MaCB, CN.MaNV
except
select  MaCB, count(NV.MaNV)as Soluong from Chuyenbay CB, Chungnhan CN, Maybay MB, Nhanvien NV
where CN.MaMB = MB.MaMB and NV.MaNV = CN.MaNV and tambay > DoDai
group by MaCB
--
select MaCB, count(NV.MaNV) from Chuyenbay CB
join Maybay MB on MB.TamBay < CB.DoDai
join Chungnhan CN on CN.MaMB = MB.MaMB
join Nhanvien NV on NV.MaNV = CN.MaNV
where (select min(Tambay) from Maybay MB
		join Chungnhan CN on CN.MaMB = MB.MaMB
		join Nhanvien NV on CN.MaNV = NV.MaNV
		group by NV.MaNV) < DoDai
group by MaCB;
--31. Với mỗi loại máy bay, cho biết loại máy bay và tổng số chuyến bay không thể thực hiện bởi loại máy bay đó
select Hieu, count(MaCB) as SoCB from Maybay MB
join Chuyenbay CB on MB.TamBay < CB.DoDai
group by Hieu;
--32. Với mỗi chuyến bay, hãy cho biết mã số chuyến bay và tổng số loại máy bay có thể thực hiện chuyến bay đó 
select MaCB, count(MaMB) as SoMB from Chuyenbay CB
join Maybay MB on Cb.DoDai <= MB.TamBay
group by MaCB;
--33. Với mỗi loại máy bay, hãy cho biết loại máy bay và tổng số phi công có lương lớn hơn 100000 có thể lái máy bay đó
select hieu, count(NV.MaNV) as SoPC from Maybay MB
join Chungnhan CN on MB.MaMB = CN.MaMB
join Nhanvien NV on NV.MaNV = CN.MaNV
where Luong > 100000
group by Hieu;
--34. Với mỗi loại máy bay có tầm bay trên 3200km, cho biết tên của loại máy bay và lương trung bình của các phi công có thể lái loại máy bay đó
select Hieu, avg(Luong) as LuongTB from Maybay MB
join Chungnhan CN on CN.MaMB = MB.MaMB
join Nhanvien NV on CN.MaNV = NV.MaNV
where TamBay > 3200
group by Hieu;
--35. Với mỗi phi công, cho biết mã số, tên phi công và tổng số chuyến bay xuất phát từ Sài Gòn mà phi công có thể lái
select  NV.MaNV, Ten, count(distinct MaCB) as SoCB from Nhanvien NV
join Chungnhan CN on CN.MaNV = NV.MaNV
join Maybay MB on CN.MaMB = MB.MaMB
join Chuyenbay CB on CB.DoDai <= MB.TamBay
where GaDi = 'SGN'
group by NV.MaNV, Ten;
--36. Một hành khách muốn đi từ HAN đến CXR mà không phải đổi chuyến bay quá một lần. Cho biết mã chuyến bay, thời gian khởi hành từ HAN nếu hành khách muốn đến CXR trước 16:00
--thieu--
select MaCB, GioDi from CHUYENBAY
where GaDi='HAN' and GaDen='CXR' and GioDen<'16:00';
--37. Cho biết thông tin của các đường bay mà tất cả các phi công có thể bay trên đường bay đó đều có lương > 100000
--!!--
select MaCB, Gadi, Gaden from Chuyenbay CB
join Maybay MB on CB.DoDai < MB.TamBay
join Chungnhan CN on CN.MaMB = MB.MaMB
join Nhanvien NV on NV.MaNV = CN.MaNV
where Luong > 100000;
--38. Cho biết tên các phi công chỉ lái các loại máy bay có tầm xa hơn 3200km và một trong số đó là Boeing
--!!--
select distinct Ten from Nhanvien NV
join Chungnhan CN on NV.MaNV = CN.MaNV
join Maybay MB on CN.MaMB = MB.MaMB
where TamBay > 3200 and Hieu like 'Boeing%';
--39. Tìm các phi công có thể lái tất cả các loại máy bay Boeing
select NV.MaNV, Ten from Nhanvien NV
join Chungnhan CN on NV.MaNV = CN.MaNV
join Maybay MB on CN.MaMB = MB.MaMB
where Hieu like 'Boeing%'
group by NV.MaNV, Ten
having count(NV.MaNV) = (select count(MaMB) from Maybay where Hieu like 'Boeing%');