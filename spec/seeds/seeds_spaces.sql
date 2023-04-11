DROP TABLE IF EXISTS spaces CASCADE;

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text, 
  available_from date,
  available_to date,
  booked_from date,
  booked_to date,
  price int,
  user_id int,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

TRUNCATE TABLE spaces RESTART IDENTITY;

INSERT INTO spaces (name, description, available_from, available_to, booked_from, booked_to, price, user_id) VALUES
  ('Bright villa', 'Cute villa on the spanish sea side', '2023-04-21','2023-05-21', '2023-03-01', '2023-03-01', 300, 1),
  ('Amazing cottage', 'Cozy cottage in the middle of the countryside', '2023-04-21','2023-06-21', '2023-03-01', '2023-03-01', 200, 2),
  ('Glamping spot', 'Camp under the stars of the Lake District with luxury', '2023-05-21','2023-09-01', '2023-03-01', '2023-03-01', 350, 1);