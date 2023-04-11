# Two Tables (One-to-Many) Design Recipe Template
## DATABASE NAMES: makersbnb || makersbnb_test
_Copy this recipe template to design and create two related database tables having a Many-to-Many relationship._

## 1. Extract nouns from the user stories or specification

```
User story (3, 4 and 5):

As a user
When I am logged in
I want to be able to list a new space on MakersBnb.

‌

As a user
When I list a new space
I want to be able to list multiple spaces.

‌

As a user
When I am listing a space
I want to be able to add a name for the space, provide a short description of the space, and a price per night.
```

```

```
Nouns:

users, spaces, requests, 

```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| users                 | email_address, password_digest, 
| spaces                | name, description, price, available_from, available_to, booked_from, booked_to, user_id(fk)
| requests              | space_id(fk), user_id(fk), requested_from, requested_to, status

1. Name of the first table (always plural): `users` 

    Column names: `title`, `content`

2. Name of the second table (always plural): `spaces` 

    Column names: `name`

3. Name of the second table (always plural): `requests` 

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: users
id: SERIAL
email_address: text
password_digest: text

Table: spaces
id: SERIAL
name: text
description: text
price: money
available_from: date
available_to: date
booked_from: date
booked_to: date


Table: requests
id: SERIAL
space_id: int
user_id: int
requested_from: date
requested_to: date
status: boolean

```

## 4. Design the Many-to-Many relationship

Make sure you can answer YES to these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

```
# EXAMPLE

1. Can one user have many spaces? YES
2. Can one space have many users? NO

1. Can one space have many requests? YES
2. Can one request have many spaces? NO

1. Can one user have many requests? YES
2. Can one request have many users? NO


```


```
# EXAMPLE

Join table for tables: posts and tags
Join table name: posts_tags
Columns: post_id, tag_id
```
```
## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: posts_tags.sql

-- Replace the table name, columm names and types.

-- Create the first table.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email_address text,
  password_digest text
);

-- Create the second table.
CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text, 
  available_from date,
  avaialable_to date,
  booked_from date,
  booked_to date,
  user_id int
  constraint fk_user foreign key(user_id) references users(id) on delete cascade,
  PRIMARY KEY (user_id)

);

-- Create the third table.
CREATE TABLE requests (
  user_id int,
  space_id int,
  requested_from date,
  requested_to date,
  status boolean 
  constraint fk_user foreign key(user_id) references users(id) on delete cascade,
  constraint fk_space foreign key(space_id) references spaces(id) on delete cascade,
  PRIMARY KEY (user_id, space_id)
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < posts_tags.sql
```

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_tables_many_to_many_design_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_tables_many_to_many_design_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_tables_many_to_many_design_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_tables_many_to_many_design_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_tables_many_to_many_design_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->