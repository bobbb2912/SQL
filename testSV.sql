create database QLLUANVAN;
use QLLUANVAN_hotenSV;
ALTER DATABASE QLLUANVAN MODIFY NAME =	QLLUANVAN_hotenSV;
create table SinhVien (
	MaSV int NOT NULL PRIMARY KEY,
	HoTen nchar(255),
	NgaySinh date,
	GioiTinh nchar(255),
	DiaChi nchar(255)
	)
create table LuanVan (
	MaLV int NOT NULL PRIMARY KEY,
	TenLV nchar(255),
	LoaiDeTai nchar(255),
	GVHuongDan nchar(255),
	MaSV int FOREIGN KEY REFERENCES SinhVien(MaSV)
	)
create table GiaoVien (
	MaGV int NOT NULL PRIMARY KEY,
	TenGV nchar(255),
	TrinhDo nchar(255)
	)
	alter table  LuanVan alter column TenLV  NOT NULL;
use sinhvien;
use QLLUANVAN_hotenSV
drop table GiaoVien;
drop table LuanVan;
drop table sinhvien;
alter table GiaoVien ADD  DEFAULT 'Tien Sy' FOR TrinhDo;
select*from GiaoVien;
