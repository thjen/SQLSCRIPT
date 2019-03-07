-- bai1
SELECT * 
FROM VATTU 
ORDER BY TenVTu DESC

SELECT TenNhaCc
FROM NHACC
WHERE DiaChi = N'1 TP HO CHI MINH'
ORDER BY TenNhaCc ASC

SELECT *, SlNhap*DgNhap AS 'THANH TIEN'
FROM CTPNHAP

SELECT DISTINCT NCC.MaNhaCc, NCC.TenNhaCc
FROM NHACC AS NCC JOIN DONDH AS DH
	ON  NCC.MaNhaCc = DH.MaNhaCc

SELECT *
FROM DONDH
WHERE NgayDh = (SELECT MAX(NgayDh) FROM DONDH)

SELECT SoPx, SlXuat*DgXuat AS 'TONG GIA TRI' 
FROM CTPXUAT
ORDER BY SlXuat*DgXuat DESC

SELECT VT.TenVTu, COUNT(CTPX.SlXuat)  
FROM VATTU AS VT JOIN CTPXUAT AS CTPX
	ON VT.MaVTu = CTPX.MaVTu
GROUP BY VT.TenVTu

DELETE CTDONDH
FROM CTDONDH AS CTDH JOIN DONDH AS DH
	ON CTDH.SoDh = DH.SoDh
WHERE DH.NgayDh = 2002/01/15

DELETE CTPXUAT
FROM CTPXUAT

INSERT INTO CTDONDH VALUES
('D001', 'DD01', 10),
('D001', 'DD02', 15),
('D002', 'VD02', 30),
('D003', 'TV14', 10),
('D003', 'TV29', 20),
('D004', 'TV14', 10),
('D002', 'TV14', 10),
('D001', 'VD01', 20);

SELECT CTPN.SoPn, PN.NgayNhap
FROM CTPNHAP AS CTPN JOIN PNHAP AS PN
	ON CTPN.SoPn = PN.SoPn
UNION 
SELECT VT.TenVTu, CTPN.SlNhap
FROM CTPNHAP AS CTPN JOIN VATTU AS VT
	ON CTPN.MaVTu = VT.MaVTu

	-- end bai1
	--------------------------------------------------
	-- bai 2
select *, 
	case
		when DATEPART(weekday,NgayDh) = 0 then 'Chu nhat'
		when DATEPART(weekday,NgayDh) = 1 then 'Thu hai'
		when DATEPART(weekday,NgayDh) = 2 then 'Thu ba'
		when DATEPART(weekday,NgayDh) = 3 then 'Thu tu'
		when DATEPART(weekday,NgayDh) = 4 then 'Thu nam'
		when DATEPART(weekday,NgayDh) = 5 then 'Thu sau'
		else 'Thu bay'
	end as thu
from DONDH
	
	--------------------------------------------------
select (
	case 
		when cx.SlXuat >= 4 and cx.SlXuat < 10 then DgXuat*0.05
		when cx.SlXuat >= 10 and cx.SlXuat <= 20 then DgXuat*0.1
		when cx.SlXuat > 20 then DgXuat*0.2
		else DgXuat
	end
) 
from CTPXuat as cx join PXUAT as px
	on cx.SoPx = px.SoPx
where YEAR(px.NgayXuat) = 2005 and Month(px.NgayXuat) = 01
	
	-- end bai2
	--------------------------------------------------
	-- bai 3
create view vw_dmvt
as
select MaVTu,TenVTu
from VATTU

select * from vw_dmvt

	--------------------------------------------------
create view vw_dondh_tongsldatnhap
as
select ctdh.SoDh, sum(ctdh.SlDat) as 'tong so luong dat', sum(ctpn.SlNhap) as 'tong so luong nhap'
from CTDONDH as ctdh 
	join DONDH as dh
		on ctdh.SoDh = dh.SoDh
	join PNHAP as pn
		on pn.SoDh = dh.SoDh
	join CTPNHAP as ctpn
		on ctpn.SoPn = pn.SoPn
group by ctdh.SoDh

select * from vw_dondh_tongsldatnhap

	--------------------------------------------------
create view vw_tongnhap
as
select tk.NamThang, vt.MaVTu, sum(ctpn.SlNhap) as 'tong so luong nhap'
from VATTU as vt 
	join TONKHO as tk
		on vt.MaVTu = tk.MaVTu
	join CTPNHAp as ctpn
		on ctpn.MaVTu = vt.MaVTu
group by tk.NamThang, vt.MaVTu

select * from vw_tongnhap

	--------------------------------------------------
create view vw_tongxuat
as
select tk.NamThang, vt.MaVTu, sum(ctpx.SlXuat) as 'tong so luong xuat'
from VATTU as vt 
	join TONKHO as tk
		on vt.MaVTu = tk.MaVTu
	join CTPXuat as ctpx
		on ctpx.MaVTu = vt.MaVTu
group by tk.NamThang, vt.MaVTu

select * from vw_tongnhap
	
	--------------------------------------------------
create view vw_dondh_mavt_tongslnhap
as
select dh.SoDh, dh.NgayDh, vt.MaVTu, vt.TenVTu, ctdh.SlDat, sum(ctpn.SlNhap) as 'Tong so luong nhap'
from DONDH as dh
	join PNHAP as pn
		on dh.SoDh = pn.SoDh
	join CTPNHAP as ctpn
		on ctpn.SoPn = pn.SoPn
	join VATTU as vt
		on vt.MaVTu = ctpn.MaVTu
	join CTDONDH as ctdh
		on ctdh.SoDh = dh.SoDh
group by dh.SoDh, dh.NgayDh, vt.MaVTu, vt.TenVTu, ctdh.SlDat

select * from vw_dondh_mavt_tongslnhap
