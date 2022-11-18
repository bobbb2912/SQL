--CSDL QLSV
use QLSV;
go
select * from Sinhvien;
select * from Monhoc;
select * from Ketqua;

--1. Cho biết mã môn học, tên môn học, điểm thi tất cả các môn của sinh viên tên Thức.
select MH.MaMH, MH.TenMH, KQ.Diem from Monhoc MH
join Ketqua KQ on MH.MaMH = KQ.MaMH
join Sinhvien SV on SV.Masv = KQ.MaSV
where SV.TenSV like  N'%Thức';
--2. Cho biết mã môn, tên môn và điểm thi ở những môn mà sinh viên tên Dung phải thi lại (điểm < 5)
select MH.MaMH, MH.TenMH, KQ.Diem from Monhoc MH
join Ketqua KQ on MH.MaMH = KQ.MaMH
join Sinhvien SV on SV.Masv = KQ.MaSV
where SV.TenSV like '%Dung' and KQ.Diem < 5;
--3. Cho biết mã sinh viên, tên những sinh viên đã thi ít nhất là 1 trong 3 môn Toán cao cấp, Tin học đại cương, mạng máy tính ---!!---
select  SV.Masv, TenSV from Sinhvien SV
where SV.MaSV in (
	select distinct MaSV from Ketqua
	);
--4. Cho biết mã môn học, tên môn mà sinh viên có mã số 1 chưa có điểm 
select MH.MaMH, MH.TenMH from Monhoc MH
where MH.MaMH not in (
	select MaMH from Ketqua
	where MaSV = 1
	);
--5. Cho biết điểm cao nhất môn 1 mà các sinh viên đạt được 
select max(Diem) as diem_cao_nhat from Ketqua
where MaMH = 1;
--6. Cho biết mã sinh viên, tên những sinh viên có điểm thi môn 2 không thấp nhất khoa
select SV.MaSV, TenSV from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
where KQ.MaMH = 2 and Diem > (
	select min(Diem) from Ketqua KQ
	where MaMH = 2
	);
--7. Cho biết mã sinh viên và tên những sinh viên có điểm thi môn 1 lớn hơn điểm thi môn 1 của sinh viên có mã số 3
select SV.MaSV, TenSV  from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
where KQ.MaMH = 1 and KQ.Diem > (
	select Diem from Ketqua
	where MaSV = 3 and MaMH = 1
	);
--8. Cho biết số sinh viên phải thi lại môn toán cao cấp
select count(MaSV) as Thilai from Ketqua KQ
join Monhoc MH on KQ.MaMH = MH.MaMH
where MH.TenMH= N'Toán cao cấp' and KQ.Diem < 5;
--9. Đối với mỗi môn, cho biết tên môn và số sinh viên phải thi lại môn đó là số sinh viên thi lại >= 2
select TenMH, count(MaSV) as soluong from Monhoc MH
join Ketqua KQ on MH.MaMH = KQ.MaMH
where KQ.Diem < 5 
group by TenMH
having count(MaSV) >= 2;
--10. Cho biết mã sinh viên, tên và lớp của sinh viên đạt điểm cao nhất môn tin đại cương
select SV.Masv, TenSV, Lop from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
join Monhoc MH on KQ.MaMH = MH.MaMH
where MH.TenMH = N'Tin đại cương' and KQ.Diem in (
	select max(Diem) from Ketqua
	);
--11. Cho biết mã số và tên của những sinh viên tham gia thi tất cả các môn (tất cả các môn có trong bảng môn học)
--cach 1
select SV.Masv, TenSV from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
group by SV.Masv, TenSV
having count(KQ.MaMH) = (select count(MaMH) from Monhoc);
--Cach 2
select SV.Masv, TenSV from Sinhvien SV
where Masv in (
	select SV.Masv from (Sinhvien SV
	join Ketqua KQ on SV.Masv = KQ.MaSV)
	group by SV.Masv
	having count(distinct MaMH) = (select count(MaMH) from Monhoc)
	);
