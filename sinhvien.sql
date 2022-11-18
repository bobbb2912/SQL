select * from SINHVIEN1;
create database sinhvien
on primary (
	name = csdl_sinhvien,
	size = 5MB,
	maxsize = 10MB,
	FileGrowth = 10%,
	filename = 'D:\SQL\csdl_sinhvien.mdf'
	)
log on (
	name = csdl_sinhvien_log,
	size = 4MB,
	maxsize = 10MB,
	FileGrowth = 10%,
	filename = 'D:\SQL\csdl_sinhvien_log.mdf'
	)

use  sinhvien;
create table danh_sach_SV (
	maSV int NOT NULL PRIMARY KEY,
	HoVaTen nchar(255) NOT nULL,
	NamSinh date,
	SDT nchar(255),
	QueQuan nchar(255),
	)
INSERT INTO danh_sach_SV VALUES (1, 'Nguyen Van A', '1998-10-09', '0169881689', 'Ha Nam')
INSERT INTO danh_sach_SV VALUES (2, 'Hoang Mai C', '1998-09-09', '016348189', 'Ha Noi')
INSERT INTO danh_sach_SV VALUES (3, 'Nguyen Thi C', '1998-08-12', '096988169', 'Thai Binh')
INSERT INTO danh_sach_SV VALUES (4, 'Le Thi D', 
'1998-03-15', '096341356', 'Nam Dinh')
INSERT INTO danh_sach_SV VALUES (5, 'Tran Mai K', '1998-05-09', '0985613589', 'Thai Binh')
INSERT INTO danh_sach_SV VALUES (6, 'lưu Văn K', 
'1998-09-20', '0984562579', 'Ha Noi')

SELECT * FROM danh_sach_SV;
UPDATE danh_sach_SV
SET HoVaTen = 'Lưu Văn K', QueQuan = 'Hà Nội' WHERE maSV = 6;