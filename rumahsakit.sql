-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 09, 2021 at 07:17 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rumahsakit`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BiayaObatBima` (OUT `totalbiaya` INT)  NO SQL
BEGIN
SELECT SUM(billing.TOTAL_TRANSAKSI) INTO totalbiaya
FROM billing
JOIN registrasi ON billing.ID_REGISTRASI = registrasi.ID_REGISTRASI
JOIN pasien ON registrasi.ID_PASIEN = pasien.ID_PASIEN
WHERE pasien.NAMA_PASIEN='Bima Reynaldi S';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDataDokter` (IN `Spesialisasi` VARCHAR(50))  BEGIN
SELECT dokter.ID_DOKTER, dokter.NAMA_DOKTER, dokter.HP_DOKTER
FROM dokter
WHERE dokter.SPESIALIS_DOKTER = Spesialisasi;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDiagnosaPasien` (IN `DiagnosaPasien` VARCHAR(100))  BEGIN
SELECT dokter.NAMA_DOKTER, dokter.SPESIALIS_DOKTER, perawat.NAMA_PERAWAT, pasien.NAMA_PASIEN
FROM dokter
JOIN registrasi ON registrasi.ID_DOKTER = dokter.ID_DOKTER
JOIN pasien ON pasien.ID_PASIEN = registrasi.ID_PASIEN
JOIN perawat ON perawat.ID_PERAWAT = registrasi.ID_PERAWAT
WHERE registrasi.DIAGNOSA = DiagnosaPasien
ORDER BY registrasi.TGL_REGISTRASI;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDokterPasien` (IN `tgl_regis` DATE)  BEGIN
SELECT registrasi.ID_DOKTER, dokter.NAMA_DOKTER, registrasi.ID_PASIEN, pasien.NAMA_PASIEN
FROM dokter, pasien, registrasi
WHERE dokter.ID_DOKTER = registrasi.ID_DOKTER AND pasien.ID_PASIEN = registrasi.ID_PASIEN
AND registrasi.TGL_REGISTRASI = tgl_regis;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetObatBeli` (IN `NamaObat` VARCHAR(50), OUT `total` INT)  BEGIN
SELECT COUNT(detail_obat.ID_BILLING) INTO total
FROM detail_obat
JOIN obat ON obat.ID_OBAT = detail_obat.ID_OBAT
JOIN billing ON billing.ID_BILLING = detail_obat.ID_BILLING
AND NamaObat = obat.NAMA_OBAT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getObatExp2021` (IN `TglExp` DATE, OUT `total` INT(11))  BEGIN
SELECT obat.NAMA_OBAT, COUNT(obat.STOK) INTO total
FROM obat
WHERE YEAR(obat.tgl_exp) = TglExp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetObatPasien` (INOUT `nama_obat` VARCHAR(40), IN `TanggalRegis` DATE)  NO SQL
BEGIN
SELECT pasien.NAMA_PASIEN from registrasi
join pasien on pasien.ID_PASIEN=registrasi.ID_PASIEN
JOIN billing on billing.ID_BILLING=registrasi.ID_BILLING
JOIN detail_obat on detail_obat.ID_BILLING=billing.ID_BILLING
JOIN obat ON obat.ID_OBAT=detail_obat.ID_OBAT
WHERE obat.NAMA_OBAT=nama_obat
AND registrasi.TGL_REGISTRASI = TanggalRegis;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasienRegistrasi` (IN `NamaPasien` VARCHAR(50), IN `TanggalRegis` DATE)  BEGIN
SELECT registrasi.ID_PASIEN, pasien.NAMA_PASIEN, registrasi.ID_REGISTRASI, billing.TOTAL_TRANSAKSI, registrasi.TGL_REGISTRASI
FROM registrasi, pasien, billing
WHERE registrasi.ID_REGISTRASI = billing.ID_REGISTRASI
AND registrasi.ID_PASIEN = pasien.ID_PASIEN
AND registrasi.TGL_REGISTRASI = TanggalRegis
AND pasien.NAMA_PASIEN = NamaPasien;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTanggalKelas` (INOUT `tipekelas` VARCHAR(15))  BEGIN
SELECT pasien.NAMA_PASIEN, kamar.KAMAR, kelas.KELAS, registrasi.TGL_REGISTRASI FROM registrasi
JOIN pasien ON pasien.ID_PASIEN=registrasi.ID_PASIEN
JOIN kamar ON kamar.ID_KAMAR=registrasi.ID_KAMAR
JOIN kelas ON kelas.ID_KELAS=kamar.ID_KELAS
WHERE kelas.KELAS=tipekelas AND registrasi.TGL_REGISTRASI BETWEEN '2018-08-01' AND '2018-12-31'
GROUP BY pasien.NAMA_PASIEN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `JmlPasienPerawat` (INOUT `NamaPerawat` VARCHAR(50))  NO SQL
BEGIN
SELECT COUNT(pasien.NAMA_PASIEN) as TOTAL FROM registrasi 
JOIN pasien ON pasien.ID_PASIEN=registrasi.ID_PASIEN
JOIN perawat ON perawat.ID_PERAWAT=registrasi.ID_PERAWAT
WHERE NamaPerawat=perawat.NAMA_PERAWAT
AND YEAR(registrasi.TGL_REGISTRASI)='2018';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Jumlah_Pasien_Ramadhan` ()  NO SQL
SELECT COUNT(pasien.NAMA_PASIEN) as TOTAL FROM registrasi
JOIN pasien ON pasien.ID_PASIEN = registrasi.ID_PASIEN
JOIN dokter ON dokter.ID_DOKTER = registrasi.ID_DOKTER
WHERE dokter.NAMA_DOKTER = 'Ramadhan Giri M'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PasienKamarSept` ()  NO SQL
BEGIN
SELECT pasien.NAMA_PASIEN, kamar.KAMAR, registrasi.TGL_REGISTRASI FROM registrasi
JOIN pasien ON pasien.ID_PASIEN=registrasi.ID_PASIEN
JOIN kamar ON kamar.ID_KAMAR=registrasi.ID_KAMAR
WHERE YEAR(registrasi.TGL_REGISTRASI)='2018'
AND MONTH(registrasi.TGL_REGISTRASI)='09'
GROUP BY kamar.KAMAR;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `ID_BILLING` varchar(15) NOT NULL,
  `ID_REGISTRASI` varchar(15) DEFAULT NULL,
  `ID_PEGAWAI` varchar(15) DEFAULT NULL,
  `TOTAL_TRANSAKSI` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`ID_BILLING`, `ID_REGISTRASI`, `ID_PEGAWAI`, `TOTAL_TRANSAKSI`) VALUES
