use QLSV
select * from Sinhvien;
select * from Monhoc;
select * from Ketqua;

insert into Ketqua values 
(5, 4, 6), (7, 5, 8);
go

--1. Lấy ra danh sách sinh viên nữ học môn Toán cao cấp và điểm thi tương ứng.

create view danhsach as
select SV.Masv, TenSV, Diem from Sinhvien SV
join Ketqua KQ on KQ.MaSV = SV.Masv
join Monhoc MH on MH.MaMH = KQ.MaMH
where TenMH = N'Toán cao cấp' and  Gioitinh = N'Nữ';
--
select TenSV, Masv from danhsach
where Diem >= 4;
--2. Cho biết số sinh viên thi đỗ môn toán cao cấp
create view Do_TCC as
select count(MaSV) as Soluong from Ketqua KQ
join Monhoc MH on MH.MaMH = KQ.MaMH
where TenMH = N'Toán cao cấp' and Diem >= 4;
--
create view Danhsachsvthilai as
select SV.Masv, tensv 
from Sinhvien sv join Ketqua KQ on SV.Masv = KQ.MaSV join Monhoc MH on MH.MaMH = KQ.MaMH
where TenMH = N'Toán cao cấp' and Diem >= 4;
----
select count(masv) from Danhsachsvthilai;
---
select * from Do_TCC;
--3. Lấy ra tên sinh viên thi và điểm trung bình của các sinh viên theo từng lớp
create view DTB_lop as
select TenSV, Lop, sum(Diem*DVHT)/sum(DVHT) as DiemTB from Sinhvien SV
join Ketqua KQ on KQ.MaSV = SV.Masv
join Monhoc MH on MH.MaMH = KQ.MaMH
group by TenSV, Lop;
--
select * from DTB_lop;
--4. Cho biết số sinh viên thi lại của từng môn
create view Thilai_mon as
select TenMH, count(Masv) as Soluong from Ketqua KQ
join Monhoc MH on KQ.MaMH = MH.MaMH
where Diem < 4
group by TenMH;
--
select *from Thilai_mon;
--5. Cho biết mã số và tên môn của những môn học mà tất cả các sinh viên đều đạt điểm >= 5
create view Diem_Hon_5
as
select MH.MaMH, TenMH from Monhoc MH
except 
select MH.MaMH, TenMH from Monhoc MH
join Ketqua KQ on KQ.MaMH = MH.MaMH
where Diem < 5;
--
select * from Diem_Hon_5;
--6. Cho biết mã số và tên những sinh viên có điểm trung bình học tập cao hơn điểm trung bình chung của mỗi lớp 
create view DTBSinhVien as
select SV.Masv, TenSV, Lop, Sum(Diem*DVHT)/sum(DVHT) as DTB1
from Sinhvien SV join Ketqua KQ on SV.Masv = KQ.MaSV
join Monhoc MH on MH.MaMH = KQ.MaMH
group by SV.Masv, TenSV, Lop;
--
create view DTBLop as
select Lop, Sum(Diem*DVHT)/sum(DVHT) as DTB2
from Sinhvien SV join Ketqua KQ on SV.Masv = KQ.MaSV
join Monhoc MH on MH.MaMH = KQ.MaMH
group by Lop;
--
--create view DTBSV as
select Masv, TenSV from DTBSinhVien, DTBLop
where DTBSinhVien.Lop = DTBLop.Lop and DTBSinhVien.DTB1 > DTBLop.DTB2;
--
select * from DTBSV;
--7. Cho biết mã số và tên những sinh viên có hơn một nửa số điểm >= 5
create view SLDiemHon5 as
select SV.Masv, TenSV, count(MaMH) as DiemHon5 
from Sinhvien SV join Ketqua KQ on SV.Masv = KQ.MaSV
where Diem >= 5
group by SV.Masv, TenSV;
---
create view NuaSoluongMH as
select MaSV, count(MaMH)/2 as NuaSLMH from Ketqua 
group by MaSV;
------
select SLDiemHon5.Masv, TenSV from SLDiemHon5, NuaSoluongMH
where SLDiemHon5.Masv = NuaSoluongMH.MaSV 
				and SLDiemHon5.DiemHon5 > NuaSoluongMH.NuaSLMH;
--

--8. Cho biết mã số và số điểm lớn hơn 7 của những sinh viên có hơn một nửa số điểm là >= 7
create view SLDiemHon7 as
select SV.Masv, TenSV, count(MaMH) as DiemHon7 
from Sinhvien SV join Ketqua KQ on SV.Masv = KQ.MaSV
where Diem >= 7
group by SV.Masv, TenSV;
---
select SLDiemHon7.Masv, DiemHon7 from SLDiemHon7, NuaSoluongMH
where SLDiemHon7.Masv = NuaSoluongMH.MaSV 
				and SLDiemHon7.DiemHon7 > NuaSoluongMH.NuaSLMH;
--
--Bài 2:
create database QL_BAN_HANG;
use QL_BAN_HANG
create table NHANVIEN (
	MaNV int identity primary key,
	Hoten Nvarchar(40),
	Diachi Nvarchar(40),
	SDT char(15),
	Ngaysinh date, 
	GT Nvarchar(7),
	HSL int 
	);
create table HANG (
	MaHang char(10) primary key,
	TenHang Nvarchar(40),
	NhaSX Nvarchar(30),
	TGBaoHanh int,
	
	);
create table KHACHHANG (
	MaKH char(15) primary key,
	TenKH Nvarchar(40),
	CMT Nvarchar(20),
	DiaChi Nvarchar(40),
	SDT char(15),
	Email varchar(50)
	);
