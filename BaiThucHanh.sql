create database QLSV;
use QLSV;
--tao bang
create table Sinhvien (
	Masv int identity primary key,
	TenSV nvarchar(30) NOT NULL,
	Gioitinh nvarchar(5) default N'Nam',
	Ngaysinh date check (Ngaysinh < getdate()),
	Que nvarchar(50) NOT NULL,
	Lop nvarchar(10)
	);
create table Monhoc (
	MaMH int identity primary key,
	TenMH nvarchar(20) unique,
	DVHT int check (DVHT between 2 and 9)
	);
create table Ketqua (
	MaSV int,
	MaMH int,
	Diem float check(Diem between 0 and 10),
	constraint PK_Ketqua primary key(MaSV, MaMH)
	);
--tao csdl bang Sinhvien
alter table Ketqua add
constraint FK_MH foreign key (MaMH) references Monhoc(MaMH);
insert into Sinhvien(TenSV, Ngaysinh, Que, Lop) values
(N'Trần Bảo Trọng', '1995-12-14', N'Hà Giang', 'L02'),
(N'Lê Thùy Dương', '1997-05-12', N'Hà Nội', 'L03'),
(N'Trần Phương Thảo', '1996-03-30', N'Quảng Ninh', 'L01'),
(N'Lê Trường An', '1995-11-20', N'Ninh Bình', 'L04'),
(N'Phạm Thị Hương Giang', '1999-02-21', N'Hòa Bình', 'L02'),
(N'Trần Anh Bảo', '1995-12-14', N'Hà Giang', 'L02'),
(N'Lê Thùy Dung', '1997-05-12', N'Hà Nội', 'L03'),
(N'Phạm Trung Tính', '1996-03-30', N'Quảng Ninh', 'L01'),
(N'Lê An Hải', '1995-11-20', N'Ninh Bình', 'L04'),
(N'Phạm Thị Giang Hương', '1999-02-21', N'Hòa Bình', 'L02'),
(N'Đoàn Duy Thức', '1994-04-12', N'Hà Nội', 'L01'),
(N'Dương Tuấn Thông', '1991-04-12', N'Nam Định', 'L03'),
(N'Lê Thành Đạt', '1993-04-15', N'Phú Thọ', 'L04'),
(N'Nguyễn Hằng Nga', '1993-05-25', N'Hà Nội', 'L01'),
(N'Trần Thanh Nga', '1994-06-20', N'Phú Thọ', 'L03'),
(N'Trần Trọng Hoàng', '1995-12-14', N'Hà Giang', 'L02'),
(N'Nguyễn Mai Hoa', '1997-05-12', N'Hà Nội', 'L03'),
(N'Lê Thúy An', '1998-03-23', N'Hà Nội', 'L01');
update  Sinhvien set Gioitinh = N'Nữ'
where MaSV = 2 or MaSV = 7 or MaSV = 10 or MaSV = 14 or MaSV = 15 or MaSV = 17;
--update  Sinhvien set Gioitinh = N'Nữ'
where MaSV = 10;
update  Sinhvien set Gioitinh = N'Nữ'
where MaSV = 14;
update  Sinhvien set Gioitinh = N'Nữ'
where MaSV = 15;
update  Sinhvien set Gioitinh = N'Nữ'
where MaSV = 17;
-- tao csdl bang Monhoc
dbcc checkident ('Monhoc', REseed, 1)
insert into Monhoc(TenMH, DVHT) values
(N'Toán cao cấp', 3),
(N'Mạng máy tính', 3),
(N'Tin đại cương', 4);
('HQT CSDL', 3),
('CTDL', 2);
--tao csdl bang Ketqua
insert into Ketqua values
(1, 1, 8), 
(1, 2, 5),
(1, 3, 7), 
(2, 1, 9),
(2, 2, 5),
(2, 3, 2),
(3, 1, 4),
(3, 2, 2),
(4, 1, 1),
(4, 2, 3),
(5, 1, 4),
(6, 1, 2),
(6, 2, 7),
(6, 3, 9),
(7, 1, 4),
(7, 2, 5),
(7, 3, 8),
(8, 1, 9),
(8, 2, 8),
(9, 1, 7),
(9, 2, 7),
(9, 3, 5),
(10, 1, 3),
(10, 3, 6),
(11, 1, 6),
(12, 1, 8),
(12, 2, 7),
(12, 3, 5),
(13, 1, 6),
(13, 2, 5),
(13, 3, 5),
(14, 1, 8),
(14, 2, 9),
(14, 3, 7),
(15, 1, 3),
(15, 2, 6),
(15, 3, 4);
-----------------
select * from Sinhvien;
select * from Monhoc;
select * from Ketqua;
sp_help Sinhvien;
-------------------------------------------------------------------------
create database ThuVien 
use Thuvien
create table BANDOC (
	maBD int identity primary key,
	hotenBD nvarchar(50) not null ,
	ngaySinh date check (ngaySinh<getdate()),
	lop  char(6) not null,
	queQuan nvarchar(30) not null,
	SDT char(15) not null 
	);
