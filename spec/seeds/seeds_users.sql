
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email_address text,
  password_digest text
);



TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users ("email_address", "password_digest") VALUES
  ('jack@makers.com','qwerty123!'),
  ('shilpa@makers.com','qwerty456!'),
  ('noelia@makers.com','qwerty789!'),
  ('jose@makers.com','qwerty012!');

