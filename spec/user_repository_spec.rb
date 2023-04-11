require "user_repository"

def reset_users_table
  seed_sql = File.read("spec/seeds/seeds_tests.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) { reset_users_table }

  context "all method" do
    it "returns all users" do
      repo = UserRepository.new
      users = repo.all
      expect(users.length).to eq 4
      expect(users[0].id).to eq '1'
      expect(users[0].email_address).to eq 'jack@makers.com'
      expect(users[0].password_digest).to eq 'qwerty123!'
      expect(users[1].id).to eq '2'
      expect(users[1].email_address).to eq 'shilpa@makers.com'
      expect(users[1].password_digest).to eq 'qwerty456!'
    end
  end

  context "create method" do
    it "creates a new user and adds them to the database" do
      user = User.new
      user.email_address = 'paul@makers.com'
      user.password_digest = 'swordfish007!'
      repo = UserRepository.new
      repo.create(user)
      users = repo.all
      expect(users.length).to eq 5
      expect(users[4].id).to eq '5'
      expect(users[4].email_address).to eq 'paul@makers.com'
      expect(users[4].password_digest).to eq 'swordfish007!'
    end
  end
end