--alter table BANDOC ADD constraint BANDOC_SDT CHECK (LEN(SDT) between 9 and 10) 
--alter table BANDOC alter column SDT char(15);
create table SACH (
	maS int identity primary key ,
	tenS nvarchar(30) not null,
	theLoai nvarchar(30) not null ,
	tacGia nvarchar(30) not null ,
	namXB nvarchar(30) not null ,
	nhaXB nvarchar(30) not null 
	);
create table PHIEUMUON(
	maBD int NOT NULL  foreign key references BANDOC	(maBD),
	maS  int  not null foreign key references SACH		(maS),
	ngayMuon datetime not null,
	ngayHenTra datetime not null,
	traSach bit default '0',
	constraint PHIEUMUON_KEY primary key (maBD,maS)
	);
alter table PHIEUMUON add constraint PHIEUMUON_ngaytra check(datediff(day,ngayMuon,ngayHenTra) <=5)  -- sach chi duoc muon toi da 5 ngay 
-----------
-- chen du lieu vao bang BANDOC
--truncate table SACH
--dbcc checkident(BANDOC, RESEED, 1)
insert into BANDOC(hotenBD, ngaySinh, lop, queQuan, SDT) values 
(N'Trần Bảo Trọng', '2000-03-14', 'L02', N'Hà Giang', '098765432'),
( N'Lê Thùy Dương', '2001-05-12', 'L03', N'Hà Nội', '0327488912'),
(N'Trần Phương Thảo', '1996-03-30', 'L01', N'Quảng Ninh', '09355489'),
( N'Phạm Thị Hương Giang', '1999-02-21', 'L04', N'Ninh Bình', '0354896345'),
( N'Đoàn Duy Thức', '2001-04-12', 'L02', N'Hòa Bình', '0931045877'),
( N'Lê Thúy An', '1999-12-14', 'L03', N'Hà Nội', '0326973483'),
( N'Nguyễn Hằng Nga', '1998-03-23', 'L01', N'Phú Thọ', '0926973483'),
( N'Nguyễn Hoa Mai', '2001-04-15', 'L03', N'Nam Định', '0935554898'),
(N'Lê An Hải', '2002-11-20', 'L04', N'Nghệ An', '0315152655'),
( N'Lê Thành Đạt', '1999-02-21', 'L01', N'Nghệ An', '0955145531')
-- chen du lieu vao bang SACH
insert into SACH(tenS, theLoai, tacGia, namXB, nhaXB) values
( N'Tin học đại cương', N'Khoa học công nghệ', N'Bùi Thế Tâm', 2010, N'Thời đại'),
(N'Triết học Mác-Lênin', N'Trinh thám', N'Phạm Văn Đức', 2019, N'Khoa học lý luận'),
(N'Lá cờ thêu sáu chữ vàng', N'Văn học lịch sử', N'Nguyễn Huy Tưởng', 1995, N'Kim Đồng'),
( N'Đắc Nhân Tâm', N'Tâm lí', N'Dale Carnegie', 2015, N'Trẻ'),
(N'Toán Cao Cấp', N'Giáo trình', N'Nguyễn Trung Đông', 1996, N'Đại học Tài Chính'),
( N'Quản trị mạng', N'Giáo trình', N'Lê Thị Hồng Vân', 2019, N'Học Viện Kỹ Thuật Mật Mã');

--chen du lieu vao bang PHIEUMUON
insert into PHIEUMUON values
(1, 3, '2015-12-12', '2015-12-15', 1),
(1, 2, '2021-9-19', '2021-9-22', 1),
(2, 4, '2021-5-9', '2021-5-10', 1),
(5, 5, '2021-6-30', '2021-7-1', 1),
(7, 1, '2021-12-29', '2021-1-1', 0),
(8, 1, '2021-8-9', '2021-8-13', 0),
(8, 3, '2021-2-23', '2021-2-27', 1),
(8, 4, '2021-9-14', '2021-9-18', 1),
(9, 1, '2021-5-20', '2021-5-24', 0),
(10, 6, '2021-3-31', '2021-4-2', 1);
  
-------------------
--drop table PHIEUMUON
--drop table BANDOC
--drop table SACH 
----------------
select * from BANDOC;
select * from SACH;
select * from PHIEUMUON;

-----------------------------------------------------------------------------
create database QLMB 
use QLMB

create table Chuyenbay (
	MaCB char(5) primary key,
	GaDi varchar(50),
	GaDen varchar(50),
	DoDai int,
	GioDi time,
	GioDen time,
	ChiPhi int,
	);
create table Maybay (
	MaMB int primary key,
	Hieu varchar(50),
	TamBay int 
	);
create table Nhanvien (
	MaNV char(9) primary key,
	Ten Nvarchar(50),
	Luong int
	);
