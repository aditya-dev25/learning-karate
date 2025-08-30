CREATE TABLE IF NOT EXISTS jobs (
  job_id INT AUTO_INCREMENT PRIMARY KEY,
  job_description VARCHAR(255) NOT NULL,
  min_lvl INT NOT NULL,
  max_lvl INT NOT NULL
);

INSERT INTO jobs (job_description, min_lvl, max_lvl) VALUES
('Software Engineer', 50, 120),
('Data Analyst', 60, 130),
('Project Manager', 70, 140),
('QA Tester', 55, 110),
('DevOps Engineer', 65, 125),
('UI/UX Designer', 45, 105),
('Business Analyst', 50, 115),
('System Administrator', 60, 135),
('Database Admin', 70, 145),
('Cloud Architect', 80, 150);