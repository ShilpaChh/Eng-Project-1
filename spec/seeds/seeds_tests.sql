TRUNCATE TABLE users, spaces, requests RESTART IDENTITY;

INSERT INTO users ("email_address", "password_digest") VALUES
  ('jack@makers.com','qwerty123!'),
  ('shilpa@makers.com','qwerty456!'),
  ('noelia@makers.com','qwerty789!'),
  ('jose@makers.com','qwerty012!');

INSERT INTO spaces (name, description, available_from, available_to, booked_from, booked_to, price, user_id) VALUES
  ('Bright villa', 'Cute villa on the spanish sea side', '2023-04-21','2023-05-21', '2023-03-01', '2023-03-01', 300, 1),
  ('Amazing cottage', 'Cozy cottage in the middle of the countryside', '2023-04-21','2023-06-21', '2023-03-01', '2023-03-01', 200, 2),
  ('Glamping spot', 'Camp under the stars of the Lake District with luxury', '2023-05-21','2023-09-01', '2023-03-01', '2023-03-01', 350, 1);

  INSERT INTO requests (user_id, space_id, requested_from, requested_to, status) VALUES
  (3, 2, '2023-05-21','2023-05-30', false),
  (4, 1, '2023-04-30','2023-05-05', true);