('BL001', 'RS001', 'PG001', 4000),
('BL002', 'RS002', 'PG001', 15000),
('BL003', 'RS003', 'PG002', 7000),
('BL004', 'RS004', 'PG002', 9000),
('BL005', 'RS005', 'PG003', 11000),
('BL006', 'RS006', 'PG004', 12000),
('BL007', 'RS007', 'PG005', 15000),
('BL008', 'RS008', 'PG003', 20000),
('BL009', 'RS009', 'PG004', 25000),
('BL010', 'RS010', 'PG003', 30000),
('BL011', 'RS011', 'PG002', 28000),
('BL012', 'RS012', 'PG001', 30000),
('BL013', 'RS013', 'PG004', 17000),
('BL014', 'RS014', 'PG005', 19000),
('BL015', 'RS015', 'PG002', 20000);

-- --------------------------------------------------------

--
-- Table structure for table `detail_obat`
--

CREATE TABLE `detail_obat` (
  `ID_BILLING` varchar(15) NOT NULL,
  `ID_OBAT` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_obat`
--

INSERT INTO `detail_obat` (`ID_BILLING`, `ID_OBAT`) VALUES
('BL001', 'OB001'),
('BL002', 'OB001'),
('BL003', 'OB002'),
('BL004', 'OB002'),
('BL005', 'OB001'),
('BL006', 'OB002'),
('BL007', 'OB002'),
('BL008', 'OB002'),
('BL009', 'OB001'),
('BL010', 'OB002'),
('BL011', 'OB001'),
('BL012', 'OB001'),
('BL013', 'OB001'),
('BL014', 'OB002'),
('BL015', 'OB002');

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `ID_BILLING` varchar(15) NOT NULL,
  `ID_TRANSAKSI` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`ID_BILLING`, `ID_TRANSAKSI`) VALUES
('BL001', 'TS001'),
('BL002', 'TS002'),
('BL003', 'TS003'),
('BL004', 'TS004'),
('BL005', 'TS005'),
('BL006', 'TS006'),
('BL007', 'TS007');

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `ID_DOKTER` varchar(15) NOT NULL,
  `NAMA_DOKTER` varchar(50) DEFAULT NULL,
  `SPESIALIS_DOKTER` varchar(50) NOT NULL,
  `ALAMAT_DOKTER` varchar(50) DEFAULT NULL,
  `HP_DOKTER` varchar(15) DEFAULT NULL,
  `tahun_awal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`ID_DOKTER`, `NAMA_DOKTER`, `SPESIALIS_DOKTER`, `ALAMAT_DOKTER`, `HP_DOKTER`, `tahun_awal`) VALUES
