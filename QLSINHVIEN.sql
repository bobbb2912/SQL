CReate database QLSINHVIEN
use QLSINHVIEN
create table SinhVien (
	maSV int primary key,
	HoTen nvarchar(50),
	GioiTinh nvarchar(15) default N'Nam',
	Diem int check(diem >= 0 and diem <= 10),
	MaLop int foreign key references LopHoc(MaLop)
	)
create table GiaoVien (
	MaGV int primary key,
	TenGV nvarchar(50),
	TrinhdoCM nvarchar(50),
	MaLop int foreign key references LopHoc(MaLop)
	)
create table LopHoc (
	MaLop int primary key,
	TenLop nvarchar(50) NOT NULL,
	Diadiem nvarchar(100), 
	MaGVQL int
	)
alter table LopHoc alter column TenLop nvarchar(50);
 
alter table LopHoc
add foreign key (MaGVQL) references GiaoVien(MaGV); 
sp_help LopHoc

insert into SinhVien values
(1, N'Nguyễn Thị Hiền', N'Nữ', 10, 1),
(2, N'Nguyễn Văn A',N'Nam' ,9, 2),
(3, N'Trần Thị A', N'Nữ', 8, 3);
insert into GiaoVien values
(1, N'Giáo Viên 1', N'Cao Học', 2),
(2, N'Giáo Viên 2', N'Đại Học', 3),
(3, N'Giáo Viên 3', N'Giáo Viên', 1);
insert into LopHoc (MaLop, TenLop, Diadiem) values
(1, 'AT', 'A'), (2, 'CT', 'B'), (3, 'DT', 'C')
insert into LopHoc(MaGVQL) values
(1) 
update LopHoc set
MaGVQL = 3 where MaLop = 1

select HoTen, GioiTinh from SinhVien where MaLop = 3
order by HoTen ASC;

select HoTen, Diadiem
from SinhVien inner join LopHoc
ON SinhVien.MaLop = LopHoc.MaLop
where maSV = 1
order by HoTen DESC;

select tenLop from LopHoc
inner join SinhVien
ON LopHoc.MaLop = SinhVien.MaLop
where Diem >= 8;