create table Chungnhan (
	MaNV char(9) foreign key references Nhanvien(MaNV),
	MaMB int foreign key references Maybay(MaMB)
	); 
--tao csdl bang Chuyenbay
insert into Chuyenbay values
('VN431', 'SGN', 'CAH', 3693, '05:55', '06:55', 236),
('VN320', 'SGN', 'DAD', 2798, '06:00', '07:10', 221),
('VN464', 'SGN', 'DLI', 2002, '07:20', '08:05', 225),
('VN216', 'SGN', 'DIN', 4170, '10:30', '14:20', 262),
('VN280', 'SGN', 'HPH', 11979, '06:00', '08:00', 1279),
('VN254', 'SGN', 'HUI', 8765, '18:40', '20:00', 781),
('VN338', 'SGN', 'BMV', 4081, '15:25', '16:25', 375),
('VN440', 'SGN', 'BMV', 4081, '18:30', '19:30', 426),
('VN651', 'DAD', 'SGN', 2798, '19:30', '08:00', 221),
('VN276', 'DAD', 'CXR', 1283, '09:00', '12:00', 203),
('VN374', 'HAN', 'VII', 510, '11:40', '13:25', 120),
('VN375', 'VII', 'CXR', 752, '14:15', '16:00', 181),
('VN269', 'HAN', 'CXR', 1262, '14:10', '15:50', 202),
('VN315', 'HAN', 'DAD', 134, '11:45', '13:00', 112),
('VN317', 'HAN', 'UIH', 827, '15:00', '16:15', 190),
('VN741', 'HAN', 'PXU', 395, '06:30', '08:30', 120),
('VN474', 'PXU', 'PQC', 1586, '08:40', '11:20', 102),
('VN476', 'UIH', 'PQC', 485, '09:15', '11:50', 117);
--tao csdl cho bang Maybay
insert into Maybay values
(747, 'Boeing 747 - 400', 13488),
(737, 'Boeing 737 - 800', 5413),
(340, 'Airbus A340 - 300', 11392),
(757, 'Boeing 757 - 300', 6416),
(777, 'Boeing 777 - 300', 10306),
(767, 'Boeing 767 - 400ER', 10360),
(320, 'Airbus A320', 4168),
(319, 'Airbus A319', 2888),
(727, 'Boeing 727', 2406),
(154, 'Tupolev 154', 6565);
-- tao csdl cho bang Nhanvien
insert into Nhanvien values 
('242518965', 'Tran Van Son', 120433),
('141582651', 'Doan Thi Mai', 178345),
('011564812', 'Ton Van Quy', 153972),
('567354612', 'Quan Cam Ly', 256481),
('552455318', 'La Que', 101745),
('550156548', 'Nguyen Thi Cam', 205187),
('390487451', 'Le Van Luat', 212156),
('274878974', 'Mai Quoc Minh', 99890),
('254099823', 'Nguyen Thi Quynh', 24450),
('356187925', 'Nguyen Vinh Bao', 44740),
('355548984', 'Tran Thi Hoai An', 212156),
('310454876', 'Ta Van Do', 212156),
('489456522', 'Nguyen Thi Quy Linh', 127984),
('489221823', 'Bui Quoc Chinh', 23980),
('548977562', 'Le Van Quy', 84476),
('310454877', 'Tran Van Hao', 33546),
('142519864', 'Nguyen Thi Xuan Dao', 227489),
('269734834', 'Truong Tuan Anh', 289950),
('287321212', 'Duong Van Minh', 48090),
('552455348', 'Bui Thi Dung', 92013),
('248965255', 'Tran Thi Ba', 43723),
('159542516', 'Le Van Ky', 48250),
('328121549', 'Nguyen Van Thanh', 32899),
('574489457', 'Bui Van Lap', 20);
--tao csdl cho bang Chungnhan
insert into Chungnhan values
('567354612', 747), ('567354612', 737), ('567354612', 757), ('567354612', 777), ('567354612', 767), ('567354612', 727), ('567354612', 340),
('552455318', 737), ('552455318', 319), ('552455318', 747), ('552455318', 767),
('390487451', 340), ('390487451', 320), ('390487451', 319),
('274878974', 757), ('274878974', 767),
('355548984', 154),
('310454876', 154),
('142519864', 747), ('142519864', 757), ('142519864', 777), ('142519864', 767),('142519864', 737), ('142519864', 340), ('142519864', 320),
('269734834', 747), ('269734834', 737), ('269734834', 340), ('269734834', 757), ('269734834', 777), ('269734834', 767), ('269734834', 320), ('269734834', 319), ('269734834', 727), ('269734834', 154), 
('242518965', 737), ('242518965', 757),
('141582651', 737), ('141582651', 757), ('141582651', 767),
('011564812', 737), ('011564812', 757),
('574489457', 154);
---------
select * from Chuyenbay;
select * from Maybay;
select * from Nhanvien;
select * from Chungnhan;