('DK001', 'Ade Ramadhana', 'Radiologi', 'Jalan Cakalang 172 E', '083835533001', '2017-12-10'),
('DK002', 'M Fauzan Akbar', '', 'Perum Bumi Banjararum', '08123421213', '2018-07-05'),
('DK003', 'Ramadhan Giri M', '', 'Jalan Batu 232', '0821321431123', '2015-03-12'),
('DK004', 'M Iqbal Ramadhan', 'Penyakit Dalam', 'Jalan Candi 23', '08123213765', '2017-06-28'),
('DK005', 'Aldo Farros Y R', 'Umum', 'Perum Blimbing Indah', '08923612897', '2016-05-05'),
('DK006', 'Marcellino Sebastian', 'Mata', 'Jl. Sigura Gura', '089301958610', '2020-10-03');

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `ID_KAMAR` varchar(15) NOT NULL,
  `ID_KELAS` varchar(15) DEFAULT NULL,
  `KAMAR` varchar(50) DEFAULT NULL,
  `STAT_KAMAR` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`ID_KAMAR`, `ID_KELAS`, `KAMAR`, `STAT_KAMAR`) VALUES
('KM001', 'KS001', 'Mawar', 'Kosong'),
('KM002', 'KS002', 'Melati', 'Kosong'),
('KM003', 'KS003', 'Anggrek', 'Kosong'),
('KM004', 'KS004', 'Kamboja', 'Kosong'),
('KM005', 'KS005', 'Lili', 'Kosong'),
('KM006', 'KS001', 'Sepatu', 'Kosong'),
('KM007', 'KS001', 'Matahari', 'Kosong');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `ID_KELAS` varchar(15) NOT NULL,
  `KELAS` varchar(50) DEFAULT NULL,
  `HRG_KELAS` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`ID_KELAS`, `KELAS`, `HRG_KELAS`) VALUES
('KS001', 'VIP', 1500000),
('KS002', 'VVIP', 2000000),
('KS003', 'Standar', 500000),
('KS004', 'Regular', 250000),
('KS005', 'Ekonomi', 100000);

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `ID_OBAT` varchar(15) NOT NULL,
  `NAMA_OBAT` varchar(50) DEFAULT NULL,
  `STOK` int(11) DEFAULT NULL,
  `HRG_OBAT` int(11) DEFAULT NULL,
  `tgl_exp` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`ID_OBAT`, `NAMA_OBAT`, `STOK`, `HRG_OBAT`, `tgl_exp`) VALUES
