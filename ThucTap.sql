create database ThucTap;
Use ThucTap;

create table Khoa (
	Makhoa char(10) primary key,
	tenkhoa Nchar(30),
	dienthoai char(10)
	);
create table GiangVien (
	Magv int primary key,
	HotenGV Nchar(30), 
	Luong decimal(5, 2),
	Makhoa char(10)
	);
create table SinhVien (
	Masv int primary key,
	HotenSV Nchar(30),
	Makhoa char(10) foreign key references Khoa,
	Namsinh int, 
	Quequan Nchar(30)
	);
create table DeTai (
	Madt char(10) primary key,
	Tendt Nchar(30),
	Kinhphi int,
	Noithuctap Nchar(30)
	);
create table HuongDan (
	Masv int primary key,
	Madt char(10) foreign key references DeTai,
	MaGV int foreign key references GiangVien,
	Ketqua decimal(5, 2)
	);

insert into Khoa values
('Geo', N'Địa lý và QLTN', '3855413'),
('Math', N'Toán', '3855411'),
('Bio', N'Công nghệ sinh học', '3855412');
insert into GiangVien values
(11, N'Thanh Bình', 700, 'Geo'),
(12, N'Thu Hương', 500, 'Math'),
(13, N'Chu Vinh', 650, 'Geo'),
(14, N'Lê Thị Lý', 500, 'Bio'),
(15, N'Trần Sơn', 900, 'Math');
insert into SinhVien values
(1, N'Lê Văn Sơn', 'Bio', 1990, N'Nghệ An'),
(2, N'Nguyễn Thị Mai', 'Geo', 1990, N'Thanh Hóa'),
(3, N'Bùi Xuân Đức', 'Math', 1992, N'Hà Nội'),
(4, N'Nguyễn Văn Tùng', 'Bio', null, N'Hà Tĩnh'),
(5, N'Lê Khánh Linh', 'Bio', 1989, N'Hà Nam'),
(6, N'Trần Khắc Trọng', 'Geo', 1991, N'Thanh Hóa'),
(7, N'Lê Thị Vân', 'Math', null, 'null'),
(8, N'Hoàng Văn Đức', 'Bio', 1992, N'Nghệ An');
insert into DeTai values
('Dt01', 'GIS', 100, N'Nghệ An'),
('Dt02', 'ARC GIS', 500, N'Nam Định'),
('Dt03', 'Spatial DB', 100, N'Hà Tĩnh'),
('Dt04', 'MAP', 300, N'Quảng Bình');
insert into HuongDan values
(1, 'Dt01', 13, 8),
(2, 'Dt03', 14, 0),
(3, 'Dt03', 12, 10),
(5, 'Dt04', 14, 7),
(6, 'Dt01', 12, null),
(7, 'Dt04', 11, 10),
(8, 'Dt03', 15, 6);
select * from Khoa;
select * from GiangVien;
select * from SinhVien;
select * from DeTai;
select * from HuongDan;
--đưa ra thông tin gồm mã số, họ tên và tên khoa của tất của giảng viên
select Magv, HotenGv, K.tenkhoa
from GiangVien GV, Khoa K
where GV.Makhoa = K.Makhoa;
--đưa ra thông tin gồm mã số, họ tên và khoa của các giáo viên của khoa 'Địa lý và QLTN'
select  magv, hotenGv 
from GiangVien GV join  Khoa K 
on Gv.Makhoa = K.Makhoa
where K.tenkhoa = N'Địa lý và QLTN';
--cho biết số sinh viên của khoa 'Công nghệ sinh học'
select count(masv) as số_sv 
from SinhVien SV join Khoa K 
on SV.Makhoa = K.Makhoa
where K.tenkhoa = N'công nghệ sinh học';
--đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa 'toán'
select masv, hotensv, ((year(getdate())- sv.Namsinh)) as tuổi
from SinhVien SV join Khoa K
on SV.Makhoa = K.Makhoa
where K.Makhoa = 'Math';
--Cho biết số giảng viên của khoa 'Công nghệ sinh học'
select count(magv) as so_GV
from GiangVien GV join Khoa K 
on GV.Makhoa = K.Makhoa
where k.tenkhoa = N'Công nghệ sinh học';
--cho biết thông tin về sinh viên không tham gia thực tập
select * from SinhVien SV
where not exists (
	select HD.Masv from HuongDan HD
	where SV.Masv = HD.Masv
	);
--đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
select K.Makhoa, K.tenkhoa, count(GV.Magv) as so_GV
from Khoa K join GiangVien GV
on K.Makhoa = GV.Makhoa
group by K.Makhoa, K.tenkhoa;
--cho biết số điện thoại của khoa mà sinh viên có tên 'Lê Văn Sơn' đang theo học
select K.dienthoai from Khoa K
join SinhVien SV on K.Makhoa = SV.Makhoa
where SV.HotenSV = N'Lê Văn Sơn';
-- cho biết mã số và tên của các đề tài do giảng viên 'Trần Sơn' hướng dẫn
select DT.Madt, DT.Tendt from  GiangVien GV 
join HuongDan HD on Gv.Magv = HD.MaGV
join DeTai DT on HD.Madt = DT.Madt
where GV.HotenGV = N'Trần Sơn';
--cach2:
select DT.Madt, DT.Tendt from DeTai DT
where DT.Madt=
	(select HD.Madt from GiangVien GV
	join HuongDan HD on GV.Magv = HD.MaGV
	where GV.HotenGV = N'Trần Sơn');
--cho biết tên đề tài không có sinh viên nào thực tập 
select DT.Tendt from DeTai DT
where not exists (
	select HD.Madt from HuongDan HD 
	where HD.Madt = DT.Madt
	);
--cho biết mã số, họ tên, tên khoa của giảng viên hướng dẫn từ 2 sinh viên trở lên
select GV.Magv, GV.HotenGV, K.tenkhoa  from GiangVien GV
join Khoa K on GV.Makhoa = K.Makhoa
where GV.Magv IN (
	select HD.MaGV from HuongDan HD
	Group by HD.MaGV
	Having count(HD.Masv) >= 2
	);
--cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select DT.Madt, DT.Tendt from DeTai DT
where DT.Kinhphi = (
	select MAX(DT.Kinhphi) from DeTai DT
	);
--cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select DT.Madt, DT.Tendt from DeTai DT
where DT.Madt IN (
	select HD.Madt from HuongDan HD
	group by HD.Madt
	Having count(HD.Masv) > 2
	);
--đưa ra mã số, họ tên và điểm của các sinh viên khoa 'Địa lý và QLTN'
select SV.Masv, SV.HotenSV, HD.Ketqua from SinhVien SV
join HuongDan HD on SV.Masv = HD.Masv
where SV.Makhoa IN (
	select SV.Makhoa from SinhVien SV
	join  Khoa K on SV.Makhoa = K.Makhoa
	where K.tenkhoa = N'Địa lý và QLTN'
	);
--đưa ra tên khoa và số lượng sinh viên mỗi khoa
select K.tenkhoa, count(SV.Masv) as so_luong from Khoa K
join SinhVien SV on K.Makhoa = SV.Makhoa
group by K.tenkhoa;
--cho biết thông tin về các sinh viên thực tập tại quê nhà
select * from SinhVien SV
join HuongDan HD on HD.Masv = SV.Masv
join DeTai DT on DT.Madt = HD.Madt
where SV.Quequan = DT.Noithuctap;
--cho biết thông tin về những sinh viên chưa có điểm thực tập
select * from SinhVien SV
join HuongDan HD on SV.Masv = HD.Masv
where HD.Ketqua is NULL;
--đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select SV.Masv, SV.HotenSV from sinhvien SV
join HuongDan HD on SV.Masv = HD.Masv
where HD.Ketqua = 0;