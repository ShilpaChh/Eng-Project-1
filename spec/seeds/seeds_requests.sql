DROP TABLE IF EXISTS requests;

CREATE TABLE requests (
  id SERIAL PRIMARY KEY,
  user_id int,
  space_id int,
  requested_from date,
  requested_to date,
  status boolean, 
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (space_id) REFERENCES spaces(id)
);


TRUNCATE TABLE requests RESTART IDENTITY;

INSERT INTO requests (user_id, space_id, requested_from, requested_to, status) VALUES
  (3, 2, '2023-05-21','2023-05-30', false),
  (4, 1, '2023-04-30','2023-05-05', true);