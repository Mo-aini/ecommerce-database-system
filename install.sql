-- Runs every script in the right order from the mysql client:
--   mysql -u root -p < install.sql      (run from the repository folder)
SOURCE schema.sql;
SOURCE triggers.sql;
SOURCE procedures.sql;
SOURCE views.sql;
SOURCE seed.sql;
