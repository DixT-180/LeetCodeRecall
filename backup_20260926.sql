-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: recall_app
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add problem',7,'add_problem'),(26,'Can change problem',7,'change_problem'),(27,'Can delete problem',7,'delete_problem'),(28,'Can view problem',7,'view_problem'),(29,'Can add problem review',8,'add_problemreview'),(30,'Can change problem review',8,'change_problemreview'),(31,'Can delete problem review',8,'delete_problemreview'),(32,'Can view problem review',8,'view_problemreview'),(33,'Can add review history',9,'add_reviewhistory'),(34,'Can change review history',9,'change_reviewhistory'),(35,'Can delete review history',9,'delete_reviewhistory'),(36,'Can view review history',9,'view_reviewhistory'),(37,'Can add solution',10,'add_solution'),(38,'Can change solution',10,'change_solution'),(39,'Can delete solution',10,'delete_solution'),(40,'Can view solution',10,'view_solution');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$870000$3e3DeEHdqvDLziZ5c9pBkk$7UKSNgHliq3jEFJ+xOXU46Fo8bFo6QNpth3Y1nhlc4s=','2026-09-25 16:37:58.379554',0,'dikshyant','','','',0,1,'2026-09-25 15:52:41.732543'),(2,'pbkdf2_sha256$870000$cOBDChch3nHZrdRTzNEtqe$llJOKZk9dsJylne0JVHPi7uSxXDHLKUVmV3ACvjJWQI=',NULL,1,'root','','','',1,1,'2026-09-25 16:17:09.712107'),(3,'pbkdf2_sha256$870000$ihpgafftkYketMkAZV3UNr$PmyNYBg37Pj1TDcXtQcTqMGHLjYiAZew3wc+dgaIFuM=','2026-09-26 10:21:23.296665',0,'dikshyant123','','','',0,1,'2026-09-26 01:05:01.164885');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'recall_app','problem'),(8,'recall_app','problemreview'),(9,'recall_app','reviewhistory'),(10,'recall_app','solution'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-09-25 15:51:22.643274'),(2,'auth','0001_initial','2026-09-25 15:51:28.102924'),(3,'admin','0001_initial','2026-09-25 15:51:29.364761'),(4,'admin','0002_logentry_remove_auto_add','2026-09-25 15:51:29.409139'),(5,'admin','0003_logentry_add_action_flag_choices','2026-09-25 15:51:29.477516'),(6,'contenttypes','0002_remove_content_type_name','2026-09-25 15:51:30.182253'),(7,'auth','0002_alter_permission_name_max_length','2026-09-25 15:51:30.700586'),(8,'auth','0003_alter_user_email_max_length','2026-09-25 15:51:30.869221'),(9,'auth','0004_alter_user_username_opts','2026-09-25 15:51:30.918230'),(10,'auth','0005_alter_user_last_login_null','2026-09-25 15:51:31.371647'),(11,'auth','0006_require_contenttypes_0002','2026-09-25 15:51:31.398663'),(12,'auth','0007_alter_validators_add_error_messages','2026-09-25 15:51:31.449798'),(13,'auth','0008_alter_user_username_max_length','2026-09-25 15:51:32.011785'),(14,'auth','0009_alter_user_last_name_max_length','2026-09-25 15:51:32.556699'),(15,'auth','0010_alter_group_name_max_length','2026-09-25 15:51:32.695812'),(16,'auth','0011_update_proxy_permissions','2026-09-25 15:51:32.754212'),(17,'auth','0012_alter_user_first_name_max_length','2026-09-25 15:51:33.197958'),(18,'sessions','0001_initial','2026-09-25 15:51:33.485803'),(19,'recall_app','0001_initial','2026-09-25 15:51:49.713726');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('493gch037u9ioi10e0xggactsq195b3y','.eJxVjDsOwjAQBe_iGln-fyjpOYO19q5xADlSnFSIu0OkFNC-mXkvlmBbW9oGLWlCdmaanX63DOVBfQd4h36beZn7ukyZ7wo_6ODXGel5Ody_gwajfetaK5GAbGU2gUJAhdVRIRRRO-EV2ShMLuBQgycRnPK2-GJAam9rlOz9ARY6OG4:1xAGqd:l6tXeZDLDihygJNt5zjActlz2tyMFsaIN400INKb2dM','2026-10-10 01:05:03.268580'),('6ujj06raprer7pdez2yzhifxjbsezl1b','.eJxVjDkOwjAUBe_iGlle5PiHkp4zWH8xOIBsKU6qiLtDpBTQvpl5m0q4LiWtPc9pEnVWVp1-N0J-5roDeWC9N82tLvNEelf0Qbu-Nsmvy-H-HRTs5Vt7GpwNRAEQx5sRz0Eg5GAQbI6eLBlHdgzROxoyGwCLyEIITGw4qvcH5yE4cA:1xA8vu:GYIMky5qQ35yBDZdWGs7N3o8oIQSe2v-goH35HCtC94','2026-10-09 16:37:58.434392'),('n4h9j2ynsyemqjt6cun9nqcznoryi417','.eJxVjDsOwjAQBe_iGln-fyjpOYO19q5xADlSnFSIu0OkFNC-mXkvlmBbW9oGLWlCdmaanX63DOVBfQd4h36beZn7ukyZ7wo_6ODXGel5Ody_gwajfetaK5GAbGU2gUJAhdVRIRRRO-EV2ShMLuBQgycRnPK2-GJAam9rlOz9ARY6OG4:1xAPX1:pchBMl3LKnn96kjKG61qpZPox-X652E67zv84DZC7O8','2026-10-10 10:21:23.362665');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recall_app_problem`
--

DROP TABLE IF EXISTS `recall_app_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recall_app_problem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `problem_name` varchar(255) NOT NULL,
  `problem_description` longtext NOT NULL,
  `problemid` int NOT NULL,
  `category` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `problemid` (`problemid`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recall_app_problem`
--

LOCK TABLES `recall_app_problem` WRITE;
/*!40000 ALTER TABLE `recall_app_problem` DISABLE KEYS */;
INSERT INTO `recall_app_problem` VALUES (1,'Longest Substring Without Repeating Characters','Given a string s, find the length of the longest contiguous substring that contains no repeating characters. A substring must be made of consecutive characters (unlike a subsequence, which can skip characters).\r\n\r\nExample 1:\r\n\r\nInput: s = \"abcabcbb\"\r\nOutput: 3\r\nExplanation: The answer is \"abc\", with the length of 3. Note that \"bca\" and \"cab\" are also correct answers.\r\nExample 2:\r\n\r\nInput: s = \"bbbbb\"\r\nOutput: 1\r\nExplanation: The answer is \"b\", with the length of 1.\r\nExample 3:\r\n\r\nInput: s = \"pwwkew\"\r\nOutput: 3\r\nExplanation: The answer is \"wke\", with the length of 3.\r\nNotice that the answer must be a substring, \"pwke\" is a subsequence and not a substring.\r\n \r\n\r\nConstraints:\r\n\r\n0 <= s.length <= 105\r\ns consists of English letters, digits, symbols and spaces.',3,'SlideWin'),(2,'3Sum','Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.\r\n\r\nNotice that the solution set must not contain duplicate triplets.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [-1,0,1,2,-1,-4]\r\nOutput: [[-1,-1,2],[-1,0,1]]\r\nExplanation: \r\nnums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.\r\nnums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0.\r\nnums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.\r\nThe distinct triplets are [-1,0,1] and [-1,-1,2].\r\nNotice that the order of the output and the order of the triplets does not matter.\r\nExample 2:\r\n\r\nInput: nums = [0,1,1]\r\nOutput: []\r\nExplanation: The only possible triplet does not sum up to 0.\r\nExample 3:\r\n\r\nInput: nums = [0,0,0]\r\nOutput: [[0,0,0]]\r\nExplanation: The only possible triplet sums up to 0.\r\n \r\n\r\nConstraints:\r\n\r\n3 <= nums.length <= 3000\r\n-105 <= nums[i] <= 105',15,'TwoPtr'),(3,'Valid Parentheses','Given a string s containing just the characters \'(\', \')\', \'{\', \'}\', \'[\' and \']\', determine if the input string is valid.\r\n\r\nAn input string is valid if:\r\n\r\nOpen brackets must be closed by the same type of brackets.\r\nOpen brackets must be closed in the correct order.\r\nEvery close bracket has a corresponding open bracket of the same type.\r\n \r\n\r\nExample 1:\r\n\r\nInput: s = \"()\"\r\n\r\nOutput: true\r\n\r\nExample 2:\r\n\r\nInput: s = \"()[]{}\"\r\n\r\nOutput: true\r\n\r\nExample 3:\r\n\r\nInput: s = \"(]\"\r\n\r\nOutput: false\r\n\r\nExample 4:\r\n\r\nInput: s = \"([])\"\r\n\r\nOutput: true\r\n\r\nExample 5:\r\n\r\nInput: s = \"([)]\"\r\n\r\nOutput: false\r\n\r\n \r\n\r\nConstraints:\r\n\r\n1 <= s.length <= 104\r\ns consists of parentheses only \'()[]{}\'.',20,'Stack'),(4,'Search in Rotated Sorted Array','There is an integer array nums sorted in ascending order (with distinct values).\r\n\r\nPrior to being passed to your function, nums is possibly left rotated at an unknown index k (1 <= k < nums.length) such that the resulting array is [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]] (0-indexed). For example, [0,1,2,4,5,6,7] might be left rotated by 3 indices and become [4,5,6,7,0,1,2].\r\n\r\nGiven the array nums after the possible rotation and an integer target, return the index of target if it is in nums, or -1 if it is not in nums.\r\n\r\nYou must write an algorithm with O(log n) runtime complexity.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [4,5,6,7,0,1,2], target = 0\r\nOutput: 4\r\nExample 2:\r\n\r\nInput: nums = [4,5,6,7,0,1,2], target = 3\r\nOutput: -1\r\nExample 3:\r\n\r\nInput: nums = [1], target = 0\r\nOutput: -1\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 5000\r\n-104 <= nums[i] <= 104\r\nAll values of nums are unique.\r\nnums is an ascending array that is possibly rotated.\r\n-104 <= target <= 104',33,'BinSearch'),(5,'Find First and Last Position of Element in Sorted Array','Given an array of integers nums sorted in non-decreasing order, find the starting and ending position of a given target value.\r\n\r\nIf target is not found in the array, return [-1, -1].\r\n\r\nYou must write an algorithm with O(log n) runtime complexity.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [5,7,7,8,8,10], target = 8\r\nOutput: [3,4]\r\nExample 2:\r\n\r\nInput: nums = [5,7,7,8,8,10], target = 6\r\nOutput: [-1,-1]\r\nExample 3:\r\n\r\nInput: nums = [], target = 0\r\nOutput: [-1,-1]\r\n \r\n\r\nConstraints:\r\n\r\n0 <= nums.length <= 105\r\n-109 <= nums[i] <= 109\r\nnums is a non-decreasing array.\r\n-109 <= target <= 109',34,'BinSearch'),(6,'Search Insert Position','Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.\r\n\r\nYou must write an algorithm with O(log n) runtime complexity.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [1,3,5,6], target = 5\r\nOutput: 2\r\nExample 2:\r\n\r\nInput: nums = [1,3,5,6], target = 2\r\nOutput: 1\r\nExample 3:\r\n\r\nInput: nums = [1,3,5,6], target = 7\r\nOutput: 4\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 104\r\n-104 <= nums[i] <= 104\r\nnums contains distinct values sorted in ascending order.\r\n-104 <= target <= 104',35,'BinSearch'),(7,'Group Anagrams','Given an array of strings strs, group the anagrams together. You can return the answer in any order.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: strs = [\"eat\",\"tea\",\"tan\",\"ate\",\"nat\",\"bat\"]\r\n\r\nOutput: [[\"bat\"],[\"nat\",\"tan\"],[\"ate\",\"eat\",\"tea\"]]\r\n\r\nExplanation:\r\n\r\nThere is no string in strs that can be rearranged to form \"bat\".\r\nThe strings \"nat\" and \"tan\" are anagrams as they can be rearranged to form each other.\r\nThe strings \"ate\", \"eat\", and \"tea\" are anagrams as they can be rearranged to form each other.\r\nExample 2:\r\n\r\nInput: strs = [\"\"]\r\n\r\nOutput: [[\"\"]]\r\n\r\nExample 3:\r\n\r\nInput: strs = [\"a\"]\r\n\r\nOutput: [[\"a\"]]\r\n\r\n \r\n\r\nConstraints:\r\n\r\n1 <= strs.length <= 104\r\n0 <= strs[i].length <= 100\r\nstrs[i] consists of lowercase English letters.',49,'Hashing'),(8,'Sqrt(x)','Given a non-negative integer x, return the square root of x rounded down to the nearest integer. The returned integer should be non-negative as well.\r\n\r\nYou must not use any built-in exponent function or operator.\r\n\r\nFor example, do not use pow(x, 0.5) in c++ or x ** 0.5 in python.\r\n \r\n\r\nExample 1:\r\n\r\nInput: x = 4\r\nOutput: 2\r\nExplanation: The square root of 4 is 2, so we return 2.\r\nExample 2:\r\n\r\nInput: x = 8\r\nOutput: 2\r\nExplanation: The square root of 8 is 2.82842..., and since we round it down to the nearest integer, 2 is returned.\r\n \r\n\r\nConstraints:\r\n\r\n0 <= x <= 231 - 1',69,'BinSearch'),(9,'Best Time to Buy and Sell Stock','You are given an array prices where prices[i] is the price of a given stock on the ith day.\r\n\r\nYou want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.\r\n\r\nReturn the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.\r\n\r\n\r\nExample 1:\r\n\r\nInput: prices = [7,1,5,3,6,4]\r\nOutput: 5\r\nExplanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.\r\nNote that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell.\r\nExample 2:\r\n\r\nInput: prices = [7,6,4,3,1]\r\nOutput: 0\r\nExplanation: In this case, no transactions are done and the max profit = 0.\r\n \r\n\r\nConstraints:\r\n\r\n1 <= prices.length <= 105\r\n0 <= prices[i] <= 104',121,'TwoPtr'),(10,'Evaluate Reverse Polish Notation','You are given an array of strings tokens that represents an arithmetic expression in a Reverse Polish Notation.\r\n\r\nEvaluate the expression. Return an integer that represents the value of the expression.\r\n\r\nNote that:\r\n\r\nThe valid operators are \'+\', \'-\', \'*\', and \'/\'.\r\nEach operand may be an integer or another expression.\r\nThe division between two integers always truncates toward zero.\r\nThere will not be any division by zero.\r\nThe input represents a valid arithmetic expression in a reverse polish notation.\r\nThe answer and all the intermediate calculations can be represented in a 32-bit integer.\r\n \r\n\r\nExample 1:\r\n\r\nInput: tokens = [\"2\",\"1\",\"+\",\"3\",\"*\"]\r\nOutput: 9\r\nExplanation: ((2 + 1) * 3) = 9\r\nExample 2:\r\n\r\nInput: tokens = [\"4\",\"13\",\"5\",\"/\",\"+\"]\r\nOutput: 6\r\nExplanation: (4 + (13 / 5)) = 6\r\nExample 3:\r\n\r\nInput: tokens = [\"10\",\"6\",\"9\",\"3\",\"+\",\"-11\",\"*\",\"/\",\"*\",\"17\",\"+\",\"5\",\"+\"]\r\nOutput: 22\r\nExplanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5\r\n= ((10 * (6 / (12 * -11))) + 17) + 5\r\n= ((10 * (6 / -132)) + 17) + 5\r\n= ((10 * 0) + 17) + 5\r\n= (0 + 17) + 5\r\n= 17 + 5\r\n= 22\r\n \r\n\r\nConstraints:\r\n\r\n1 <= tokens.length <= 104\r\ntokens[i] is either an operator: \"+\", \"-\", \"*\", or \"/\", or an integer in the range [-200, 200].',150,'Stack'),(11,'Find Minimum in Rotated Sorted Array','Suppose an array of length n sorted in ascending order is rotated between 1 and n times. For example, the array nums = [0,1,2,4,5,6,7] might become:\r\n\r\n[4,5,6,7,0,1,2] if it was rotated 4 times.\r\n[0,1,2,4,5,6,7] if it was rotated 7 times.\r\nNotice that rotating an array [a[0], a[1], a[2], ..., a[n-1]] 1 time results in the array [a[n-1], a[0], a[1], a[2], ..., a[n-2]].\r\n\r\nGiven the sorted rotated array nums of unique elements, return the minimum element of this array.\r\n\r\nYou must write an algorithm that runs in O(log n) time.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [3,4,5,1,2]\r\nOutput: 1\r\nExplanation: The original array was [1,2,3,4,5] rotated 3 times.\r\nExample 2:\r\n\r\nInput: nums = [4,5,6,7,0,1,2]\r\nOutput: 0\r\nExplanation: The original array was [0,1,2,4,5,6,7] and it was rotated 4 times.\r\nExample 3:\r\n\r\nInput: nums = [11,13,15,17]\r\nOutput: 11\r\nExplanation: The original array was [11,13,15,17] and it was rotated 4 times. \r\n \r\n\r\nConstraints:\r\n\r\nn == nums.length\r\n1 <= n <= 5000\r\n-5000 <= nums[i] <= 5000\r\nAll the integers of nums are unique.\r\nnums is sorted and rotated between 1 and n times.',153,'BinSearch'),(12,'Min Stack','Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.\r\n\r\nImplement the MinStack class:\r\n\r\nMinStack() initializes the stack object.\r\nvoid push(int value) pushes the element value onto the stack.\r\nvoid pop() removes the element on the top of the stack.\r\nint top() gets the top element of the stack.\r\nint getMin() retrieves the minimum element in the stack.\r\nYou must implement a solution with O(1) time complexity for each function.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput\r\n[\"MinStack\",\"push\",\"push\",\"push\",\"getMin\",\"pop\",\"top\",\"getMin\"]\r\n[[],[-2],[0],[-3],[],[],[],[]]\r\n\r\nOutput\r\n[null,null,null,null,-3,null,0,-2]\r\n\r\nExplanation\r\nMinStack minStack = new MinStack();\r\nminStack.push(-2);\r\nminStack.push(0);\r\nminStack.push(-3);\r\nminStack.getMin(); // return -3\r\nminStack.pop();\r\nminStack.top();    // return 0\r\nminStack.getMin(); // return -2\r\n \r\n\r\nConstraints:\r\n\r\n-231 <= val <= 231 - 1\r\nMethods pop, top and getMin operations will always be called on non-empty stacks.\r\nAt most 3 * 104 calls will be made to push, pop, top, and getMin.',155,'Stack'),(13,'Find Peak Element','A peak element is an element that is strictly greater than its neighbors.\r\n\r\nGiven a 0-indexed integer array nums, find a peak element, and return its index. If the array contains multiple peaks, return the index to any of the peaks.\r\n\r\nYou may imagine that nums[-1] = nums[n] = -∞. In other words, an element is always considered to be strictly greater than a neighbor that is outside the array.\r\n\r\nYou must write an algorithm that runs in O(log n) time.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [1,2,3,1]\r\nOutput: 2\r\nExplanation: 3 is a peak element and your function should return the index number 2.\r\nExample 2:\r\n\r\nInput: nums = [1,2,1,3,5,6,4]\r\nOutput: 5\r\nExplanation: Your function can return either index number 1 where the peak element is 2, or index number 5 where the peak element is 6.\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 1000\r\n-231 <= nums[i] <= 231 - 1\r\nnums[i] != nums[i + 1] for all valid i.',162,'BinSearch'),(14,'Two Sum II - Input Array Is Sorted','You are given a 1-indexed array of integers numbers that is already sorted in non-decreasing order.\r\n\r\nFind two numbers such that they add up to a specific target number. Let these two numbers be numbers[index1] and numbers[index2] where 1 <= index1 < index2 <= numbers.length.\r\n\r\nReturn the indices of the two numbers index1 and index2 as an integer array [index1, index2] of length 2.\r\n\r\nThe tests are generated such that there is exactly one solution. You may not use the same element twice.\r\n\r\nYour solution must use only constant extra space.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: numbers = [2,7,11,15], target = 9\r\nOutput: [1,2]\r\nExplanation: The sum of 2 and 7 is 9. Therefore, index1 = 1, index2 = 2. We return [1, 2].\r\nExample 2:\r\n\r\nInput: numbers = [2,3,4], target = 6\r\nOutput: [1,3]\r\nExplanation: The sum of 2 and 4 is 6. Therefore index1 = 1, index2 = 3. We return [1, 3].\r\nExample 3:\r\n\r\nInput: numbers = [-1,0], target = -1\r\nOutput: [1,2]\r\nExplanation: The sum of -1 and 0 is -1. Therefore index1 = 1, index2 = 2. We return [1, 2].\r\n \r\n\r\nConstraints:\r\n\r\n2 <= numbers.length <= 3 * 104\r\n-1000 <= numbers[i] <= 1000\r\nnumbers is sorted in non-decreasing order.\r\n-1000 <= target <= 1000\r\nThe tests are generated such that there is exactly one solution.',167,'TwoPtr'),(15,'Product of Array Except Self','Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].\r\n\r\nThe product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.\r\n\r\nYou must write an algorithm that runs in O(n) time and without using the division operation.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [1,2,3,4]\r\nOutput: [24,12,8,6]\r\nExample 2:\r\n\r\nInput: nums = [-1,1,0,-3,3]\r\nOutput: [0,0,9,0,0]\r\n \r\n\r\nConstraints:\r\n\r\n2 <= nums.length <= 105\r\n-30 <= nums[i] <= 30\r\nThe input is generated such that answer[i] is guaranteed to fit in a 32-bit integer.\r\n \r\n\r\nFollow up: Can you solve the problem in O(1) extra space complexity? (The output array does not count as extra space for space complexity analysis.)',238,'Array'),(16,'Top K Frequent Elements','Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [1,1,1,2,2,3], k = 2\r\n\r\nOutput: [1,2]\r\n\r\nExample 2:\r\n\r\nInput: nums = [1], k = 1\r\n\r\nOutput: [1]\r\n\r\nExample 3:\r\n\r\nInput: nums = [1,2,1,2,1,2,3,1,3,2], k = 2\r\n\r\nOutput: [1,2]\r\n\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 105\r\n-104 <= nums[i] <= 104\r\nk is in the range [1, the number of unique elements in the array].\r\nIt is guaranteed that the answer is unique.\r\n \r\n\r\nFollow up: Your algorithm\'s time complexity must be better than O(n log n), where n is the array\'s size.',347,'Hashing'),(17,'Valid Perfect Square','Given a positive integer num, return true if num is a perfect square or false otherwise.\r\n\r\nA perfect square is an integer that is the square of an integer. In other words, it is the product of some integer with itself.\r\n\r\nYou must not use any built-in library function, such as sqrt.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: num = 16\r\nOutput: true\r\nExplanation: We return true because 4 * 4 = 16 and 4 is an integer.\r\nExample 2:\r\n\r\nInput: num = 14\r\nOutput: false\r\nExplanation: We return false because 3.742 * 3.742 = 14 and 3.742 is not an integer.\r\n \r\n\r\nConstraints:\r\n\r\n1 <= num <= 231 - 1',367,'BinSearch'),(18,'Next Greater Element I','The next greater element of some element x in an array is the first greater element that is to the right of x in the same array.\r\n\r\nYou are given two distinct 0-indexed integer arrays nums1 and nums2, where nums1 is a subset of nums2.\r\n\r\nFor each 0 <= i < nums1.length, find the index j such that nums1[i] == nums2[j] and determine the next greater element of nums2[j] in nums2. If there is no next greater element, then the answer for this query is -1.\r\n\r\nReturn an array ans of length nums1.length such that ans[i] is the next greater element as described above.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums1 = [4,1,2], nums2 = [1,3,4,2]\r\nOutput: [-1,3,-1]\r\nExplanation: The next greater element for each value of nums1 is as follows:\r\n- 4 is underlined in nums2 = [1,3,4,2]. There is no next greater element, so the answer is -1.\r\n- 1 is underlined in nums2 = [1,3,4,2]. The next greater element is 3.\r\n- 2 is underlined in nums2 = [1,3,4,2]. There is no next greater element, so the answer is -1.\r\nExample 2:\r\n\r\nInput: nums1 = [2,4], nums2 = [1,2,3,4]\r\nOutput: [3,-1]\r\nExplanation: The next greater element for each value of nums1 is as follows:\r\n- 2 is underlined in nums2 = [1,2,3,4]. The next greater element is 3.\r\n- 4 is underlined in nums2 = [1,2,3,4]. There is no next greater element, so the answer is -1.\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums1.length <= nums2.length <= 1000\r\n0 <= nums1[i], nums2[i] <= 104\r\nAll integers in nums1 and nums2 are unique.\r\nAll the integers of nums1 also appear in nums2.\r\n \r\n\r\nFollow up: Could you find an O(nums1.length + nums2.length) solution?',496,'Stack'),(19,'Next Greater Element II','Given a circular integer array nums (i.e., the next element of nums[nums.length - 1] is nums[0]), return the next greater number for every element in nums.\r\n\r\nThe next greater number of a number x is the first greater number to its traversing-order next in the array, which means you could search circularly to find its next greater number. If it doesn\'t exist, return -1 for this number.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [1,2,1]\r\nOutput: [2,-1,2]\r\nExplanation: The first 1\'s next greater number is 2; \r\nThe number 2 can\'t find next greater number. \r\nThe second 1\'s next greater number needs to search circularly, which is also 2.\r\nExample 2:\r\n\r\nInput: nums = [1,2,3,4,3]\r\nOutput: [2,3,4,-1,4]\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 104\r\n-109 <= nums[i] <= 109',503,'Stack'),(20,'Permutation in String','Given two strings s1 and s2, determine whether s2 contains a contiguous substring that is a permutation (i.e. an anagram) of s1.\n\nExample 1: s1 = \"ab\", s2 = \"eidbaooo\" -> true, because s2 contains \"ba\", a permutation of \"ab\".\nExample 2: s1 = \"ab\", s2 = \"eidboaoo\" -> false.\n\nConstraints: 1 <= s1.length, s2.length <= 10^4; both strings are lowercase English letters.',567,'SlideWin'),(21,'Maximum Average Subarray I','Given an integer array nums and an integer k, find a contiguous subarray of exactly length k that has the maximum average value, and return that average. (Since k is fixed, this is the same as finding the subarray of length k with the maximum sum, then dividing by k.)\n\nExample 1: nums = [1,12,-5,-6,50,3], k = 4 -> 12.75, from the subarray [12,-5,-6,50] (sum 51 / 4).\nExample 2: nums = [5], k = 1 -> 5.0.\n\nConstraints: 1 <= k <= nums.length <= 10^5; -10^4 <= nums[i] <= 10^4.',643,'SlideWin'),(22,'Binary Search','Given an array of integers nums which is sorted in ascending order, and an integer target, write a function to search target in nums. If target exists, then return its index. Otherwise, return -1.\r\n\r\nYou must write an algorithm with O(log n) runtime complexity.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: nums = [-1,0,3,5,9,12], target = 9\r\nOutput: 4\r\nExplanation: 9 exists in nums and its index is 4\r\nExample 2:\r\n\r\nInput: nums = [-1,0,3,5,9,12], target = 2\r\nOutput: -1\r\nExplanation: 2 does not exist in nums so return -1\r\n \r\n\r\nConstraints:\r\n\r\n1 <= nums.length <= 104\r\n-104 < nums[i], target < 104\r\nAll the integers in nums are unique.\r\nnums is sorted in ascending order.',704,'BinSearch'),(23,'Daily Temperatures','Given an array of integers temperatures represents the daily temperatures, return an array answer such that answer[i] is the number of days you have to wait after the ith day to get a warmer temperature. If there is no future day for which this is possible, keep answer[i] == 0 instead.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: temperatures = [73,74,75,71,69,72,76,73]\r\nOutput: [1,1,4,2,1,1,0,0]\r\nExample 2:\r\n\r\nInput: temperatures = [30,40,50,60]\r\nOutput: [1,1,1,0]\r\nExample 3:\r\n\r\nInput: temperatures = [30,60,90]\r\nOutput: [1,1,0]\r\n \r\n\r\nConstraints:\r\n\r\n1 <= temperatures.length <= 105\r\n30 <= temperatures[i] <= 100',739,'Stack'),(24,'Find Smallest Letter Greater Than Target','ou are given an array of characters letters that is sorted in non-decreasing order, and a character target. There are at least two different characters in letters.\r\n\r\nReturn the smallest character in letters that is lexicographically greater than target. If such a character does not exist, return the first character in letters.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: letters = [\"c\",\"f\",\"j\"], target = \"a\"\r\nOutput: \"c\"\r\nExplanation: The smallest character that is lexicographically greater than \'a\' in letters is \'c\'.\r\nExample 2:\r\n\r\nInput: letters = [\"c\",\"f\",\"j\"], target = \"c\"\r\nOutput: \"f\"\r\nExplanation: The smallest character that is lexicographically greater than \'c\' in letters is \'f\'.\r\nExample 3:\r\n\r\nInput: letters = [\"x\",\"x\",\"y\",\"y\"], target = \"z\"\r\nOutput: \"x\"\r\nExplanation: There are no characters in letters that is lexicographically greater than \'z\' so we return letters[0].\r\n \r\n\r\nConstraints:\r\n\r\n2 <= letters.length <= 104\r\nletters[i] is a lowercase English letter.\r\nletters is sorted in non-decreasing order.\r\nletters contains at least two different characters.\r\ntarget is a lowercase English letter.',744,'BinSearch'),(25,'Peak Index in a Mountain Array','You are given an integer mountain array arr of length n where the values increase to a peak element and then decrease.\r\n\r\nReturn the index of the peak element.\r\n\r\nYour task is to solve it in O(log(n)) time complexity.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: arr = [0,1,0]\r\n\r\nOutput: 1\r\n\r\nExample 2:\r\n\r\nInput: arr = [0,2,1,0]\r\n\r\nOutput: 1\r\n\r\nExample 3:\r\n\r\nInput: arr = [0,10,5,2]\r\n\r\nOutput: 1\r\n\r\n \r\n\r\nConstraints:\r\n\r\n3 <= arr.length <= 105\r\n0 <= arr[i] <= 106\r\narr is guaranteed to be a mountain array.',852,'BinSearch'),(26,'Koko Eating Bananas','Koko loves to eat bananas. There are n piles of bananas, the ith pile has piles[i] bananas. The guards have gone and will come back in h hours.\r\n\r\nKoko can decide her bananas-per-hour eating speed of k. Each hour, she chooses some pile of bananas and eats k bananas from that pile. If the pile has less than k bananas, she eats all of them instead and will not eat any more bananas during this hour.\r\n\r\nKoko likes to eat slowly but still wants to finish eating all the bananas before the guards return.\r\n\r\nReturn the minimum integer k such that she can eat all the bananas within h hours.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: piles = [3,6,7,11], h = 8\r\nOutput: 4\r\nExample 2:\r\n\r\nInput: piles = [30,11,23,4,20], h = 5\r\nOutput: 30\r\nExample 3:\r\n\r\nInput: piles = [30,11,23,4,20], h = 6\r\nOutput: 23\r\n \r\n\r\nConstraints:\r\n\r\n1 <= piles.length <= 104\r\npiles.length <= h <= 109\r\n1 <= piles[i] <= 109',875,'BinSearch'),(27,'Capacity To Ship Packages Within D Days','A conveyor belt has packages that must be shipped from one port to another within days days.\r\n\r\nThe ith package on the conveyor belt has a weight of weights[i]. Each day, we load the ship with packages on the conveyor belt (in the order given by weights). We may not load more weight than the maximum weight capacity of the ship.\r\n\r\nReturn the least weight capacity of the ship that will result in all the packages on the conveyor belt being shipped within days days.\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: weights = [1,2,3,4,5,6,7,8,9,10], days = 5\r\nOutput: 15\r\nExplanation: A ship capacity of 15 is the minimum to ship all the packages in 5 days like this:\r\n1st day: 1, 2, 3, 4, 5\r\n2nd day: 6, 7\r\n3rd day: 8\r\n4th day: 9\r\n5th day: 10\r\n\r\nNote that the cargo must be shipped in the order given, so using a ship of capacity 14 and splitting the packages into parts like (2, 3, 4, 5), (1, 6, 7), (8), (9), (10) is not allowed.\r\nExample 2:\r\n\r\nInput: weights = [3,2,2,4,1,4], days = 3\r\nOutput: 6\r\nExplanation: A ship capacity of 6 is the minimum to ship all the packages in 3 days like this:\r\n1st day: 3, 2\r\n2nd day: 2, 4\r\n3rd day: 1, 4\r\nExample 3:\r\n\r\nInput: weights = [1,2,3,1,1], days = 4\r\nOutput: 3\r\nExplanation:\r\n1st day: 1\r\n2nd day: 2\r\n3rd day: 3\r\n4th day: 1, 1\r\n \r\n\r\nConstraints:\r\n\r\n1 <= days <= weights.length <= 5 * 104\r\n1 <= weights[i] <= 500',1011,'BinSearch'),(28,'Defuse the Bomb','You have a bomb to defuse, and your time is running out! Your informer will provide you with a circular array code of length of n and a key k.\r\n\r\nTo decrypt the code, you must replace every number. All the numbers are replaced simultaneously.\r\n\r\nIf k > 0, replace the ith number with the sum of the next k numbers.\r\nIf k < 0, replace the ith number with the sum of the previous -k numbers.\r\nIf k == 0, replace the ith number with 0.\r\nAs code is circular, the next element of code[n-1] is code[0], and the previous element of code[0] is code[n-1].\r\n\r\nGiven the circular array code and an integer key k, return the decrypted code to defuse the bomb!\r\n\r\n \r\n\r\nExample 1:\r\n\r\nInput: code = [5,7,1,4], k = 3\r\nOutput: [12,10,16,13]\r\nExplanation: Each number is replaced by the sum of the next 3 numbers. The decrypted code is [7+1+4, 1+4+5, 4+5+7, 5+7+1]. Notice that the numbers wrap around.\r\nExample 2:\r\n\r\nInput: code = [1,2,3,4], k = 0\r\nOutput: [0,0,0,0]\r\nExplanation: When k is zero, the numbers are replaced by 0. \r\nExample 3:\r\n\r\nInput: code = [2,4,9,3], k = -2\r\nOutput: [12,5,6,13]\r\nExplanation: The decrypted code is [3+9, 2+3, 4+2, 9+4]. Notice that the numbers wrap around again. If k is negative, the sum is of the previous numbers.\r\n \r\n\r\nConstraints:\r\n\r\nn == code.length\r\n1 <= n <= 100\r\n1 <= code[i] <= 100\r\n-(n - 1) <= k <= n - 1',1652,'Array'),(29,'Subarrays with Target Sum','Given an array of positive integers and a target sum, find every contiguous subarray whose elements add up exactly to the target.',90002,'SlideWin'),(31,'Maximum Sum Subarray of Size K','Input:\r\nnums = [2, 1, 5, 1, 3, 2]\r\nk = 3\r\n\r\n\r\nSubarrays:\r\n[2, 1, 5] = 8\r\n[1, 5, 1] = 7\r\n[5, 1, 3] = 9\r\n[1, 3, 2] = 6\r\n\r\n\r\nOutput:\r\n9\r\n\r\n###########################\r\n\r\nExample 2\r\n\r\nInput:\r\n\r\nnums = [2, 3, 4, 1, 5]\r\nk = 2\r\n\r\nOutput:\r\n\r\n7\r\n\r\nExplanation:\r\n\r\n[2, 3] = 5\r\n[3, 4] = 7  ← maximum\r\n[4, 1] = 5\r\n[1, 5] = 6',100001,'SlideWin');
/*!40000 ALTER TABLE `recall_app_problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recall_app_problemreview`
--

DROP TABLE IF EXISTS `recall_app_problemreview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recall_app_problemreview` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `notes` longtext NOT NULL,
  `solution` longtext NOT NULL,
  `last_reviewed` datetime(6) NOT NULL,
  `understanding` int NOT NULL,
  `number_of_reviews` int NOT NULL,
  `half_life` double NOT NULL,
  `retention` double NOT NULL,
  `problem_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_problem` (`user_id`,`problem_id`),
  KEY `recall_app_problemre_problem_id_c2dfd4e9_fk_recall_ap` (`problem_id`),
  CONSTRAINT `recall_app_problemre_problem_id_c2dfd4e9_fk_recall_ap` FOREIGN KEY (`problem_id`) REFERENCES `recall_app_problem` (`id`),
  CONSTRAINT `recall_app_problemreview_user_id_da221ca5_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recall_app_problemreview`
--

LOCK TABLES `recall_app_problemreview` WRITE;
/*!40000 ALTER TABLE `recall_app_problemreview` DISABLE KEYS */;
INSERT INTO `recall_app_problemreview` VALUES (1,'','','2026-09-25 16:05:16.167868',1,0,0,1,3,1),(2,'','','2026-09-26 05:28:18.859827',1,0,0,1,31,3),(3,'','','2026-09-26 06:26:01.981353',1,0,0,1,1,3),(4,'Time is linear.','','2026-09-26 06:27:49.209767',4,3,0,1,9,3),(5,'Default dict!','','2026-09-26 06:36:59.550880',1,1,0,1,7,3),(6,'','','2026-09-26 06:42:45.374640',1,1,0,1,15,3),(7,'','','2026-09-26 06:47:04.069022',1,1,0,1,16,3),(8,'TWO SUM II — ALGORITHM\r\n\r\nGoal:\r\nFind two numbers in the sorted array that add up to target.\r\n\r\nAlgorithm:\r\n\r\n1. Start with two pointers:\r\n\r\n   * l → beginning of the array\r\n   * r → end of the array\r\n\r\n2. Add the two numbers:\r\n   sum = numbers[l] + numbers[r]\r\n\r\n3. Compare sum with target:\r\n\r\n   * If sum == target:\r\n     We found the answer.\r\n     return l + 1, r + 1\r\n\r\n   * If sum < target:\r\n     We need a bigger sum.\r\n     Move l to the right.\r\n     l = l + 1\r\n\r\n   * If sum > target:\r\n     We need a smaller sum.\r\n     Move r to the left.\r\n     r = r - 1\r\n\r\n4. Keep moving the pointers until the answer is found.\r\n\r\nWhy does moving the pointers work?\r\n\r\nBecause the array is sorted.\r\n\r\n* Moving l to the right gives us a larger number.\r\n* Moving r to the left gives us a smaller number.\r\n\r\nComplexity:\r\nTime: O(N)\r\nSpace: O(1)\r\n\r\nSolution Type:\r\nTwo Pointers\r\n','','2026-09-26 06:53:19.971439',1,2,0,1,14,3),(9,'TWO SUM II — ALGORITHM\r\n\r\nGoal:\r\nFind two numbers in the sorted array that add up to target.\r\n\r\nAlgorithm:\r\n\r\n1. Start with two pointers:\r\n\r\n   * l → beginning of the array\r\n   * r → end of the array\r\n\r\n2. Add the two numbers:\r\n   sum = numbers[l] + numbers[r]\r\n\r\n3. Compare sum with target:\r\n\r\n   * If sum == target:\r\n     We found the answer.\r\n     return l + 1, r + 1\r\n\r\n   * If sum < target:\r\n     We need a bigger sum.\r\n     Move l to the right.\r\n     l = l + 1\r\n\r\n   * If sum > target:\r\n     We need a smaller sum.\r\n     Move r to the left.\r\n     r = r - 1\r\n\r\n4. Keep moving the pointers until the answer is found.\r\n\r\nWhy does moving the pointers work?\r\n\r\nBecause the array is sorted.\r\n\r\n* Moving l to the right gives us a larger number.\r\n* Moving r to the left gives us a smaller number.\r\n','','2026-09-26 07:00:39.521369',1,2,0,1,2,3),(10,'VALID PARENTHESES — ALGORITHM\r\n\r\n1. Create a mapping of closing brackets to their matching opening brackets:\r\n\r\n   {\')\': \'(\', \'}\': \'{\', \']\': \'[\'}\r\n\r\n2. Use a stack to keep track of opening brackets.\r\n\r\n3. For each character:\r\n\r\n   a. If it is an opening bracket:\r\n\r\n   * Push it onto the stack.\r\n\r\n   b. If it is a closing bracket:\r\n   i. If the stack is non-empty and its top matches:\r\n   - Pop the opening bracket.\r\n\r\n   ii. Otherwise:\r\n   - Invalid.\r\n\r\n4. After processing all characters:\r\n\r\n   a. If the stack is empty:\r\n\r\n   * Return True.\r\n\r\n   b. Otherwise:\r\n\r\n   * Return False.\r\n\r\n\r\n','','2026-09-26 07:11:07.541376',1,2,0,1,3,3),(11,'Time: O(1) for all operations Space: O(N) \r\n\r\nMINSTACK ALGORITHM\r\n\r\n1. Initialize two stacks:\r\n\r\n   a. stack\r\n\r\n   * Stores all values.\r\n\r\n   b. min_stack\r\n\r\n   * Stores the minimum value at each level.\r\n\r\n2. Push(value):\r\n\r\n   a. Add value to stack.\r\n\r\n   b. If min_stack is empty:\r\n\r\n   * Add value to min_stack.\r\n\r\n   c. Otherwise:\r\n\r\n   * Add min(previous_min, value) to min_stack.\r\n\r\n3. Pop():\r\n\r\n   a. Remove the top element from both stack and min_stack.\r\n\r\n4. Top():\r\n\r\n   a. Return the top element of stack using:\r\n   stack[-1]\r\n\r\n5. GetMin():\r\n\r\n   a. Return the top of min_stack.\r\n\r\n   b. The top of min_stack always contains the current minimum.\r\n','','2026-09-26 07:18:43.479688',1,2,0,1,12,3),(12,'The monotonic stack approach efficiently finds the next greater element for each relevant number in a single pass through `nums2`.\r\n\r\nCore Idea\r\n\r\nWe traverse `nums2` and use a stack to keep track of numbers that still need their next greater element and haven\'t found it.\r\n\r\nIf we find a greater element for those pending stack elements, we can pop them and update the result with the greater element.\r\n\r\nWhen a new number `cur` arrives, any smaller number on top of the stack has found its next greater element (`cur`), so we pop it and update the result.\r\n\r\nFor example:\r\n\r\n```text\r\nN1 = [4, 1, 2]\r\nN2 = [2, 1, 3, 4]\r\n\r\nstack = [2, 1]\r\ncurr = 3\r\n```\r\n\r\nAll the stack elements have found their next greater element, so they can all be popped here.\r\n\r\nWe use a `while` loop with the condition:\r\n\r\n```python\r\nstack[-1] < curr\r\n```\r\n\r\nuntil `2` and `1` are removed.\r\n\r\nBoth `2` and `1` share `3` as their next greater element.\r\n\r\nBut we don\'t place `3` in the stack. Why?\r\n\r\nBecause `3` doesn\'t belong to `N1`, and we don\'t need to find the greater element for `3`.\r\n\r\nOnly those elements whose greater element is still pending need to be put in the stack.\r\n\r\n```text\r\nStack = []\r\ncurr = 4\r\n```\r\n\r\n`4` exists in `N1`, so we need to put it in the stack.\r\n\r\nWe also need to find the greater element for it.\r\n\r\nUnfortunately, the `N2` list ends right after `4`, so `4` remains in the stack.\r\n','','2026-09-26 07:29:00.822071',1,3,0,1,18,3),(13,'Simple Algorithm\r\nCreate res with 0 for every day.\r\nUse a monotonic decreasing stack.\r\nStore [temperature, index] in the stack.\r\nFor each current temperature:\r\n          While the current temperature is greater than the temperature at the top of the stack:\r\n                        Pop that day.\r\n                        Calculate the number of days waited: i - idx.\r\n                         Store it in res[idx].\r\n\r\nPush the current temperature and index onto the stack.\r\nReturn res.','','2026-09-26 08:02:09.425014',1,2,0,1,23,3),(14,'','','2026-09-26 08:14:12.262468',1,1,0,1,10,3),(15,'SIMPLE ALGORITHM\r\n\r\n1. Duplicate the array:\r\n   nums = a + b\r\n   This simulates the circular array.\r\n\r\n2. Create a result array filled with -1.\r\n\r\n3. Use a monotonic decreasing stack.\r\n   Store [value, index].\r\n\r\n4. Traverse the duplicated array:\r\n   If the current number is greater than the stack top:\r\n      - Pop the smaller number.\r\n      - Current number is its next greater element.\r\n      - Store it in res.\r\n\r\n5. Push the current number and index into the stack.\r\n\r\n6. Return only the first len(a) results.','','2026-09-26 08:16:48.880141',1,2,0,1,19,3),(16,'SIMPLE ALGORITHM\r\n\r\n1. Create a result array filled with 0.\r\n\r\n2. Traverse every index of code.\r\n\r\n3. If k > 0:\r\n   - We need to add the next k elements.\r\n   - If the elements do not wrap around:\r\n      sum code[i+1 : i+k+1]\r\n   - Otherwise:\r\n      - Calculate where the index wraps using:\r\n        new_index = (i + k) % len(code)\r\n      - Add the elements from i+1 to the end.\r\n      - Add the elements from the beginning to new_index.\r\n\r\n4. If k < 0:\r\n   - We need to add the previous k elements.\r\n   - If the elements do not wrap around:\r\n      sum code[i+k : i]\r\n   - Otherwise:\r\n      - Calculate the wrapped index using:\r\n        new_index = (i + k) % len(code)\r\n      - Add the elements before i.\r\n      - Add the elements from new_index to the end.\r\n\r\n5. If k == 0:\r\n   - The result remains 0 for every position.\r\n\r\n6. Return res.\r\n| \r\n\r\nTIME COMPLEXITY\r\n\r\nO(N * K)\r\n\r\nFor every element, we calculate the sum of up to K elements.\r\n\r\nWorst case:\r\nO(N²)\r\n\r\n\r\nSPACE COMPLEXITY\r\n\r\nO(N)\r\n\r\nres takes O(N) space.\r\n\r\nThe slicing used by sum() can temporarily use O(K) space,\r\nso total auxiliary space is O(N + K), which is O(N)\r\nwhen K <= N.\r\n\r\n\r\nKEY IDEA\r\n\r\nUse modulo (%) to handle the circular wrap-around.','','2026-09-26 08:22:09.852514',1,2,0,1,28,3),(17,'','','2026-09-26 08:32:45.884860',1,1,0,1,22,3),(18,'','','2026-09-26 08:35:06.990662',1,1,0,1,6,3),(19,'SIMPLE ALGORITHM\r\n\r\n1. Set two pointers:\r\n   l = 0\r\n   r = len(letters) - 1\r\n\r\n2. Use binary search.\r\n\r\n3. Calculate the middle index:\r\n   mid = (l + r) // 2\r\n\r\n4. Compare letters[mid] with target:\r\n   - If letters[mid] > target:\r\n       Move r to the left.\r\n       r = mid - 1\r\n\r\n   - Otherwise:\r\n       Move l to the right.\r\n       l = mid + 1\r\n\r\n5. After the binary search:\r\n   - l points to the first letter greater than target.\r\n\r\n6. If l reaches the end of the array:\r\n   - Return letters[0] because the array is circular.\r\n\r\n7. Otherwise:\r\n   - Return letters[l].','','2026-09-26 08:40:54.695276',1,2,0,1,24,3),(20,'SIMPLE ALGORITHM\r\n\r\n1. Use binary search to find the first occurrence of target.\r\n   - If nums[mid] == target:\r\n      Store the possible position and continue searching on the left.\r\n      r = mid - 1\r\n\r\n2. Use binary search again to find the last occurrence of target.\r\n   - If nums[mid] == target:\r\n      Store the possible position and continue searching on the right.\r\n      l = mid + 1\r\n\r\n3. After both searches:\r\n   - first = left boundary\r\n   - second = right boundary\r\n\r\n4. If first > second:\r\n   - Target does not exist.\r\n   - Return [-1, -1]\r\n\r\n5. Otherwise:\r\n   - Return [first, second]','','2026-09-26 09:54:47.968798',1,2,0,1,5,3),(21,'SIMPLE ALGORITHM\r\n\r\n1. Set two pointers:\r\n   l = 0\r\n   r = x\r\n\r\n2. Use binary search to find the square root.\r\n\r\n3. Calculate the middle:\r\n   m = (l + r) // 2\r\n\r\n4. Compare m * m with x:\r\n   - If m * m > x:\r\n      The square is too large.\r\n      Move r to the left.\r\n\r\n   - If m * m < x:\r\n      The square is too small.\r\n      Store m as the current possible answer.\r\n      Move l to the right.\r\n\r\n   - If m * m == x:\r\n      Return m because it is the exact square root.\r\n\r\n5. When the loop ends:\r\n   - Return res, which contains the largest integer whose square is less than or equal to x.','','2026-09-26 10:00:02.223946',1,2,0,1,8,3),(22,'SIMPLE ALGORITHM\r\n\r\n1. Set two pointers:\r\n   l = 0\r\n   r = num\r\n\r\n2. Use binary search to find the square root.\r\n\r\n3. Calculate the middle:\r\n   m = (l + r) // 2\r\n\r\n4. Compare m * m with num:\r\n   - If m * m > num:\r\n      The square is too large.\r\n      Move r to the left.\r\n\r\n   - If m * m < num:\r\n      The square is too small.\r\n      Move l to the right.\r\n\r\n   - If m * m == num:\r\n      The number is a perfect square.\r\n      Return True.\r\n\r\n5. If the loop finishes without finding an exact square:\r\n   Return False.','','2026-09-26 10:03:18.317246',1,2,0,1,17,3),(23,'SIMPLE ALGORITHM\r\n\r\n1. Set two pointers:\r\n   l = 0\r\n   r = len(nums) - 1\r\n\r\n2. Initialize res with the first element:\r\n   res = nums[l]\r\n\r\n3. While l <= r:\r\n\r\n   a. If nums[l] < nums[r]:\r\n      - The current portion is already sorted.\r\n      - The smallest element is nums[l].\r\n      - Return the minimum of res and nums[l].\r\n\r\n   b. Calculate the middle:\r\n      m = (l + r) // 2\r\n\r\n   c. Update res:\r\n      res = min(nums[m], res)\r\n\r\n   d. Check which side contains the minimum:\r\n      - If nums[m] >= nums[l]:\r\n         The left portion is sorted.\r\n         Move l to m + 1.\r\n\r\n      - Otherwise:\r\n         The minimum is on the left side.\r\n         Move r to m - 1.\r\n\r\n4. Return res.','','2026-09-26 10:06:03.228565',2,3,0,1,11,3),(24,'1. Set two pointers:\r\n   l = 0\r\n   r = len(arr) - 1\r\n\r\n2. Use binary search to find the peak.\r\n\r\n3. Calculate the middle:\r\n   mid = (l + r) // 2\r\n\r\n4. Compare arr[mid] with its neighbors:\r\n\r\n   - If arr[mid] < arr[mid - 1]:\r\n      We are on the decreasing side.\r\n      Move r to the left.\r\n\r\n   - If arr[mid] < arr[mid + 1]:\r\n      We are on the increasing side.\r\n      Move l to the right.\r\n\r\n   - Otherwise:\r\n      arr[mid] is greater than both neighbors.\r\n      It is the peak.\r\n      Return mid.\r\n\r\n5. Continue until the peak is found.','','2026-09-26 10:08:50.464004',1,2,0,1,25,3),(25,'1. Set two pointers:\r\n   l = 0\r\n   r = len(nums) - 1\r\n\r\n2. Use binary search to find a peak element.\r\n\r\n3. Calculate the middle:\r\n   m = (l + r) // 2\r\n\r\n4. Compare nums[m] with its neighbors:\r\n\r\n   - If m > 0 and nums[m] < nums[m - 1]:\r\n      The left neighbor is greater.\r\n      Move r to the left.\r\n      r = m - 1\r\n\r\n   - Else if m < len(nums) - 1 and nums[m] < nums[m + 1]:\r\n      The right neighbor is greater.\r\n      Move l to the right.\r\n      l = m + 1\r\n\r\n   - Otherwise:\r\n      nums[m] is greater than its available neighbors.\r\n      It is a peak.\r\n      Return m.\r\n\r\n5. Continue until a peak is found.','','2026-09-26 10:10:57.745662',1,2,0,1,13,3),(26,'1. Set two pointers:\r\n   l = 0\r\n   r = len(nums) - 1\r\n\r\n2. Use binary search.\r\n\r\n3. Calculate the middle:\r\n   mid = (l + r) // 2\r\n\r\n4. If nums[mid] == target:\r\n   Return mid.\r\n\r\n5. Check which half is sorted:\r\n\r\n   - If nums[l] <= nums[mid]:\r\n      The left half is sorted.\r\n\r\n      If nums[l] <= target < nums[mid]:\r\n         Target is inside the left half.\r\n         Move r to mid - 1.\r\n\r\n      Otherwise:\r\n         Target is in the right half.\r\n         Move l to mid + 1.\r\n\r\n   - Otherwise:\r\n      The right half is sorted.\r\n\r\n      If nums[r] >= target > nums[mid]:\r\n         Target is inside the right half.\r\n         Move l to mid + 1.\r\n\r\n      Otherwise:\r\n         Target is in the left half.\r\n         Move r to mid - 1.\r\n\r\n6. Continue until the target is found or l > r.\r\n\r\n7. If the target is not found:\r\n   Return -1.','','2026-09-26 10:12:57.701105',1,2,0,1,4,3),(27,'1. Set the possible eating speeds:\r\n   l = 1\r\n   r = max(piles)\r\n\r\n2. Set res to the maximum possible speed:\r\n   res = r\r\n\r\n3. Use binary search to find the minimum valid eating speed.\r\n\r\n4. Calculate the middle speed:\r\n   m = (l + r) // 2\r\n\r\n5. Calculate the total hours needed at speed m:\r\n   - For every pile:\r\n      hrs = hrs + ceil(i / m)\r\n\r\n6. Compare the required hours with h:\r\n\r\n   - If hrs <= h:\r\n      The speed is fast enough.\r\n      Try a smaller speed.\r\n      Move r to m - 1.\r\n      Update res = min(res, m).\r\n\r\n   - If hrs > h:\r\n      The speed is too slow.\r\n      Need a higher speed.\r\n      Move l to m + 1.\r\n\r\n7. Continue binary search until l > r.\r\n\r\n8. Return res.','','2026-09-26 10:16:28.825886',1,3,0,1,26,3),(28,'1. Find the possible range of ship capacity:\r\n   l = max(weights)\r\n   r = sum(weights)\r\n\r\n2. Set res to the total weight:\r\n   res = total\r\n\r\n3. Use binary search to find the minimum valid capacity.\r\n\r\n4. Calculate the middle capacity:\r\n   m = (l + r) // 2\r\n\r\n5. Calculate how many days are needed with capacity m:\r\n   - Start with:\r\n      curr_sum = 0\r\n      day = 1\r\n\r\n   - Traverse each weight:\r\n      Add the weight to curr_sum.\r\n\r\n      If curr_sum > m:\r\n         Start a new day.\r\n         Increment day.\r\n         Set curr_sum to the current weight.\r\n\r\n6. Compare the required days with the given days:\r\n\r\n   - If day <= days:\r\n      The capacity is sufficient.\r\n      Try a smaller capacity.\r\n      Move r to m - 1.\r\n      Update res.\r\n\r\n   - If day > days:\r\n      The capacity is too small.\r\n      Increase the capacity.\r\n      Move l to m + 1.\r\n\r\n7. Continue until l > r.\r\n\r\n8. Return res.','','2026-09-26 10:20:21.689450',1,2,0,1,27,3);
/*!40000 ALTER TABLE `recall_app_problemreview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recall_app_reviewhistory`
--

DROP TABLE IF EXISTS `recall_app_reviewhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recall_app_reviewhistory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `understanding` int NOT NULL,
  `reviewed_at` datetime(6) NOT NULL,
  `problem_review_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recall_app_reviewhis_problem_review_id_61ccc55e_fk_recall_ap` (`problem_review_id`),
  CONSTRAINT `recall_app_reviewhis_problem_review_id_61ccc55e_fk_recall_ap` FOREIGN KEY (`problem_review_id`) REFERENCES `recall_app_problemreview` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recall_app_reviewhistory`
--

LOCK TABLES `recall_app_reviewhistory` WRITE;
/*!40000 ALTER TABLE `recall_app_reviewhistory` DISABLE KEYS */;
INSERT INTO `recall_app_reviewhistory` VALUES (13,1,'2026-09-26 06:27:49.284387',4),(14,2,'2026-09-26 06:33:03.894316',4),(15,4,'2026-09-26 06:34:06.953230',4),(16,1,'2026-09-26 06:36:59.615067',5),(17,1,'2026-09-26 06:56:00.390317',8),(18,1,'2026-09-26 07:06:53.504772',9),(19,1,'2026-09-26 07:12:33.995819',10),(20,1,'2026-09-26 07:19:15.389789',11),(21,1,'2026-09-26 07:29:49.331356',12),(22,1,'2026-09-26 07:55:22.822068',12),(23,1,'2026-09-26 08:02:09.469518',13),(24,1,'2026-09-26 08:03:36.684800',13),(25,1,'2026-09-26 08:18:01.113303',15),(26,1,'2026-09-26 08:22:09.910941',16),(27,1,'2026-09-26 08:24:48.190558',16),(28,1,'2026-09-26 08:42:00.302079',19),(29,1,'2026-09-26 09:55:11.386640',20),(30,1,'2026-09-26 10:00:56.779554',21),(31,1,'2026-09-26 10:03:44.124649',22),(32,1,'2026-09-26 10:06:14.770449',23),(33,2,'2026-09-26 10:06:20.406107',23),(34,1,'2026-09-26 10:09:10.052459',24),(35,1,'2026-09-26 10:11:14.791002',25),(36,1,'2026-09-26 10:13:33.342818',26),(37,1,'2026-09-26 10:16:34.451231',27),(38,1,'2026-09-26 10:18:17.444952',27),(39,1,'2026-09-26 10:20:37.081884',28);
/*!40000 ALTER TABLE `recall_app_reviewhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recall_app_solution`
--

DROP TABLE IF EXISTS `recall_app_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recall_app_solution` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `code` longtext NOT NULL,
  `explanation` longtext NOT NULL,
  `problem_review_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recall_app_solution_problem_review_id_2d5b8df3_fk_recall_ap` (`problem_review_id`),
  CONSTRAINT `recall_app_solution_problem_review_id_2d5b8df3_fk_recall_ap` FOREIGN KEY (`problem_review_id`) REFERENCES `recall_app_problemreview` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recall_app_solution`
--

LOCK TABLES `recall_app_solution` WRITE;
/*!40000 ALTER TABLE `recall_app_solution` DISABLE KEYS */;
INSERT INTO `recall_app_solution` VALUES (1,'d','dewd','we',1),(2,'Two-Pointer 0(n)','curr_s = sum(nums[:k])              # calculate sum for first window\r\nmax_s = curr_s\r\n\r\nfor i in range(0, len(nums) - k):\r\n    tail = a[i]\r\n    head = a[i + k]\r\n\r\n    curr_s = curr_s + head - tail\r\n    max_s = max(max_s, curr_s)\r\n\r\nreturn max_s','',2),(3,'O(n)','class Solution:\r\n    def lengthOfLongestSubstring(self, s: str) -> int:\r\n        l=0\r\n        r=0\r\n        seen=set()\r\n        max_len=0\r\n        for r in range(0,len(s)):\r\n\r\n            while s[r] in seen:\r\n                seen.remove(s[l])\r\n                l = l +1\r\n            seen.add(s[r])\r\n            max_len = max(max_len,len(s[l:r+1]))\r\n        return max_len','',3),(4,'Two-pointer 0(n)','class Solution:\r\n    def maxProfit(self, prices: List[int]) -> int:\r\n        max_profit=0\r\n        buy=0\r\n        sell=1\r\n        while sell <= len(prices) -1:\r\n\r\n            if prices[sell] > prices[buy]:\r\n                profit = prices[sell] - prices[buy]\r\n                max_profit = max(max_profit,profit)\r\n                sell = sell + 1\r\n            \r\n            else:\r\n                buy=sell\r\n                sell = sell + 1\r\n        return max_profit','',4),(6,'Hashing + FrequencyCount','from collections import defaultdict\r\nclass Solution:\r\n    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:\r\n        df_dict = defaultdict(list)\r\n        for word in strs:\r\n            char_c = [0] * 26\r\n            for c in word:\r\n                char_c[ord(c) - ord(\'a\')] += 1\r\n            key = tuple(char_c)\r\n            df_dict[key].append(word)\r\n        return list(df_dict.values())','',5),(7,'Prefix + Postfix product solution ','class Solution:\r\n    def productExceptSelf(self, nums: List[int]) -> List[int]:\r\n        l=1\r\n        r=1\r\n        prefix=[1] * len(nums)\r\n        postfix=[1] * len(nums)\r\n        for i in range(0,len(nums)):\r\n            j = -i - 1\r\n            prefix[i] = l\r\n            postfix[j] = r\r\n            l = l * nums[i]\r\n            r = r * nums[j]\r\n        return [x*y for x,y in zip(prefix,postfix)]','This is a Prefix + Postfix Product solution.\r\n\r\nSolution Type\r\n\r\nPattern: Prefix/Suffix\r\nTechnique: Two-pass / simultaneous left-right traversal\r\n\r\nYou calculate:\r\n\r\nprefix[i] = product of everything to the left of i\r\npostfix[i] = product of everything to the right of i',6),(8,'Hash Map + Bucket Sort ','class Solution:\r\n\r\n    def topKFrequent(self, nums: List[int], k: int) -> List[int]:\r\n\r\n        def_dict = {}\r\n\r\n        for i in range(0, len(nums) + 1):\r\n            def_dict[i] = []\r\n\r\n        count_dict = Counter(nums)\r\n\r\n        for key, v in count_dict.items():\r\n            def_dict[v].append(key)\r\n\r\n        res = []','def_dict[i] = [] is needed because each frequency i can have multiple elements. Therefore, the value must be a list so we can do:\r\n\r\ndef_dict[v].append(key)\r\n\r\nIf we used only a single value instead of a list, we couldn\'t store multiple numbers having the same frequency.',7),(10,'Two Pointers / Sorted Array','class Solution:\r\n    def twoSum(self, numbers: List[int], target: int) -> List[int]:\r\n\r\n        l = 0\r\n        r = len(numbers) - 1\r\n\r\n        while l < r:\r\n\r\n            sum_ = numbers[l] + numbers[r]\r\n\r\n            if sum_ == target:\r\n                return l + 1, r + 1\r\n\r\n            if sum_ < target:\r\n                l = l + 1\r\n\r\n            if sum_ > target:\r\n                r = r - 1','TWO SUM II — ALGORITHM\r\n\r\nGoal:\r\nFind two numbers in the sorted array that add up to target.\r\n\r\nAlgorithm:\r\n\r\n1. Start with two pointers:\r\n\r\n   * l → beginning of the array\r\n   * r → end of the array\r\n\r\n2. Add the two numbers:\r\n   sum = numbers[l] + numbers[r]\r\n\r\n3. Compare sum with target:\r\n\r\n   * If sum == target:\r\n     We found the answer.\r\n     return l + 1, r + 1\r\n\r\n   * If sum < target:\r\n     We need a bigger sum.\r\n     Move l to the right.\r\n     l = l + 1\r\n\r\n   * If sum > target:\r\n     We need a smaller sum.\r\n     Move r to the left.\r\n     r = r - 1\r\n\r\n4. Keep moving the pointers until the answer is found.\r\n\r\nWhy does moving the pointers work?\r\n\r\nBecause the array is sorted.\r\n\r\n* Moving l to the right gives us a larger number.\r\n* Moving r to the left gives us a smaller number.\r\n\r\n\r\n\r\n\r\n',8),(11,'Naive Brute Force approach |  n × n × n = O(n³)','class Solution:\r\n    def threeSum(self, nums: list[int]) -> list[list[int]]:\r\n        res=[]\r\n        for i in range(0,len(nums)):\r\n            target = 0 - nums[i]\r\n            for j in range(0,len(nums)):\r\n                for k in range(0,len(nums)):\r\n                    if i!=j and j!=k and i!=k:\r\n                        if nums[j] + nums[k] == target:\r\n                            res.append(sorted([nums[j],nums[k],nums[i]]))\r\n \r\n        return list(set(tuple(x) for x in res))  \r\n','Try every possible combination of 3 different elements.',9),(12,'Solution Type: Two Pointers | Time:  O(N²) Space: O(N) ','class Solution:\r\n\r\n    def threeSum(self, nums: list[int]) -> list[list[int]]:\r\n\r\n        nums = sorted(nums)\r\n\r\n        res = []\r\n\r\n        for i in range(0, len(nums)):\r\n\r\n            if i > 0 and nums[i-1] == nums[i]:\r\n                continue\r\n\r\n            if nums[i] > 0:\r\n                break\r\n\r\n            l = i + 1\r\n            h = len(nums) - 1\r\n\r\n            while l < h:\r\n\r\n                if nums[l] + nums[h] + nums[i] == 0:\r\n\r\n                    res.append([nums[l], nums[h], nums[i]])\r\n\r\n                    l = l + 1\r\n                    h = h - 1\r\n\r\n                    while l < h and nums[l] == nums[l-1]:\r\n                        l = l + 1\r\n\r\n                    while l < h and nums[h] == nums[h+1]:\r\n                        h = h - 1\r\n\r\n                if nums[l] + nums[h] + nums[i] > 0:\r\n                    h = h - 1\r\n\r\n                if nums[l] + nums[h] + nums[i] < 0:\r\n                    l = l + 1\r\n\r\n        return res','',9),(13,'Stack + Hash Map','class Solution:\r\n\r\n    def isValid(self, s: str) -> bool:\r\n\r\n        char_pair = {\r\n            \')\': \'(\',\r\n            \'}\': \'{\',\r\n            \']\': \'[\'\r\n        }\r\n\r\n        stack_s = []\r\n\r\n        for i in s:\r\n\r\n            if i not in char_pair:\r\n                stack_s.append(i)\r\n\r\n            if i in char_pair:\r\n                if stack_s != [] and stack_s[-1] == char_pair[i]:\r\n                    stack_s.pop()\r\n                else:\r\n                    stack_s.append(i)\r\n\r\n        if stack_s == []:\r\n            return True\r\n\r\n        return False','Pattern:\r\nOpening bracket → push\r\nClosing bracket → check top → pop if matching.',10),(14,'Solution Type: Stack + Auxiliary Stack','class MinStack:\r\n\r\n    def __init__(self):\r\n\r\n        self.stack = []\r\n        self.min_stack = []\r\n\r\n    def push(self, value: int) -> None:\r\n\r\n        self.stack.append(value)\r\n\r\n        if self.min_stack == []:\r\n            self.min_stack.append(value)\r\n\r\n        else:\r\n            temp = min(self.min_stack[-1], value)\r\n            self.min_stack.append(temp)\r\n\r\n    def pop(self) -> None:\r\n\r\n        self.stack.pop()\r\n        self.min_stack.pop()\r\n\r\n    def top(self) -> int:\r\n\r\n        return (self.stack[-1])\r\n\r\n    def getMin(self) -> int:\r\n\r\n        return self.min_stack[-1]','',11),(15,'Time: O(N × M) |  Space: O(N) | Hash Map + Brute Force / Linear Search','class Solution:\r\n\r\n    def nextGreaterElement(self, nums1: List[int], nums2: List[int]) -> List[int]:\r\n\r\n        hash_nums1 = {}\r\n\r\n        for i, c in enumerate(nums1):\r\n            hash_nums1[c] = i\r\n\r\n        res = [-1] * len(nums1)\r\n\r\n        for i in range(0, len(nums2)):\r\n\r\n            if nums2[i] in hash_nums1:\r\n\r\n                for j in range(i + 1, len(nums2)):\r\n\r\n                    if nums2[j] > nums2[i]:\r\n                        res[hash_nums1[nums2[i]]] = nums2[j]\r\n                        break\r\n\r\n        return res','',12),(16,'Time: O(N + M) | Space: O(N + M) | Monotonic Stack','class Solution:\r\n\r\n    def nextGreaterElement(self, nums1: List[int], nums2: List[int]) -> List[int]:\r\n\r\n        hash_nums1 = {}\r\n\r\n        res = [-1] * len(nums1)\r\n\r\n        stack = []\r\n\r\n        for i in range(0, len(nums1)):\r\n\r\n            hash_nums1[nums1[i]] = i\r\n\r\n        for i in range(0, len(nums2)):\r\n\r\n            while stack and stack[-1] < nums2[i]:\r\n\r\n                if stack[-1] in hash_nums1:\r\n\r\n                    res[hash_nums1[stack[-1]]] = nums2[i]\r\n\r\n                stack.pop()\r\n\r\n            stack.append(nums2[i])\r\n\r\n        return res','',12),(17,'Monotonic Stack | Time 0(n) | Space 0(n)','class Solution:\r\n\r\n    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:\r\n\r\n        res = [0] * len(temperatures)\r\n\r\n        stack_s = []\r\n\r\n        for i in range(0, len(temperatures)):\r\n\r\n            while stack_s and stack_s[-1][0] < temperatures[i]:\r\n\r\n                temp, idx = stack_s.pop()\r\n\r\n                res[idx] = i - idx\r\n\r\n            stack_s.append([temperatures[i], i])\r\n\r\n        return res','',13),(18,'Stack | Time 0(n) | Space 0(n)','class Solution:\r\n    def evalRPN(self, tokens: List[str]) -> int:\r\n        stack=[]\r\n        for i in tokens:\r\n            if i==\"*\":\r\n                res= stack.pop() * stack.pop()\r\n                stack.append(res)\r\n            elif i==\"+\":\r\n\r\n                res= stack.pop() + stack.pop()\r\n                stack.append(res)\r\n\r\n            elif i==\"/\":\r\n                f = stack.pop()\r\n                l = stack.pop()\r\n                res= l / f\r\n                stack.append(int(res))\r\n\r\n            elif i==\"-\":\r\n                f = stack.pop()\r\n                l = stack.pop()\r\n                res= l - f\r\n                stack.append(int(res))\r\n            \r\n            else:\r\n                stack.append(int(i))\r\n        return stack[0]','',14),(19,'Monotonic Stack + Circular Array | Time o(n) | Space o(n)','class Solution:\r\n\r\n    def nextGreaterElements(self, nums: List[int]) -> List[int]:\r\n\r\n        a = nums\r\n\r\n        b = nums\r\n\r\n        nums = a + b\r\n\r\n        res = [-1] * len(nums)\r\n\r\n        stack = []\r\n\r\n        for i in range(0, len(nums)):\r\n\r\n            while stack and stack[-1][0] < nums[i]:\r\n\r\n                x, y = stack.pop()\r\n\r\n                res[y] = nums[i]\r\n\r\n            stack.append([nums[i], i])\r\n\r\n        return res[:len(a)]','',15),(20,'Brute Force + Circular Array |  TIME COMPLEXITY  O(N * K) |   Worst case: O(N²) |   SPACE COMPLEXITY  O(N)','class Solution:\r\n    def decrypt(self, code: List[int], k: int) -> List[int]:\r\n        res=[0]*len(code)\r\n        for i in range(0,len(code)):\r\n            if k > 0:\r\n                if i+k <= len(code) -1: \r\n                    res[i] = sum(code[i+1:i+k+1])\r\n                else:\r\n                    new_index = (i+ k) % len(code)\r\n                    res[i] = sum(code[i+1:]) + sum(code[0:new_index+1])\r\n            elif k < 0:\r\n                if i >=(-1) * k:\r\n                    res[i] = sum(code[i+k:i])\r\n                else:\r\n                    new_index = (i+ k) % len(code)\r\n                    res[i] = sum(code[:i]) + sum(code[new_index:])\r\n                \r\n                \r\n        return (res)\r\n \r\n        ','',16),(21,'Binary Search | Time Complexiy 0(logn) | Space Complexity O(1)','class Solution:\r\n    def search(self, nums: List[int], target: int) -> int:\r\n        l =0\r\n        r = len(nums)\r\n        while l < r:\r\n            n = l + int((r-l) / 2)\r\n            if nums[n]==target:\r\n                return n\r\n            if nums[n] > target:\r\n                r= n\r\n            else:\r\n                l=n+1\r\n        return -1','',17),(22,'Binary Search | Time o(logn) | space O(1)','class Solution:\r\n    def searchInsert(self, nums: List[int], target: int) -> int:\r\n        l = 0\r\n        r = len(nums) - 1\r\n \r\n        while l <= r:\r\n            mid = (l + r) // 2\r\n \r\n            if nums[mid] == target:\r\n                return mid\r\n \r\n            if nums[mid] < target:\r\n                l = mid + 1\r\n \r\n            if nums[mid] > target:\r\n                r = mid - 1\r\n \r\n        return l','',18),(23,'Binary Search | Time: O(log N) | Space: O(1)','class Solution:\r\n    def nextGreatestLetter(self, letters: List[str], target: str) -> str:\r\n        l=0\r\n        r=len(letters)-1\r\n        while l<=r:\r\n            mid = (l+r) // 2\r\n            \r\n            if ord(letters[mid]) > ord(target):\r\n                r = mid -1\r\n            else:\r\n                l = mid +1 \r\n        if l == len(letters):\r\n            return letters[0]\r\n\r\n        return letters[l]\r\n            \r\n\r\n\r\n        ','',19),(24,'Binary Search (Find Left Boundary + Find Right Boundary) | Time: O(log N) | Space: O(1)','class Solution:\r\n    def searchRange(self, nums: List[int], target: int) -> List[int]:\r\n        l=0\r\n        r=len(nums)-1\r\n        #find first pointer\r\n        while l<=r:\r\n            mid = (l+r) // 2\r\n            if nums[mid] == target:\r\n                r = mid -1\r\n            elif nums[mid] < target:\r\n                l = mid +1\r\n            else:\r\n                r = mid -1\r\n        \r\n        first = l\r\n\r\n        #find second pointer\r\n        l=0\r\n        r=len(nums)-1\r\n        while l<=r:\r\n            mid = (l+r) // 2\r\n            if nums[mid] == target:\r\n                l = mid +1\r\n            elif nums[mid] < target:\r\n                l = mid +1\r\n            else:\r\n                r = mid -1\r\n\r\n\r\n        second = r\r\n\r\n        if first > second:\r\n            return [-1,-1]\r\n        else:\r\n            return[first,second]','',20),(25,'Binary Search |  Time: O(log N) | Space: O(1) ','class Solution:\r\n    def mySqrt(self, x: int) -> int:\r\n        l=0\r\n        r=x\r\n        while l<=r:\r\n            m = (l+r) // 2\r\n            if m*m > x:\r\n                r=m-1\r\n            elif m*m < x:\r\n                l = m +1\r\n                res= m\r\n            else:\r\n                return m\r\n        return res\r\n        \r\n        ','',21),(26,'Binary Search | Time: O(log N) | Space: O(1)','class Solution:\r\n    def isPerfectSquare(self, num: int) -> bool:\r\n        l = 0\r\n        r = num\r\n        while l<=r:\r\n            m = (l+r) // 2\r\n            if m*m > num:\r\n                r=m-1\r\n            elif m*m < num:\r\n                l = m +1\r\n            else:\r\n                return True\r\n        return False','',22),(27,'Binary Search | Time: O(log N) | Space: O(1)','class Solution:\r\n    def findMin(self, nums: list[int]) -> int:\r\n        l = 0\r\n        r = len(nums)-1\r\n        res = nums[l]\r\n        while l <= r:\r\n            if nums[l] < nums[r]:\r\n                return min(res,nums[l])\r\n                break\r\n\r\n            m = (l + r) // 2\r\n            res = min(nums[m],res)\r\n            if nums[m] >= nums[l]:\r\n                l = m + 1\r\n            else:\r\n                r = m - 1\r\n        return res\r\n            \r\n        ','',23),(28,'Binary Search | Time: O(log N) | Space: O(1)','class Solution:\r\n    def peakIndexInMountainArray(self, arr: list[int]) -> int:\r\n\r\n        l = 0\r\n        r = len(arr)-1\r\n\r\n        while l<=r:\r\n            mid = (l+r) // 2\r\n            if arr[mid] < arr[mid-1]:\r\n                r = r -1\r\n            elif arr[mid] < arr[mid + 1]:\r\n                l = mid +1\r\n            else:\r\n                return mid \r\n\r\n\r\n\r\n\r\n\r\n        ','',24),(29,'Binary Search | Time: O(log N) | Space: O(1)','class Solution:\r\n    def findPeakElement(self, nums: list[int]) -> int:\r\n        l = 0\r\n        r = len(nums)-1\r\n        while l<=r:\r\n            m = (l+r) // 2\r\n            if m > 0 and nums[m] < nums[m-1]:\r\n                r= m -1\r\n            elif m < len(nums) -1 and nums[m] < nums[m+1]  :\r\n                l = m +1\r\n            else:\r\n                return m\r\n\r\n\r\n        ','',25),(30,'Binary Search + Rotated Sorted Array | Time: O(log N) | Space: O(1)','class Solution:\r\n    def search(self, nums: list[int], target: int) -> int:\r\n        l = 0\r\n        r = len(nums)-1\r\n        while l<=r:\r\n          mid = (l+r) // 2\r\n          if nums[mid] == target:\r\n            return mid\r\n\r\n          if nums[l]<=nums[mid]:\r\n            #left sorted\r\n            if nums[l] <= target < nums[mid]:\r\n                r=mid -1\r\n            else:\r\n                l = mid +1\r\n            \r\n\r\n\r\n          else:\r\n            #right sorted\r\n            if nums[r] >= target > nums[mid]:\r\n                l = mid +1\r\n            else:\r\n                r=mid-1\r\n        return -1\r\n            \r\n\r\n        \r\n\r\n\r\n            \r\n\r\n\r\n        ','',26),(31,'Binary Search on Answer | Time: O(N log M) | Space: O(1) | N = number of piles M = maximum pile size','class Solution:\r\n    def minEatingSpeed(self, piles: list[int], h: int) -> int:\r\n        l = 1\r\n        r= max(piles)\r\n        res = r\r\n        while l <= r:\r\n            hrs=0\r\n            m = (l+r) // 2\r\n            for  i in piles:\r\n                hrs = hrs  + ceil(i / m)\r\n\r\n            if hrs <=h:\r\n                r = m -1\r\n                res = min(res,m)\r\n\r\n            if hrs > h:\r\n                l = m +1\r\n        return res','',27),(32,'Binary Search on Answer | Time: O(N log S) | Space: O(1)  N = number of packages S = sum of all weights','class Solution:\r\n    def shipWithinDays(self, weights: list[int], days: int) -> int:\r\n        total = sum(weights)\r\n        l = max(weights)\r\n        r = total\r\n        res= total\r\n        while l<=r:\r\n            m = (l+r) // 2\r\n            curr_sum = 0\r\n            day = 1\r\n            for  i in weights:\r\n                curr_sum = curr_sum + i\r\n                if curr_sum > m:\r\n                    day = day +1\r\n                    curr_sum=i\r\n            if day <= days:\r\n                r = m -1\r\n                res = min(m,res)\r\n            else:\r\n                l = m +1\r\n        return res\r\n\r\n        \r\n        ','',28);
/*!40000 ALTER TABLE `recall_app_solution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'recall_app'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-26 10:32:40
