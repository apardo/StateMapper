SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE `amounts` (
  `id` bigint(20) NOT NULL,
  `originalValue` bigint(20) NOT NULL,
  `originalUnit` varchar(4) NOT NULL,
  `value` bigint(20) NOT NULL,
  `unit` varchar(4) NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `bulletins` (
  `id` bigint(11) NOT NULL,
  `external_id` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `fetched` datetime DEFAULT NULL,
  `attempts` int(11) NOT NULL DEFAULT '0',
  `fixes` int(11) NOT NULL DEFAULT '0',
  `last_error` longtext,
  `parsed` datetime DEFAULT NULL,
  `bulletin_schema` varchar(15) NOT NULL,
  `format` varchar(40) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `done` datetime DEFAULT NULL,
  `status` varchar(25) NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `bulletin_uses_bulletin` (
  `id` bigint(11) NOT NULL,
  `bulletin_id` bigint(11) NOT NULL,
  `bulletin_in` bigint(11) NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `entities` (
  `id` bigint(11) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `subtype` varchar(50) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `fetched` datetime NOT NULL,
  `created` date DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `national_id` varchar(30) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `keywords` varchar(400) NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `locations` (
  `id` bigint(20) NOT NULL,
  `original` varchar(200) NOT NULL,
  `label` varchar(200) DEFAULT NULL,
  `country` varchar(5) DEFAULT NULL,
  `state` bigint(20) DEFAULT NULL,
  `county` bigint(20) DEFAULT NULL,
  `city` bigint(20) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `housenumber` varchar(8) DEFAULT NULL,
  `postalcode` varchar(8) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `relevance` smallint(6) DEFAULT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `location_cities` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `county_id` bigint(20) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `country` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `location_counties` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `state_id` bigint(20) NOT NULL,
  `country` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `location_states` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `country` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `locks` (
  `id` bigint(20) NOT NULL,
  `target` varchar(30) NOT NULL,
  `created` datetime NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `names` (
  `name` varchar(80) NOT NULL,
  `type` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `options` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` longtext NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `precepts` (
  `id` bigint(20) NOT NULL,
  `bulletin_id` bigint(20) NOT NULL,
  `issuing_id` bigint(20) DEFAULT NULL,
  `title` longtext,
  `text` longtext NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `spiders` (
  `id` int(11) NOT NULL,
  `bulletin_schema` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `pid` bigint(20) DEFAULT NULL,
  `date_back` date DEFAULT NULL,
  `workers_count` mediumint(9) NOT NULL,
  `cpu_rate` tinyint(4) NOT NULL,
  `extract` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL,
  `precept_id` bigint(20) NOT NULL,
  `target_id` bigint(20) DEFAULT NULL,
  `type` varchar(30) NOT NULL,
  `action` varchar(30) NOT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `amount` bigint(20) DEFAULT NULL,
  `related_id` bigint(20) DEFAULT NULL,
  `contract_type_id` bigint(6) DEFAULT NULL,
  `sector_id` bigint(6) DEFAULT NULL,
  `note` text
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `status_has_service` (
  `id` int(11) NOT NULL,
  `status_id` bigint(20) NOT NULL,
  `service_id` bigint(20) NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;

CREATE TABLE `workers` (
  `id` int(11) NOT NULL,
  `spider_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `status` varchar(20) NOT NULL,
  `pid` bigint(20) DEFAULT NULL,
  `started` datetime NOT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1;


ALTER TABLE `amounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `originalValue` (`originalValue`),
  ADD KEY `value` (`value`),
  ADD KEY `unit` (`unit`);

ALTER TABLE `bulletins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bulletin_schema` (`bulletin_schema`,`date`),
  ADD KEY `external_id` (`external_id`),
  ADD KEY `created` (`created`);

ALTER TABLE `bulletin_uses_bulletin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bulletin_id` (`bulletin_id`),
  ADD KEY `bulletin_in` (`bulletin_in`);

ALTER TABLE `entities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `type` (`type`),
  ADD KEY `name` (`name`),
  ADD KEY `last_name` (`first_name`),
  ADD KEY `name_2` (`name`),
  ADD KEY `last_name_2` (`first_name`),
  ADD KEY `country` (`country`),
  ADD KEY `type_2` (`type`);

ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `location_cities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `country_id` (`country`,`name`(20)),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `county_id` (`county_id`);

ALTER TABLE `location_counties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `country_id` (`country`,`name`(20)),
  ADD KEY `state_id` (`state_id`);

ALTER TABLE `location_states`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_id` (`country`,`name`(20));

ALTER TABLE `locks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `target` (`target`);

ALTER TABLE `names`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `options`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `precepts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `issuing_id` (`issuing_id`),
  ADD KEY `bulletin_id` (`bulletin_id`);

ALTER TABLE `spiders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bulletin_schema` (`bulletin_schema`),
  ADD KEY `status` (`status`);

ALTER TABLE `statuses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `precept_id` (`precept_id`),
  ADD KEY `target_id` (`target_id`),
  ADD KEY `contract_type_id` (`contract_type_id`),
  ADD KEY `sector_id` (`sector_id`);

ALTER TABLE `status_has_service`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status_id` (`status_id`),
  ADD KEY `service_id` (`service_id`);

ALTER TABLE `workers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `status` (`status`);


ALTER TABLE `amounts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1985;
ALTER TABLE `bulletins`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=489300;
ALTER TABLE `bulletin_uses_bulletin`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=483801;
ALTER TABLE `entities`
  MODIFY `id` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8695;
ALTER TABLE `locations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
ALTER TABLE `location_cities`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
ALTER TABLE `location_counties`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `location_states`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `locks`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=585;
ALTER TABLE `options`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76078;
ALTER TABLE `precepts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6346;
ALTER TABLE `spiders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
ALTER TABLE `statuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8473;
ALTER TABLE `status_has_service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=603;
ALTER TABLE `workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;
