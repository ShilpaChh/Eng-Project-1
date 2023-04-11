# User Model and Repository Classes Design Recipe

## 1. The Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: users

Columns:
id | email_address | password_digest
```


## 2. Class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

## 3. Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :id, :email_address, :password_digest
end
```

## 4. Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email_address, password_digest FROM users;

    # Returns an array of User objects.
  end

#   # Gets a single record by its ID
#   # One argument: the id (number)
#   def find(id)
#     # Executes the SQL query:
#     # SELECT id, name, cohort_name FROM students WHERE id = $1;

#     # Returns a single Student object.
#   end

  # Add more methods below for each operation you'd like to implement.

  def create(user) #=> user is an instance of User
    # creates a new user
    # executes the sql query: INSERT INTO users ("email_address", "password_digest") VALUES  (user.email_address, user.password_digest);
  end

  # def update(student)
  # end

  # def delete(student)
  # end
end
```

## 5. Test Examples

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new

users = repo.all

users.length # =>  4

users[0].id # =>  1
users[0].email_address # =>  'jack@makers.com'
users[0].password_digest # =>  'qwerty123!'
users[1].id # =>  2
users[1].email_address # =>  'shilpa@makers.com'
users[1].password_digest # =>  'qwerty456!'

# 2
# Create a new user

user = User.new
user.email_address = 'paul@makers.com'
user.password_digest = 'swordfish007!'

repo = UserRepository.new
repo.create(user)

users = repo.all

users.length # =>  5

users[4].id # =>  5
users[4].email_address # =>  'paul@makers.com'
users[4].password_digest # =>  'swordfish007!'


```

Encode this example as a test.

## 6. SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/seeds/seeds_tests.rb

def reset_users_table
  seed_sql = File.read('spec/seeds/seeds_tests.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  # (your tests will go here).
end
```

## 7. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