('OB001', 'Paracetamol', 10, 15000, '2022-10-12'),
('OB002', 'Insida', 20, 5000, '2021-02-04'),
('OB003', 'ASPIRIN', 11, 7000, '2021-10-04');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `ID_PASIEN` varchar(15) NOT NULL,
  `NAMA_PASIEN` varchar(50) DEFAULT NULL,
  `ALAMAT_PASIEN` varchar(50) DEFAULT NULL,
  `HP_PAS` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`ID_PASIEN`, `NAMA_PASIEN`, `ALAMAT_PASIEN`, `HP_PAS`) VALUES
('PS001', 'Alivia Yurika P', 'Jalan Mawar 104', '08231321321'),
('PS002', 'Ananda Farhan R', 'Jalan Dirgantara V blok F', '08123409990'),
('PS003', 'Alvian Pratama Putra P', 'Jalan Dirgantara IV ', '082345123213'),
('PS004', 'Bima Reynaldi S', 'Ngijo Karangploso', '08575512131'),
('PS005', 'Ardhian Tri P', 'Jalan Sudimoro 17', '087214632189');

-- --------------------------------------------------------

--
-- Table structure for table `pegawai`
--

CREATE TABLE `pegawai` (
  `ID_PEGAWAI` varchar(15) NOT NULL,
  `NAMA_PEGAWAI` varchar(50) DEFAULT NULL,
  `ALAMAT_PEGAWAI` varchar(50) DEFAULT NULL,
  `HP_PEG` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pegawai`
--

INSERT INTO `pegawai` (`ID_PEGAWAI`, `NAMA_PEGAWAI`, `ALAMAT_PEGAWAI`, `HP_PEG`) VALUES
('PG001', 'Yorikho', 'Jalan Blimbing Indah', '08121212322'),
('PG002', 'Dewangga', 'SIngosari', '08321312312'),
('PG003', 'Bima', 'Jalan Valencia 5', '081249513134'),
('PG004', 'Maulana', 'Singosari', '0818789213'),
('PG005', 'Gamma', 'Jalan Soekarno Hatta', '089321877876');

-- --------------------------------------------------------

--
-- Table structure for table `perawat`
--

CREATE TABLE `perawat` (
  `ID_PERAWAT` varchar(15) NOT NULL,
  `NAMA_PERAWAT` varchar(50) DEFAULT NULL,
  `ALAMAT_PERAWAT` varchar(50) DEFAULT NULL,
  `HP_PER` varchar(15) DEFAULT NULL,
  `tahun_awal` date NOT NULL,
  `berhenti_kerja` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `perawat`
--

INSERT INTO `perawat` (`ID_PERAWAT`, `NAMA_PERAWAT`, `ALAMAT_PERAWAT`, `HP_PER`, `tahun_awal`, `berhenti_kerja`) VALUES
('PR001', 'Farah Prasetia B', 'Jalan LA Sucipto', '082123321213', '2017-12-25', '2020-02-28'),
('PR002', 'Anggi Fitria', 'Putuk', '089217i13788', '2017-05-12', '2022-06-12'),
('PR003', 'Annisatuz Z', 'SIngosari', '08123678900', '2018-03-25', '2021-06-07'),
('PR004', 'Fadilla Iftita H', 'Singosari', '089123732213', '2018-12-20', '2023-05-10'),
('PR005', 'Dian Kartini N P', 'SIngosari', '089233213689', '2019-01-30', '2020-10-29');

-- --------------------------------------------------------

--
-- Table structure for table `registrasi`
--

CREATE TABLE `registrasi` (
  `ID_REGISTRASI` varchar(15) NOT NULL,
  `ID_BILLING` varchar(15) DEFAULT NULL,
  `ID_KAMAR` varchar(15) DEFAULT NULL,
  `ID_DOKTER` varchar(15) DEFAULT NULL,
  `ID_PERAWAT` varchar(15) DEFAULT NULL,
  `ID_PASIEN` varchar(15) DEFAULT NULL,
  `ID_PEGAWAI` varchar(15) DEFAULT NULL,
  `DIAGNOSA` varchar(100) NOT NULL,
  `TGL_REGISTRASI` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `registrasi`
--

INSERT INTO `registrasi` (`ID_REGISTRASI`, `ID_BILLING`, `ID_KAMAR`, `ID_DOKTER`, `ID_PERAWAT`, `ID_PASIEN`, `ID_PEGAWAI`, `DIAGNOSA`, `TGL_REGISTRASI`) VALUES
('RS001', 'BL001', 'KM001', 'DK001', 'PR001', 'PS001', 'PG001', 'Demam', '2018-10-04'),
('RS002', 'BL002', 'KM001', 'DK001', 'PR001', 'PS005', 'PG001', 'Batuk', '2018-09-05'),
('RS003', 'BL003', 'KM002', 'DK002', 'PR002', 'PS002', 'PG002', 'Tipes', '2018-09-06'),
('RS004', 'BL004', 'KM003', 'DK003', 'PR003', 'PS003', 'PG003', 'Flu', '2018-09-09'),
('RS005', 'BL005', 'KM004', 'DK004', 'PR004', 'PS004', 'PG004', 'DBD', '2018-09-07'),
('RS006', 'BL006', 'KM005', 'DK005', 'PR005', 'PS003', 'PG005', 'Diare', '2018-10-09'),
('RS007', 'BL007', 'KM003', 'DK003', 'PR003', 'PS004', 'PG003', 'Radang', '2018-09-11'),
('RS008', 'BL008', 'KM004', 'DK003', 'PR004', 'PS005', 'PG004', 'Batuk', '2018-09-26'),
('RS009', 'BL009', 'KM006', 'DK005', 'PR001', 'PS003', 'PG002', 'DBD', '2018-09-26'),
('RS010', 'BL010', 'KM005', 'DK003', 'PR004', 'PS004', 'PG004', 'Tipes', '2018-08-06'),
('RS011', 'BL011', 'KM006', 'DK005', 'PR004', 'PS002', 'PG002', 'Diare', '2018-08-06'),
('RS012', 'BL012', 'KM004', 'DK003', 'PR004', 'PS002', 'PG003', 'Demam', '2018-10-08'),
('RS013', 'BL013', 'KM005', 'DK004', 'PR003', 'PS003', 'PG003', 'Batuk', '2018-09-13'),
('RS014', 'BL014', 'KM001', 'DK004', 'PR002', 'PS001', 'PG005', 'Diare', '2018-08-10'),
('RS015', 'BL015', 'KM007', 'DK005', 'PR005', 'PS002', 'PG003', 'Pusing', '2018-08-22');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `ID_TRANSAKSI` varchar(15) NOT NULL,
  `TGL_TRANS` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`ID_TRANSAKSI`, `TGL_TRANS`) VALUES
('TS001', '2018-09-11'),
('TS002', '2018-09-11'),
('TS003', '2018-09-11'),
('TS004', '2018-09-11'),
('TS005', '2018-09-11'),
('TS006', '2018-09-11'),
('TS007', '2018-09-11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`ID_BILLING`),
  ADD KEY `FK_RELATIONSHIP_13` (`ID_PEGAWAI`),
  ADD KEY `FK_RELATIONSHIP_8` (`ID_REGISTRASI`);

--
-- Indexes for table `detail_obat`
--
ALTER TABLE `detail_obat`
  ADD PRIMARY KEY (`ID_BILLING`,`ID_OBAT`),
  ADD KEY `FK_RELATIONSHIP_12` (`ID_OBAT`);

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`ID_BILLING`,`ID_TRANSAKSI`),
  ADD KEY `FK_RELATIONSHIP_10` (`ID_TRANSAKSI`);

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`ID_DOKTER`);

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`ID_KAMAR`),
  ADD KEY `FK_RELATIONSHIP_1` (`ID_KELAS`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`ID_KELAS`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`ID_OBAT`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`ID_PASIEN`);

--
-- Indexes for table `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`ID_PEGAWAI`);