create table HOADONXUAT (
	MaHD char(10) primary key,
	MaKH char(15) foreign key references KHACHHANG(MaKH),
	NgayLapHD date,
	MaNV int foreign key references NHANVIEN(MaNV),
	PhuongThucTT Nvarchar(20)
	);
create table CT_HOADON (
	MaHD char(10) foreign key references HOADONXUAT(MaHD),
	MaHang char(10) foreign key references HANG(MaHang),
	SoLuongMua int,
	DonGia int
	);
dbcc checkident(Nhanvien, reseed, 1);
insert into NHANVIEN(Hoten, Diachi, SDT, Ngaysinh, GT, HSL) values 
(N'Nguyễn Khánh Ngọc', N'Hà Nội', '08658963', '1992-05-01', N'Nữ', 4),
(N'Châu Ngọc Phương', N'Hà Nam', '08745612', '1993-08-14', N'Nữ', 3),
(N'Phạm Hùng Minh', N'Nghệ An', '08450203', '1970-04-01', N'Nam', 3),
(N'Bùi Công Sinh', N'Thái Bình', '08674036', '1997-04-03', N'Nam', 7),
(N'Trần Vĩ Minh', N'Hà Nội', '08716027', '1992-03-07', N'Nam', 5),
(N'Mai Kiều Oanh', N'Thanh Hóa', '08476502', '1988-10-21', N'Nữ', 3),
(N'Phạm Hoài Trâm', N'Bắc Ninh', '08445020', '1992-12-01', N'Nữ', 7);
insert into HANG values 
('H01', N'Bút máy', N'Thiên Long', 0),
('H02', N'Băng Nhạc', N'Music', 1),
('H03', N'Nồi cơm điện', N'Toshiba', 2),
('H04', N'Tủ Lạnh', N'Sony', 4),
('H05', N'Tivi', N'Samsung', 3),
('H06', N'Quạt', N'Chicken', 1),
('H07', N'Coca', N'Coca-cola', 0); 

insert into KHACHHANG values 
('KH01', N'Nguyễn Thị Hằng', '225126', N'Hà Nam', '08171717', 'hang@gmail.com'),
('KH02', N'Bùi Ngọc Linh', '060201', N'Thái Bình', '08146735', 'linh@gmail.com'),
('KH03', N'Nguyễn Thị Huyền Trang', '021001', N'Thanh Hóa', '08246747', 'trang@gmail.com'),
('KH04', N'Nguyễn Thị Tố Uyên', '012812', N'Hà Nam', '08777342', 'uyen@gmail.com'),
('KH05', N'Ngô Thị Huyền', '190601', N'Hà Nội', '080123456', 'huyen@gmail.com'),
('KH06', N'Trần Văn Hùng', '363644', N'Hà Giang', '08999234', 'hung@gmail.com');
insert into HOADONXUAT values
('HD01', 'KH01', '2021-01-29', 4, N'Tiền mặt'),
('HD02', 'KH05', '2020-12-01', 3, N'Thẻ'),
('HD03', 'KH04', '2021-11-15', 2, N'Tiền mặt'),
('HD04', 'KH02', '2021-02-06', 2, N'Tiền mặt'),
('HD05', 'KH02', '2020-12-12', 2, N'Thẻ'),
('HD06', 'KH06', '2020-02-11', 7, N'Tiền mặt'),
('HD07', 'KH03', '2021-01-01', 6, N'Tiền mặt');
insert into CT_HOADON values
('HD01', 'H01', 10, 50000),
('HD02', 'H03', 2, 1500000),
('HD03', 'H07', 5, 10000),
('HD04', 'H05', 3, 1350000),
('HD05', 'H04', 2, 4500000),
('HD06', 'H02', 3, 10000),
('HD07', 'H03', 1, 1500000);

select*from NHANVIEN;
select*from HANG;
select*from KHACHHANG;
select*from HOADONXUAT;
select*from CT_HOADON;
------------------------
--1. Tạo view chứa danh sách nhân viên nữ
create view NhanVienNu as
select * from NHANVIEN
where GT = N'Nữ';
--
select * from NhanVienNu;
--2. Tạo view chứa danh sách nhân viên với các thông tin: Mã nhân viên, họ tên, giới tính, tuổi
create view TuoiNV as
select MaNV, Hoten, GT, datediff(year, Ngaysinh, getdate()) as Tuoi
from NHANVIEN;
--
select * from TuoiNV;
--3. Tạo view cho biết họ tên của khách hàng đã mua tổng >10 triệu
create view TongMuaKH as
select KH.MaKH, TenKH, sum(SoLuongMua*DonGia) as TongMua 
from KHACHHANG KH
join HOADONXUAT HDX on KH.MaKH = HDX.MaKH
join CT_HOADON CTHD on HDX.MaHD = CTHD.MaHD
group by KH.MaKH, TenKH;
---------
select TenKH from TongMuaKH
where TongMuaKH.TongMua > 10000000;
--
select* from TongmuaKH;
--4. Tạo view cho biết họ tên của nhân viên đã bán được > 1 triệu tiền hàng 
create view TongBanNV as
select NV.MaNV, Hoten, sum(SoLuongMua*DonGia) as TongBan
from NHANVIEN NV 
join HOADONXUAT HDX on NV.MaNV = HDX.MaNV
join CT_HOADON CTHD on HDX.MaHD = CTHD.MaHD
group by NV.MaNV, Hoten;
---------
select Hoten from TongBanNV
where TongBanNV.TongBan > 1000000;