--12. Cho biết mã sinh viên và tên của sinh viên có điểm trung bình chung học tập >= 6
select SV.Masv, TenSV, SUM(KQ.Diem*MH.DVHT)/sum(DVHT) as DTB from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
join Monhoc MH on KQ.MaMH = MH.MaMH
group by SV.Masv, TenSV
having SUM(KQ.Diem*MH.DVHT)/sum(DVHT) >= 6;
--13. Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của toàn khóa
select SV.Masv, TenSV from Sinhvien SV
join Ketqua KQ on KQ.MaSV = SV.Masv
join Monhoc MH on KQ.MaMH = MH.MaMH
group by SV.Masv, TenSV
having sum(Diem*DVHT)/sum(DVHT) > (
	select sum(diem*DVHT)/sum(DVHT) from Monhoc MH
	join Ketqua KQ on MH.MaMH = KQ.MaMH);
--14.Cho biết mã sinh viên và tên những sinh viên phải thi lại ở ít nhất là những môn mà sinh viên có mã số 3 phải thi lại 
select distinct  SV.Masv, TenSV from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
where KQ.Diem < 5 and KQ.MaSV <> 3 and KQ.MaMH in (
	select MH.MaMH from Monhoc MH
	join Ketqua KQ on MH.MaMH = KQ.MaMH
	where KQ.Diem < 5 and KQ.MaSV = 3
	);--3 4 5 7 6 10 15
--15. Cho mã sinh viên và tên của những sinh viên có hơn nửa số điểm >= 5
--sai--
select SV.Masv, TenSV from Sinhvien SV
join Ketqua KQ on SV.Masv = KQ.MaSV
where Diem >= 5
group by SV.Masv, TenSV
having count(KQ.MaMH) >= (select count(MaMH)/2 from Ketqua);
--
select A.Masv, TenSV from
	(select SV.Masv, TenSV, count(MaMH) as SLDiemHon5 
	from Sinhvien SV join Ketqua KQ on SV.Masv = KQ.MaSV
	where Diem >= 5
	group by SV.Masv, TenSV) as A,
	(select MaSV, count(MaMH)/2 as NuaSoluongMH from Ketqua group	by MaSV)	as B
where A.Masv = B.MaSV and A.SLDiemHon5 >= B.NuaSoluongMH;
--16. Cho danh sách mã sinh viên, tên sinh viên có điểm môn Tin đại cương cao nhất của mỗi lớp
select SV.Masv, TenSV from Sinhvien SV, Ketqua KQ, Monhoc MH,
	(select Lop,  max(diem) as D from Sinhvien SV
	join Ketqua KQ on KQ.MaSV = SV.Masv
	join Monhoc MH on KQ.MaMH = MH.MaMH
	where TenMH = N'Tin đại cương'
	group by Lop
	) as L
where SV.Masv = KQ.MaSV and KQ.MaMH = MH.MaMH and Diem = D and L.Lop = SV.Lop and TenMH = N'Tin đại cương';
--17. Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của lớp sinh viên đó theo học
select Masv, TenSV from
	(select SV.Masv, TenSV, Lop, sum(Diem*DVHT)/Sum(DVHT) as D1 from Sinhvien SV
	join Ketqua KQ on SV.Masv = KQ.MaSV
	join Monhoc MH on MH.MaMH = KQ.MaMH
	group by SV.Masv, TenSV, Lop ) as B1,
	(select Lop, sum(Diem*DVHT)/Sum(DVHT) as D2 from Sinhvien SV
	join Ketqua KQ on SV.Masv = KQ.MaSV
	join Monhoc MH on MH.MaMH = KQ.MaMH
	group by Lop) as B2
where B1.Lop = B2.Lop and B1.D1 > B2.D2
--18. Đối với mỗi lớp, lập bảng điểm gồm mã SV, tên SV và điểm trung bình chung học tập
