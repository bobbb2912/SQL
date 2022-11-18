-- Bài 1: csdl Sinhvien
use QLSV;
select * from Sinhvien;
--1. Viết một thủ tục đưa ra các sinh viên có năm sinh bằng với năm sinh được nhập vào (lấy năm sinh bằng hàmdatepart(yyyy, ngaysinh))
create proc namsinh_sv (@namSinh int)
as
	select * from sinhvien
	where DATEPART(YEAR, Ngaysinh) = @namSinh;
---
namsinh_sv[1994];
--2. So sánh 2 sinh viên có mã được nhập vào xem sinh viên nào được sinh trước 
create proc soSanh (@masv1 int, @masv2 int)
as
declare @ngaysinh1 date, @ngaysinh2 date
select @ngaysinh1 = ngaysinh from Sinhvien where Masv = @masv1
select @ngaysinh2 = ngaysinh from Sinhvien where Masv = @masv2
if(@ngaysinh1 < @ngaysinh2)
print N'Sinh viên có mã'+ str(@masv1) + N'sinh trước sinh viên có mã' + str(@masv2)
else 
	if (@ngaysinh1 > @ngaysinh2)
	print N'Sinh viên có mã'+ str(@masv1) + N'sinh sau sinh viên có mã'+ str(@masv2)
	else 
	print N'Sinh viên có mã'+ str(@masv1) + N'có cùng ngày sinh với sinh viên có mã'+ str(@masv2)
--------------
soSanh 1, 2;

--3. Viết một hàm đưa ra tháng sinh. Áp dụng để đưa ra tháng sinh các bạn sinh viên đã thi có mã là 1.

create function thangSinh (@ngaySinh date)
	returns int
as
begin
	declare @thang int;
	select @thang = datepart(month, @Ngaysinh) from Sinhvien
	return (@thang)
end;
---
select dbo.thangSinh(ngaysinh) as thangsinh  from sinhvien
where Masv = 2;
---------------------
--Bai 2: CSDL QL_banhang
use QL_BAN_HANG
--1. Tính tổng tiền đã mua hàng của một khách hàng nào đó theo mã KH
create proc tongMua (@kh char(15))
as
begin
	select @kh, sum(SoLuongMua*DonGia) as TongMua 
	from KHACHHANG KH
	join HOADONXUAT HDX on KH.maKH= HDX.maKH
	join CT_HOADON CTHD on HDX.MaHD = CTHD.MaHD
	where KH.maKH = @kh
	group by KH.maKH
end
--
tongMua[KH01]

--2. Cho biết tổng số tiền hàng đã mua của một hóa đơn nào đó
create proc tongTien (@hd char(10))
as
begin
	select @hd, (soluongMua*DonGia) as soTien 
	from CT_HOADON
	where MaHD = @hd
end
---
select * from CT_HOADON
select * from HOADONXUAT
tongTien[HD02]
--3. Cho biết tổng số tiền hàng đã bán của một tháng nào đó.
create function tien_thang(@thang int)
returns table
as return
	--declare @thang int
	(select  datepart(month, NgayLapHD) as thang, sum(soluongMua*DonGia) as Tongtien
	from HOADONXUAT HDX
	join CT_HOADON CTHD on HDX.MaHD = CTHD.MaHD
	where @thang = datepart(month, NgayLapHD)
	group by datepart(month, NgayLapHD)
	)
----
select * from dbo.tien_thang(1)
--4. Cho biết họ tên của nhân viên có tuổi cao nhất.
create proc tuoi_cao_nhat
as
begin
	select Hoten, DATEDIFF(year, Ngaysinh, GETDATE()) as tuoi from NHANVIEN
	where DATEDIFF(year, Ngaysinh, GETDATE()) = 
		(select  max(TuoiNV.tuoi) from (select DATEDIFF(year, Ngaysinh, GETDATE()) as tuoi from NHANVIEN) as TuoiNV)
