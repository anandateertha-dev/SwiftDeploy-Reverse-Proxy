-- CreateTable
CREATE TABLE `user_db` (
    `userId` VARCHAR(191) NOT NULL,
    `userName` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `user_db_userName_key`(`userName`),
    UNIQUE INDEX `user_db_email_key`(`email`),
    PRIMARY KEY (`userId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `project_model` (
    `projectId` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `projectName` VARCHAR(191) NOT NULL,
    `gitURL` VARCHAR(191) NOT NULL,
    `subDomain` VARCHAR(191) NULL,
    `customDomain` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`projectId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `deployment_model` (
    `deploymentId` VARCHAR(191) NOT NULL,
    `projectId` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`deploymentId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `project_model` ADD CONSTRAINT `project_model_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user_db`(`userId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `deployment_model` ADD CONSTRAINT `deployment_model_projectId_fkey` FOREIGN KEY (`projectId`) REFERENCES `project_model`(`projectId`) ON DELETE RESTRICT ON UPDATE CASCADE;
