-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 06, 2026 at 10:55 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lookinapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:1;', 1793959569),
('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1793959569;', 1793959569);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_requests`
--

CREATE TABLE `employee_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` enum('cuti','izin','sakit','lembur') COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `reviewed_by` bigint UNSIGNED DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `reviewer_note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_requests`
--

INSERT INTO `employee_requests` (`id`, `user_id`, `type`, `start_date`, `end_date`, `start_time`, `end_time`, `reason`, `status`, `reviewed_by`, `reviewed_at`, `reviewer_note`, `created_at`, `updated_at`) VALUES
(4, 3, 'sakit', '2026-11-03', '2026-11-04', NULL, NULL, 'Flu dan panas', 'pending', NULL, NULL, NULL, '2026-11-02 11:14:11', '2026-11-02 11:14:11'),
(5, 3, 'sakit', '2026-11-03', '2026-11-04', NULL, NULL, 'Mriang', 'pending', NULL, NULL, NULL, '2026-11-02 11:22:11', '2026-11-02 11:22:11');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_31_094130_create_personal_access_tokens_table', 1),
(5, '2026_10_31_100040_create_presensis_table', 1),
(6, '2026_10_31_120000_create_employee_requests_table', 1),
(7, '2026_10_31_120001_add_is_active_to_users_table', 1),
(8, '2026_10_31_120002_add_unique_attendance_per_day', 1),
(9, '2026_10_31_120003_make_attendance_photos_optional', 1),
(10, '2026_11_01_000000_add_face_enrollment_to_users_table', 1),
(11, '2026_11_01_010000_remove_face_enrollment_from_users_table', 1),
(12, '2026_11_06_160000_restore_legacy_user_and_attendance_fields', 2),
(13, '2026_11_02_220000_add_employee_profile_and_break_columns', 3);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '19dff3baa0b01aa09dbee90ed9ff01e9ad7fe4c4cac1c222d411006bfefd9a63', '[\"*\"]', NULL, NULL, '2026-10-31 05:19:25', '2026-10-31 05:19:25'),
(2, 'App\\Models\\User', 3, 'auth_token', 'c1fe5d612b258327dc8b240236173c04e99be45656a4c1774f7129268346bbc9', '[\"*\"]', NULL, NULL, '2026-10-31 05:20:52', '2026-10-31 05:20:52'),
(3, 'App\\Models\\User', 2, 'auth_token', '9ee825a11dc1586f0835dea9bc733c54fa0763b0430d15c4ff7e557fb7e8d1c5', '[\"*\"]', NULL, NULL, '2026-10-31 05:22:05', '2026-10-31 05:22:05'),
(4, 'App\\Models\\User', 3, 'auth_token', '59baa302d4a7f11ac9aa8bcfe6c58af6884046542dfe0b0559a44f940fd1dd1a', '[\"*\"]', NULL, NULL, '2026-10-31 05:24:38', '2026-10-31 05:24:38'),
(5, 'App\\Models\\User', 1, 'auth_token', '9c6a9927c4f9e161b220f015615a0e4cc46c083fe45150a23cbc41a3d54fbef7', '[\"*\"]', NULL, NULL, '2026-10-31 05:26:05', '2026-10-31 05:26:05'),
(6, 'App\\Models\\User', 3, 'auth_token', '7dcea7a2daffb11bf9b2bb5089df1a3fa0f5d93d90fe924ac963eee00d14b7f0', '[\"*\"]', NULL, NULL, '2026-10-31 05:29:31', '2026-10-31 05:29:31'),
(7, 'App\\Models\\User', 3, 'auth_token', '1cb4ca9eb5660250f35ce4436f5420510f925264010f265a31bce72d55db3a63', '[\"*\"]', '2026-10-31 12:49:08', NULL, '2026-10-31 12:49:05', '2026-10-31 12:49:08'),
(8, 'App\\Models\\User', 1, 'auth_token', 'fc1f547b625f3fbe3de9f280f21eb2e4142dae9d37aec8d40566101fa8da37f2', '[\"*\"]', '2026-10-31 12:56:26', NULL, '2026-10-31 12:56:14', '2026-10-31 12:56:26'),
(9, 'App\\Models\\User', 3, 'auth_token', '9c9b3d80696c9b1f698ee4eac50052dabf3ea6b1e450795f5c0569e41b6eab69', '[\"*\"]', '2026-10-31 13:02:12', NULL, '2026-10-31 13:01:45', '2026-10-31 13:02:12'),
(16, 'App\\Models\\User', 2, 'auth_token', '514c4e0279ea030cac4501536ac32fba3efb067479918eabbaf6c9314e3b411c', '[\"*\"]', '2026-10-31 13:35:05', NULL, '2026-10-31 13:34:46', '2026-10-31 13:35:05'),
(19, 'App\\Models\\User', 3, 'auth_token', '897aae3f44cce8618d212fce543f8de6c6e9de0cc87c4987432a4f53de06a47b', '[\"*\"]', '2026-10-31 15:53:22', NULL, '2026-10-31 15:48:17', '2026-10-31 15:53:22'),
(20, 'App\\Models\\User', 3, 'auth_token', '9fcf2969de23eb6d8dd9f679bd9f104c8b6be7b83cb7fb02ea161697f1dbde9c', '[\"*\"]', '2026-10-31 16:31:45', NULL, '2026-10-31 16:19:23', '2026-10-31 16:31:45'),
(21, 'App\\Models\\User', 3, 'auth_token', 'b12a19b8ec7d750fe0423db192954be6ee38dd2b87f6c472a7bfc6f0e0e4b4e8', '[\"*\"]', '2026-10-31 17:58:26', NULL, '2026-10-31 16:53:13', '2026-10-31 17:58:26'),
(22, 'App\\Models\\User', 3, 'auth_token', '9f63e08279d01c266398f0e7e3bb828618832285486418057b00302bb2185661', '[\"*\"]', '2026-10-31 18:20:08', NULL, '2026-10-31 18:19:44', '2026-10-31 18:20:08'),
(24, 'App\\Models\\User', 2, 'auth_token', '33034a743ff22e71d7d42380d4911ab19e13ecd423e772e67a6002d639b99506', '[\"*\"]', '2026-10-31 18:26:33', NULL, '2026-10-31 18:26:30', '2026-10-31 18:26:33'),
(37, 'App\\Models\\User', 3, 'auth_token', '0f87b7ca4d85350abab6d921fbb943df8a6122c6f33b675cfcb5fc7f9324785a', '[\"*\"]', '2026-11-02 15:53:45', NULL, '2026-11-02 15:53:41', '2026-11-02 15:53:45'),
(38, 'App\\Models\\User', 3, 'auth_token', '54c1781d88fb0bbd47b867179e66a735d531be6c4df80790f0b6fa0cf3c18e97', '[\"*\"]', '2026-11-06 00:48:34', NULL, '2026-11-06 00:48:29', '2026-11-06 00:48:34'),
(39, 'App\\Models\\User', 3, 'auth_token', 'd40672115937a7fd2ae7eaf866abd9beff3fd00f66af4b2f2f38da42b082b162', '[\"*\"]', '2026-11-06 07:47:54', NULL, '2026-11-06 07:46:31', '2026-11-06 07:47:54'),
(41, 'App\\Models\\User', 3, 'auth_token', 'df720370ff74c43bd9663dd1a7265e455f4a0cc804abce8598bcea6b3d7065dd', '[\"*\"]', '2026-11-06 08:48:53', NULL, '2026-11-06 08:48:49', '2026-11-06 08:48:53'),
(43, 'App\\Models\\User', 3, 'auth_token', 'cd1b0cae4e46139c22aface1fe96b0bdb828dc4cbdbf0b8dbb2e0277e4264137', '[\"*\"]', '2026-11-06 09:05:52', NULL, '2026-11-06 09:05:45', '2026-11-06 09:05:52'),
(44, 'App\\Models\\User', 7, 'auth_token', '9f86b5e85247f94d6155eb2e60d961ca9e916b764d9e375828e56448ef5d50f8', '[\"*\"]', '2026-11-06 10:01:33', NULL, '2026-11-06 09:59:42', '2026-11-06 10:01:33'),
(46, 'App\\Models\\User', 7, 'auth_token', '6a5a9c2c9af607d3cedb1230b6959654bbb175ba9d94bd19d372afc7bc7c5eb8', '[\"*\"]', '2026-11-06 10:32:21', NULL, '2026-11-06 10:32:16', '2026-11-06 10:32:21');

-- --------------------------------------------------------

--
-- Table structure for table `presensis`
--

CREATE TABLE `presensis` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `jam_masuk` time NOT NULL,
  `foto_masuk` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jam_pulang` time DEFAULT NULL,
  `foto_pulang` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bekerja',
  `jam_mulai_istirahat` time DEFAULT NULL,
  `jam_selesai_istirahat` time DEFAULT NULL,
  `total_istirahat_detik` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `presensis`