end
----
tuoi_cao_nhat
--------------------------------------------
use QLSV
-- Viết một thủ tục đưa ra các sinh viên có năm sinh bằng với năm sinh được nhập vào (lấy năm sinh bằng hàm datepart(yyyy, ngaysinh)
create proc namsinh_sv (@namSinh int)
as
	select * from sinhvien
	where DATEPART(YEAR, Ngaysinh) = @namSinh;
---
namsinh_sv[1994];
-- Viết thủ tục xóa dữ liệu của sinh viên theo mã sinh viên
create proc xoaSV(@masv int)
as
	delete from Ketqua where Masv = @masv
	delete from Sinhvien where Masv = @masv

---
execute xoaSV [20]
---
select*from Sinhvien;
---
insert Sinhvien(TenSV, Gioitinh, Ngaysinh, Que, Lop)values
('A', N'Nữ', '2001-12-29', N'AAA', 'L01')
------
-- Viết thủ tục sửa tên lớp của sinh viên theo mã sinh viên
drop proc suaLop 
create proc suaLop(@masv int, @lop nvarchar(10))
as
	update Sinhvien set Lop = @lop
	where Masv = @masv
---
execute suaLop 20, N'L02'
-- Viết thủ tục kiểm tra xem hai sinh viên có cùng năm sinh hay không 

create proc soSanhNamSinh (@masv1 int, @masv2 int)
as
begin
declare @namsinh1 int, @namsinh2 int
select @namsinh1 = datepart(year,ngaysinh) from Sinhvien where Masv = @masv1
select @namsinh2 = datepart(year,ngaysinh) from Sinhvien where Masv = @masv2
if(@namsinh1 <> @namsinh2)
	print N'Hai sinh viên khác năm sinh'
else 
	print N'Hai sinh viên có cùng năm sinh'
end
---
execute soSanhNamSinh 1, 16
-- Viết thủ tục kiểm tra xem hai sinh viên có mã được nhập vào xem sinh viên nào được sinh trước 
create proc soSanh (@masv1 int, @masv2 int)
as
declare @ngaysinh1 date, @ngaysinh2 date
select @ngaysinh1 = ngaysinh from Sinhvien where Masv = @masv1
select @ngaysinh2 = ngaysinh from Sinhvien where Masv = @masv2
if(@ngaysinh1 < @ngaysinh2)
print N'Sinh viên có mã'+ str(@masv1) + N'sinh trước sinh viên có mã' + str(@masv2)
else 
	if (@ngaysinh1 > @ngaysinh2)
	print N'Sinh viên có mã'+ str(@masv1) + N'sinh sau sinh viên có mã'+ str(@masv2)
	else 
	print N'Sinh viên có mã'+ str(@masv1) + N'có cùng ngày sinh với sinh viên có mã'+ str(@masv2)
--------------
soSanh 1, 2;
-- Đối với mỗi lớp, lập bảng điểm gồm mã sinh viên, tên sinh viên và điểm trung bình chung học tập
create proc DTB (@lop nvarchar(10))
as
	select SV.Masv, TenSV, sum(Diem*DVHT)/sum(DVHT) as diemtb from Sinhvien SV join Ketqua KQ on KQ.MaSV = SV.Masv join Monhoc MH on MH.MaMH = KQ.MaMH
	where Lop = @lop
	group by SV.Masv, TenSV
--
execute DTB [L01]
select* from Sinhvien
select* from Ketqua
-- Đối với mỗi lớp, cho biết mã sinh viên và tên những sinh viên phải thi lại từ 2 môn trở lên
--drop proc thilaiHon2MH
create proc thilaiHon2MH (@lop nvarchar(10))
as
	select SV.Masv, TenSV from Sinhvien SV join Ketqua KQ on KQ.MaSV = SV.Masv
	where Lop = @lop and Diem <= 4
	group by SV.Masv, TenSV
	having count(maMH) >= 2
--
execute thilaiHon2MH[L03]
