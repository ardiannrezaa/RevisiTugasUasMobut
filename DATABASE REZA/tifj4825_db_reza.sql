-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 27, 2026 at 01:54 PM
-- Server version: 10.11.15-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tifj4825_db_reza`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `created_at`) VALUES
(1, 'Tips memilih sepatu', 'Pilih sepatu sesuai ukuran kaki dan kebutuhan aktivitas.', '2026-01-13 12:59:29'),
(2, 'Cara merawat sepatu', 'Bersihkan rutin, simpan di tempat kering, gunakan silica gel.', '2026-01-13 12:59:29'),
(3, 'sdasdada', 'dasdadads', '2026-01-25 05:03:42');

-- --------------------------------------------------------

--
-- Table structure for table `shoes`
--

CREATE TABLE `shoes` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `brand` varchar(80) NOT NULL,
  `price` int(11) NOT NULL,
  `image_url` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `shoes`
--

INSERT INTO `shoes` (`id`, `name`, `brand`, `price`, `image_url`, `created_at`) VALUES
(1, 'Nike Air Zoom', 'Nike', 1200000, 'https://picsum.photos/seed/nike/300/300', '2026-01-13 12:59:29'),
(2, 'Adidas Ultraboost', 'Adidas', 1500000, 'https://picsum.photos/seed/adidas/300/300', '2026-01-13 12:59:29'),
(3, 'Converse Classic', 'Converse', 650000, 'https://picsum.photos/seed/converse/300/300', '2026-01-13 12:59:29'),
(4, 'fsdfsdf', 'sdfsdfsdf', 100000, 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/107/MTA-117749663/adidas_sepatu_adidas_superstar_xlg_if9995_full01_hrk6d4cy.jpg', '2026-01-25 05:03:24'),
(5, 'Kaneki', 'Adios', 145, 'https://down-id.img.susercontent.com/file/id-11134207-7r98u-lp3kxofuvzwaa1', '2026-01-25 07:16:48');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'reza', 'reza@gmail.com', '$2y$10$z6HtLKdqLtyO2PvR7u602.Oyetkib3S5gKH0oDQpyacwK2pHSU2oS', '2026-01-13 13:12:31'),
(2, 'reza', 'ardian@gmail.com', '$2y$10$Df0G0kfgLqJ8ZGSfhLHnpuEPqAnVzlqP4Psnzjwg1aA2OAygfBXFK', '2026-01-21 22:05:43'),
(3, 'test', 'testhhshs', '$2y$10$/Xk0uv1IT6S3h20eM1KS/.UqHz4o4I9c/ERgCOEA/zaH30U9ywKj2', '2026-01-22 14:07:55'),
(4, 'yudha', 'test@gmail.com', '$2y$10$MnnxSr/7nEip.4HB4sVBPegLtJrWxd/ZcwO06zsWmyHm7FixvDd6u', '2026-01-22 14:08:48'),
(5, 'reza', 'reza', '$2y$10$Wi2Z4ih86U0J0MJ1L3QMOOMW/sjILEDjW5c6e.xeUtrPF44re/6WW', '2026-01-22 14:59:49'),
(6, 'aswas', 'sawa', '$2y$10$2sDo639EuLVq8JpuLECSReRw8jmuMr207YKkhpNE0/qDglKLyHtEq', '2026-01-23 10:53:26'),
(7, 'sawa', 'sawak', '$2y$10$v75vBIsEyocvZXe2H1R0ceLCF9B94K1HTbY33YB8SOgPUbfMchAIC', '2026-01-23 11:04:35'),
(8, 'qweqweqwe', '@gmail.com', '$2y$10$pM9Oaz9S.QfdmDEhUthE4uNMdODzeZ9KSodqWHv3fe5EH/0c8KrxC', '2026-01-25 05:15:39'),
(9, 'sdfdsf', 'contoh@gmail.com', '$2y$10$uFeqDUFsOQCG6nEuS7dyKePRebVxkFsQRsQRi1ucNNJMz.dX4AZzW', '2026-01-25 05:20:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shoes`
--
ALTER TABLE `shoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `shoes`
--
ALTER TABLE `shoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
