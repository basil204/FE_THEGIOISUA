-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 02, 2024 lúc 09:08 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `hp03_english`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `image_data` longblob NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `invoice`
--

CREATE TABLE `invoice` (
  `id` bigint(20) NOT NULL,
  `invoicecode` varchar(255) NOT NULL,
  `creationdate` datetime DEFAULT current_timestamp() COMMENT 'Ngày tạo hóa đơn',
  `voucherid` bigint(20) DEFAULT NULL,
  `discountamount` int(11) NOT NULL,
  `totalamount` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái hóa đơn'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `invoice`
--

INSERT INTO `invoice` (`id`, `invoicecode`, `creationdate`, `voucherid`, `discountamount`, `totalamount`, `status`) VALUES
(1, 'INV001', '2024-10-13 16:12:04', NULL, 0, 100000, 1),
(2, 'INV002', '2024-10-13 16:12:04', NULL, 5000, 150000, 1),
(3, 'INV003', '2024-10-14 14:54:08', NULL, 10000, 100000, 1),
(4, 'INV004', '2024-10-14 07:59:48', NULL, 0, 100000, 1),
(5, 'INV005', '2024-10-14 08:03:28', NULL, 0, 100000, 1),
(6, 'INV006', '2024-10-14 08:07:06', NULL, 0, 100000, 1),
(7, 'INV007', '2024-10-14 14:53:00', 1, 10000, 100000, 1),
(8, 'INV008', '2024-10-14 08:08:30', NULL, 0, 100000, 1),
(9, 'INV009', '2024-10-14 08:08:43', 1, 0, 100000, 1),
(10, 'INV001', '2024-10-14 08:14:00', 1, 0, 100000, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `invoicedetail`
--

CREATE TABLE `invoicedetail` (
  `id` bigint(20) NOT NULL,
  `invoiceid` bigint(20) DEFAULT NULL,
  `milkdetailid` bigint(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL COMMENT 'Số lượng',
  `price` int(11) NOT NULL,
  `totalprice` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái chi tiết hóa đơn'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `invoicedetail`
--

INSERT INTO `invoicedetail` (`id`, `invoiceid`, `milkdetailid`, `quantity`, `price`, `totalprice`, `status`) VALUES
(1, 1, 1, 10, 10000, 100000, 1),
(2, 2, 2, 5, 20000, 100000, 1),
(3, 1, 1, 10, 10000, 100000, 1),
(4, 1, 1, 10, 10000, 100000, 1),
(5, 1, 1, 10, 10000, 100000, 1),
(6, 1, 3, 13, 10000, 130000, 1),
(7, 1, 3, 13, 10000, 130000, 1),
(8, 1, 3, 13, 10000, 130000, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `milkbrand`
--

CREATE TABLE `milkbrand` (
  `id` bigint(20) NOT NULL,
  `milkbrandname` varchar(100) DEFAULT NULL COMMENT 'Tên thương hiệu sữa',
  `description` varchar(255) DEFAULT NULL COMMENT 'Mô tả thương hiệu',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái thương hiệu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `milkbrand`
--

INSERT INTO `milkbrand` (`id`, `milkbrandname`, `description`, `status`) VALUES
(1, 'Vinamilk', 'Thương hiệu sữa hàng đầu Việt Nam', 1),
(2, 'TH True Milk', 'Thương hiệu sữa hàng đầu Việt Nam', 1),
(3, 'Dutch Lady', 'Thương hiệu sữa hàng đầu Việt Nam', 1),
(4, 'NutiFood', 'Thương hiệu sữa đậu nành hàng đầu', 1),
(5, 'Nestlé', 'Thương hiệu đồ uống hàng đầu thế giới', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `milkdetail`
--

CREATE TABLE `milkdetail` (
  `id` int(11) NOT NULL COMMENT 'ID chi tiết sản phẩm sữa',
  `milkdetailcode` varchar(255) DEFAULT NULL,
  `productid` int(11) DEFAULT NULL COMMENT 'ID sản phẩm',
  `milktasteid` int(11) DEFAULT NULL COMMENT 'ID vị sữa',
  `packagingunitid` int(11) DEFAULT NULL COMMENT 'ID đơn vị đóng gói',
  `usagecapacityid` int(11) DEFAULT NULL COMMENT 'ID công suất sử dụng',
  `expirationdate` date DEFAULT NULL COMMENT 'Ngày hết hạn',
  `price` decimal(18,0) DEFAULT NULL COMMENT 'Giá sản phẩm',
  `imgUrl` varchar(255) DEFAULT NULL COMMENT 'url ảnh Sản phẩm',
  `description` varchar(500) NOT NULL,
  `stockquantity` int(11) DEFAULT NULL COMMENT 'Số lượng tồn kho',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái sản phẩm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `milkdetail`
--

INSERT INTO `milkdetail` (`id`, `milkdetailcode`, `productid`, `milktasteid`, `packagingunitid`, `usagecapacityid`, `expirationdate`, `price`, `imgUrl`, `description`, `stockquantity`, `status`) VALUES
(0, '0', 0, 0, 0, 0, '0000-00-00', 0, '0', '0', 0, 0),
(1, '1', 1, 1, 1, 1, '0000-00-00', 1, '1', '1', 1, 1),
(634, 'MD0001', 1, 1, 1, 1, '2025-03-02', 34421, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_1_5b8c6c94dd.png', 'Sản phẩm sữa tươi Vinamilk', 631, 1),
(635, 'MD0002', 1, 1, 1, 2, '2026-09-06', 19964, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_1_b81fc23fef.png', 'Sản phẩm sữa tươi Vinamilk', 837, 1),
(636, 'MD0003', 1, 1, 1, 3, '2026-02-25', 32107, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/SSD_FINO_Dau_220_1_00a16dcf9b.png', 'Sản phẩm sữa tươi Vinamilk', 630, 1),
(637, 'MD0004', 1, 1, 1, 4, '2025-10-22', 38431, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_1_L_1_5b62401c86.png', 'Sản phẩm sữa tươi Vinamilk', 581, 1),
(638, 'MD0005', 1, 1, 1, 5, '2025-10-24', 17926, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_1_5b8c6c94dd.png', 'Sản phẩm sữa tươi Vinamilk', 730, 0),
(639, 'MD0006', 1, 1, 2, 1, '2026-08-30', 24933, 'https://vietnam-mart.com/wp-content/uploads/2022/10/a3.jpg', 'Sản phẩm sữa tươi Vinamilk', 422, 1),
(640, 'MD0007', 1, 1, 2, 2, '2024-12-08', 19972, 'https://vietnam-mart.com/wp-content/uploads/2022/10/a3.jpg', 'Sản phẩm sữa tươi Vinamilk', 171, 0),
(641, 'MD0008', 1, 1, 2, 3, '2025-06-03', 20458, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/SSD_FINO_Dau_220_1_00a16dcf9b.png', 'Sản phẩm sữa tươi Vinamilk', 508, 0),
(642, 'MD0009', 1, 1, 2, 4, '2025-08-02', 24186, 'https://vietnam-mart.com/wp-content/uploads/2022/10/a3.jpg', 'Sản phẩm sữa tươi Vinamilk', 498, 0),
(643, 'MD0010', 1, 1, 2, 5, '2026-10-10', 17671, 'https://vietnam-mart.com/wp-content/uploads/2022/10/a3.jpg', 'Sản phẩm sữa tươi Vinamilk', 349, 0),
(644, 'MD0011', 1, 1, 3, 1, '2026-05-18', 18728, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_3_0c1ba23b9d.png', 'Sản phẩm sữa tươi Vinamilk', 74, 1),
(645, 'MD0012', 1, 1, 3, 2, '2026-07-19', 21383, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_3_c0e08cd2f4.png', 'Sản phẩm sữa tươi Vinamilk', 639, 1),
(646, 'MD0013', 1, 1, 3, 3, '2026-09-28', 13222, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/SSD_FINO_Dau_220_1_00a16dcf9b.png', 'Sản phẩm sữa tươi Vinamilk', 119, 0),
(647, 'MD0014', 1, 1, 3, 4, '2026-08-14', 35016, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_3_c0e08cd2f4.png', 'Sản phẩm sữa tươi Vinamilk', 420, 0),
(648, 'MD0015', 1, 1, 3, 5, '2025-07-06', 21316, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_3_c0e08cd2f4.png', 'Sản phẩm sữa tươi Vinamilk', 515, 0),
(649, 'MD0016', 1, 1, 4, 1, '2024-12-08', 12277, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_4_368620a220.png', 'Sản phẩm sữa tươi Vinamilk', 623, 0),
(650, 'MD0017', 1, 1, 4, 2, '2026-09-01', 30979, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_4_4f044e675f.png', 'Sản phẩm sữa tươi Vinamilk', 479, 0),
(651, 'MD0018', 1, 1, 4, 3, '2025-03-19', 33887, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/SSD_FINO_Dau_220_4_c5b154bfa4.png', 'Sản phẩm sữa tươi Vinamilk', 967, 0),
(652, 'MD0019', 1, 1, 4, 4, '2026-10-14', 31775, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_4_4f044e675f.png', 'Sản phẩm sữa tươi Vinamilk', 840, 0),
(653, 'MD0020', 1, 1, 4, 5, '2025-09-21', 40166, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_4_4f044e675f.png', 'Sản phẩm sữa tươi Vinamilk', 744, 0),
(654, 'MD0021', 1, 1, 5, 1, '2026-02-02', 41808, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_3_0c1ba23b9d.png', 'Sản phẩm sữa tươi Vinamilk', 257, 1),
(655, 'MD0022', 1, 1, 5, 2, '2026-07-19', 12068, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_180_3_c0e08cd2f4.png', 'Sản phẩm sữa tươi Vinamilk', 67, 1),
(656, 'MD0023', 1, 1, 5, 3, '2026-03-05', 20846, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_3_0c1ba23b9d.png', 'Sản phẩm sữa tươi Vinamilk', 162, 1),
(657, 'MD0024', 1, 1, 5, 4, '2025-05-27', 19516, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_3_0c1ba23b9d.png', 'Sản phẩm sữa tươi Vinamilk', 837, 0),
(658, 'MD0025', 1, 1, 5, 5, '2025-02-04', 31191, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_DAU_110_3_0c1ba23b9d.png', 'Sản phẩm sữa tươi Vinamilk', 532, 0),
(659, 'MD0026', 1, 2, 1, 1, '2025-10-19', 25144, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_1_5e96a1a238.png', 'Sản phẩm sữa tươi Vinamilk', 870, 1),
(660, 'MD0027', 1, 2, 1, 2, '2026-06-06', 24128, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_1_3465af162b.png', 'Sản phẩm sữa tươi Vinamilk', 540, 1),
(661, 'MD0028', 1, 2, 1, 3, '2025-12-22', 34322, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_1_5e96a1a238.png', 'Sản phẩm sữa tươi Vinamilk', 360, 0),
(662, 'MD0029', 1, 2, 1, 4, '2025-02-02', 24576, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_1_5e96a1a238.png', 'Sản phẩm sữa tươi Vinamilk', 994, 0),
(663, 'MD0030', 1, 2, 1, 5, '2026-08-28', 29850, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_1_5e96a1a238.png', 'Sản phẩm sữa tươi Vinamilk', 298, 0),
(664, 'MD0031', 1, 2, 2, 1, '2025-10-28', 49753, 'https://cdn.shopify.com/s/files/1/0761/8769/7443/files/SSDFindo_SCL_220_1.png?v=1698811984', 'Sản phẩm sữa tươi Vinamilk', 545, 1),
(665, 'MD0032', 1, 2, 2, 2, '2026-02-07', 12323, 'https://cdn.shopify.com/s/files/1/0761/8769/7443/files/SSDFindo_SCL_220_1.png?v=1698811984', 'Sản phẩm sữa tươi Vinamilk', 858, 1),
(666, 'MD0033', 1, 2, 2, 3, '2026-07-20', 32802, 'https://cdn.shopify.com/s/files/1/0761/8769/7443/files/SSDFindo_SCL_220_1.png?v=1698811984', 'Sản phẩm sữa tươi Vinamilk', 98, 1),
(667, 'MD0034', 1, 2, 2, 4, '2025-08-07', 21468, 'https://cdn.shopify.com/s/files/1/0761/8769/7443/files/SSDFindo_SCL_220_1.png?v=1698811984', 'Sản phẩm sữa tươi Vinamilk', 380, 0),
(668, 'MD0035', 1, 2, 2, 5, '2026-06-30', 21106, 'https://cdn.shopify.com/s/files/1/0761/8769/7443/files/SSDFindo_SCL_220_1.png?v=1698811984', 'Sản phẩm sữa tươi Vinamilk', 902, 0),
(669, 'MD0036', 1, 2, 3, 1, '2026-08-13', 43955, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_3_af5a3e0c26.png', 'Sản phẩm sữa tươi Vinamilk', 325, 1),
(670, 'MD0037', 1, 2, 3, 2, '2025-10-11', 20825, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_3_af5a3e0c26.png', 'Sản phẩm sữa tươi Vinamilk', 843, 1),
(671, 'MD0038', 1, 2, 3, 3, '2026-03-14', 32236, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_3_af5a3e0c26.png', 'Sản phẩm sữa tươi Vinamilk', 601, 0),
(672, 'MD0039', 1, 2, 3, 4, '2025-08-03', 35788, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_3_af5a3e0c26.png', 'Sản phẩm sữa tươi Vinamilk', 600, 0),
(673, 'MD0040', 1, 2, 3, 5, '2025-04-23', 39671, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_110_3_af5a3e0c26.png', 'Sản phẩm sữa tươi Vinamilk', 877, 0),
(674, 'MD0041', 1, 2, 4, 1, '2026-01-22', 33331, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_4_cd2ea9d438.png', 'Sản phẩm sữa tươi Vinamilk', 570, 1),
(675, 'MD0042', 1, 2, 4, 2, '2025-11-29', 48930, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_4_cd2ea9d438.png', 'Sản phẩm sữa tươi Vinamilk', 121, 1),
(676, 'MD0043', 1, 2, 4, 3, '2026-05-13', 14624, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_4_cd2ea9d438.png', 'Sản phẩm sữa tươi Vinamilk', 556, 0),
(677, 'MD0044', 1, 2, 4, 4, '2025-12-30', 19643, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_4_cd2ea9d438.png', 'Sản phẩm sữa tươi Vinamilk', 335, 0),
(678, 'MD0045', 1, 2, 4, 5, '2025-02-26', 40141, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_4_cd2ea9d438.png', 'Sản phẩm sữa tươi Vinamilk', 554, 0),
(679, 'MD0046', 1, 2, 5, 1, '2025-08-12', 12440, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_3_58ed3b5b41.png', 'Sản phẩm sữa tươi Vinamilk', 923, 1),
(680, 'MD0047', 1, 2, 5, 2, '2025-10-05', 20954, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_3_58ed3b5b41.png', 'Sản phẩm sữa tươi Vinamilk', 509, 1),
(681, 'MD0048', 1, 2, 5, 3, '2025-11-05', 39961, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_3_58ed3b5b41.png', 'Sản phẩm sữa tươi Vinamilk', 926, 0),
(682, 'MD0049', 1, 2, 5, 4, '2025-10-31', 46773, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_3_58ed3b5b41.png', 'Sản phẩm sữa tươi Vinamilk', 660, 0),
(683, 'MD0050', 1, 2, 5, 5, '2026-05-25', 35939, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_SCL_180_3_58ed3b5b41.png', 'Sản phẩm sữa tươi Vinamilk', 47, 0),
(684, 'MD0051', 1, 3, 1, 1, '2025-01-13', 39886, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_1_7cf49846b1.png', 'Sản phẩm sữa tươi Vinamilk', 59, 0),
(685, 'MD0052', 1, 3, 1, 2, '2025-12-11', 48614, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_1_7cf49846b1.png', 'Sản phẩm sữa tươi Vinamilk', 19, 1),
(686, 'MD0053', 1, 3, 1, 3, '2025-04-22', 13960, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_1_7cf49846b1.png', 'Sản phẩm sữa tươi Vinamilk', 751, 1),
(687, 'MD0054', 1, 3, 1, 4, '2025-10-19', 33436, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_1_7cf49846b1.png', 'Sản phẩm sữa tươi Vinamilk', 292, 1),
(688, 'MD0055', 1, 3, 1, 5, '2025-10-05', 27812, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_1_7cf49846b1.png', 'Sản phẩm sữa tươi Vinamilk', 110, 0),
(689, 'MD0056', 1, 3, 2, 1, '2026-05-29', 40831, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_220_1_0c505c66d4.png', 'Sản phẩm sữa tươi Vinamilk', 248, 1),
(690, 'MD0057', 1, 3, 2, 2, '2026-02-14', 32960, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_220_1_0c505c66d4.png', 'Sản phẩm sữa tươi Vinamilk', 542, 1),
(691, 'MD0058', 1, 3, 2, 3, '2026-06-22', 19468, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_220_1_0c505c66d4.png', 'Sản phẩm sữa tươi Vinamilk', 543, 1),
(692, 'MD0059', 1, 3, 2, 4, '2026-02-20', 23021, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_220_1_0c505c66d4.png', 'Sản phẩm sữa tươi Vinamilk', 758, 1),
(693, 'MD0060', 1, 3, 2, 5, '2025-10-18', 24776, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_220_1_0c505c66d4.png', 'Sản phẩm sữa tươi Vinamilk', 849, 0),
(694, 'MD0061', 1, 3, 3, 1, '2025-07-01', 37285, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_3_04e81b54bf.png', 'Sản phẩm sữa tươi Vinamilk', 319, 1),
(695, 'MD0062', 1, 3, 3, 2, '2025-07-26', 30094, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_3_04e81b54bf.png', 'Sản phẩm sữa tươi Vinamilk', 549, 0),
(696, 'MD0063', 1, 3, 3, 3, '2026-04-02', 27930, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_3_04e81b54bf.png', 'Sản phẩm sữa tươi Vinamilk', 368, 1),
(697, 'MD0064', 1, 3, 3, 4, '2025-08-29', 28491, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_3_04e81b54bf.png', 'Sản phẩm sữa tươi Vinamilk', 610, 1),
(698, 'MD0065', 1, 3, 3, 5, '2025-06-26', 30024, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_3_04e81b54bf.png', 'Sản phẩm sữa tươi Vinamilk', 163, 0),
(700, 'MD0067', 1, 3, 4, 2, '2025-01-22', 20383, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_4_e06833018c.png', 'Sản phẩm sữa tươi Vinamilk', 164, 1),
(701, 'MD0068', 1, 3, 4, 3, '2026-05-08', 10478, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_4_e06833018c.png', 'Sản phẩm sữa tươi Vinamilk', 401, 1),
(702, 'MD0069', 1, 3, 4, 4, '2025-03-28', 16927, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_4_e06833018c.png', 'Sản phẩm sữa tươi Vinamilk', 986, 1),
(703, 'MD0070', 1, 3, 4, 5, '2025-07-08', 19206, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_180_4_e06833018c.png', 'Sản phẩm sữa tươi Vinamilk', 287, 0),
(704, 'MD0071', 1, 3, 5, 1, '2026-05-21', 35491, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_3_3035618e49.png', 'Sản phẩm sữa tươi Vinamilk', 239, 1),
(705, 'MD0072', 1, 3, 5, 2, '2026-06-10', 13682, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_3_3035618e49.png', 'Sản phẩm sữa tươi Vinamilk', 509, 1),
(706, 'MD0073', 1, 3, 5, 3, '2025-05-06', 26130, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_3_3035618e49.png', 'Sản phẩm sữa tươi Vinamilk', 939, 1),
(707, 'MD0074', 1, 3, 5, 4, '2026-10-06', 45677, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_3_3035618e49.png', 'Sản phẩm sữa tươi Vinamilk', 614, 1),
(708, 'MD0075', 1, 3, 5, 5, '2026-04-09', 42065, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_ID_110_3_3035618e49.png', 'Sản phẩm sữa tươi Vinamilk', 155, 0),
(709, 'MD0076', 1, 4, 1, 1, '2026-04-21', 25193, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_1_5e747021c9.png', 'Sản phẩm sữa tươi Vinamilk', 470, 0),
(710, 'MD0077', 1, 4, 1, 2, '2025-09-14', 17139, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_1_5e747021c9.png', 'Sản phẩm sữa tươi Vinamilk', 403, 1),
(711, 'MD0078', 1, 4, 1, 3, '2026-05-27', 25292, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_1_5e747021c9.png', 'Sản phẩm sữa tươi Vinamilk', 687, 0),
(712, 'MD0079', 1, 4, 1, 4, '2026-10-18', 26597, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_1_5e747021c9.png', 'Sản phẩm sữa tươi Vinamilk', 325, 1),
(713, 'MD0080', 1, 4, 1, 5, '2026-01-02', 42080, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_1_5e747021c9.png', 'Sản phẩm sữa tươi Vinamilk', 109, 0),
(714, 'MD0081', 1, 4, 2, 1, '2026-07-07', 36453, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_220_1_4e25d73d37.png', 'Sản phẩm sữa tươi Vinamilk,', 363, 0),
(715, 'MD0082', 1, 4, 2, 2, '2026-10-07', 33279, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_220_1_4e25d73d37.png', 'Sản phẩm sữa tươi Vinamilk', 285, 0),
(716, 'MD0083', 1, 4, 2, 3, '2024-11-30', 36594, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_220_1_4e25d73d37.png', 'Sản phẩm sữa tươi Vinamilk', 366, 1),
(717, 'MD0084', 1, 4, 2, 4, '2026-10-08', 24431, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_220_1_4e25d73d37.png', 'Sản phẩm sữa tươi Vinamilk', 372, 0),
(718, 'MD0085', 1, 4, 2, 5, '2025-12-24', 24289, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_220_1_4e25d73d37.png', 'Sản phẩm sữa tươi Vinamilk', 706, 0),
(719, 'MD0086', 1, 4, 3, 1, '2025-02-09', 19584, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_3_bed6adb0bd.png', 'Sản phẩm sữa tươi Vinamilk', 844, 1),
(720, 'MD0087', 1, 4, 3, 2, '2025-05-03', 46468, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_3_bed6adb0bd.png', 'Sản phẩm sữa tươi Vinamilk', 193, 1),
(721, 'MD0088', 1, 4, 3, 3, '2026-04-07', 30127, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_3_bed6adb0bd.png', 'Sản phẩm sữa tươi Vinamilk', 921, 0),
(722, 'MD0089', 1, 4, 3, 4, '2024-12-13', 13346, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_3_bed6adb0bd.png', 'Sản phẩm sữa tươi Vinamilk', 875, 1),
(723, 'MD0090', 1, 4, 3, 5, '2025-05-06', 41620, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_3_bed6adb0bd.png', 'Sản phẩm sữa tươi Vinamilk', 764, 0),
(724, 'MD0091', 1, 4, 4, 1, '2025-12-07', 20465, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_4_f55122fa62.png', 'Sản phẩm sữa tươi Vinamilk', 461, 1),
(725, 'MD0092', 1, 4, 4, 2, '2026-05-31', 23949, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_4_f55122fa62.png', 'Sản phẩm sữa tươi Vinamilk', 970, 1),
(726, 'MD0093', 1, 4, 4, 3, '2026-10-13', 28595, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_4_f55122fa62.png', 'Sản phẩm sữa tươi Vinamilk', 11, 1),
(727, 'MD0094', 1, 4, 4, 4, '2025-08-12', 19061, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_4_f55122fa62.png', 'Sản phẩm sữa tươi Vinamilk', 794, 1),
(728, 'MD0095', 1, 4, 4, 5, '2025-12-10', 10563, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_180_4_f55122fa62.png', 'Sản phẩm sữa tươi Vinamilk', 282, 0),
(729, 'MD0096', 1, 4, 5, 1, '2025-02-14', 36736, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_3_c0a652aca9.png', 'Sản phẩm sữa tươi Vinamilk', 499, 1),
(730, 'MD0097', 1, 4, 5, 2, '2025-02-12', 24500, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_3_c0a652aca9.png', 'Sản phẩm sữa tươi Vinamilk', 376, 1),
(731, 'MD0098', 1, 4, 5, 3, '2026-02-05', 21308, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_3_c0a652aca9.png', 'Sản phẩm sữa tươi Vinamilk', 234, 1),
(732, 'MD0099', 1, 4, 5, 4, '2025-01-22', 38967, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_3_c0a652aca9.png', 'Sản phẩm sữa tươi Vinamilk', 684, 1),
(733, 'MD0100', 1, 4, 5, 5, '2026-10-20', 14013, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_CD_110_3_c0a652aca9.png', 'Sản phẩm sữa tươi Vinamilk', 931, 0),
(734, 'MD0101', 1, 5, 1, 1, '2025-02-25', 22907, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_1_29fe804dcf.png', 'Sản phẩm sữa tươi Vinamilk', 403, 1),
(735, 'MD0102', 1, 5, 1, 2, '2025-12-19', 25127, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_1_29fe804dcf.png', 'Sản phẩm sữa tươi Vinamilk', 600, 1),
(736, 'MD0103', 1, 5, 1, 3, '2026-02-26', 23985, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_1_29fe804dcf.png', 'Sản phẩm sữa tươi Vinamilk', 108, 1),
(737, 'MD0104', 1, 5, 1, 4, '2025-08-20', 10468, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_1_29fe804dcf.png', 'Sản phẩm sữa tươi Vinamilk', 286, 1),
(738, 'MD0105', 1, 5, 1, 5, '2024-12-13', 17796, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_1_29fe804dcf.png', 'Sản phẩm sữa tươi Vinamilk', 511, 0),
(739, 'MD0106', 1, 5, 2, 1, '2026-08-02', 29614, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_220_1_732005e93e.png', 'Sản phẩm sữa tươi Vinamilk', 497, 0),
(740, 'MD0107', 1, 5, 2, 2, '2025-01-01', 26586, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_220_1_732005e93e.png', 'Sản phẩm sữa tươi Vinamilk', 549, 0),
(741, 'MD0108', 1, 5, 2, 3, '2026-01-23', 36420, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_220_1_732005e93e.png', 'Sản phẩm sữa tươi Vinamilk', 413, 1),
(742, 'MD0109', 1, 5, 2, 4, '2025-06-29', 20624, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_220_1_732005e93e.png', 'Sản phẩm sữa tươi Vinamilk', 695, 0),
(743, 'MD0110', 1, 5, 2, 5, '2026-07-20', 23023, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_220_1_732005e93e.png', 'Sản phẩm sữa tươi Vinamilk', 513, 0),
(744, 'MD0111', 1, 5, 3, 1, '2026-10-11', 27041, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_3_715ac4447b.png', 'Sản phẩm sữa tươi Vinamilk', 29, 1),
(745, 'MD0112', 1, 5, 3, 2, '2025-07-14', 13952, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_3_715ac4447b.png', 'Sản phẩm sữa tươi Vinamilk', 548, 1),
(746, 'MD0113', 1, 5, 3, 3, '2026-08-28', 39814, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_3_715ac4447b.png', 'Sản phẩm sữa tươi Vinamilk', 237, 1),
(747, 'MD0114', 1, 5, 3, 4, '2025-08-17', 24005, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_3_715ac4447b.png', 'Sản phẩm sữa tươi Vinamilk', 776, 1),
(748, 'MD0115', 1, 5, 3, 5, '2026-07-20', 11560, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_3_715ac4447b.png', 'Sản phẩm sữa tươi Vinamilk', 96, 0),
(749, 'MD0116', 1, 5, 4, 1, '2025-07-13', 31668, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_4_e9228d2ffd.png', 'Sản phẩm sữa tươi Vinamilk', 576, 1),
(750, 'MD0117', 1, 5, 4, 2, '2025-10-17', 22852, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_4_e9228d2ffd.png', 'Sản phẩm sữa tươi Vinamilk', 141, 1),
(751, 'MD0118', 1, 5, 4, 3, '2026-05-23', 19543, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_4_e9228d2ffd.png', 'Sản phẩm sữa tươi Vinamilk', 762, 1),
(752, 'MD0119', 1, 5, 4, 4, '2026-03-30', 41482, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_4_e9228d2ffd.png', 'Sản phẩm sữa tươi Vinamilk', 619, 1),
(753, 'MD0120', 1, 5, 4, 5, '2025-07-24', 32445, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_180_4_e9228d2ffd.png', 'Sản phẩm sữa tươi Vinamilk', 445, 0),
(754, 'MD0121', 1, 5, 5, 1, '2026-07-14', 13802, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_3_524b317fd3.png', 'Sản phẩm sữa tươi Vinamilk', 37, 1),
(755, 'MD0122', 1, 5, 5, 2, '2025-10-06', 43781, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_3_524b317fd3.png', 'Sản phẩm sữa tươi Vinamilk', 803, 1),
(756, 'MD0123', 1, 5, 5, 3, '2026-09-15', 25371, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_3_524b317fd3.png', 'Sản phẩm sữa tươi Vinamilk', 438, 1),
(757, 'MD0124', 1, 5, 5, 4, '2026-06-09', 36865, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_3_524b317fd3.png', 'Sản phẩm sữa tươi Vinamilk', 728, 1),
(758, 'MD0125', 1, 5, 5, 5, '2025-11-28', 21813, 'https://d8um25gjecm9v.cloudfront.net/store-front-cms/ST_Tiet_trung_FM_100_KD_110_3_524b317fd3.png', 'Sản phẩm sữa tươi Vinamilk', 407, 0),
(759, 'MD0126', 2, 1, 1, 1, '2025-03-02', 34421, 'https://cdn.tgdd.vn/Products/Images/2386/86171/thung-48-hop-sua-tiet-trung-huong-dau-dutch-lady-110ml-2.jpg', 'Sản phẩm sữa tươi Dutch Lady', 631, 1),
(760, 'MD0127', 2, 1, 1, 2, '2026-09-06', 19964, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Straw-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 837, 1),
(762, 'MD0129', 2, 1, 1, 4, '2025-10-22', 38431, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Straw-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 581, 0),
(763, 'MD0130', 2, 1, 1, 5, '2025-10-24', 17926, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Straw-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 730, 0),
(764, 'MD0131', 2, 1, 2, 1, '2026-08-30', 24933, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20STRAW%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 422, 0),
(765, 'MD0132', 2, 1, 2, 2, '2024-12-08', 19972, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20STRAW%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 171, 1),
(766, 'MD0133', 2, 1, 2, 3, '2025-06-03', 20458, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20STRAW%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 508, 1),
(767, 'MD0134', 2, 1, 2, 4, '2025-08-02', 24186, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20STRAW%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 498, 0),
(768, 'MD0135', 2, 1, 2, 5, '2026-10-10', 17671, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20STRAW%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 349, 0),
(769, 'MD0136', 2, 1, 3, 1, '2026-05-18', 18728, 'https://media.shoptretho.com.vn/upload/image/product/20230731/sua-tiet-trung-dutch-lady-vi-dau-110ml-loc-4-hop-1.jpg', 'Sản phẩm sữa tươi Dutch Lady', 74, 1),
(770, 'MD0137', 2, 1, 3, 2, '2026-07-19', 21383, 'https://down-vn.img.susercontent.com/file/188234052c06d71fa39333ade843b529_tn.webp', 'Sản phẩm sữa tươi Dutch Lady', 639, 1),
(771, 'MD0138', 2, 1, 3, 3, '2026-09-28', 13222, 'https://minhcaumart.vn/media/com_eshop/products/8934841901863%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 119, 0),
(772, 'MD0139', 2, 1, 3, 4, '2026-08-14', 35016, 'https://minhcaumart.vn/media/com_eshop/products/8934841901863%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 420, 0),
(773, 'MD0140', 2, 1, 3, 5, '2025-07-06', 21316, 'https://minhcaumart.vn/media/com_eshop/products/8934841901863%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 515, 0),
(774, 'MD0141', 2, 1, 4, 1, '2024-12-08', 12277, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/437/188/products/wwwwwwwwww.jpg?v=1677204953157', 'Sản phẩm sữa tươi Dutch Lady', 623, 1),
(775, 'MD0142', 2, 1, 4, 2, '2026-09-01', 30979, 'https://laz-img-sg.alicdn.com/p/6eebad55d47203c99d59b491ca390f27.jpg', 'Sản phẩm sữa tươi Dutch Lady', 479, 1),
(776, 'MD0143', 2, 1, 4, 3, '2025-03-19', 33887, 'https://salt.tikicdn.com/ts/product/b6/6d/0e/fd16e24fdb79043723a396d80d11bd7c.jpg', 'Sản phẩm sữa tươi Dutch Lady', 967, 0),
(777, 'MD0144', 2, 1, 4, 4, '2026-10-14', 31775, 'https://salt.tikicdn.com/ts/product/b6/6d/0e/fd16e24fdb79043723a396d80d11bd7c.jpg', 'Sản phẩm sữa tươi Dutch Lady', 840, 0),
(778, 'MD0145', 2, 1, 4, 5, '2025-09-21', 40166, 'https://salt.tikicdn.com/ts/product/b6/6d/0e/fd16e24fdb79043723a396d80d11bd7c.jpg', 'Sản phẩm sữa tươi Dutch Lady', 744, 0),
(779, 'MD0146', 2, 1, 5, 1, '2026-02-02', 41808, 'https://media.shoptretho.com.vn/upload/image/product/20230731/sua-tiet-trung-dutch-lady-vi-dau-110ml-loc-4-hop-1.jpg', 'Sản phẩm sữa tươi Dutch Lady', 257, 1),
(780, 'MD0147', 2, 1, 5, 2, '2026-07-19', 12068, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901863-2.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 67, 1),
(781, 'MD0148', 2, 1, 5, 3, '2026-03-05', 20846, 'https://cdn-v2.kidsplaza.vn/media/catalog/product/s/u/sua-tuoi-tiet-trung-vi-dau-active-20-dutch-lady-110ml-1.jpg', 'Sản phẩm sữa tươi Dutch Lady', 162, 0),
(782, 'MD0149', 2, 1, 5, 4, '2025-05-27', 19516, 'https://cdn-v2.kidsplaza.vn/media/catalog/product/s/u/sua-tuoi-tiet-trung-vi-dau-active-20-dutch-lady-110ml-1.jpg', 'Sản phẩm sữa tươi Dutch Lady', 837, 0),
(783, 'MD0150', 2, 1, 5, 5, '2025-02-04', 31191, 'https://cdn-v2.kidsplaza.vn/media/catalog/product/s/u/sua-tuoi-tiet-trung-vi-dau-active-20-dutch-lady-110ml-1.jpg', 'Sản phẩm sữa tươi Dutch Lady', 532, 1),
(784, 'MD0151', 2, 2, 1, 1, '2025-10-19', 25144, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Choco-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 870, 1),
(785, 'MD0152', 2, 2, 1, 2, '2026-06-06', 24128, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Choco-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 540, 1),
(786, 'MD0153', 2, 2, 1, 3, '2025-12-22', 34322, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Choco-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 360, 1),
(787, 'MD0154', 2, 2, 1, 4, '2025-02-02', 24576, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Choco-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 994, 1),
(788, 'MD0155', 2, 2, 1, 5, '2026-08-28', 29850, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Choco-180ml_2104036.png', 'Sản phẩm sữa tươi Dutch Lady', 298, 0),
(789, 'MD0156', 2, 2, 2, 1, '2025-10-28', 49753, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20CHOCO%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 545, 0),
(790, 'MD0157', 2, 2, 2, 2, '2026-02-07', 12323, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20CHOCO%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 858, 0),
(791, 'MD0158', 2, 2, 2, 3, '2026-07-20', 32802, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20CHOCO%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 98, 1),
(792, 'MD0159', 2, 2, 2, 4, '2025-08-07', 21468, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20CHOCO%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 380, 0),
(793, 'MD0160', 2, 2, 2, 5, '2026-06-30', 21106, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20CHOCO%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 902, 0),
(794, 'MD0161', 2, 2, 3, 1, '2026-08-13', 43955, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901870-1.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 325, 0),
(795, 'MD0162', 2, 2, 3, 2, '2025-10-11', 20825, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901870-1.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 843, 0),
(796, 'MD0163', 2, 2, 3, 3, '2026-03-14', 32236, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901870-1.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 601, 0),
(797, 'MD0164', 2, 2, 3, 4, '2025-08-03', 35788, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901870-1.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 600, 1),
(798, 'MD0165', 2, 2, 3, 5, '2025-04-23', 39671, 'https://www.lottemart.vn/media/catalog/product/cache/0x0/8/9/8934841901870-1.jpg.webp', 'Sản phẩm sữa tươi Dutch Lady', 877, 0),
(799, 'MD0166', 2, 2, 4, 1, '2026-01-22', 33331, 'https://down-vn.img.susercontent.com/file/6e91106bd165f9049a5f3a2ac5f4a357', 'Sản phẩm sữa tươi Dutch Lady', 570, 0),
(800, 'MD0167', 2, 2, 4, 2, '2025-11-29', 48930, 'https://down-vn.img.susercontent.com/file/6e91106bd165f9049a5f3a2ac5f4a357', 'Sản phẩm sữa tươi Dutch Lady', 121, 0),
(801, 'MD0168', 2, 2, 4, 3, '2026-05-13', 14624, 'https://down-vn.img.susercontent.com/file/6e91106bd165f9049a5f3a2ac5f4a357', 'Sản phẩm sữa tươi Dutch Lady', 556, 0),
(802, 'MD0169', 2, 2, 4, 4, '2025-12-30', 19643, 'https://down-vn.img.susercontent.com/file/6e91106bd165f9049a5f3a2ac5f4a357', 'Sản phẩm sữa tươi Dutch Lady', 335, 1),
(803, 'MD0170', 2, 2, 4, 5, '2025-02-26', 40141, 'https://down-vn.img.susercontent.com/file/6e91106bd165f9049a5f3a2ac5f4a357', 'Sản phẩm sữa tươi Dutch Lady', 554, 1),
(804, 'MD0171', 2, 2, 5, 1, '2025-08-12', 12440, 'https://cdn.tgdd.vn/Products/Images/2386/80463/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-so-co-la-110ml-201912031548419555.jpg', 'Sản phẩm sữa tươi Dutch Lady', 923, 0),
(805, 'MD0172', 2, 2, 5, 2, '2025-10-05', 20954, 'https://cdn.tgdd.vn/Products/Images/2386/80463/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-so-co-la-110ml-201912031548419555.jpg', 'Sản phẩm sữa tươi Dutch Lady', 509, 1),
(806, 'MD0173', 2, 2, 5, 3, '2025-11-05', 39961, 'https://cdn.tgdd.vn/Products/Images/2386/80463/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-so-co-la-110ml-201912031548419555.jpg', 'Sản phẩm sữa tươi Dutch Lady', 926, 0),
(807, 'MD0174', 2, 2, 5, 4, '2025-10-31', 46773, 'https://cdn.tgdd.vn/Products/Images/2386/80463/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-so-co-la-110ml-201912031548419555.jpg', 'Sản phẩm sữa tươi Dutch Lady', 660, 0),
(808, 'MD0175', 2, 2, 5, 5, '2026-05-25', 35939, 'https://cdn.tgdd.vn/Products/Images/2386/80463/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-so-co-la-110ml-201912031548419555.jpg', 'Sản phẩm sữa tươi Dutch Lady', 47, 1),
(809, 'MD0176', 2, 3, 1, 1, '2025-01-13', 39886, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 59, 1),
(810, 'MD0177', 2, 3, 1, 2, '2025-12-11', 48614, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 19, 1),
(811, 'MD0178', 2, 3, 1, 3, '2025-04-22', 13960, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 751, 1),
(812, 'MD0179', 2, 3, 1, 4, '2025-10-19', 33436, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 292, 0),
(813, 'MD0180', 2, 3, 1, 5, '2025-10-05', 27812, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 110, 0),
(814, 'MD0181', 2, 3, 2, 1, '2026-05-29', 40831, 'https://www.dutchlady.com.vn/sites/default/files/2023-07/LESS%20SUGAR.png', 'Sản phẩm sữa tươi Dutch Lady', 248, 0),
(815, 'MD0182', 2, 3, 2, 2, '2026-02-14', 32960, 'https://www.dutchlady.com.vn/sites/default/files/2023-07/LESS%20SUGAR.png', 'Sản phẩm sữa tươi Dutch Lady', 542, 1),
(816, 'MD0183', 2, 3, 2, 3, '2026-06-22', 19468, 'https://www.dutchlady.com.vn/sites/default/files/2023-07/LESS%20SUGAR.png', 'Sản phẩm sữa tươi Dutch Lady', 543, 0),
(817, 'MD0184', 2, 3, 2, 4, '2026-02-20', 23021, 'https://www.dutchlady.com.vn/sites/default/files/2023-07/LESS%20SUGAR.png', 'Sản phẩm sữa tươi Dutch Lady', 758, 1),
(818, 'MD0185', 2, 3, 2, 5, '2025-10-18', 24776, 'https://www.dutchlady.com.vn/sites/default/files/2023-07/LESS%20SUGAR.png', 'Sản phẩm sữa tươi Dutch Lady', 849, 0),
(819, 'MD0186', 2, 3, 3, 1, '2025-07-01', 37285, 'https://cdn.tgdd.vn/Products/Images/2386/326076/bhx/loc-4-hop-sua-tuoi-tiet-trung-it-duong-dutch-lady-180ml-202407301627285969.jpg', 'Sản phẩm sữa tươi Dutch Lady', 319, 1),
(820, 'MD0187', 2, 3, 3, 2, '2025-07-26', 30094, 'https://cdn.tgdd.vn/Products/Images/2386/326076/bhx/loc-4-hop-sua-tuoi-tiet-trung-it-duong-dutch-lady-180ml-202407301627285969.jpg', 'Sản phẩm sữa tươi Dutch Lady', 549, 0),
(821, 'MD0188', 2, 3, 3, 3, '2026-04-02', 27930, 'https://cdn.tgdd.vn/Products/Images/2386/326076/bhx/loc-4-hop-sua-tuoi-tiet-trung-it-duong-dutch-lady-180ml-202407301627285969.jpg', 'Sản phẩm sữa tươi Dutch Lady', 368, 1),
(822, 'MD0189', 2, 3, 3, 4, '2025-08-29', 28491, 'https://cdn.tgdd.vn/Products/Images/2386/326076/bhx/loc-4-hop-sua-tuoi-tiet-trung-it-duong-dutch-lady-180ml-202407301627285969.jpg', 'Sản phẩm sữa tươi Dutch Lady', 610, 0),
(823, 'MD0190', 2, 3, 3, 5, '2025-06-26', 30024, 'https://cdn.tgdd.vn/Products/Images/2386/326076/bhx/loc-4-hop-sua-tuoi-tiet-trung-it-duong-dutch-lady-180ml-202407301627285969.jpg', 'Sản phẩm sữa tươi Dutch Lady', 163, 0),
(824, 'MD0191', 2, 3, 4, 1, '2025-05-23', 38975, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 173, 0),
(825, 'MD0192', 2, 3, 4, 2, '2025-01-22', 20383, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 164, 1),
(826, 'MD0193', 2, 3, 4, 3, '2026-05-08', 10478, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 401, 1),
(827, 'MD0194', 2, 3, 4, 4, '2025-03-28', 16927, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 986, 1),
(828, 'MD0195', 2, 3, 4, 5, '2025-07-08', 19206, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 287, 1),
(829, 'MD0196', 2, 3, 5, 1, '2026-05-21', 35491, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 239, 0),
(830, 'MD0197', 2, 3, 5, 2, '2026-06-10', 13682, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 509, 1),
(831, 'MD0198', 2, 3, 5, 3, '2025-05-06', 26130, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 939, 0),
(832, 'MD0199', 2, 3, 5, 4, '2026-10-06', 45677, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 614, 1),
(833, 'MD0200', 2, 3, 5, 5, '2026-04-09', 42065, 'https://salt.tikicdn.com/cache/280x280/ts/product/38/ff/cc/425b1f67cdcc475f4e9eecc00b186d5e.jpg', 'Sản phẩm sữa tươi Dutch Lady', 155, 0),
(834, 'MD0201', 2, 4, 1, 1, '2026-04-21', 25193, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/FRESH.png', 'Sản phẩm sữa tươi Dutch Lady', 470, 0),
(835, 'MD0202', 2, 4, 1, 2, '2025-09-14', 17139, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/FRESH.png', 'Sản phẩm sữa tươi Dutch Lady', 403, 1),
(836, 'MD0203', 2, 4, 1, 3, '2026-05-27', 25292, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/FRESH.png', 'Sản phẩm sữa tươi Dutch Lady', 687, 0),
(837, 'MD0204', 2, 4, 1, 4, '2026-10-18', 26597, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/FRESH.png', 'Sản phẩm sữa tươi Dutch Lady', 325, 1),
(838, 'MD0205', 2, 4, 1, 5, '2026-01-02', 42080, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/FRESH.png', 'Sản phẩm sữa tươi Dutch Lady', 109, 0),
(839, 'MD0206', 2, 4, 2, 1, '2026-07-07', 36453, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20SWEET%20210ML_6.png', 'Sản phẩm sữa tươi Dutch Lady,', 363, 0),
(840, 'MD0207', 2, 4, 2, 2, '2026-10-07', 33279, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20SWEET%20210ML_6.png', 'Sản phẩm sữa tươi Dutch Lady', 285, 1),
(841, 'MD0208', 2, 4, 2, 3, '2024-11-30', 36594, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20SWEET%20210ML_6.png', 'Sản phẩm sữa tươi Dutch Lady', 366, 0),
(842, 'MD0209', 2, 4, 2, 4, '2026-10-08', 24431, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20SWEET%20210ML_6.png', 'Sản phẩm sữa tươi Dutch Lady', 372, 1),
(843, 'MD0210', 2, 4, 2, 5, '2025-12-24', 24289, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20SWEET%20210ML_6.png', 'Sản phẩm sữa tươi Dutch Lady', 706, 1),
(844, 'MD0211', 2, 4, 3, 1, '2025-02-09', 19584, 'https://cdn.tgdd.vn/Products/Images/2386/80466/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-co-duong-180ml-201902251452202571.jpg', 'Sản phẩm sữa tươi Dutch Lady', 844, 0),
(845, 'MD0212', 2, 4, 3, 2, '2025-05-03', 46468, 'https://cdn.tgdd.vn/Products/Images/2386/80466/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-co-duong-180ml-201902251452202571.jpg', 'Sản phẩm sữa tươi Dutch Lady', 193, 0),
(846, 'MD0213', 2, 4, 3, 3, '2026-04-07', 30127, 'https://cdn.tgdd.vn/Products/Images/2386/80466/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-co-duong-180ml-201902251452202571.jpg', 'Sản phẩm sữa tươi Dutch Lady', 921, 1),
(847, 'MD0214', 2, 4, 3, 4, '2024-12-13', 13346, 'https://cdn.tgdd.vn/Products/Images/2386/80466/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-co-duong-180ml-201902251452202571.jpg', 'Sản phẩm sữa tươi Dutch Lady', 875, 0),
(848, 'MD0215', 2, 4, 3, 5, '2025-05-06', 41620, 'https://cdn.tgdd.vn/Products/Images/2386/80466/bhx/loc-4-hop-sua-tiet-trung-dutch-lady-co-duong-180ml-201902251452202571.jpg', 'Sản phẩm sữa tươi Dutch Lady', 764, 0),
(849, 'MD0216', 2, 4, 4, 1, '2025-12-07', 20465, 'https://www.moby.com.vn/data/bt1/sua-tuoi-tiet-trung-dutch-lady-co-duong-180ml-thung-48-hop-1_1630496302.jpg', 'Sản phẩm sữa tươi Dutch Lady', 461, 1),
(850, 'MD0217', 2, 4, 4, 2, '2026-05-31', 23949, 'https://www.moby.com.vn/data/bt1/sua-tuoi-tiet-trung-dutch-lady-co-duong-180ml-thung-48-hop-1_1630496302.jpg', 'Sản phẩm sữa tươi Dutch Lady', 970, 1),
(851, 'MD0218', 2, 4, 4, 3, '2026-10-13', 28595, 'https://www.moby.com.vn/data/bt1/sua-tuoi-tiet-trung-dutch-lady-co-duong-180ml-thung-48-hop-1_1630496302.jpg', 'Sản phẩm sữa tươi Dutch Lady', 11, 1),
(852, 'MD0219', 2, 4, 4, 4, '2025-08-12', 19061, 'https://www.moby.com.vn/data/bt1/sua-tuoi-tiet-trung-dutch-lady-co-duong-180ml-thung-48-hop-1_1630496302.jpg', 'Sản phẩm sữa tươi Dutch Lady', 794, 0),
(853, 'MD0220', 2, 4, 4, 5, '2025-12-10', 10563, 'https://www.moby.com.vn/data/bt1/sua-tuoi-tiet-trung-dutch-lady-co-duong-180ml-thung-48-hop-1_1630496302.jpg', 'Sản phẩm sữa tươi Dutch Lady', 282, 0),
(854, 'MD0221', 2, 4, 5, 1, '2025-02-14', 36736, 'https://www.moby.com.vn/data/ck/images/S%E1%BB%AFa%20t%C6%B0%C6%A1i%20ti%E1%BB%87t%20tr%C3%B9ng%20Dutch%20Lady%20c%C3%B3%20%C4%91%C6%B0%E1%BB%9Dng%20-%20L%E1%BB%91c%204%20h%E1%BB%99p%20110ml%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 499, 0),
(855, 'MD0222', 2, 4, 5, 2, '2025-02-12', 24500, 'https://www.moby.com.vn/data/ck/images/S%E1%BB%AFa%20t%C6%B0%C6%A1i%20ti%E1%BB%87t%20tr%C3%B9ng%20Dutch%20Lady%20c%C3%B3%20%C4%91%C6%B0%E1%BB%9Dng%20-%20L%E1%BB%91c%204%20h%E1%BB%99p%20110ml%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 376, 1),
(856, 'MD0223', 2, 4, 5, 3, '2026-02-05', 21308, 'https://www.moby.com.vn/data/ck/images/S%E1%BB%AFa%20t%C6%B0%C6%A1i%20ti%E1%BB%87t%20tr%C3%B9ng%20Dutch%20Lady%20c%C3%B3%20%C4%91%C6%B0%E1%BB%9Dng%20-%20L%E1%BB%91c%204%20h%E1%BB%99p%20110ml%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 234, 1),
(857, 'MD0224', 2, 4, 5, 4, '2025-01-22', 38967, 'https://www.moby.com.vn/data/ck/images/S%E1%BB%AFa%20t%C6%B0%C6%A1i%20ti%E1%BB%87t%20tr%C3%B9ng%20Dutch%20Lady%20c%C3%B3%20%C4%91%C6%B0%E1%BB%9Dng%20-%20L%E1%BB%91c%204%20h%E1%BB%99p%20110ml%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 684, 0),
(858, 'MD0225', 2, 4, 5, 5, '2026-10-20', 14013, 'https://www.moby.com.vn/data/ck/images/S%E1%BB%AFa%20t%C6%B0%C6%A1i%20ti%E1%BB%87t%20tr%C3%B9ng%20Dutch%20Lady%20c%C3%B3%20%C4%91%C6%B0%E1%BB%9Dng%20-%20L%E1%BB%91c%204%20h%E1%BB%99p%20110ml%201.jpg', 'Sản phẩm sữa tươi Dutch Lady', 931, 1),
(859, 'MD0226', 2, 5, 1, 1, '2025-02-25', 22907, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Plain-180ml_2104036_0.png', 'Sản phẩm sữa tươi Dutch Lady', 403, 0),
(860, 'MD0227', 2, 5, 1, 2, '2025-12-19', 25127, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Plain-180ml_2104036_0.png', 'Sản phẩm sữa tươi Dutch Lady', 600, 0),
(861, 'MD0228', 2, 5, 1, 3, '2026-02-26', 23985, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Plain-180ml_2104036_0.png', 'Sản phẩm sữa tươi Dutch Lady', 108, 0),
(862, 'MD0229', 2, 5, 1, 4, '2025-08-20', 10468, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Plain-180ml_2104036_0.png', 'Sản phẩm sữa tươi Dutch Lady', 286, 0),
(863, 'MD0230', 2, 5, 1, 5, '2024-12-13', 17796, 'https://www.dutchlady.com.vn/sites/default/files/2022-06/0405_DL_Mockup-label_FRESH_Plain-180ml_2104036_0.png', 'Sản phẩm sữa tươi Dutch Lady', 511, 0),
(864, 'MD0231', 2, 5, 2, 1, '2026-08-02', 29614, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20PLAIN%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 497, 0),
(865, 'MD0232', 2, 5, 2, 2, '2025-01-01', 26586, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20PLAIN%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 549, 0),
(866, 'MD0233', 2, 5, 2, 3, '2026-01-23', 36420, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20PLAIN%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 413, 0),
(867, 'MD0234', 2, 5, 2, 4, '2025-06-29', 20624, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20PLAIN%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 695, 0),
(868, 'MD0235', 2, 5, 2, 5, '2026-07-20', 23023, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/FINO%20PLAIN%20210ML.png', 'Sản phẩm sữa tươi Dutch Lady', 513, 1),
(869, 'MD0236', 2, 5, 3, 1, '2026-10-11', 27041, 'https://cooponline.vn/wp-content/uploads/2020/05/sua-tiet-trung-dutch-lady-khong-duong-loc-4-x-180ml.jpg', 'Sản phẩm sữa tươi Dutch Lady', 29, 0),
(870, 'MD0237', 2, 5, 3, 2, '2025-07-14', 13952, 'https://cooponline.vn/wp-content/uploads/2020/05/sua-tiet-trung-dutch-lady-khong-duong-loc-4-x-180ml.jpg', 'Sản phẩm sữa tươi Dutch Lady', 548, 0),
(871, 'MD0238', 2, 5, 3, 3, '2026-08-28', 39814, 'https://cooponline.vn/wp-content/uploads/2020/05/sua-tiet-trung-dutch-lady-khong-duong-loc-4-x-180ml.jpg', 'Sản phẩm sữa tươi Dutch Lady', 237, 0),
(872, 'MD0239', 2, 5, 3, 4, '2025-08-17', 24005, 'https://cooponline.vn/wp-content/uploads/2020/05/sua-tiet-trung-dutch-lady-khong-duong-loc-4-x-180ml.jpg', 'Sản phẩm sữa tươi Dutch Lady', 776, 0),
(873, 'MD0240', 2, 5, 3, 5, '2026-07-20', 11560, 'https://cooponline.vn/wp-content/uploads/2020/05/sua-tiet-trung-dutch-lady-khong-duong-loc-4-x-180ml.jpg', 'Sản phẩm sữa tươi Dutch Lady', 96, 1),
(874, 'MD0241', 2, 5, 4, 1, '2025-07-13', 31668, 'https://www.moby.com.vn/data/bt2/sua-tuoi-tiet-trung-dutch-lady-khong-duong-hop-1-lit-thung-12-hop-1630503192.jpg', 'Sản phẩm sữa tươi Dutch Lady', 576, 0),
(875, 'MD0242', 2, 5, 4, 2, '2025-10-17', 22852, 'https://www.moby.com.vn/data/bt2/sua-tuoi-tiet-trung-dutch-lady-khong-duong-hop-1-lit-thung-12-hop-1630503192.jpg', 'Sản phẩm sữa tươi Dutch Lady', 141, 0),
(876, 'MD0243', 2, 5, 4, 3, '2026-05-23', 19543, 'https://www.moby.com.vn/data/bt2/sua-tuoi-tiet-trung-dutch-lady-khong-duong-hop-1-lit-thung-12-hop-1630503192.jpg', 'Sản phẩm sữa tươi Dutch Lady', 762, 0),
(877, 'MD0244', 2, 5, 4, 4, '2026-03-30', 41482, 'https://www.moby.com.vn/data/bt2/sua-tuoi-tiet-trung-dutch-lady-khong-duong-hop-1-lit-thung-12-hop-1630503192.jpg', 'Sản phẩm sữa tươi Dutch Lady', 619, 0),
(878, 'MD0245', 2, 5, 4, 5, '2025-07-24', 32445, 'https://www.moby.com.vn/data/bt2/sua-tuoi-tiet-trung-dutch-lady-khong-duong-hop-1-lit-thung-12-hop-1630503192.jpg', 'Sản phẩm sữa tươi Dutch Lady', 445, 0),
(879, 'MD0246', 2, 5, 5, 1, '2026-07-14', 13802, 'https://lzd-img-global.slatic.net/g/p/f6f7656d8b41569b35351f70520ca001.jpg_320x320.jpg_550x550.jpg', 'Sản phẩm sữa tươi Dutch Lady', 37, 0),
(880, 'MD0247', 2, 5, 5, 2, '2025-10-06', 43781, 'https://lzd-img-global.slatic.net/g/p/f6f7656d8b41569b35351f70520ca001.jpg_320x320.jpg_550x550.jpg', 'Sản phẩm sữa tươi Dutch Lady', 803, 1),
(881, 'MD0248', 2, 5, 5, 3, '2026-09-15', 25371, 'https://lzd-img-global.slatic.net/g/p/f6f7656d8b41569b35351f70520ca001.jpg_320x320.jpg_550x550.jpg', 'Sản phẩm sữa tươi Dutch Lady', 438, 1),
(882, 'MD0249', 2, 5, 5, 4, '2026-06-09', 36865, 'https://lzd-img-global.slatic.net/g/p/f6f7656d8b41569b35351f70520ca001.jpg_320x320.jpg_550x550.jpg', 'Sản phẩm sữa tươi Dutch Lady', 728, 1),
(883, 'MD0250', 2, 5, 5, 5, '2025-11-28', 21813, 'https://lzd-img-global.slatic.net/g/p/f6f7656d8b41569b35351f70520ca001.jpg_320x320.jpg_550x550.jpg', 'Sản phẩm sữa tươi Dutch Lady', 407, 1),
(884, 'MD0251', 3, 1, 1, 1, '2025-03-02', 34421, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-2.png', 'Sản phẩm sữa tươi TH True Milk', 631, 0),
(885, 'MD0252', 3, 1, 1, 2, '2026-09-06', 19964, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-2.png', 'Sản phẩm sữa tươi TH True Milk', 837, 0),
(886, 'MD02513', 3, 1, 1, 3, '2026-02-25', 32107, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-2.png', 'Sản phẩm sữa tươi TH True Milk', 630, 0),
(887, 'MD0254', 3, 1, 1, 4, '2025-10-22', 38431, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-2.png', 'Sản phẩm sữa tươi TH True Milk', 581, 1),
(888, 'MD0255', 3, 1, 1, 5, '2025-10-24', 17926, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-2.png', 'Sản phẩm sữa tươi TH True Milk', 730, 0),
(889, 'MD0256', 3, 1, 2, 1, '2026-08-30', 24933, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 422, 0),
(890, 'MD0257', 3, 1, 2, 2, '2024-12-08', 19972, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 171, 1),
(891, 'MD0258', 3, 1, 2, 3, '2025-06-03', 20458, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 508, 0),
(892, 'MD0259', 3, 1, 2, 4, '2025-08-02', 24186, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 498, 0),
(893, 'MD0260', 3, 1, 2, 5, '2026-10-10', 17671, 'https://www.thmilk.vn/wp-content/uploads/2019/11/d%C3%A2u-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 349, 0),
(894, 'MD0261', 3, 1, 3, 1, '2026-05-18', 18728, 'https://cdn1.concung.com/storage/2022/04/1650274282.webp', 'Sản phẩm sữa tươi TH True Milk', 74, 1),
(895, 'MD0262', 3, 1, 3, 2, '2026-07-19', 21383, 'https://cdn1.concung.com/storage/2022/04/1650274282.webp', 'Sản phẩm sữa tươi TH True Milk', 639, 1),
(896, 'MD0263', 3, 1, 3, 3, '2026-09-28', 13222, 'https://cdn1.concung.com/storage/2022/04/1650274282.webp', 'Sản phẩm sữa tươi TH True Milk', 119, 0),
(897, 'MD0264', 3, 1, 3, 4, '2026-08-14', 35016, 'https://cdn1.concung.com/storage/2022/04/1650274282.webp', 'Sản phẩm sữa tươi TH True Milk', 420, 0),
(898, 'MD0265', 3, 1, 3, 5, '2025-07-06', 21316, 'https://cdn1.concung.com/storage/2022/04/1650274282.webp', 'Sản phẩm sữa tươi TH True Milk', 515, 1),
(899, 'MD0266', 3, 1, 4, 1, '2024-12-08', 12277, 'https://www.thmilk.vn/wp-content/uploads/2019/11/th%C3%B9ng-d%C3%A2u-180-ml.jpg', 'Sản phẩm sữa tươi TH True Milk', 623, 0),
(900, 'MD0267', 3, 1, 4, 2, '2026-09-01', 30979, 'https://www.thmilk.vn/wp-content/uploads/2019/11/th%C3%B9ng-d%C3%A2u-180-ml.jpg', 'Sản phẩm sữa tươi TH True Milk', 479, 0),
(901, 'MD0268', 3, 1, 4, 3, '2025-03-19', 33887, 'https://www.thmilk.vn/wp-content/uploads/2019/11/th%C3%B9ng-d%C3%A2u-180-ml.jpg', 'Sản phẩm sữa tươi TH True Milk', 967, 0);
INSERT INTO `milkdetail` (`id`, `milkdetailcode`, `productid`, `milktasteid`, `packagingunitid`, `usagecapacityid`, `expirationdate`, `price`, `imgUrl`, `description`, `stockquantity`, `status`) VALUES
(902, 'MD0269', 3, 1, 4, 4, '2026-10-14', 31775, 'https://www.thmilk.vn/wp-content/uploads/2019/11/th%C3%B9ng-d%C3%A2u-180-ml.jpg', 'Sản phẩm sữa tươi TH True Milk', 840, 1),
(903, 'MD0270', 3, 1, 4, 5, '2025-09-21', 40166, 'https://www.thmilk.vn/wp-content/uploads/2019/11/th%C3%B9ng-d%C3%A2u-180-ml.jpg', 'Sản phẩm sữa tươi TH True Milk', 744, 0),
(904, 'MD0271', 3, 1, 5, 1, '2026-02-02', 41808, 'https://cdn.tgdd.vn/Products/Images/2386/80494/sua-tt-th-milk-dau-110ml-loc-070124-100223-600x600.jpg', 'Sản phẩm sữa tươi TH True Milk', 257, 1),
(905, 'MD0272', 3, 1, 5, 2, '2026-07-19', 12068, 'https://cdn.tgdd.vn/Products/Images/2386/80494/sua-tt-th-milk-dau-110ml-loc-070124-100223-600x600.jpg', 'Sản phẩm sữa tươi TH True Milk', 67, 1),
(906, 'MD0273', 3, 1, 5, 3, '2026-03-05', 20846, 'https://cdn.tgdd.vn/Products/Images/2386/80494/sua-tt-th-milk-dau-110ml-loc-070124-100223-600x600.jpg', 'Sản phẩm sữa tươi TH True Milk', 162, 0),
(907, 'MD0274', 3, 1, 5, 4, '2025-05-27', 19516, 'https://cdn.tgdd.vn/Products/Images/2386/80494/sua-tt-th-milk-dau-110ml-loc-070124-100223-600x600.jpg', 'Sản phẩm sữa tươi TH True Milk', 837, 1),
(908, 'MD0275', 3, 1, 5, 5, '2025-02-04', 31191, 'https://cdn.tgdd.vn/Products/Images/2386/80494/sua-tt-th-milk-dau-110ml-loc-070124-100223-600x600.jpg', 'Sản phẩm sữa tươi TH True Milk', 532, 1),
(909, 'MD0276', 3, 2, 1, 1, '2025-10-19', 25144, 'https://www.thmilk.vn/wp-content/uploads/2019/11/choco-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 870, 1),
(910, 'MD0277', 3, 2, 1, 2, '2026-06-06', 24128, 'https://www.thmilk.vn/wp-content/uploads/2019/11/choco-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 540, 1),
(911, 'MD0278', 3, 2, 1, 3, '2025-12-22', 34322, 'https://www.thmilk.vn/wp-content/uploads/2019/11/choco-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 360, 1),
(912, 'MD0279', 3, 2, 1, 4, '2025-02-02', 24576, 'https://www.thmilk.vn/wp-content/uploads/2019/11/choco-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 994, 1),
(913, 'MD0280', 3, 2, 1, 5, '2026-08-28', 29850, 'https://www.thmilk.vn/wp-content/uploads/2019/11/choco-png-1.png', 'Sản phẩm sữa tươi TH True Milk', 298, 0),
(914, 'MD0281', 3, 2, 2, 1, '2025-10-28', 49753, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-vi-socola-hop-180ml-3.jpg', 'Sản phẩm sữa tươi TH True Milk', 545, 0),
(915, 'MD0282', 3, 2, 2, 2, '2026-02-07', 12323, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-vi-socola-hop-180ml-3.jpg', 'Sản phẩm sữa tươi TH True Milk', 858, 0),
(916, 'MD0283', 3, 2, 2, 3, '2026-07-20', 32802, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-vi-socola-hop-180ml-3.jpg', 'Sản phẩm sữa tươi TH True Milk', 98, 1),
(917, 'MD0284', 3, 2, 2, 4, '2025-08-07', 21468, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-vi-socola-hop-180ml-3.jpg', 'Sản phẩm sữa tươi TH True Milk', 380, 0),
(918, 'MD0285', 3, 2, 2, 5, '2026-06-30', 21106, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-vi-socola-hop-180ml-3.jpg', 'Sản phẩm sữa tươi TH True Milk', 902, 0),
(919, 'MD0286', 3, 2, 3, 1, '2026-08-13', 43955, 'https://storage.googleapis.com/mm-online-bucket/ecommerce-website/uploads/media/182595.jpg', 'Sản phẩm sữa tươi TH True Milk', 325, 0),
(920, 'MD0287', 3, 2, 3, 2, '2025-10-11', 20825, 'https://storage.googleapis.com/mm-online-bucket/ecommerce-website/uploads/media/182595.jpg', 'Sản phẩm sữa tươi TH True Milk', 843, 0),
(921, 'MD0288', 3, 2, 3, 3, '2026-03-14', 32236, 'https://storage.googleapis.com/mm-online-bucket/ecommerce-website/uploads/media/182595.jpg', 'Sản phẩm sữa tươi TH True Milk', 601, 0),
(922, 'MD0289', 3, 2, 3, 4, '2025-08-03', 35788, 'https://storage.googleapis.com/mm-online-bucket/ecommerce-website/uploads/media/182595.jpg', 'Sản phẩm sữa tươi TH True Milk', 600, 1),
(923, 'MD0290', 3, 2, 3, 5, '2025-04-23', 39671, 'https://storage.googleapis.com/mm-online-bucket/ecommerce-website/uploads/media/182595.jpg', 'Sản phẩm sữa tươi TH True Milk', 877, 0),
(924, 'MD0291', 3, 2, 4, 1, '2026-01-22', 33331, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltywbbpvnyu778', 'Sản phẩm sữa tươi TH True Milk', 570, 0),
(925, 'MD0292', 3, 2, 4, 2, '2025-11-29', 48930, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltywbbpvnyu778', 'Sản phẩm sữa tươi TH True Milk', 121, 0),
(926, 'MD0293', 3, 2, 4, 3, '2026-05-13', 14624, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltywbbpvnyu778', 'Sản phẩm sữa tươi TH True Milk', 556, 0),
(927, 'MD0294', 3, 2, 4, 4, '2025-12-30', 19643, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltywbbpvnyu778', 'Sản phẩm sữa tươi TH True Milk', 335, 1),
(928, 'MD0295', 3, 2, 4, 5, '2025-02-26', 40141, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltywbbpvnyu778', 'Sản phẩm sữa tươi TH True Milk', 554, 1),
(929, 'MD0296', 3, 2, 5, 1, '2025-08-12', 12440, 'https://product.hstatic.net/1000288770/product/sua_tuoi_tiet_trung_th_true_milk_so_co_la_loc_4_hop_x_110ml_2_9d85efd48cd445959da9f2fe311d31d6_master.jpg', 'Sản phẩm sữa tươi TH True Milk', 923, 0),
(930, 'MD0297', 3, 2, 5, 2, '2025-10-05', 20954, 'https://product.hstatic.net/1000288770/product/sua_tuoi_tiet_trung_th_true_milk_so_co_la_loc_4_hop_x_110ml_2_9d85efd48cd445959da9f2fe311d31d6_master.jpg', 'Sản phẩm sữa tươi TH True Milk', 509, 1),
(931, 'MD0298', 3, 2, 5, 3, '2025-11-05', 39961, 'https://product.hstatic.net/1000288770/product/sua_tuoi_tiet_trung_th_true_milk_so_co_la_loc_4_hop_x_110ml_2_9d85efd48cd445959da9f2fe311d31d6_master.jpg', 'Sản phẩm sữa tươi TH True Milk', 926, 0),
(932, 'MD0299', 3, 2, 5, 4, '2025-10-31', 46773, 'https://product.hstatic.net/1000288770/product/sua_tuoi_tiet_trung_th_true_milk_so_co_la_loc_4_hop_x_110ml_2_9d85efd48cd445959da9f2fe311d31d6_master.jpg', 'Sản phẩm sữa tươi TH True Milk', 660, 0),
(933, 'MD0300', 3, 2, 5, 5, '2026-05-25', 35939, 'https://product.hstatic.net/1000288770/product/sua_tuoi_tiet_trung_th_true_milk_so_co_la_loc_4_hop_x_110ml_2_9d85efd48cd445959da9f2fe311d31d6_master.jpg', 'Sản phẩm sữa tươi TH True Milk', 47, 1),
(934, 'MD0301', 3, 3, 1, 1, '2025-01-13', 39886, 'https://www.thmilk.vn/wp-content/uploads/2019/11/it-duong-180ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 59, 1),
(935, 'MD0302', 3, 3, 1, 2, '2025-12-11', 48614, 'https://www.thmilk.vn/wp-content/uploads/2019/11/it-duong-180ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 19, 1),
(936, 'MD0303', 3, 3, 1, 3, '2025-04-22', 13960, 'https://www.thmilk.vn/wp-content/uploads/2019/11/it-duong-180ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 751, 1),
(937, 'MD0304', 3, 3, 1, 4, '2025-10-19', 33436, 'https://www.thmilk.vn/wp-content/uploads/2019/11/it-duong-180ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 292, 0),
(938, 'MD0305', 3, 3, 1, 5, '2025-10-05', 27812, 'https://www.thmilk.vn/wp-content/uploads/2019/11/it-duong-180ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 110, 0),
(939, 'MD0306', 3, 3, 2, 1, '2026-05-29', 40831, 'https://www.thmilk.vn/wp-content/uploads/2019/11/%C3%ADt-%C4%91%C6%B0%E1%BB%9Dng-png-5.png', 'Sản phẩm sữa tươi TH True Milk', 248, 0),
(940, 'MD0307', 3, 3, 2, 2, '2026-02-14', 32960, 'https://www.thmilk.vn/wp-content/uploads/2019/11/%C3%ADt-%C4%91%C6%B0%E1%BB%9Dng-png-5.png', 'Sản phẩm sữa tươi TH True Milk', 542, 1),
(941, 'MD0308', 3, 3, 2, 3, '2026-06-22', 19468, 'https://www.thmilk.vn/wp-content/uploads/2019/11/%C3%ADt-%C4%91%C6%B0%E1%BB%9Dng-png-5.png', 'Sản phẩm sữa tươi TH True Milk', 543, 0),
(942, 'MD0309', 3, 3, 2, 4, '2026-02-20', 23021, 'https://www.thmilk.vn/wp-content/uploads/2019/11/%C3%ADt-%C4%91%C6%B0%E1%BB%9Dng-png-5.png', 'Sản phẩm sữa tươi TH True Milk', 758, 1),
(943, 'MD0310', 3, 3, 2, 5, '2025-10-18', 24776, 'https://www.thmilk.vn/wp-content/uploads/2019/11/%C3%ADt-%C4%91%C6%B0%E1%BB%9Dng-png-5.png', 'Sản phẩm sữa tươi TH True Milk', 849, 0),
(944, 'MD0311', 3, 3, 3, 1, '2025-07-01', 37285, 'https://concung.com/2022/04/56131-86789-large_mobile/sua-tuoi-tiet-trung-th-true-milk-it-duong-180ml-loc-4-hop.jpg', 'Sản phẩm sữa tươi TH True Milk', 319, 1),
(945, 'MD0312', 3, 3, 3, 2, '2025-07-26', 30094, 'https://concung.com/2022/04/56131-86789-large_mobile/sua-tuoi-tiet-trung-th-true-milk-it-duong-180ml-loc-4-hop.jpg', 'Sản phẩm sữa tươi TH True Milk', 549, 0),
(946, 'MD0313', 3, 3, 3, 3, '2026-04-02', 27930, 'https://concung.com/2022/04/56131-86789-large_mobile/sua-tuoi-tiet-trung-th-true-milk-it-duong-180ml-loc-4-hop.jpg', 'Sản phẩm sữa tươi TH True Milk', 368, 1),
(947, 'MD0314', 3, 3, 3, 4, '2025-08-29', 28491, 'https://concung.com/2022/04/56131-86789-large_mobile/sua-tuoi-tiet-trung-th-true-milk-it-duong-180ml-loc-4-hop.jpg', 'Sản phẩm sữa tươi TH True Milk', 610, 0),
(948, 'MD0315', 3, 3, 3, 5, '2025-06-26', 30024, 'https://concung.com/2022/04/56131-86789-large_mobile/sua-tuoi-tiet-trung-th-true-milk-it-duong-180ml-loc-4-hop.jpg', 'Sản phẩm sữa tươi TH True Milk', 163, 0),
(949, 'MD0316', 3, 3, 4, 1, '2025-05-23', 38975, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-it-duong-th-true-milk-hop-110ml-thung-4933.jpg', 'Sản phẩm sữa tươi TH True Milk', 173, 0),
(950, 'MD0317', 3, 3, 4, 2, '2025-01-22', 20383, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-it-duong-th-true-milk-hop-110ml-thung-4933.jpg', 'Sản phẩm sữa tươi TH True Milk', 164, 1),
(951, 'MD0318', 3, 3, 4, 3, '2026-05-08', 10478, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-it-duong-th-true-milk-hop-110ml-thung-4933.jpg', 'Sản phẩm sữa tươi TH True Milk', 401, 1),
(952, 'MD0319', 3, 3, 4, 4, '2025-03-28', 16927, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-it-duong-th-true-milk-hop-110ml-thung-4933.jpg', 'Sản phẩm sữa tươi TH True Milk', 986, 1),
(953, 'MD0320', 3, 3, 4, 5, '2025-07-08', 19206, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-it-duong-th-true-milk-hop-110ml-thung-4933.jpg', 'Sản phẩm sữa tươi TH True Milk', 287, 1),
(954, 'MD0321', 3, 3, 5, 1, '2026-05-21', 35491, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-co-duong-th-true-milk-hop-110ml-1516.jpg', 'Sản phẩm sữa tươi TH True Milk', 239, 0),
(955, 'MD0322', 3, 3, 5, 2, '2026-06-10', 13682, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-co-duong-th-true-milk-hop-110ml-1516.jpg', 'Sản phẩm sữa tươi TH True Milk', 509, 1),
(956, 'MD0323', 3, 3, 5, 3, '2025-05-06', 26130, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-co-duong-th-true-milk-hop-110ml-1516.jpg', 'Sản phẩm sữa tươi TH True Milk', 939, 0),
(957, 'MD0324', 3, 3, 5, 4, '2026-10-06', 45677, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-co-duong-th-true-milk-hop-110ml-1516.jpg', 'Sản phẩm sữa tươi TH True Milk', 614, 1),
(958, 'MD0325', 3, 3, 5, 5, '2026-04-09', 42065, 'https://shopsuatramanh.com/upload/product/sua-tuoi-tiet-trung-co-duong-th-true-milk-hop-110ml-1516.jpg', 'Sản phẩm sữa tươi TH True Milk', 155, 0),
(959, 'MD0326', 3, 4, 1, 1, '2026-04-21', 25193, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-dduongf-png.png', 'Sản phẩm sữa tươi TH True Milk', 470, 0),
(960, 'MD0327', 3, 4, 1, 2, '2025-09-14', 17139, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-dduongf-png.png', 'Sản phẩm sữa tươi TH True Milk', 403, 1),
(961, 'MD0328', 3, 4, 1, 3, '2026-05-27', 25292, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-dduongf-png.png', 'Sản phẩm sữa tươi TH True Milk', 687, 0),
(962, 'MD0329', 3, 4, 1, 4, '2026-10-18', 26597, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-dduongf-png.png', 'Sản phẩm sữa tươi TH True Milk', 325, 1),
(963, 'MD0330', 3, 4, 1, 5, '2026-01-02', 42080, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-dduongf-png.png', 'Sản phẩm sữa tươi TH True Milk', 109, 0),
(964, 'MD0331', 3, 4, 2, 1, '2026-07-07', 36453, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-duong-220ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk,', 363, 0),
(965, 'MD0332', 3, 4, 2, 2, '2026-10-07', 33279, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-duong-220ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 285, 1),
(966, 'MD0333', 3, 4, 2, 3, '2024-11-30', 36594, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-duong-220ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 366, 0),
(967, 'MD0334', 3, 4, 2, 4, '2026-10-08', 24431, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-duong-220ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 372, 1),
(968, 'MD0335', 3, 4, 2, 5, '2025-12-24', 24289, 'https://www.thmilk.vn/wp-content/uploads/2019/11/co-duong-220ml-2024-1.jpg', 'Sản phẩm sữa tươi TH True Milk', 706, 1),
(969, 'MD0336', 3, 4, 3, 1, '2025-02-09', 19584, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-2.jpeg', 'Sản phẩm sữa tươi TH True Milk', 844, 0),
(970, 'MD0337', 3, 4, 3, 2, '2025-05-03', 46468, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-2.jpeg', 'Sản phẩm sữa tươi TH True Milk', 193, 0),
(971, 'MD0338', 3, 4, 3, 3, '2026-04-07', 30127, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-2.jpeg', 'Sản phẩm sữa tươi TH True Milk', 921, 1),
(972, 'MD0339', 3, 4, 3, 4, '2024-12-13', 13346, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-2.jpeg', 'Sản phẩm sữa tươi TH True Milk', 875, 0),
(973, 'MD0340', 3, 4, 3, 5, '2025-05-06', 41620, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-2.jpeg', 'Sản phẩm sữa tươi TH True Milk', 764, 0),
(974, 'MD0341', 3, 4, 4, 1, '2025-12-07', 20465, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-7.jpg', 'Sản phẩm sữa tươi TH True Milk', 461, 1),
(975, 'MD0342', 3, 4, 4, 2, '2026-05-31', 23949, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-7.jpg', 'Sản phẩm sữa tươi TH True Milk', 970, 1),
(976, 'MD0343', 3, 4, 4, 3, '2026-10-13', 28595, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-7.jpg', 'Sản phẩm sữa tươi TH True Milk', 11, 1),
(977, 'MD0344', 3, 4, 4, 4, '2025-08-12', 19061, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-7.jpg', 'Sản phẩm sữa tươi TH True Milk', 794, 0),
(978, 'MD0345', 3, 4, 4, 5, '2025-12-10', 10563, 'https://cdn.tgdd.vn/Products/Images/2386/85859/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-7.jpg', 'Sản phẩm sữa tươi TH True Milk', 282, 0),
(979, 'MD0346', 3, 4, 5, 1, '2025-02-14', 36736, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Icon-UHT-Co-duong-110-275x186.png', 'Sản phẩm sữa tươi TH True Milk', 499, 0),
(980, 'MD0347', 3, 4, 5, 2, '2025-02-12', 24500, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Icon-UHT-Co-duong-110-275x186.png', 'Sản phẩm sữa tươi TH True Milk', 376, 1),
(981, 'MD0348', 3, 4, 5, 3, '2026-02-05', 21308, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Icon-UHT-Co-duong-110-275x186.png', 'Sản phẩm sữa tươi TH True Milk', 234, 1),
(982, 'MD0349', 3, 4, 5, 4, '2025-01-22', 38967, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Icon-UHT-Co-duong-110-275x186.png', 'Sản phẩm sữa tươi TH True Milk', 684, 0),
(983, 'MD0350', 3, 4, 5, 5, '2026-10-20', 14013, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Icon-UHT-Co-duong-110-275x186.png', 'Sản phẩm sữa tươi TH True Milk', 931, 1),
(984, 'MD0351', 3, 5, 1, 1, '2025-02-25', 22907, 'https://www.thmilk.vn/wp-content/uploads/2019/11/vi-tu-nhi%C3%AAn-png.png', 'Sản phẩm sữa tươi TH True Milk', 403, 0),
(985, 'MD0352', 3, 5, 1, 2, '2025-12-19', 25127, 'https://www.thmilk.vn/wp-content/uploads/2019/11/vi-tu-nhi%C3%AAn-png.png', 'Sản phẩm sữa tươi TH True Milk', 600, 0),
(986, 'MD0353', 3, 5, 1, 3, '2026-02-26', 23985, 'https://www.thmilk.vn/wp-content/uploads/2019/11/vi-tu-nhi%C3%AAn-png.png', 'Sản phẩm sữa tươi TH True Milk', 108, 0),
(987, 'MD0354', 3, 5, 1, 4, '2025-08-20', 10468, 'https://www.thmilk.vn/wp-content/uploads/2019/11/vi-tu-nhi%C3%AAn-png.png', 'Sản phẩm sữa tươi TH True Milk', 286, 0),
(988, 'MD0355', 3, 5, 1, 5, '2024-12-13', 17796, 'https://www.thmilk.vn/wp-content/uploads/2019/11/vi-tu-nhi%C3%AAn-png.png', 'Sản phẩm sữa tươi TH True Milk', 511, 0),
(989, 'MD0356', 3, 5, 2, 1, '2026-08-02', 29614, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Nguy%C3%AAn-ch%E1%BA%A5t-png.png', 'Sản phẩm sữa tươi TH True Milk', 497, 0),
(990, 'MD0357', 3, 5, 2, 2, '2025-01-01', 26586, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Nguy%C3%AAn-ch%E1%BA%A5t-png.png', 'Sản phẩm sữa tươi TH True Milk', 549, 0),
(991, 'MD0358', 3, 5, 2, 3, '2026-01-23', 36420, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Nguy%C3%AAn-ch%E1%BA%A5t-png.png', 'Sản phẩm sữa tươi TH True Milk', 413, 0),
(992, 'MD0359', 3, 5, 2, 4, '2025-06-29', 20624, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Nguy%C3%AAn-ch%E1%BA%A5t-png.png', 'Sản phẩm sữa tươi TH True Milk', 695, 0),
(993, 'MD0360', 3, 5, 2, 5, '2026-07-20', 23023, 'https://www.thmilk.vn/wp-content/uploads/2019/11/Nguy%C3%AAn-ch%E1%BA%A5t-png.png', 'Sản phẩm sữa tươi TH True Milk', 513, 1),
(994, 'MD0361', 3, 5, 3, 1, '2026-10-11', 27041, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-180ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 29, 0),
(995, 'MD0362', 3, 5, 3, 2, '2025-07-14', 13952, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-180ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 548, 0),
(996, 'MD0363', 3, 5, 3, 3, '2026-08-28', 39814, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-180ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 237, 0),
(997, 'MD0364', 3, 5, 3, 4, '2025-08-17', 24005, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-180ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 776, 0),
(998, 'MD0365', 3, 5, 3, 5, '2026-07-20', 11560, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-180ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 96, 1),
(999, 'MD0366', 3, 5, 4, 1, '2025-07-13', 31668, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-nguyen-chat-hop-180ml-a1.jpg', 'Sản phẩm sữa tươi TH True Milk', 576, 0),
(1000, 'MD0367', 3, 5, 4, 2, '2025-10-17', 22852, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-nguyen-chat-hop-180ml-a1.jpg', 'Sản phẩm sữa tươi TH True Milk', 141, 0),
(1001, 'MD0368', 3, 5, 4, 3, '2026-05-23', 19543, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-nguyen-chat-hop-180ml-a1.jpg', 'Sản phẩm sữa tươi TH True Milk', 762, 0),
(1002, 'MD0369', 3, 5, 4, 4, '2026-03-30', 41482, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-nguyen-chat-hop-180ml-a1.jpg', 'Sản phẩm sữa tươi TH True Milk', 619, 0),
(1003, 'MD0370', 3, 5, 4, 5, '2025-07-24', 32445, 'https://suachobeyeu.vn/application/upload/products/sua-tuoi-th-true-milk-nguyen-chat-hop-180ml-a1.jpg', 'Sản phẩm sữa tươi TH True Milk', 445, 0),
(1004, 'MD0371', 3, 5, 5, 1, '2026-07-14', 13802, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-110ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 37, 0),
(1005, 'MD0372', 3, 5, 5, 2, '2025-10-06', 43781, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-110ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 803, 1),
(1006, 'MD0373', 3, 5, 5, 3, '2026-09-15', 25371, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-110ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 438, 1),
(1007, 'MD0374', 3, 5, 5, 4, '2026-06-09', 36865, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-110ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 728, 1),
(1008, 'MD0375', 3, 5, 5, 5, '2025-11-28', 21813, 'https://www.thtruemart.vn/media/catalog/product/cache/207e23213cf636ccdef205098cf3c8a3/n/g/nguyen-chat-110ml-2024_2_.jpg', 'Sản phẩm sữa tươi TH True Milk', 407, 1),
(1009, 'MD0376', 4, 1, 1, 1, '2025-03-02', 34421, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 631, 0),
(1010, 'MD0377', 4, 1, 1, 2, '2026-09-06', 19964, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 837, 0),
(1011, 'MD0378', 4, 1, 1, 3, '2026-02-25', 32107, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 630, 0),
(1012, 'MD0379', 4, 1, 1, 4, '2025-10-22', 38431, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 581, 1),
(1013, 'MD0380', 4, 1, 1, 5, '2025-10-24', 17926, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 730, 0),
(1014, 'MD0381', 4, 1, 2, 1, '2026-08-30', 24933, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 422, 0),
(1015, 'MD0382', 4, 1, 2, 2, '2024-12-08', 19972, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 171, 1),
(1016, 'MD0383', 4, 1, 2, 3, '2025-06-03', 20458, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 508, 0),
(1017, 'MD0384', 4, 1, 2, 4, '2025-08-02', 24186, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 498, 0),
(1018, 'MD0385', 4, 1, 2, 5, '2026-10-10', 17671, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 349, 0),
(1019, 'MD0386', 4, 1, 3, 1, '2026-05-18', 18728, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 74, 1),
(1020, 'MD0387', 4, 1, 3, 2, '2026-07-19', 21383, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 639, 1),
(1021, 'MD0388', 4, 1, 3, 3, '2026-09-28', 13222, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 119, 0),
(1022, 'MD0389', 4, 1, 3, 4, '2026-08-14', 35016, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 420, 0),
(1023, 'MD0390', 4, 1, 3, 5, '2025-07-06', 21316, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 515, 1),
(1024, 'MD0391', 4, 1, 4, 1, '2024-12-08', 12277, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 623, 0),
(1025, 'MD0392', 4, 1, 4, 2, '2026-09-01', 30979, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 479, 0),
(1026, 'MD0393', 4, 1, 4, 3, '2025-03-19', 33887, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 967, 0),
(1027, 'MD0394', 4, 1, 4, 4, '2026-10-14', 31775, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 840, 1),
(1028, 'MD0395', 4, 1, 4, 5, '2025-09-21', 40166, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 744, 0),
(1029, 'MD0396', 4, 1, 5, 1, '2026-02-02', 41808, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 257, 1),
(1030, 'MD0397', 4, 1, 5, 2, '2026-07-19', 12068, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 67, 1),
(1031, 'MD0398', 4, 1, 5, 3, '2026-03-05', 20846, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 162, 0),
(1032, 'MD0399', 4, 1, 5, 4, '2025-05-27', 19516, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 837, 1),
(1033, 'MD0400', 4, 1, 5, 5, '2025-02-04', 31191, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 532, 1),
(1034, 'MD0401', 4, 2, 1, 1, '2025-10-19', 25144, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 870, 1),
(1035, 'MD0402', 4, 2, 1, 2, '2026-06-06', 24128, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 540, 1),
(1036, 'MD0403', 4, 2, 1, 3, '2025-12-22', 34322, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 360, 1),
(1037, 'MD0404', 4, 2, 1, 4, '2025-02-02', 24576, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 994, 1),
(1038, 'MD0405', 4, 2, 1, 5, '2026-08-28', 29850, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 298, 0),
(1039, 'MD0406', 4, 2, 2, 1, '2025-10-28', 49753, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 545, 0),
(1040, 'MD0407', 4, 2, 2, 2, '2026-02-07', 12323, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 858, 0),
(1041, 'MD0408', 4, 2, 2, 3, '2026-07-20', 32802, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 98, 1),
(1042, 'MD0409', 4, 2, 2, 4, '2025-08-07', 21468, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 380, 0),
(1043, 'MD0410', 4, 2, 2, 5, '2026-06-30', 21106, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 902, 0),
(1044, 'MD0411', 4, 2, 3, 1, '2026-08-13', 43955, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 325, 0),
(1045, 'MD0412', 4, 2, 3, 2, '2025-10-11', 20825, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 843, 0),
(1046, 'MD0413', 4, 2, 3, 3, '2026-03-14', 32236, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 601, 0),
(1047, 'MD0414', 4, 2, 3, 4, '2025-08-03', 35788, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 600, 1),
(1048, 'MD0415', 4, 2, 3, 5, '2025-04-23', 39671, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 877, 0),
(1049, 'MD0416', 4, 2, 4, 1, '2026-01-22', 33331, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 570, 0),
(1050, 'MD0417', 4, 2, 4, 2, '2025-11-29', 48930, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 121, 0),
(1051, 'MD0418', 4, 2, 4, 3, '2026-05-13', 14624, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 556, 0),
(1052, 'MD0419', 4, 2, 4, 4, '2025-12-30', 19643, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 335, 1),
(1053, 'MD0420', 4, 2, 4, 5, '2025-02-26', 40141, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 554, 1),
(1054, 'MD0421', 4, 2, 5, 1, '2025-08-12', 12440, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 923, 0),
(1055, 'MD0422', 4, 2, 5, 2, '2025-10-05', 20954, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 509, 1),
(1056, 'MD0423', 4, 2, 5, 3, '2025-11-05', 39961, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 926, 0),
(1057, 'MD0424', 4, 2, 5, 4, '2025-10-31', 46773, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 660, 0),
(1058, 'MD0425', 4, 2, 5, 5, '2026-05-25', 35939, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 47, 1),
(1059, 'MD0426', 4, 3, 1, 1, '2025-01-13', 39886, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 59, 1),
(1060, 'MD0427', 4, 3, 1, 2, '2025-12-11', 48614, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 19, 1),
(1061, 'MD0428', 4, 3, 1, 3, '2025-04-22', 13960, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 751, 1),
(1062, 'MD0429', 4, 3, 1, 4, '2025-10-19', 33436, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 292, 0),
(1063, 'MD0430', 4, 3, 1, 5, '2025-10-05', 27812, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 110, 0),
(1064, 'MD0431', 4, 3, 2, 1, '2026-05-29', 40831, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 248, 0),
(1065, 'MD0432', 4, 3, 2, 2, '2026-02-14', 32960, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 542, 1),
(1066, 'MD0433', 4, 3, 2, 3, '2026-06-22', 19468, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 543, 0),
(1067, 'MD0434', 4, 3, 2, 4, '2026-02-20', 23021, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 758, 1),
(1068, 'MD0435', 4, 3, 2, 5, '2025-10-18', 24776, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 849, 0),
(1069, 'MD0436', 4, 3, 3, 1, '2025-07-01', 37285, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 319, 1),
(1070, 'MD0437', 4, 3, 3, 2, '2025-07-26', 30094, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 549, 0),
(1071, 'MD0438', 4, 3, 3, 3, '2026-04-02', 27930, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 368, 1),
(1072, 'MD0439', 4, 3, 3, 4, '2025-08-29', 28491, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 610, 0),
(1073, 'MD0440', 4, 3, 3, 5, '2025-06-26', 30024, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 163, 0),
(1074, 'MD0441', 4, 3, 4, 1, '2025-05-23', 38975, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 173, 0),
(1075, 'MD0442', 4, 3, 4, 2, '2025-01-22', 20383, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 164, 1),
(1076, 'MD0443', 4, 3, 4, 3, '2026-05-08', 10478, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 401, 1),
(1077, 'MD0444', 4, 3, 4, 4, '2025-03-28', 16927, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 986, 1),
(1078, 'MD0445', 4, 3, 4, 5, '2025-07-08', 19206, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 287, 1),
(1079, 'MD0446', 4, 3, 5, 1, '2026-05-21', 35491, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 239, 0),
(1080, 'MD0447', 4, 3, 5, 2, '2026-06-10', 13682, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 509, 1),
(1081, 'MD0448', 4, 3, 5, 3, '2025-05-06', 26130, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 939, 0),
(1082, 'MD0449', 4, 3, 5, 4, '2026-10-06', 45677, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 614, 1),
(1083, 'MD0450', 4, 3, 5, 5, '2026-04-09', 42065, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 155, 0),
(1084, 'MD0451', 4, 4, 1, 1, '2026-04-21', 25193, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 470, 0),
(1085, 'MD0452', 4, 4, 1, 2, '2025-09-14', 17139, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 403, 1),
(1086, 'MD0453', 4, 4, 1, 3, '2026-05-27', 25292, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 687, 0),
(1087, 'MD0454', 4, 4, 1, 4, '2026-10-18', 26597, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 325, 1),
(1088, 'MD0455', 4, 4, 1, 5, '2026-01-02', 42080, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 109, 0),
(1089, 'MD0456', 4, 4, 2, 1, '2026-07-07', 36453, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady,', 363, 0),
(1090, 'MD0457', 4, 4, 2, 2, '2026-10-07', 33279, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 285, 1),
(1091, 'MD0458', 4, 4, 2, 3, '2024-11-30', 36594, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 366, 0),
(1092, 'MD0459', 4, 4, 2, 4, '2026-10-08', 24431, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 372, 1),
(1093, 'MD0460', 4, 4, 2, 5, '2025-12-24', 24289, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 706, 1),
(1094, 'MD0461', 4, 4, 3, 1, '2025-02-09', 19584, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 844, 0),
(1095, 'MD0462', 4, 4, 3, 2, '2025-05-03', 46468, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 193, 0),
(1096, 'MD0463', 4, 4, 3, 3, '2026-04-07', 30127, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 921, 1),
(1097, 'MD0464', 4, 4, 3, 4, '2024-12-13', 13346, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 875, 0),
(1098, 'MD0465', 4, 4, 3, 5, '2025-05-06', 41620, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 764, 0),
(1099, 'MD0466', 4, 4, 4, 1, '2025-12-07', 20465, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 461, 1),
(1100, 'MD0467', 4, 4, 4, 2, '2026-05-31', 23949, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 970, 1),
(1101, 'MD0468', 4, 4, 4, 3, '2026-10-13', 28595, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 11, 1),
(1102, 'MD0469', 4, 4, 4, 4, '2025-08-12', 19061, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 794, 0),
(1103, 'MD0470', 4, 4, 4, 5, '2025-12-10', 10563, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 282, 0),
(1104, 'MD0471', 4, 4, 5, 1, '2025-02-14', 36736, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 499, 0),
(1105, 'MD0472', 4, 4, 5, 2, '2025-02-12', 24500, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 376, 1),
(1106, 'MD0473', 4, 4, 5, 3, '2026-02-05', 21308, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 234, 1),
(1107, 'MD0474', 4, 4, 5, 4, '2025-01-22', 38967, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 684, 0),
(1108, 'MD0475', 4, 4, 5, 5, '2026-10-20', 14013, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 931, 1),
(1109, 'MD0476', 4, 5, 1, 1, '2025-02-25', 22907, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 403, 0),
(1110, 'MD0477', 4, 5, 1, 2, '2025-12-19', 25127, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 600, 0),
(1111, 'MD0478', 4, 5, 1, 3, '2026-02-26', 23985, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 108, 0),
(1112, 'MD0479', 4, 5, 1, 4, '2025-08-20', 10468, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 286, 0),
(1113, 'MD0480', 4, 5, 1, 5, '2024-12-13', 17796, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 511, 0),
(1114, 'MD0481', 4, 5, 2, 1, '2026-08-02', 29614, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 497, 0),
(1115, 'MD0482', 4, 5, 2, 2, '2025-01-01', 26586, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 549, 0),
(1116, 'MD0483', 4, 5, 2, 3, '2026-01-23', 36420, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 413, 0),
(1117, 'MD0484', 4, 5, 2, 4, '2025-06-29', 20624, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 695, 0),
(1118, 'MD0485', 4, 5, 2, 5, '2026-07-20', 23023, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 513, 1),
(1119, 'MD0486', 4, 5, 3, 1, '2026-10-11', 27041, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 29, 0),
(1120, 'MD0487', 4, 5, 3, 2, '2025-07-14', 13952, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 548, 0),
(1121, 'MD0488', 4, 5, 3, 3, '2026-08-28', 39814, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 237, 0),
(1122, 'MD0489', 4, 5, 3, 4, '2025-08-17', 24005, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 776, 0),
(1123, 'MD0490', 4, 5, 3, 5, '2026-07-20', 11560, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 96, 1),
(1124, 'MD0491', 4, 5, 4, 1, '2025-07-13', 31668, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 576, 0),
(1125, 'MD0492', 4, 5, 4, 2, '2025-10-17', 22852, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 141, 0),
(1126, 'MD0493', 4, 5, 4, 3, '2026-05-23', 19543, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 762, 0),
(1127, 'MD0494', 4, 5, 4, 4, '2026-03-30', 41482, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 619, 0),
(1128, 'MD0495', 4, 5, 4, 5, '2025-07-24', 32445, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 445, 0),
(1129, 'MD0496', 4, 5, 5, 1, '2026-07-14', 13802, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 37, 0),
(1130, 'MD0497', 4, 5, 5, 2, '2025-10-06', 43781, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 803, 1),
(1131, 'MD0498', 4, 5, 5, 3, '2026-09-15', 25371, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 438, 1),
(1132, 'MD0499', 4, 5, 5, 4, '2026-06-09', 36865, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 728, 1),
(1133, 'MD0500', 4, 5, 5, 5, '2025-11-28', 21813, 'https://www.dutchlady.com.vn/sites/default/files/2023-05/Packshot%20-%20DL%20SCC%20Blue%20Tin_1.jpg', 'Sản phẩm sữa đặc Dutch Lady', 407, 1),
(1134, 'MD0501', 5, 1, 1, 1, '2025-03-02', 34421, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 631, 0),
(1135, 'MD0502', 5, 1, 1, 2, '2026-09-06', 19964, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 837, 0),
(1136, 'MD0503', 5, 1, 1, 3, '2026-02-25', 32107, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 630, 0),
(1137, 'MD0504', 5, 1, 1, 4, '2025-10-22', 38431, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 581, 1),
(1138, 'MD0505', 5, 1, 1, 5, '2025-10-24', 17926, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 730, 0),
(1139, 'MD0506', 5, 1, 2, 1, '2026-08-30', 24933, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 422, 0),
(1140, 'MD0507', 5, 1, 2, 2, '2024-12-08', 19972, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 171, 1),
(1141, 'MD0508', 5, 1, 2, 3, '2025-06-03', 20458, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 508, 0),
(1142, 'MD0509', 5, 1, 2, 4, '2025-08-02', 24186, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 498, 0),
(1143, 'MD0510', 5, 1, 2, 5, '2026-10-10', 17671, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 349, 0),
(1144, 'MD0511', 5, 1, 3, 1, '2026-05-18', 18728, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 74, 1),
(1145, 'MD0512', 5, 1, 3, 2, '2026-07-19', 21383, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 639, 1),
(1146, 'MD0513', 5, 1, 3, 3, '2026-09-28', 13222, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 119, 0),
(1147, 'MD0514', 5, 1, 3, 4, '2026-08-14', 35016, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 420, 0),
(1148, 'MD0515', 5, 1, 3, 5, '2025-07-06', 21316, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 515, 1),
(1149, 'MD0516', 5, 1, 4, 1, '2024-12-08', 12277, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 623, 0),
(1150, 'MD0517', 5, 1, 4, 2, '2026-09-01', 30979, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 479, 0),
(1151, 'MD0518', 5, 1, 4, 3, '2025-03-19', 33887, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 967, 0),
(1152, 'MD0519', 5, 1, 4, 4, '2026-10-14', 31775, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 840, 1),
(1153, 'MD0520', 5, 1, 4, 5, '2025-09-21', 40166, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 744, 0),
(1154, 'MD0521', 5, 1, 5, 1, '2026-02-02', 41808, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 257, 1),
(1155, 'MD0522', 5, 1, 5, 2, '2026-07-19', 12068, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 67, 1),
(1156, 'MD0523', 5, 1, 5, 3, '2026-03-05', 20846, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 162, 0),
(1157, 'MD0524', 5, 1, 5, 4, '2025-05-27', 19516, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 837, 1),
(1158, 'MD0525', 5, 1, 5, 5, '2025-02-04', 31191, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 532, 1),
(1159, 'MD0526', 5, 2, 1, 1, '2025-10-19', 25144, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 870, 1),
(1160, 'MD0527', 5, 2, 1, 2, '2026-06-06', 24128, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 540, 1),
(1161, 'MD0528', 5, 2, 1, 3, '2025-12-22', 34322, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 360, 1),
(1162, 'MD0529', 5, 2, 1, 4, '2025-02-02', 24576, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 994, 1);
INSERT INTO `milkdetail` (`id`, `milkdetailcode`, `productid`, `milktasteid`, `packagingunitid`, `usagecapacityid`, `expirationdate`, `price`, `imgUrl`, `description`, `stockquantity`, `status`) VALUES
(1163, 'MD0530', 5, 2, 1, 5, '2026-08-28', 29850, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 298, 0),
(1164, 'MD0531', 5, 2, 2, 1, '2025-10-28', 49753, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 545, 0),
(1165, 'MD0532', 5, 2, 2, 2, '2026-02-07', 12323, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 858, 0),
(1166, 'MD0533', 5, 2, 2, 3, '2026-07-20', 32802, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 98, 1),
(1167, 'MD0534', 5, 2, 2, 4, '2025-08-07', 21468, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 380, 0),
(1168, 'MD0535', 5, 2, 2, 5, '2026-06-30', 21106, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 902, 0),
(1169, 'MD0536', 5, 2, 3, 1, '2026-08-13', 43955, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 325, 0),
(1170, 'MD0537', 5, 2, 3, 2, '2025-10-11', 20825, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 843, 0),
(1171, 'MD0538', 5, 2, 3, 3, '2026-03-14', 32236, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 601, 0),
(1172, 'MD0539', 5, 2, 3, 4, '2025-08-03', 35788, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 600, 1),
(1173, 'MD0540', 5, 2, 3, 5, '2025-04-23', 39671, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 877, 0),
(1174, 'MD0541', 5, 2, 4, 1, '2026-01-22', 33331, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 570, 0),
(1175, 'MD0542', 5, 2, 4, 2, '2025-11-29', 48930, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 121, 0),
(1176, 'MD0543', 5, 2, 4, 3, '2026-05-13', 14624, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 556, 0),
(1177, 'MD0544', 5, 2, 4, 4, '2025-12-30', 19643, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 335, 1),
(1178, 'MD0545', 5, 2, 4, 5, '2025-02-26', 40141, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 554, 1),
(1179, 'MD0546', 5, 2, 5, 1, '2025-08-12', 12440, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 923, 0),
(1180, 'MD0547', 5, 2, 5, 2, '2025-10-05', 20954, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 509, 1),
(1181, 'MD0548', 5, 2, 5, 3, '2025-11-05', 39961, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 926, 0),
(1182, 'MD0549', 5, 2, 5, 4, '2025-10-31', 46773, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 660, 0),
(1183, 'MD0550', 5, 2, 5, 5, '2026-05-25', 35939, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 47, 1),
(1184, 'MD0551', 5, 3, 1, 1, '2025-01-13', 39886, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 59, 1),
(1185, 'MD0552', 5, 3, 1, 2, '2025-12-11', 48614, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 19, 1),
(1186, 'MD0553', 5, 3, 1, 3, '2025-04-22', 13960, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 751, 1),
(1187, 'MD0554', 5, 3, 1, 4, '2025-10-19', 33436, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 292, 0),
(1188, 'MD0555', 5, 3, 1, 5, '2025-10-05', 27812, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 110, 0),
(1189, 'MD0556', 5, 3, 2, 1, '2026-05-29', 40831, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 248, 0),
(1190, 'MD0557', 5, 3, 2, 2, '2026-02-14', 32960, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 542, 1),
(1191, 'MD0558', 5, 3, 2, 3, '2026-06-22', 19468, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 543, 0),
(1192, 'MD0559', 5, 3, 2, 4, '2026-02-20', 23021, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 758, 1),
(1193, 'MD0560', 5, 3, 2, 5, '2025-10-18', 24776, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 849, 0),
(1194, 'MD0561', 5, 3, 3, 1, '2025-07-01', 37285, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 319, 1),
(1195, 'MD0562', 5, 3, 3, 2, '2025-07-26', 30094, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 549, 0),
(1196, 'MD0563', 5, 3, 3, 3, '2026-04-02', 27930, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 368, 1),
(1197, 'MD0564', 5, 3, 3, 4, '2025-08-29', 28491, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 610, 0),
(1198, 'MD0565', 5, 3, 3, 5, '2025-06-26', 30024, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 163, 0),
(1199, 'MD0566', 5, 3, 4, 1, '2025-05-23', 38975, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 173, 0),
(1200, 'MD0567', 5, 3, 4, 2, '2025-01-22', 20383, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 164, 1),
(1201, 'MD0568', 5, 3, 4, 3, '2026-05-08', 10478, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 401, 1),
(1202, 'MD0569', 5, 3, 4, 4, '2025-03-28', 16927, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 986, 1),
(1203, 'MD0570', 5, 3, 4, 5, '2025-07-08', 19206, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 287, 1),
(1204, 'MD0571', 5, 3, 5, 1, '2026-05-21', 35491, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 239, 0),
(1205, 'MD0572', 5, 3, 5, 2, '2026-06-10', 13682, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 509, 1),
(1206, 'MD0573', 5, 3, 5, 3, '2025-05-06', 26130, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 939, 0),
(1207, 'MD0574', 5, 3, 5, 4, '2026-10-06', 45677, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 614, 1),
(1208, 'MD0575', 5, 3, 5, 5, '2026-04-09', 42065, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 155, 0),
(1209, 'MD0576', 5, 4, 1, 1, '2026-04-21', 25193, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 470, 0),
(1210, 'MD0577', 5, 4, 1, 2, '2025-09-14', 17139, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 403, 1),
(1211, 'MD0578', 5, 4, 1, 3, '2026-05-27', 25292, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 687, 0),
(1212, 'MD0579', 5, 4, 1, 4, '2026-10-18', 26597, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 325, 1),
(1213, 'MD0580', 5, 4, 1, 5, '2026-01-02', 42080, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 109, 0),
(1214, 'MD0581', 5, 4, 2, 1, '2026-07-07', 36453, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé,', 363, 0),
(1215, 'MD0582', 5, 4, 2, 2, '2026-10-07', 33279, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 285, 1),
(1216, 'MD0583', 5, 4, 2, 3, '2024-11-30', 36594, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 366, 0),
(1217, 'MD0584', 5, 4, 2, 4, '2026-10-08', 24431, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 372, 1),
(1218, 'MD0585', 5, 4, 2, 5, '2025-12-24', 24289, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 706, 1),
(1219, 'MD0586', 5, 4, 3, 1, '2025-02-09', 19584, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 844, 0),
(1220, 'MD0587', 5, 4, 3, 2, '2025-05-03', 46468, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 193, 0),
(1221, 'MD0588', 5, 4, 3, 3, '2026-04-07', 30127, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 921, 1),
(1222, 'MD0589', 5, 4, 3, 4, '2024-12-13', 13346, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 875, 0),
(1223, 'MD0590', 5, 4, 3, 5, '2025-05-06', 41620, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 764, 0),
(1224, 'MD0591', 5, 4, 4, 1, '2025-12-07', 20465, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 461, 1),
(1225, 'MD0592', 5, 4, 4, 2, '2026-05-31', 23949, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 970, 1),
(1226, 'MD0593', 5, 4, 4, 3, '2026-10-13', 28595, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 11, 1),
(1227, 'MD0594', 5, 4, 4, 4, '2025-08-12', 19061, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 794, 0),
(1228, 'MD0595', 5, 4, 4, 5, '2025-12-10', 10563, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 282, 0),
(1229, 'MD0596', 5, 4, 5, 1, '2025-02-14', 36736, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 499, 0),
(1230, 'MD0597', 5, 4, 5, 2, '2025-02-12', 24500, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 376, 1),
(1231, 'MD0598', 5, 4, 5, 3, '2026-02-05', 21308, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 234, 1),
(1232, 'MD0599', 5, 4, 5, 4, '2025-01-22', 38967, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 684, 0),
(1233, 'MD0600', 5, 4, 5, 5, '2026-10-20', 14013, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 931, 1),
(1234, 'MD0601', 5, 5, 1, 1, '2025-02-25', 22907, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 403, 0),
(1235, 'MD0602', 5, 5, 1, 2, '2025-12-19', 25127, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 600, 0),
(1236, 'MD0603', 5, 5, 1, 3, '2026-02-26', 23985, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 108, 0),
(1237, 'MD0604', 5, 5, 1, 4, '2025-08-20', 10468, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 286, 0),
(1238, 'MD0605', 5, 5, 1, 5, '2024-12-13', 17796, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 511, 0),
(1239, 'MD0606', 5, 5, 2, 1, '2026-08-02', 29614, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 497, 0),
(1240, 'MD0607', 5, 5, 2, 2, '2025-01-01', 26586, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 549, 0),
(1241, 'MD0608', 5, 5, 2, 3, '2026-01-23', 36420, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 413, 0),
(1242, 'MD0609', 5, 5, 2, 4, '2025-06-29', 20624, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 695, 0),
(1243, 'MD0610', 5, 5, 2, 5, '2026-07-20', 23023, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 513, 1),
(1244, 'MD0611', 5, 5, 3, 1, '2026-10-11', 27041, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 29, 0),
(1245, 'MD0612', 5, 5, 3, 2, '2025-07-14', 13952, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 548, 0),
(1246, 'MD0613', 5, 5, 3, 3, '2026-08-28', 39814, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 237, 0),
(1247, 'MD0614', 5, 5, 3, 4, '2025-08-17', 24005, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 776, 0),
(1248, 'MD0615', 5, 5, 3, 5, '2026-07-20', 11560, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 96, 1),
(1249, 'MD0616', 5, 5, 4, 1, '2025-07-13', 31668, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 576, 0),
(1250, 'MD0617', 5, 5, 4, 2, '2025-10-17', 22852, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 141, 0),
(1251, 'MD0618', 5, 5, 4, 3, '2026-05-23', 19543, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 762, 0),
(1252, 'MD0619', 5, 5, 4, 4, '2026-03-30', 41482, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 619, 0),
(1253, 'MD0620', 5, 5, 4, 5, '2025-07-24', 32445, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 445, 0),
(1254, 'MD0621', 5, 5, 5, 1, '2026-07-14', 13802, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 37, 0),
(1255, 'MD0622', 5, 5, 5, 2, '2025-10-06', 43781, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 803, 1),
(1256, 'MD0623', 5, 5, 5, 3, '2026-09-15', 25371, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 438, 1),
(1257, 'MD0624', 5, 5, 5, 4, '2026-06-09', 36865, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 728, 1),
(1258, 'MD0625', 5, 5, 5, 5, '2025-11-28', 21813, 'https://sieuthihoaba.com.vn/wp-content/uploads/2020/08/bot-milo-nguyen-chat-hu-400g-5-org.jpg', 'Sản phẩm đồ uống lúa mạch Nestlé', 407, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `milktaste`
--

CREATE TABLE `milktaste` (
  `id` bigint(20) NOT NULL,
  `milktastename` varchar(255) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái hương vị'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `milktaste`
--

INSERT INTO `milktaste` (`id`, `milktastename`, `status`) VALUES
(1, 'Vị dâu', 1),
(2, 'Vị socola', 1),
(3, 'Ít đường', 1),
(4, 'Có đường', 1),
(5, 'Không đường', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `milktype`
--

CREATE TABLE `milktype` (
  `id` bigint(20) NOT NULL,
  `milkTypename` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT 'Mô tả loại sữa',
  `status` int(11) NOT NULL COMMENT 'Trạng thái loại sữa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `milktype`
--

INSERT INTO `milktype` (`id`, `milkTypename`, `description`, `status`) VALUES
(1, 'Sữa tươi', 'Sữa được sản xuất từ sữa bò tươi', 1),
(2, 'Sữa bột', 'Sữa được chế biến thành bột', 1),
(3, 'Sữa đặc', 'Sữa được đặc chế cô đặc ít nước', 1),
(4, 'Sữa đậu nành', 'Sữa được sản xuất từ hạt đậu nành', 1),
(5, 'Sữa trái cây', 'Sữa được sản xuất kết hợp với hoa quả', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `packagingunit`
--

CREATE TABLE `packagingunit` (
  `id` bigint(20) NOT NULL,
  `packagingunitname` varchar(255) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái đơn vị đóng gói'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `packagingunit`
--

INSERT INTO `packagingunit` (`id`, `packagingunitname`, `status`) VALUES
(1, 'Lẻ 1 hộp', 1),
(2, 'Lẻ 1 bịch', 1),
(3, '6 lốc (24 hộp)', 1),
(4, 'Thùng 48 hộp', 1),
(5, '3 lốc (12 hộp)', 1),
(12, 'Một hộp 36 thùng', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product`
--

CREATE TABLE `product` (
  `id` bigint(20) NOT NULL,
  `productCode` varchar(255) DEFAULT NULL,
  `productname` varchar(100) DEFAULT NULL COMMENT 'Tên sản phẩm',
  `milktypeid` bigint(20) NOT NULL,
  `milkbrandid` bigint(20) NOT NULL,
  `targetuserid` bigint(20) NOT NULL,
  `productUrl` varchar(255) DEFAULT NULL COMMENT 'url Sản phẩm',
  `imgUrl` varchar(255) DEFAULT NULL COMMENT 'url ảnh Sản phẩm',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái sản phẩm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product`
--

INSERT INTO `product` (`id`, `productCode`, `productname`, `milktypeid`, `milkbrandid`, `targetuserid`, `productUrl`, `imgUrl`, `status`) VALUES
(1, 'SP001', 'Sữa tươi Vinamilk', 1, 1, 2, 'Sua-tuoi-Vinamilk-43664', 'https://www.vinamilk.com.vn/sua-tuoi-vinamilk/wp-content/themes/suanuoc/tpl/fm100-revamp/images/package/packshot-hoa-co-duong.png', 1),
(2, 'SP002', 'Sữa tươi Dutch Lady', 1, 3, 1, 'sua_tuoi_dutch_lady_03232', 'https://down-vn.img.susercontent.com/file/c1dd6fe5023c968c81da6ef3a9dd060d', 1),
(3, 'SP003', 'Sữa tươi TH True Milk', 1, 2, 2, 'Sua-bot-Nestle-5574', 'https://cdn.tgdd.vn/Products/Images/2386/85859/bhx/thung-48-hop-sua-tuoi-tiet-trung-co-duong-th-true-milk-180ml-202307120946039774.jpg', 1),
(4, 'SP004', 'Sữa đặc Dutch Lady', 3, 3, 3, 'Sua-dac-Dutch-Lady', 'https://cdn.tgdd.vn/Products/Images/2526/87242/bhx/sua-dac-co-duong-dutch-lady-xanh-bien-lon-380g-202202250816207887.jpg', 1),
(5, 'SP005', 'Milo', 2, 5, 2, 'Sua-bot-Nestle', 'https://product.hstatic.net/1000141988/product/bot_milo_nestle_285_g__i0000893__84cfa9dc86364fd2a4cc0ded8cf4aa52_1024x1024.jpg', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `role`
--

CREATE TABLE `role` (
  `id` bigint(20) NOT NULL,
  `roleName` varchar(255) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái vai trò'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `role`
--

INSERT INTO `role` (`id`, `roleName`, `status`) VALUES
(1, 'Admin', 1),
(2, 'User', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `targetuser`
--

CREATE TABLE `targetuser` (
  `id` bigint(20) NOT NULL,
  `targetName` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT 'Mô tả đối tượng sử dụng',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái đối tượng sử dụng'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `targetuser`
--

INSERT INTO `targetuser` (`id`, `targetName`, `description`, `status`) VALUES
(1, 'Trẻ em', 'Dành cho trẻ em', 1),
(2, 'Người lớn', 'Dành cho người lớn', 1),
(3, 'Người cao tuổi', 'Dành cho người cao tuổi', 1),
(4, 'người lớn trên 40', 'Dành cho người lớn trung niên', 1),
(5, 'người lớn trên 50', 'Dành cho người lớn', 1),
(6, 'mọi nứa tuổi', 'Dành cho mọi nữa tuổi sử dụng', 1),
(7, 'Thanh thiếu niên', '', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `usagecapacity`
--

CREATE TABLE `usagecapacity` (
  `id` bigint(20) NOT NULL,
  `capacity` int(11) DEFAULT NULL COMMENT 'Công suất sử dụng',
  `unit` varchar(255) DEFAULT NULL COMMENT 'Đơn vị công suất',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái công suất'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `usagecapacity`
--

INSERT INTO `usagecapacity` (`id`, `capacity`, `unit`, `status`) VALUES
(1, 110, 'ml', 1),
(2, 180, 'ml', 1),
(3, 220, 'ml', 1),
(4, 1, 'L', 1),
(5, 380, 'g', 1),
(17, 0, 'g', 1),
(18, 0, 'g', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL,
  `roleid` bigint(20) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) DEFAULT NULL COMMENT 'Mật khẩu',
  `fullname` varchar(255) DEFAULT NULL COMMENT 'Họ tên',
  `registrationdate` date DEFAULT NULL,
  `phonenumber` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT 'Địa chỉ',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái người dùng',
  `verificationToken` varchar(255) DEFAULT NULL,
  `tokenCreationTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`id`, `roleid`, `username`, `password`, `fullname`, `registrationdate`, `phonenumber`, `address`, `email`, `status`, `verificationToken`, `tokenCreationTime`) VALUES
(1, 2, 'admin', '$2a$10$hvtMiNWueDqxMkvGP5NYR.55qRcwbNiTWO/qZdxtjFgLkY1rUpQNC', 'admin', '2024-10-13', NULL, NULL, 'admin@admin.com', 0, NULL, '2024-11-01 07:16:47'),
(2, 1, 'hieu', '$2a$10$FXZi/F/Fy0Tif9fHR3PIeu/u2Lx9lsCttSOAOhlKNDI7LkYxnYG9i', 'hieu nguyen', '2024-10-13', NULL, NULL, 'hieudz@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(3, 2, 'truong', '$2a$10$NVriAztkibS5m.nRmkJzcOVykt9YekZmRGySmhJdCA.pyvGepkqBq', 'truong nguyen', '2024-10-13', NULL, NULL, 'truong@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(4, 2, 'truong1', '$2a$10$jXzihEPBC6K0rfeaGpxZU.63TS/PR1BJhoTAtfZnrBa1EXEyVSJ5G', 'truong nguyen', '2024-10-13', NULL, NULL, 'truong1@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(5, 1, 'manhne', '$2a$10$nEPii6ULzbtuihEJuJbiMOp6qrafZM6z6mPxnNwzXc8Ktb.fdVVy6', 'manhne', '2024-10-14', NULL, NULL, 'manhne', 0, NULL, '2024-10-31 16:44:03'),
(6, 1, 'thien', '$2a$10$oQuTC5g2BSFeWruY7XNBYu/j08OUcQoOggxc6HFZfbYaIFXpKsOiy', 'Luong Thuan Thien', '2024-10-15', NULL, NULL, 'luongthuanthien2gmail.com', 0, NULL, '2024-11-01 05:06:03'),
(7, 2, 'thienE', '$2a$10$VelvDeTA1xOQZSd4BZv8HebmbNBT.HtkUl3urRquwSL0tiqmrWhJG', 'Luong Thuan Thien 2', '2024-10-15', NULL, NULL, 'example@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(8, 2, 'thienV', '$2a$10$wS2XbJmBJc2S/yZYji1EUeins79BhvfMS9S6/6Tx5BJOGnWgLE8bq', 'Luong Thuan Thien 4', '2024-10-15', NULL, NULL, 'example4@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(9, 2, 'thien5', '$2a$10$eWyZ88ZDHvQOVlU0zLRv3ufIIj/.AgtmkYYSDX7dBshHR4ypZgVpO', 'Luong Thuan Thien 5', '2024-10-15', NULL, NULL, 'example5@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(10, 2, 'thien6', '$2a$10$54DAvzLHGIGg8Yb66c7mQ..99.pihZ1w4rFM9DBHXOexoEE5SuWG2', 'Luong Thuan Thien 6', '2024-10-15', NULL, NULL, 'example6@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(11, 2, 'thien7', '$2a$10$NxSnKebbf6zhe3Mk5HmLmOu42fxvQKtwPOITHtCqgJ05IPs8O/ww2', 'Luong Thuan Thien 7', '2024-10-15', NULL, NULL, 'example7@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(12, 2, 'thien8', '$2a$10$Z7MPJJwSZ71F1qfpZSQ8C.9KUFkhSIYHgSqV6k/nVkzhSm5nIyPty', 'Luong Thuan Thien 8', '2024-10-15', NULL, NULL, 'example8@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(13, 2, 'thien9', '$2a$10$U5JjD7Plgx9M7GnwDBVM8ujC0ztApXvCoDQH9hyPCh9Kynms2qZ9q', 'Luong Thuan Thien 9', '2024-10-15', '123456789', NULL, 'example9@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(14, 2, 'thien10', '$2a$10$a2xsYkdX8JWNqqtemsPoz.pptahd8JINvrtt9tKSxJWnuB2HLloDS', 'Luong Thuan Thien 10', '2024-10-15', '1234567890', NULL, 'example10@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(15, 2, 'basil2k4', '$2a$10$2/4BJdfJFNf3guRTkePB9eIlqTS3kfqVNqvJMdtwjtkW0DIhyZ1Cq', 'basil', '2024-10-15', NULL, NULL, 'basil2k4', 0, NULL, '2024-10-31 16:44:03'),
(16, 2, 'basil234', '$2a$10$Ij93VXFqHtX7axwEiVaogO9xVvgOwiieT2ZjD5Fj4vO1ZuvP.cY0W', 'basil', '2024-10-15', NULL, NULL, 'basil2k', 0, NULL, '2024-10-31 16:44:03'),
(17, 2, 'dtruong', '$2a$10$cb5gzQhkZS0gsi2iFjkxDuVesmW/3MLARux4kPC5AMhJe0qbtRIy.', 'dtruong', '2024-10-15', NULL, NULL, 'dtruong@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(18, 2, 'hieu12', '$2a$10$3itV2EfF7Wb9diyhRGMupeWb2TPNuodB33d6cLvSpUJEVj7OcCPFG', 'hieu12', '2024-10-15', NULL, NULL, 'hieu', 0, NULL, '2024-10-31 16:44:03'),
(19, 2, 'newuser', '$2a$10$7yxSGylU/HU22vyfGv8nwuzMtXTATHYcI/OULdCzMY84/TueI.uAO', 'Newser', '2024-10-19', NULL, NULL, 'newuser@example.com', 0, NULL, '2024-10-31 16:44:03'),
(20, 2, 'thien3', '$2a$10$MMmssRWsg33vqA2sLKOoW.QEraE.mP8XKgkaiA0vwF3uhAYZ29Gb6', 'Luong_Thuan_Thien33', '2024-10-19', NULL, NULL, 'luongthuanthien3@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(21, 2, 'thien31', '$2a$10$GnxyNNdEa2IVWS3D6.7poucoiw4W/HmTF4zlWA3t/SQdEfrwOd1Om', 'Luong_Thuan_Thien33', '2024-10-19', NULL, NULL, 'luongthuanthie2n3@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(22, 2, 'manhtest', '$2a$10$IMQ5hW29bNR.o7kK8uvpcukSbu2ONJMUl6BkTNUBtTRpOJUSc0fIG', 'Luong_Thuan_Thien33', '2024-10-19', NULL, NULL, 'manhtest@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(23, 2, 'newuser2', '$2a$10$myajVaIZbm0MhgBF1x.xXua8MC3nEndD7PycCANcCQUcYHV4ny6OO', 'Newser', '2024-10-19', NULL, NULL, 'newuser2@example.com', 0, NULL, '2024-10-31 16:44:03'),
(24, 2, 'newuser3', '$2a$10$5Esvr26wAorz9/r8CseWp.4DiuABaSz6WB36gTStbxR0IV2zPtnZ6', 'Newuser', '2024-10-19', NULL, NULL, 'newuser3@example.com', 0, NULL, '2024-10-31 16:44:03'),
(25, 2, 'newuser4', '$2a$10$wD55OKy7831.fXnke9JvfuPPKlchTra2PHZNpKzT1uRAANAlnXr0i', 'Newuserfire', '2024-10-20', NULL, NULL, 'newuser44@example.com', 0, NULL, '2024-10-31 16:44:03'),
(26, 2, 'newuser5', '$2a$10$dwf0oAfojvqOs4OtTiiRqerIW5gRBN806tad7VTKbOB/cBe7pJ65q', 'Luong Thuan Thien', '2024-10-20', NULL, NULL, 'newuser55@example.com', 0, NULL, '2024-10-31 16:44:03'),
(27, 2, 'Thien66', '$2a$10$iWtPoDtR248MY9hv5CqojOdba9ktEL8uuJR0IJTqrST9hSm5X7aGy', 'Luong Thuan Thien', '2024-10-22', NULL, NULL, 'luongthuanthien66@gmail.com', 0, NULL, '2024-10-31 16:44:03'),
(46, 2, 'botruong', '$2a$10$tgeG3zEVejgPFgd0JJlFCuMsGGJ2bJs.fttarMg/YFGxTXwVeaflS', 'truongnguyen', '2024-11-01', NULL, NULL, 'truongnguyen010123@gmail.com', 0, NULL, '2024-10-31 22:25:12'),
(51, 2, 'manhnes', '$2a$10$IvrBmvuGUFrdrsM09dANUOLF7cLb6/3VXyAB6..ykLdQNmzhsWr/C', 'nguyen manh', '2024-11-01', NULL, NULL, 'mynlatui@gmail.com', 1, NULL, '2024-11-01 03:29:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `userinvoice`
--

CREATE TABLE `userinvoice` (
  `id` bigint(20) NOT NULL,
  `userid` bigint(20) DEFAULT NULL,
  `invoiceid` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái mối quan hệ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `userinvoice`
--

INSERT INTO `userinvoice` (`id`, `userid`, `invoiceid`, `status`) VALUES
(1, 1, 1, 55),
(2, 2, 1, 55),
(3, 5, 2, 56),
(4, 3, 2, 56);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher`
--

CREATE TABLE `voucher` (
  `id` bigint(20) NOT NULL,
  `vouchercode` varchar(20) NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `discountpercentage` int(11) DEFAULT NULL COMMENT 'Phần trăm giảm giá',
  `maxamount` double NOT NULL,
  `usagecount` int(11) DEFAULT NULL COMMENT 'Số lần sử dụng',
  `status` int(11) DEFAULT NULL COMMENT 'Trạng thái voucher'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `voucher`
--

INSERT INTO `voucher` (`id`, `vouchercode`, `startdate`, `enddate`, `discountpercentage`, `maxamount`, `usagecount`, `status`) VALUES
(1, 'SALE50', '2024-10-01', '2024-12-31', 50, 50000, 100, 1),
(5, 'SALE510', '2024-10-25', '2024-12-31', 50, 50000, 100, 1),
(6, 'SALE15', '2024-11-01', '2024-12-24', 15, 15000, 1500, 1),
(7, 'SALE35', '2024-11-01', '2024-12-31', 35, 35000, 130, 1);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK9m312ke5bnn971xu85ke1o4b9` (`voucherid`);

--
-- Chỉ mục cho bảng `invoicedetail`
--
ALTER TABLE `invoicedetail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKt0mve2vv8ocb25b2779rqeksr` (`invoiceid`);

--
-- Chỉ mục cho bảng `milkbrand`
--
ALTER TABLE `milkbrand`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `milkdetail`
--
ALTER TABLE `milkdetail`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `milktaste`
--
ALTER TABLE `milktaste`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `milktype`
--
ALTER TABLE `milktype`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `packagingunit`
--
ALTER TABLE `packagingunit`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKohgj0exerg0r9ygn0gr8074ed` (`milkbrandid`),
  ADD KEY `FKitvnymfpm94v7bjovryk5ce4f` (`milktypeid`),
  ADD KEY `FKbfce4hhuxsms1rbohhkv9jxb1` (`targetuserid`);

--
-- Chỉ mục cho bảng `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `targetuser`
--
ALTER TABLE `targetuser`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `usagecapacity`
--
ALTER TABLE `usagecapacity`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `FK2ovmsl4hvm5vu1w8i308r5j6w` (`roleid`);

--
-- Chỉ mục cho bảng `userinvoice`
--
ALTER TABLE `userinvoice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK2wkkao3b7ck06u0u7k8qsbohj` (`invoiceid`),
  ADD KEY `FKe76kg9h2itr13g828v8vi0q35` (`userid`);

--
-- Chỉ mục cho bảng `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vouchercode` (`vouchercode`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `invoice`
--
ALTER TABLE `invoice`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `invoicedetail`
--
ALTER TABLE `invoicedetail`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `milkbrand`
--
ALTER TABLE `milkbrand`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `milkdetail`
--
ALTER TABLE `milkdetail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID chi tiết sản phẩm sữa', AUTO_INCREMENT=1259;

--
-- AUTO_INCREMENT cho bảng `milktaste`
--
ALTER TABLE `milktaste`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `milktype`
--
ALTER TABLE `milktype`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `packagingunit`
--
ALTER TABLE `packagingunit`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `product`
--
ALTER TABLE `product`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `role`
--
ALTER TABLE `role`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `targetuser`
--
ALTER TABLE `targetuser`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `usagecapacity`
--
ALTER TABLE `usagecapacity`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT cho bảng `userinvoice`
--
ALTER TABLE `userinvoice`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `FK9m312ke5bnn971xu85ke1o4b9` FOREIGN KEY (`voucherid`) REFERENCES `voucher` (`id`);

--
-- Các ràng buộc cho bảng `invoicedetail`
--
ALTER TABLE `invoicedetail`
  ADD CONSTRAINT `FKt0mve2vv8ocb25b2779rqeksr` FOREIGN KEY (`invoiceid`) REFERENCES `invoice` (`id`);

--
-- Các ràng buộc cho bảng `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `FKbfce4hhuxsms1rbohhkv9jxb1` FOREIGN KEY (`targetuserid`) REFERENCES `targetuser` (`id`),
  ADD CONSTRAINT `FKitvnymfpm94v7bjovryk5ce4f` FOREIGN KEY (`milktypeid`) REFERENCES `milktype` (`id`),
  ADD CONSTRAINT `FKohgj0exerg0r9ygn0gr8074ed` FOREIGN KEY (`milkbrandid`) REFERENCES `milkbrand` (`id`);

--
-- Các ràng buộc cho bảng `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK2ovmsl4hvm5vu1w8i308r5j6w` FOREIGN KEY (`roleid`) REFERENCES `role` (`id`);

--
-- Các ràng buộc cho bảng `userinvoice`
--
ALTER TABLE `userinvoice`
  ADD CONSTRAINT `FK2wkkao3b7ck06u0u7k8qsbohj` FOREIGN KEY (`invoiceid`) REFERENCES `invoice` (`id`),
  ADD CONSTRAINT `FKe76kg9h2itr13g828v8vi0q35` FOREIGN KEY (`userid`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