--

INSERT INTO `presensis` (`id`, `user_id`, `tanggal`, `jam_masuk`, `foto_masuk`, `jam_pulang`, `foto_pulang`, `created_at`, `updated_at`, `status`, `jam_mulai_istirahat`, `jam_selesai_istirahat`, `total_istirahat_detik`) VALUES
(6, 3, '2026-11-02', '18:09:41', NULL, '18:09:49', NULL, '2026-11-02 11:09:41', '2026-11-02 11:09:49', 'bekerja', NULL, NULL, 0),
(7, 4, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:20', '2026-11-02 15:16:20', 'bekerja', NULL, NULL, 0),
(8, 5, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:20', '2026-11-02 15:16:20', 'bekerja', NULL, NULL, 0),
(9, 6, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:21', '2026-11-02 15:16:21', 'bekerja', NULL, NULL, 0),
(10, 10, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:22', '2026-11-02 15:16:22', 'bekerja', NULL, NULL, 0),
(11, 12, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:22', '2026-11-02 15:16:22', 'bekerja', NULL, NULL, 0),
(12, 13, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:23', '2026-11-02 15:16:23', 'bekerja', NULL, NULL, 0),
(13, 14, '2026-11-02', '08:00:00', 'presensi/sample.jpg', NULL, NULL, '2026-11-02 15:16:23', '2026-11-02 15:16:23', 'bekerja', NULL, NULL, 0),
(14, 1, '2026-11-03', '12:56:41', NULL, '12:57:10', NULL, '2026-11-03 05:56:41', '2026-11-03 05:57:10', 'selesai', '12:57:02', '12:57:07', 0),
(15, 3, '2026-11-06', '14:46:40', NULL, '14:46:45', NULL, '2026-11-06 07:46:40', '2026-11-06 07:46:45', 'bekerja', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('H7r4d9c9c1ILsv5TwXoK7bhAtFLFW3CBs09KSzHD', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.142.0 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', 'eyJfdG9rZW4iOiJkZGxSRE5TZ2Y1UFhRWFd6UTJ2Y0tOUnZtb01yY052dklLbDdkT3pEIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9hZG1pbiIsInJvdXRlIjoiYWRtaW4uZGFzaGJvYXJkIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjEsInBhc3N3b3JkX2hhc2hfd2ViIjoiODA4ZDQ2OWZmNDliOGJiYTlkOGU2MzE2MTJlYmJmNDkyZmIyYmRhYTk4NDA0NDEwMWEwZGIxOTRhMjczZGQzYyJ9', 1793959511);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','hrd','karyawan') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'karyawan',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `employee_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `division` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `gender` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `joined_date` date DEFAULT NULL,
  `shift_time` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `branch` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_depan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_samping_kiri` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_samping_kanan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_menunduk` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `face_menengadah` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`, `is_active`, `employee_id`, `phone`, `division`, `position`, `address`, `gender`, `birth_date`, `joined_date`, `shift_time`, `branch`, `avatar`, `face_depan`, `face_samping_kiri`, `face_samping_kanan`, `face_menunduk`, `face_menengadah`) VALUES
(1, 'Jane Cooper', 'admin@lookin.com', NULL, '$2y$12$W4/.5uilGFhWoMKN85a9lefoHzMVQhshvr7aJHa8IdL.Xidcc2tuC', 'admin', NULL, '2026-10-31 05:03:20', '2026-11-02 15:47:21', 1, '20210000', '0987654321', 'Manajemen', 'UI/UX DESIGNER', '534 Spear Street San Francisco, CA 94105 United States', 'Laki-Laki', '1997-01-06', '2020-06-25', '10:00:59 - 19:00:59', 'Hyderabad', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'HRD LookIn', 'hrd@lookin.com', NULL, '$2y$12$UozACGwXbazuHTG17FYmjuM/ShSsgT9WOyX1vO3Zov7g9ZhODMk92', 'hrd', NULL, '2026-10-31 05:03:20', '2026-11-02 15:47:21', 1, 'HR-001', '081122334455', 'Human Resources', 'HR Manager', 'Jakarta Selatan', 'Perempuan', '1992-05-14', '2021-01-10', '08:00:00 - 17:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Khanza Nibras', 'karyawan@lookin.com', NULL, '$2y$12$Av2KE7OJbfSyrLwMd9Q0Le2NwjgjJPuCmDIfD8TEjznMowFGWtyy2', 'karyawan', NULL, '2026-10-31 05:03:20', '2026-11-02 15:47:22', 1, 'K-002', '081345678912', 'Divisi Desain', 'UI/UX Designer', 'Yogyakarta', 'Perempuan', '2000-02-18', '2023-01-10', '09:00:00 - 18:00:00', 'Yogyakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'Aldo Saputra', 'mas@example.com', NULL, '$2y$12$txWfhQ5dxukac4PriHrF..GOV7jqc3EVNCbcLmdq1OSlyjPtS/uLy', 'karyawan', NULL, '2026-11-02 15:16:20', '2026-11-03 05:53:06', 1, 'K-086', '081234567890', 'Divisi IT', 'Programmer', 'Solo', 'Laki-Laki', '1998-03-22', '2022-03-01', '08:00:00 - 17:00:00', 'Solo', NULL, 'faces/xUdKZYLWG3DWeQXMj3nXVwUf8FC2dKLlbtxxIJ3G.png', NULL, NULL, NULL, NULL),
(5, 'Mochammad Elang', 'elang@example.com', NULL, '$2y$12$OT7KOVWFwdFFbSlFb7TnsuGuMVNSP9wHZjhEZ9ELgprYnkakhYysW', 'karyawan', NULL, '2026-11-02 15:16:20', '2026-11-02 15:47:22', 1, 'K-001', '081298765431', 'Divisi Operasional', 'Staff Operasional', 'Semarang', 'Laki-Laki', '1999-07-15', '2022-06-15', '08:00:00 - 17:00:00', 'Semarang', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 'Nallenaya Ilham', 'ilham@example.com', NULL, '$2y$12$NX1hK3aPIAUlde8eMFFcGulwJnzjXgzfs98k.4.rnEwL9H5dL5Q4a', 'karyawan', NULL, '2026-11-02 15:16:21', '2026-11-02 15:47:22', 1, 'K-003', '081398761234', 'Divisi IT', 'Mobile Developer', 'Bandung', 'Laki-Laki', '1997-11-20', '2021-08-01', '08:00:00 - 17:00:00', 'Bandung', NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'Mohamad Rahmat', 'rahmat@example.com', NULL, '$2y$12$F3aUro5/gFzTy2jGYNT/SOfXbiAGiRhnW4vRWU5JCq8TUiRRY95dW', 'karyawan', NULL, '2026-11-02 15:16:21', '2026-11-02 15:47:22', 1, 'K-004', '081277665544', 'Divisi HRD', 'Recruiter', 'Surabaya', 'Laki-Laki', '1995-09-09', '2020-11-15', '08:00:00 - 17:00:00', 'Surabaya', NULL, NULL, NULL, NULL, NULL, NULL),
(8, 'Faudhan Adzin', 'faudhan@example.com', NULL, '$2y$12$5DxRlta/x97HkubaKdEajuuqRjpG1L4VPKk.NMBjfBNqEJ/K1lhue', 'karyawan', NULL, '2026-11-02 15:16:21', '2026-11-02 15:47:22', 1, 'K-005', '081266554433', 'Divisi Marketing', 'SEO Specialist', 'Jakarta Barat', 'Laki-Laki', '1996-04-12', '2022-01-20', '09:00:00 - 18:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(9, 'Ireng gendeng', 'ireng@example.com', NULL, '$2y$12$EH7z/j12jyPZDk9adpiAD.KQuRjnmeIXgbExaN3gs/WSw5c/P5bii', 'karyawan', NULL, '2026-11-02 15:16:22', '2026-11-02 15:47:23', 1, 'K-006', '081255443322', 'Divisi Keuangan', 'Akuntan', 'Solo', 'Laki-Laki', '1994-12-05', '2019-09-01', '08:00:00 - 17:00:00', 'Solo', NULL, NULL, NULL, NULL, NULL, NULL),
(10, 'Andi Saputra', 'andi@example.com', NULL, '$2y$12$uLiEQnU7ziXpTnZ6RyqLquSfmvhvGS3ce2FSRDj.Dz9iebXfjG6KK', 'karyawan', NULL, '2026-11-02 15:16:22', '2026-11-06 08:51:39', 1, 'KRY001', '081211223344', 'Divisi IT', 'Backend Developer', 'Jakarta Selatan', 'Laki-Laki', '1996-08-10', '2021-04-01', '08:00:00 - 17:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'Budi Santoso', 'budi@example.com', NULL, '$2y$12$Nrk2UregphJ6EC.wRCLu1OBnoNFkDM7unWGsffIxRNTH27p41jCma', 'karyawan', NULL, '2026-11-02 15:16:22', '2026-11-02 15:47:23', 1, 'KRY002', '081233445566', 'Divisi Operasional', 'Field Officer', 'Tangerang', 'Laki-Laki', '1993-10-30', '2020-02-15', '08:00:00 - 17:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(12, 'Yogi Prasetyo', 'yogi@example.com', NULL, '$2y$12$FpwOhheeIzZeUSN0eAk0UuzPpwPt6zymGC.oAzZsFnig1Bs2v.wUO', 'karyawan', NULL, '2026-11-02 15:16:22', '2026-11-02 15:47:23', 1, 'K-008', '081244556677', 'Divisi Marketing', 'Content Creator', 'Malang', 'Laki-Laki', '2001-01-25', '2023-05-01', '09:00:00 - 18:00:00', 'Surabaya', NULL, NULL, NULL, NULL, NULL, NULL),
(13, 'Arifin Pratama', 'arifin@example.com', NULL, '$2y$12$k3o4KZ6g4IitaIDf7//uhudAkXL0hKGlnUU912x3A9C1Drc40zaGe', 'karyawan', NULL, '2026-11-02 15:16:23', '2026-11-02 15:47:23', 1, 'K-009', '081255667788', 'Divisi IT', 'Quality Assurance', 'Bogor', 'Laki-Laki', '1997-06-14', '2022-07-01', '08:00:00 - 17:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'Bayu Nugroho', 'bayu@example.com', NULL, '$2y$12$GeUjrBVxlTkxpgbVUnD7hOzlXZA0r32.3iflwwBq1OnDvD0IJKY.S', 'karyawan', NULL, '2026-11-02 15:16:23', '2026-11-02 15:47:24', 1, 'K-010', '081266778899', 'Divisi Logistik', 'Inventory Specialist', 'Bekasi', 'Laki-Laki', '1995-03-19', '2021-10-10', '08:00:00 - 17:00:00', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL),
(15, 'iejriji', 'jrjtirj@gmail.com', NULL, '$2y$12$xZaXQ8aaNKXjp/vOjQSODuY7n5JCQKelM9KjaqRA2TYijed7FZjzm', 'karyawan', NULL, '2026-11-03 06:05:25', '2026-11-03 06:05:25', 1, 'K-915', '08947483782', 'Divisi IT', 'Programmer', 'Jalan Randu Alas RT 04 RW 09', NULL, NULL, '2026-11-03', '08:00:00 - 17:00:00', NULL, NULL, 'assets/design/face-depan.png', 'assets/design/face-samping-kiri.png', 'assets/design/face-samping-kanan.png', 'assets/design/face-menunduk.png', 'assets/design/face-menengadah.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `employee_requests`
--
ALTER TABLE `employee_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_requests_reviewed_by_foreign` (`reviewed_by`),
  ADD KEY `employee_requests_status_created_at_index` (`status`,`created_at`),
  ADD KEY `employee_requests_user_id_start_date_index` (`user_id`,`start_date`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `presensis`
--
ALTER TABLE `presensis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `presensis_user_id_tanggal_unique` (`user_id`,`tanggal`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `employee_requests`
--
ALTER TABLE `employee_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `presensis`
--
ALTER TABLE `presensis`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employee_requests`
--
ALTER TABLE `employee_requests`
  ADD CONSTRAINT `employee_requests_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `employee_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `presensis`
--
ALTER TABLE `presensis`
  ADD CONSTRAINT `presensis_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