--
-- Indexes for table `perawat`
--
ALTER TABLE `perawat`
  ADD PRIMARY KEY (`ID_PERAWAT`);

--
-- Indexes for table `registrasi`
--
ALTER TABLE `registrasi`
  ADD PRIMARY KEY (`ID_REGISTRASI`),
  ADD KEY `FK_RELATIONSHIP_2` (`ID_PEGAWAI`),
  ADD KEY `FK_RELATIONSHIP_3` (`ID_KAMAR`),
  ADD KEY `FK_RELATIONSHIP_4` (`ID_DOKTER`),
  ADD KEY `FK_RELATIONSHIP_5` (`ID_PERAWAT`),
  ADD KEY `FK_RELATIONSHIP_6` (`ID_PASIEN`),
  ADD KEY `FK_RELATIONSHIP_7` (`ID_BILLING`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`ID_TRANSAKSI`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `FK_RELATIONSHIP_13` FOREIGN KEY (`ID_PEGAWAI`) REFERENCES `pegawai` (`ID_PEGAWAI`),
  ADD CONSTRAINT `FK_RELATIONSHIP_8` FOREIGN KEY (`ID_REGISTRASI`) REFERENCES `registrasi` (`ID_REGISTRASI`);

--
-- Constraints for table `detail_obat`
--
ALTER TABLE `detail_obat`
  ADD CONSTRAINT `FK_RELATIONSHIP_11` FOREIGN KEY (`ID_BILLING`) REFERENCES `billing` (`ID_BILLING`),
  ADD CONSTRAINT `FK_RELATIONSHIP_12` FOREIGN KEY (`ID_OBAT`) REFERENCES `obat` (`ID_OBAT`);

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `FK_RELATIONSHIP_10` FOREIGN KEY (`ID_TRANSAKSI`) REFERENCES `transaksi` (`ID_TRANSAKSI`),
  ADD CONSTRAINT `FK_RELATIONSHIP_9` FOREIGN KEY (`ID_BILLING`) REFERENCES `billing` (`ID_BILLING`);

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `FK_RELATIONSHIP_1` FOREIGN KEY (`ID_KELAS`) REFERENCES `kelas` (`ID_KELAS`);

--
-- Constraints for table `registrasi`
--
ALTER TABLE `registrasi`
  ADD CONSTRAINT `FK_RELATIONSHIP_2` FOREIGN KEY (`ID_PEGAWAI`) REFERENCES `pegawai` (`ID_PEGAWAI`),
  ADD CONSTRAINT `FK_RELATIONSHIP_3` FOREIGN KEY (`ID_KAMAR`) REFERENCES `kamar` (`ID_KAMAR`),
  ADD CONSTRAINT `FK_RELATIONSHIP_4` FOREIGN KEY (`ID_DOKTER`) REFERENCES `dokter` (`ID_DOKTER`),
  ADD CONSTRAINT `FK_RELATIONSHIP_5` FOREIGN KEY (`ID_PERAWAT`) REFERENCES `perawat` (`ID_PERAWAT`),
  ADD CONSTRAINT `FK_RELATIONSHIP_6` FOREIGN KEY (`ID_PASIEN`) REFERENCES `pasien` (`ID_PASIEN`),
  ADD CONSTRAINT `FK_RELATIONSHIP_7` FOREIGN KEY (`ID_BILLING`) REFERENCES `billing` (`ID_BILLING`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
