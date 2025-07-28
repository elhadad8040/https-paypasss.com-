-- PayPass Database Setup
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS `joudk_pay1` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE `joudk_pay1`;

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL UNIQUE,
  `phone` varchar(255) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL UNIQUE,
  `role` enum('owner','user') DEFAULT 'user',
  `referralCode` varchar(255) UNIQUE,
  `referredById` int(11) NULL,
  `otp` varchar(255) NULL,
  `otpExpires` datetime NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_referredById` (`referredById`),
  CONSTRAINT `fk_users_referredById` FOREIGN KEY (`referredById`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Cars table
CREATE TABLE IF NOT EXISTS `cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `make` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `year` int(4) NOT NULL,
  `licensePlate` varchar(255) NOT NULL UNIQUE,
  `color` varchar(255) NULL,
  `type` enum('sedan','suv','truck','van','coupe','convertible','wagon','other') NOT NULL,
  `size` enum('small','medium','large') NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  CONSTRAINT `fk_cars_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Packages table
CREATE TABLE IF NOT EXISTS `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `basePrice` decimal(10,2) NOT NULL,
  `originalPrice` decimal(10,2) NOT NULL,
  `features` text NULL,
  `popular` boolean DEFAULT false,
  `washes` int(11) NOT NULL,
  `savings` decimal(10,2) NOT NULL,
  `duration` int(11) NOT NULL COMMENT 'Duration in days',
  `size` enum('small','medium','large') NOT NULL COMMENT 'Required car size for this package',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Washing places table
CREATE TABLE IF NOT EXISTS `washing_places` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `hours` varchar(255) NOT NULL,
  `email` varchar(255) NULL,
  `location` varchar(255) DEFAULT 'Point',
  `city` varchar(255) NULL,
  `rating` decimal(3,2) NULL,
  `customers` int(11) NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User packages table
