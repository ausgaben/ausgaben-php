-- MySQL dump 9.11
--
-- Host: localhost    Database: ausgaben
-- ------------------------------------------------------
-- Server version	4.0.20

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS account;
CREATE TABLE account (
  account_id int(11) unsigned NOT NULL auto_increment,
  name tinytext NOT NULL,
  description text NOT NULL,
  summarize_months tinyint(1) unsigned NOT NULL default '1',
  PRIMARY KEY  (account_id)
) TYPE=MyISAM;

--
-- Table structure for table `spending`
--

DROP TABLE IF EXISTS spending;
CREATE TABLE spending (
  spending_id int(11) unsigned NOT NULL auto_increment,
  type tinyint(1) unsigned NOT NULL default '1',
  year int(4) unsigned NOT NULL default '0',
  month tinyint(2) unsigned NOT NULL default '0',
  day tinyint(2) unsigned NOT NULL default '0',
  spendinggroup_id int(11) unsigned NOT NULL default '0',
  description text NOT NULL,
  user_id int(11) unsigned NOT NULL default '0',
  account_id int(11) unsigned NOT NULL default '0',
  value tinytext NOT NULL,
  booked tinyint(1) unsigned NOT NULL default '1',
  spendingmethod_id tinyint(4) unsigned NOT NULL default '0',
  timestamp timestamp(14) NOT NULL,
  PRIMARY KEY  (spending_id)
) TYPE=MyISAM;

--
-- Table structure for table `spendinggroup`
--

DROP TABLE IF EXISTS spendinggroup;
CREATE TABLE spendinggroup (
  spendinggroup_id int(11) unsigned NOT NULL auto_increment,
  name tinytext NOT NULL,
  description text NOT NULL,
  PRIMARY KEY  (spendinggroup_id)
) TYPE=MyISAM;

--
-- Table structure for table `spendingmethod`
--

DROP TABLE IF EXISTS spendingmethod;
CREATE TABLE spendingmethod (
  spendingmethod_id tinyint(4) unsigned NOT NULL auto_increment,
  name tinytext NOT NULL,
  icon tinytext NOT NULL,
  PRIMARY KEY  (spendingmethod_id),
  UNIQUE KEY spendingmethod_id (spendingmethod_id)
) TYPE=MyISAM;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  user_id int(11) unsigned NOT NULL auto_increment,
  email tinytext NOT NULL,
  password varchar(32) NOT NULL default '',
  prename tinytext NOT NULL,
  name tinytext NOT NULL,
  admin tinyint(4) unsigned NOT NULL default '0',
  last_account_id int(11) unsigned NOT NULL default '0',
  last_login varchar(14) default NULL,
  avatar tinytext NOT NULL,
  locale varchar(16) NOT NULL default '',
  spendingmailer_notify tinyint(1) unsigned NOT NULL default '1',
  spendingmailer_cc tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (user_id)
) TYPE=MyISAM;

--
-- Table structure for table `user2account`
--

DROP TABLE IF EXISTS user2account;
CREATE TABLE user2account (
  user_id int(11) unsigned NOT NULL default '0',
  account_id int(11) unsigned NOT NULL default '0'
) TYPE=MyISAM;

