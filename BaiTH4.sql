use ThuVien;
select * from BANDOC
select * from SACH
select * from PHIEUMUON

go
--1. Xem bạn có mã bạn đọc là HN123 đã mượn những quyển sách nào(in mã sách và tên sách)
select S.maS, tenS from SACH S
join PHIEUMUON PM on S.maS = PM.maS
where maBD = 1;
--2. Có bao nhiêu cuốn Giáo trình đã được mượn vào 9/2021
select count(maBD) as soLuong from PHIEUMUON PM
join SACH S on S.maS = PM.maS
where S.theLoai = N'Giáo trình' and month(PM.ngayMuon) = 9 and year(PM.ngayMuon) = 2021;
--3. Hiển thị về việc mượn sách của những độc giả quê ở Hà Nội
select * from PHIEUMUON PM
join BANDOC BD on PM.maBD = BD.maBD
where queQuan = N'Hà Nội';
--4. Hiển thị mã bạn đọc và tên của những bạn đọc cùng mượn sách có mã là T123
select BD.maBD, hotenBD from BANDOC BD
join PHIEUMUON PM on PM.maBD = BD.maBD
where maS = 1; 
--5. Hiển thị danh sách bạn đọc quê ở Bắc Ninh và chưa trả sách
select hotenBD from BANDOC BD
join PHIEUMUON PM on BD.maBD = PM.maBD
where queQuan = N'Bắc Ninh' and traSach = 0;
--6. Hiển thị bạn đọc quê ở Hà Nội mượn nhiều sách nhất
select BD.maBD, hotenBD, count(PM.maBD) as muon from BANDOC BD
join PHIEUMUON PM on BD.maBD = PM.maBD
where queQuan = N'Hà Nội' 
group by BD.maBD, hotenBD
having count(PM.maBD) = (
	select max(Soluong.LanMuon) from 
	(select count(PM.maBD) as LanMuon from PHIEUMUON PM
	join BANDOC BD on PM.maBD = BD.maBD
	where queQuan = N'Hà Nội'
	group by PM.maBD) as Soluong
	);
--7. Tính số lượng sách của mỗi thể loại có trong thư viện
select theLoai, count(theLoai) as soLuong from SACH
group by theLoai;
--8. Hiển thị các cuốn sách được in ở nhà xuất bản giáo dục trước năm 2010
select tenS from SACH
where nhaXB = N'Giáo Dục' and namXB < 2010;
--9. Hiển thị các bạn có mã bạn đọc nhưng chưa mượn sách bao giờ 
select * from BANDOC BD
where maBD not in (select maBD from PHIEUMUON);
--10. Hiển thị các bạn mượn >= 2 quyển sách
select maBD from PHIEUMUON
group by maBD
having count(maBD) >= 2;
--11. Hiển thị các bạn mượn >= 3 quyển thuộc sách khoa học vào tháng  10/2018
select maBD from PHIEUMUON PM
join SACH S on S.maS = PM.maS
where S.theLoai = N'Khoa học' and month(ngayMuon) = 10 and year(ngayMuon) = 2018
group by maBD
having count(maBD) >= 3;
--12. Hiển thị tổng số sách đã được mượn ở thư viện
select count( distinct MaS) as SoSach from PHIEUMUON;
--13. Hiển thị mã và tên bạn đọc mượn sách nhiều hơn bạn có mã số là 1
select maBD, hotenBD from BANDOC
where maBD in (
	select maBD from PHIEUMUON
	group by maBD
	having count(maBD) > (select count(maBD) from PHIEUMUON where maBD = 1)
	);
--14. Hiển thị mã và tên cuốn sách được mượn nhiều nhất ít nhất năm 2021
select S.maS, tenS from SACH S, PHIEUMUON PM
where S.maS = PM.maS and year(ngayMuon) = 2021 
group by S.maS, tenS
having count(PM.maS) = (select max(Soluong.S) from
	(select PM.maS, count(PM.maS) as S from PHIEUMUON PM
	where year(PM.ngayMuon) = 2021
	group by maS) as Soluong)
	or count(PM.maS) = (select min(Soluong.S) from
	(select count(PM.maS) as S from PHIEUMUON PM
	where year(PM.ngayMuon) = 2021
	group by maS) as Soluong);
--15. Cho danh sách các bạn đọc mượn sách quá hạn tính đến ngày hiện tại
select * from BANDOC BD
join PHIEUMUON PM on BD.maBD = PM.maBD
where PM.traSach = 0 and datediff(day, ngayMuon, getdate()) > 5;