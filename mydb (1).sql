-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 26, 2024 at 10:46 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mydb`
--

-- --------------------------------------------------------

--
-- Table structure for table `knowledge base`
--

CREATE TABLE `knowledge base` (
  `ArticleID` int(11) NOT NULL,
  `Title` varchar(45) NOT NULL,
  `Content` varchar(45) NOT NULL,
  `Report_ReportID` int(11) NOT NULL,
  `Staff_StaffID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

CREATE TABLE `queue` (
  `QueueID` int(11) NOT NULL,
  `TicketID` int(11) NOT NULL,
  `AssignStaff` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `ReportID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Summary` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `StaffID` int(11) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Role` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `TicketID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `User` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `phone` varchar(15) NOT NULL,
  `category` varchar(50) NOT NULL,
  `Description` varchar(10000) NOT NULL,
  `screenshot` text DEFAULT NULL,
  `status` enum('รอการตรวจสอบ','ตรวจสอบแล้ว','แก้ไขแล้ว') DEFAULT 'รอการตรวจสอบ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`TicketID`, `UserID`, `User`, `date`, `phone`, `category`, `Description`, `screenshot`, `status`) VALUES
(1, 1, 'bankhab', '2024-10-16', '0870352468', 'Electrical system', 'ไฟก', NULL, 'ตรวจสอบแล้ว'),
(2, 1, 'bankhab', '2024-10-16', '0870352468', 'Air conditioning system', 'awdawedwewe', NULL, 'ตรวจสอบแล้ว'),
(3, 1, 'bankhab', '2024-10-16', '0870352468', 'Water supply system', '1312asdaw', NULL, 'แก้ไขแล้ว'),
(4, 1, 'bankhab', '2024-10-16', '0870352468', 'Water supply system', '213123aaw', NULL, 'รอการตรวจสอบ'),
(5, 5, 'bankhab01', '2024-10-16', '0943260003', 'Internet system', '212awe', NULL, 'รอการตรวจสอบ'),
(6, 1, 'bankhab', '2024-10-16', '0943260003', 'Electrical system', '12a', NULL, 'รอการตรวจสอบ'),
(7, 5, 'bankhab01', '2024-10-16', '0870352468', 'Water supply system', '123asdw', NULL, 'รอการตรวจสอบ'),
(8, 1, 'bankhab', '2024-10-16', '0943260003', 'Air conditioning system', '1213aw', NULL, 'รอการตรวจสอบ'),
(9, 1, 'bankhab', '2024-10-16', '0540658111', 'Internet system', '0540658111', NULL, 'รอการตรวจสอบ'),
(10, 1, 'bankhab', '2024-10-16', '0540658111', 'Water supply system', 'awe13', NULL, 'รอการตรวจสอบ'),
(11, 1, 'bankhab', '2024-10-16', '0870352468', 'Air conditioning system', 'awe23a', NULL, 'รอการตรวจสอบ'),
(12, 5, 'bankhab01', '2024-10-16', '0870352468', 'Air conditioning system', 'awewa11', NULL, 'รอการตรวจสอบ'),
(13, 1, 'bankhab', '2024-10-19', '0870352468', 'Water supply system', 'ทดสอบ', NULL, 'รอการตรวจสอบ'),
(14, 1, 'bankhab', '2024-10-19', '0870352468', 'Internet system', '1212aw', NULL, 'รอการตรวจสอบ'),
(15, 1, 'bankhab', '2024-10-19', '0870352468', 'Water supply system', 'aawewa', NULL, 'รอการตรวจสอบ'),
(20, 1, 'bankhab', '2024-10-19', '0870352468', 'Electrical System', 'help', NULL, 'รอการตรวจสอบ');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserID` int(100) NOT NULL,
  `User` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Phone` varchar(45) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `Role` enum('user','staff','admin') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserID`, `User`, `Email`, `Password`, `Phone`, `created_at`, `Role`) VALUES
(1, 'bankhab', 'atiwitpat46@gmail.com', '123455', '0540658111', '2024-10-19 08:34:44', 'user'),
(5, 'bankhab01', 'atihab2546@gmail.com', '12345', '0540658111', '2024-10-19 08:34:44', 'user'),
(9, 'Atiwit', '65160394@go.buu.ac.th', '123455', '0870355496', '2024-10-19 08:44:53', 'staff'),
(10, 'Atiwit12', '65160394@my.buu.ac.th', '123455', '0870355789', '2024-10-19 08:45:45', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `knowledge base`
--
ALTER TABLE `knowledge base`
  ADD PRIMARY KEY (`ArticleID`,`Staff_StaffID`),
  ADD KEY `fk_Knowledge Base_Report1_idx` (`Report_ReportID`),
  ADD KEY `fk_Knowledge Base_Staff1_idx` (`Staff_StaffID`);

--
-- Indexes for table `queue`
--
ALTER TABLE `queue`
  ADD PRIMARY KEY (`QueueID`),
  ADD KEY `fk_Queue_Ticket1_idx` (`TicketID`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`StaffID`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`TicketID`),
  ADD KEY `fk_Ticket_User_idx` (`UserID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `unique_email` (`Email`),
  ADD UNIQUE KEY `Name` (`User`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `TicketID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserID` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `knowledge base`
--
ALTER TABLE `knowledge base`
  ADD CONSTRAINT `fk_Knowledge Base_Report1` FOREIGN KEY (`Report_ReportID`) REFERENCES `report` (`ReportID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Knowledge Base_Staff1` FOREIGN KEY (`Staff_StaffID`) REFERENCES `staff` (`StaffID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `queue`
--
ALTER TABLE `queue`
  ADD CONSTRAINT `fk_Queue_Ticket1` FOREIGN KEY (`TicketID`) REFERENCES `tickets` (`TicketID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_Ticket_User` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
