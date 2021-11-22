<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_nutanixapi()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `nutanix` , `nutanixresources` , `nutanixboot` , `nutanixdisk` , `nutanixnic`, `nutanixhost`, `nutanixcluster`;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanix` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMUUID` VARCHAR(255) DEFAULT NULL,
        `VMSTATUS` VARCHAR(255) DEFAULT NULL,
        `VMNAME` VARCHAR(255) DEFAULT NULL,
        `VMDESC` VARCHAR(255) DEFAULT NULL,
        `VMOS` VARCHAR(255) DEFAULT NULL,
        `VMPOWERSTATE` VARCHAR(255) DEFAULT NULL,
        `VMCLUSTER` VARCHAR(255) DEFAULT NULL,
        `VMCLUSTERUUID` VARCHAR(255) DEFAULT NULL,
        `VMCLUSTERNAME` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixresources` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMUUID` VARCHAR(255) DEFAULT NULL,
        `RESTHREAD` VARCHAR(255) DEFAULT NULL,
        `RESVCPU` VARCHAR(255) DEFAULT NULL,
        `RESSOCKET` VARCHAR(255) DEFAULT NULL,
        `RESPROTECTED` VARCHAR(255) DEFAULT NULL,
        `RESMEMORY` VARCHAR(255) DEFAULT NULL,
        `RESHWTIMEZONE` VARCHAR(255) DEFAULT NULL,
        `RESHYPERVISORTYPE` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixboot` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMUUID` VARCHAR(255) DEFAULT NULL,
        `BOOTTYPE` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixdisk` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMUUID` VARCHAR(255) DEFAULT NULL,
        `DISKUUID` VARCHAR(255) DEFAULT NULL,
        `DISKTYPE` VARCHAR(255) DEFAULT NULL,
        `DISKADAPTER` VARCHAR(255) DEFAULT NULL,
        `DISKKIND` VARCHAR(255) DEFAULT NULL,
        `DISKSIZE` VARCHAR(255) DEFAULT NULL,
        `DISKSIZEMIB` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixnic` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMUUID` VARCHAR(255) DEFAULT NULL,
        `NICTYPE` VARCHAR(255) DEFAULT NULL,
        `NICUUID` VARCHAR(255) DEFAULT NULL,
        `NICVLANMODE` VARCHAR(255) DEFAULT NULL,
        `NICMACADDR` VARCHAR(255) DEFAULT NULL,
        `NICSUBNAME` VARCHAR(255) DEFAULT NULL,
        `NICACTIVE` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixhost` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `NUTANIXSRVURL`  VARCHAR(255) DEFAULT NULL,
        `HOSTUUID` VARCHAR(255) DEFAULT NULL,
        `HOSTSTATUS` VARCHAR(255) DEFAULT NULL,
        `HOSTNAME` VARCHAR(255) DEFAULT NULL,
        `HOSTCLUSTERN` VARCHAR(255) DEFAULT NULL,
        `HOSTCLUSTERID` VARCHAR(255) DEFAULT NULL,
        `HOSTSERIAL` VARCHAR(255) DEFAULT NULL,
        `HOSTIPMI` VARCHAR(255) DEFAULT NULL,
        `HOSTTYPE` VARCHAR(255) DEFAULT NULL,
        `HOSTCPU` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUSOCKET` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUNUM` VARCHAR(255) DEFAULT NULL,
        `HOSTMEMORY` VARCHAR(255) DEFAULT NULL,
        `HOSTHVVMS` VARCHAR(255) DEFAULT NULL,
        `HOSTHVIP` VARCHAR(255) DEFAULT NULL,
        `HOSTHVNAME` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `nutanixcluster` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `NUTANIXSRVURL`  VARCHAR(255) DEFAULT NULL,
        `CLUSTERUUID` VARCHAR(255) DEFAULT NULL,
        `CLUSTERSTATUS` VARCHAR(255) DEFAULT NULL,
        `CLUSTERNAME` VARCHAR(255) DEFAULT NULL,
        `CLUSTERENCRYPTION` VARCHAR(255) DEFAULT NULL,
        `CLUSTERVERBOSITY` VARCHAR(255) DEFAULT NULL,
        `CLUSTERRUNDFACTOR` VARCHAR(255) DEFAULT NULL,
        `CLUSTERARCH` VARCHAR(255) DEFAULT NULL,
        `CLUSTERAVAILABLE` VARCHAR(255) DEFAULT NULL,
        `CLUSTERBUILDTYPE` VARCHAR(255) DEFAULT NULL,
        `CLUSTERBUILDVERSION` VARCHAR(255) DEFAULT NULL,
        `CLUSTERBUILDLTS` VARCHAR(255) DEFAULT NULL,
        `CLUSTERTZ` VARCHAR(255) DEFAULT NULL,
        `CLUSTEREXTNET` VARCHAR(255) DEFAULT NULL,
        `CLUSTERINTNET` VARCHAR(255) DEFAULT NULL,
        `CLUSTEREXTIP` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
        ) ENGINE=INNODB;");

}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_nutanixapi()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `nutanix` , `nutanixresources` , `nutanixboot` , `nutanixdisk` , `nutanixnic`, `nutanixhost`, `nutanixcluster`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_nutanixapi()
{

}