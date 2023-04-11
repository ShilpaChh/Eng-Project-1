require "sinatra/base"
require "sinatra/reloader"
require "bcrypt"
require_relative "./lib/user"
require_relative "./lib/user_repository"
require_relative "./lib/space_repository"
require_relative "./lib/request_repository"
require_relative "./lib/database_connection"

if ENV["ENV"] == "test"
  DatabaseConnection.connect("makersbnb_test")
else
  DatabaseConnection.connect("makersbnb")
end

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/" do
    return erb(:index)
  end

  post "/users" do
    if !email_confirmed?(params[:email_address])
      status 400
      return "Invalid email address"
    end
    if email_exists?(params[:email_address])
      status 400
      return "User email already exists"
    end
    if !passwords_match?(params[:password_input], params[:password_digest])
      status 400
      return "Passwords don't match"
    end
    if !password_is_valid?(params[:password_digest])
      status 400
      return(
        "Password must include 1 special character, 1 number and be at least 8 characters long"
      )
    end
    encrypted_password = BCrypt::Password.create(params[:password_digest])
    repo = UserRepository.new
    new_user = User.new
    new_user.email_address = params[:email_address]
    new_user.password_digest = encrypted_password
    repo.create(new_user)
    return erb(:sign_up)
  end

  def email_confirmed?(user_input)
    user_input.match?(/[@]/)
  end

  def email_exists?(user_input)
    repo = UserRepository.new
    users = repo.all
    users.any? { |user| user.email_address == user_input }
  end

  def password_exists?(user_input)
    repo = UserRepository.new
    users = repo.all
    users.any? {|user| user.password_digest == user_input }
  end

  def passwords_match?(user_input1, user_input2)
    user_input1 == user_input2
  end

  def password_is_valid?(user_input)
    user_input.length > 8 && user_input.match?(/[!@$%*]/) &&
      user_input.match?(/[0-9]/)
  end

  get "/space/new" do
    return erb(:listing_page)
  end

  get "/space/:id" do
    space_id = params[:id]
    repo = SpaceRepository.new
    @space = repo.find(space_id)
    return erb(:space)
  end

  post "/space/new" do
    repo = SpaceRepository.new

    spacename = params[:spacename]
    description = params[:description]
    available_from = params[:available_from]
    available_to = params[:available_to]
    space_price = params[:space_price]

    space = Space.new
    space.name = spacename
    space.description = description
    space.available_from = available_from
    space.available_to = available_to
    space.price = space_price
    repo.create(space)

    return erb(:index)
  end

  get '/login' do
    return erb(:login_page)
  end

  post '/login' do
    repo = SpaceRepository.new
    @all_spaces = repo.all
    if email_exists?(params[:email_address]) && password_exists?(params[:password_digest])
      return redirect('/spaces')
    else
      return erb(:wrong_login_page)
    end
  end

  get '/spaces' do
    repo = SpaceRepository.new
    @all_spaces = repo.all
    return erb(:all_spaces_page)
  end

  get '/spaces/by_date' do 
    repo = SpaceRepository.new
    space = Space.new
    space.available_from = params[:available_from]
    space.available_to = params[:available_to]
    @find_space = repo.find_by_availability(space)
    return erb(:filtered_spaces_page)
  end

  post "/requests" do
    repo = RequestRepository.new
    new_request = Request.new
    new_request.id = params[:id]
    new_request.user_id = params[:user_id]
    new_request.space_id = params[:space_id]
    new_request.requested_from = params[:requested_from]
    new_request.requested_to= params[:requested_to]
    new_request.status= params[:status]
    repo.create(new_request)
    return "Your request to the owner of this space has been added"
  end
end