CREATE TABLE IF NOT EXISTS `user_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `carSize` enum('sedan','suv','truck','van','luxury') NOT NULL COMMENT 'Car size category for this package',
  `barcode` varchar(255) NOT NULL UNIQUE COMMENT 'barcode/QR code string',
  `barcodeImage` text NULL COMMENT 'base64 or URL to QR image',
  `washesLeft` int(11) NOT NULL,
  `expiry` datetime NOT NULL,
  `status` enum('active','expired','used') DEFAULT 'active',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_packageId` (`packageId`),
  KEY `idx_barcode` (`barcode`),
  CONSTRAINT `fk_userPackages_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_userPackages_packageId` FOREIGN KEY (`packageId`) REFERENCES `packages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Washes table
CREATE TABLE IF NOT EXISTS `washes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `carId` int(11) NULL,
  `washingPlaceId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `ownerId` int(11) NULL COMMENT 'Owner who scanned the QR code',
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('scheduled','completed','cancelled') DEFAULT 'scheduled',
  `feedbackId` int(11) NULL,
  `tip` decimal(10,2) DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_carId` (`carId`),
  KEY `idx_washingPlaceId` (`washingPlaceId`),
  KEY `idx_packageId` (`packageId`),
  KEY `idx_ownerId` (`ownerId`),
  KEY `idx_feedbackId` (`feedbackId`),
  CONSTRAINT `fk_washes_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_washes_carId` FOREIGN KEY (`carId`) REFERENCES `cars` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_washes_washingPlaceId` FOREIGN KEY (`washingPlaceId`) REFERENCES `washing_places` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_washes_packageId` FOREIGN KEY (`packageId`) REFERENCES `packages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_washes_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Payments table
CREATE TABLE IF NOT EXISTS `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `packageId` int(11) NULL,
  `stationId` int(11) NULL COMMENT 'For tip payments',
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  `method` varchar(255) NOT NULL,
  `transactionId` varchar(255) NULL,
  `type` enum('purchase','tip') DEFAULT 'purchase',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_packageId` (`packageId`),
  KEY `idx_stationId` (`stationId`),
  CONSTRAINT `fk_payments_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payments_packageId` FOREIGN KEY (`packageId`) REFERENCES `packages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_payments_stationId` FOREIGN KEY (`stationId`) REFERENCES `washing_places` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Feedbacks table
CREATE TABLE IF NOT EXISTS `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `washId` int(11) NOT NULL,
  `washingPlaceId` int(11) NOT NULL,
  `rating` int(1) NOT NULL,
  `comment` text NULL,
  `complaint` text NULL COMMENT 'Optional complaint field',
  `photo` text NULL COMMENT 'URL or base64 string for car photo after wash',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_washId` (`washId`),
  KEY `idx_washingPlaceId` (`washingPlaceId`),
  CONSTRAINT `fk_feedbacks_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_feedbacks_washId` FOREIGN KEY (`washId`) REFERENCES `washes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_feedbacks_washingPlaceId` FOREIGN KEY (`washingPlaceId`) REFERENCES `washing_places` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_rating` CHECK (`rating` >= 1 AND `rating` <= 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notifications table
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` enum('otp','feedback','reminder','referral','general') NOT NULL,
  `message` text NOT NULL,
  `status` enum('sent','delivered','read','failed') DEFAULT 'sent',
  `relatedWashId` int(11) NULL,
  `relatedFeedbackId` int(11) NULL,
  `sentAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_userId` (`userId`),
  KEY `idx_relatedWashId` (`relatedWashId`),
  KEY `idx_relatedFeedbackId` (`relatedFeedbackId`),
  CONSTRAINT `fk_notifications_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notifications_relatedWashId` FOREIGN KEY (`relatedWashId`) REFERENCES `washes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_notifications_relatedFeedbackId` FOREIGN KEY (`relatedFeedbackId`) REFERENCES `feedbacks` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Referrals table
CREATE TABLE IF NOT EXISTS `referrals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inviterId` int(11) NOT NULL,
  `inviteeId` int(11) NULL,
  `inviteeEmail` varchar(255) NULL,
  `status` enum('pending','completed','rewarded') DEFAULT 'pending',
  `rewardGiven` boolean DEFAULT false,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inviterId` (`inviterId`),
  KEY `idx_inviteeId` (`inviteeId`),
  CONSTRAINT `fk_referrals_inviterId` FOREIGN KEY (`inviterId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_referrals_inviteeId` FOREIGN KEY (`inviteeId`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample data for packages
INSERT INTO `packages` (`name`, `basePrice`, `originalPrice`, `features`, `popular`, `washes`, `savings`, `duration`, `size`) VALUES
('Basic Wash - Small Car', 25.00, 30.00, '["Exterior wash", "Interior vacuum", "Window cleaning"]', false, 1, 5.00, 30, 'small'),
('Basic Wash - Medium Car', 30.00, 35.00, '["Exterior wash", "Interior vacuum", "Window cleaning"]', false, 1, 5.00, 30, 'medium'),
('Basic Wash - Large Car', 35.00, 40.00, '["Exterior wash", "Interior vacuum", "Window cleaning"]', false, 1, 5.00, 30, 'large'),
('Premium Package - Small Car', 45.00, 55.00, '["Exterior wash", "Interior deep clean", "Waxing", "Tire shine"]', true, 1, 10.00, 30, 'small'),
('Premium Package - Medium Car', 55.00, 65.00, '["Exterior wash", "Interior deep clean", "Waxing", "Tire shine"]', true, 1, 10.00, 30, 'medium'),
('Premium Package - Large Car', 65.00, 75.00, '["Exterior wash", "Interior deep clean", "Waxing", "Tire shine"]', true, 1, 10.00, 30, 'large'),
('Monthly Package - Small Car', 80.00, 120.00, '["4 washes per month", "Priority booking", "Free interior refresh"]', false, 4, 40.00, 30, 'small'),
('Monthly Package - Medium Car', 100.00, 140.00, '["4 washes per month", "Priority booking", "Free interior refresh"]', false, 4, 40.00, 30, 'medium'),
('Monthly Package - Large Car', 120.00, 160.00, '["4 washes per month", "Priority booking", "Free interior refresh"]', false, 4, 40.00, 30, 'large');

-- Insert sample washing places
INSERT INTO `washing_places` (`name`, `address`, `phone`, `hours`, `email`, `city`, `rating`, `customers`) VALUES
('Clean Car Center - Downtown', '123 Main Street, Downtown', '+966501234567', '8:00 AM - 10:00 PM', 'info@cleancar.com', 'Riyadh', 4.5, 150),
('Quick Wash Express', '456 King Fahd Road', '+966507654321', '7:00 AM - 11:00 PM', 'contact@quickwash.com', 'Riyadh', 4.2, 120),
('Premium Auto Care', '789 Olaya Street', '+966509876543', '9:00 AM - 9:00 PM', 'service@premiumauto.com', 'Riyadh', 4.8, 200);

-- Create admin user (password: admin123)
INSERT INTO `users` (`name`, `email`, `phone`, `password`, `username`, `role`) VALUES
('Admin User', 'admin@paypass.com', '+966501234567', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'owner');

-- Show success message
SELECT 'PayPass database setup completed successfully!' as message; 