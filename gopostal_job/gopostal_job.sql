--
-- Contenu de la table `jobs`
--
INSERT INTO `jobs` (`name`, `label`) VALUES
('gopostal', 'GoPostal');

--
-- Contenu de la table `job_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('gopostal', 0, 'employee', 'Intérimaire', 200, '', '');

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES 
('letter', 'Courrier', '-1', '0', '1'), 
('colis', 'Colis', '-1', '0', '1');