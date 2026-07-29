-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 29, 2026 at 12:35 PM
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
-- Database: `wellnesshub`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `achievement_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `badge_icon` varchar(255) DEFAULT NULL,
  `xp_reward` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `activity_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `activity_type` varchar(80) NOT NULL,
  `duration` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auditlog`
--

CREATE TABLE `auditlog` (
  `audit_id` int(11) NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE','SELECT') NOT NULL,
  `performed_by` int(11) DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `counsellingslots`
--

CREATE TABLE `counsellingslots` (
  `slot_id` int(11) NOT NULL,
  `counselor_id` int(11) NOT NULL,
  `slot_date` date NOT NULL,
  `slot_time` time NOT NULL,
  `is_booked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `counselors`
--

CREATE TABLE `counselors` (
  `counselor_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `specialization` varchar(150) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `journalentries`
--

CREATE TABLE `journalentries` (
  `entry_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `entry_text` blob NOT NULL,
  `mood_tag` varchar(50) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `moodlogs`
--

CREATE TABLE `moodlogs` (
  `log_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `mood_score` tinyint(4) NOT NULL CHECK (`mood_score` between 1 and 10),
  `mood_label` enum('Great','Good','Okay','Low','Struggling') NOT NULL,
  `stress_level` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notif_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `type` enum('counselling_reminder','weekly_report','new_resource','risk_alert') NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `peersupportposts`
--

CREATE TABLE `peersupportposts` (
  `post_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT 1,
  `is_flagged` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `peersupportreplies`
--

CREATE TABLE `peersupportreplies` (
  `reply_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `riskalerts`
--

CREATE TABLE `riskalerts` (
  `alert_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `counselor_id` int(11) DEFAULT NULL,
  `risk_level` enum('Low','Medium','High') NOT NULL,
  `indicators` text DEFAULT NULL,
  `status` enum('unreviewed','in_progress','resolved') NOT NULL DEFAULT 'unreviewed',
  `flagged_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `selfhelpresources`
--

CREATE TABLE `selfhelpresources` (
  `resource_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `category` enum('Anxiety','Academic Stress','Sleep','Relationships','Self-Confidence') NOT NULL,
  `resource_type` enum('PDF Worksheet','Audio','Video','Article') NOT NULL,
  `duration` varchar(20) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `studentachievements`
--

CREATE TABLE `studentachievements` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `achievement_id` int(11) NOT NULL,
  `earned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `role` enum('student','counsellor','admin') NOT NULL DEFAULT 'student',
  `profile_photo` varchar(255) DEFAULT NULL,
  `dark_mode` tinyint(1) DEFAULT 0,
  `biometric_login` tinyint(1) DEFAULT 0,
  `popia_agreed` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `therapysessions`
--

CREATE TABLE `therapysessions` (
  `session_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `counselor_id` int(11) NOT NULL,
  `slot_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `notes` blob DEFAULT NULL,
  `status` enum('pending','confirmed','completed','cancelled') NOT NULL DEFAULT 'pending',
  `reminder_sent` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weeklymoodsummary`
--

CREATE TABLE `weeklymoodsummary` (
  `summary_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `avg_mood_score` decimal(4,2) DEFAULT NULL,
  `high_risk_days` tinyint(4) DEFAULT 0,
  `email_sent` tinyint(1) DEFAULT 0,
  `sent_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`achievement_id`);

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`activity_id`),
  ADD KEY `fk_activity_student` (`student_id`);

--
-- Indexes for table `auditlog`
--
ALTER TABLE `auditlog`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indexes for table `counsellingslots`
--
ALTER TABLE `counsellingslots`
  ADD PRIMARY KEY (`slot_id`),
  ADD KEY `idx_slots_counselor` (`counselor_id`,`slot_date`);

--
-- Indexes for table `counselors`
--
ALTER TABLE `counselors`
  ADD PRIMARY KEY (`counselor_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `journalentries`
--
ALTER TABLE `journalentries`
  ADD PRIMARY KEY (`entry_id`),
  ADD KEY `idx_journal_student` (`student_id`,`date`);

--
-- Indexes for table `moodlogs`
--
ALTER TABLE `moodlogs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_mood_student_date` (`student_id`,`date`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notif_id`),
  ADD KEY `fk_notif_student` (`student_id`);

--
-- Indexes for table `peersupportposts`
--
ALTER TABLE `peersupportposts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `fk_post_student` (`student_id`);

--
-- Indexes for table `peersupportreplies`
--
ALTER TABLE `peersupportreplies`
  ADD PRIMARY KEY (`reply_id`),
  ADD KEY `fk_reply_post` (`post_id`),
  ADD KEY `fk_reply_student` (`student_id`);

--
-- Indexes for table `riskalerts`
--
ALTER TABLE `riskalerts`
  ADD PRIMARY KEY (`alert_id`),
  ADD KEY `fk_alert_student` (`student_id`),
  ADD KEY `fk_alert_counselor` (`counselor_id`),
  ADD KEY `idx_alerts_status` (`status`,`risk_level`);

--
-- Indexes for table `selfhelpresources`
--
ALTER TABLE `selfhelpresources`
  ADD PRIMARY KEY (`resource_id`);

--
-- Indexes for table `studentachievements`
--
ALTER TABLE `studentachievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sa_student` (`student_id`),
  ADD KEY `fk_sa_achievement` (`achievement_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `therapysessions`
--
ALTER TABLE `therapysessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `fk_session_counselor` (`counselor_id`),
  ADD KEY `fk_session_slot` (`slot_id`),
  ADD KEY `idx_sessions_student` (`student_id`,`date`);

--
-- Indexes for table `weeklymoodsummary`
--
ALTER TABLE `weeklymoodsummary`
  ADD PRIMARY KEY (`summary_id`),
  ADD KEY `fk_summary_student` (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `achievement_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `activity_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auditlog`
--
ALTER TABLE `auditlog`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `counsellingslots`
--
ALTER TABLE `counsellingslots`
  MODIFY `slot_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `counselors`
--
ALTER TABLE `counselors`
  MODIFY `counselor_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `journalentries`
--
ALTER TABLE `journalentries`
  MODIFY `entry_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `moodlogs`
--
ALTER TABLE `moodlogs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notif_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `peersupportposts`
--
ALTER TABLE `peersupportposts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `peersupportreplies`
--
ALTER TABLE `peersupportreplies`
  MODIFY `reply_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `riskalerts`
--
ALTER TABLE `riskalerts`
  MODIFY `alert_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `selfhelpresources`
--
ALTER TABLE `selfhelpresources`
  MODIFY `resource_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `studentachievements`
--
ALTER TABLE `studentachievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `therapysessions`
--
ALTER TABLE `therapysessions`
  MODIFY `session_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weeklymoodsummary`
--
ALTER TABLE `weeklymoodsummary`
  MODIFY `summary_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `fk_activity_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `counsellingslots`
--
ALTER TABLE `counsellingslots`
  ADD CONSTRAINT `fk_slot_counselor` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`counselor_id`) ON DELETE CASCADE;

--
-- Constraints for table `journalentries`
--
ALTER TABLE `journalentries`
  ADD CONSTRAINT `fk_journal_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `moodlogs`
--
ALTER TABLE `moodlogs`
  ADD CONSTRAINT `fk_mood_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `peersupportposts`
--
ALTER TABLE `peersupportposts`
  ADD CONSTRAINT `fk_post_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `peersupportreplies`
--
ALTER TABLE `peersupportreplies`
  ADD CONSTRAINT `fk_reply_post` FOREIGN KEY (`post_id`) REFERENCES `peersupportposts` (`post_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reply_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `riskalerts`
--
ALTER TABLE `riskalerts`
  ADD CONSTRAINT `fk_alert_counselor` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`counselor_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_alert_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `studentachievements`
--
ALTER TABLE `studentachievements`
  ADD CONSTRAINT `fk_sa_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`achievement_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sa_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `therapysessions`
--
ALTER TABLE `therapysessions`
  ADD CONSTRAINT `fk_session_counselor` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`counselor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_session_slot` FOREIGN KEY (`slot_id`) REFERENCES `counsellingslots` (`slot_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_session_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `weeklymoodsummary`
--
ALTER TABLE `weeklymoodsummary`
  ADD CONSTRAINT `fk_summary_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
