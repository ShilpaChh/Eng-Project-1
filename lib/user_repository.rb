require_relative "user"

class UserRepository
  def all
    sql = 'SELECT id, email_address, password_digest FROM users;'
    result = DatabaseConnection.exec_params(sql, []);
    users = []
    result.each do |record|
      user = User.new
      user.id = record['id']
      user.email_address = record['email_address']
      user.password_digest = record['password_digest']
      users << user
    end
    return users
  end

  def create(user)
    sql = 'INSERT INTO users ("email_address", "password_digest") VALUES ($1, $2);'
    params = [user.email_address, user.password_digest]
    DatabaseConnection.exec_params(sql, params);
  end
end