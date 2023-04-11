require_relative "../spec_helper"
require "rack/test"
require_relative "../../app"
require "user_repository"
require "space_repository"
require "request_repository"
require "json"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  # reset_tables()

  context "GET /" do
    it "should get the homepage" do
      response = get("/")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Feel at home, anywhere</h1>")
      expect(response.body).to include("<p>Lorem ipsum")
      expect(response.body).to include("<h2>Sign up to MakersBnB</h2>")
      expect(response.body).to include('<form method="POST" action="/users">')
      expect(response.body).to include(
        '<label for="email">Email Address</label>',
      )
      expect(response.body).to include(
        '<input id="email" type="text" name="email_address">',
      )
      expect(response.body).to include('<label for="password">Password</label>')
      expect(response.body).to include(
        '<input id="password" type="password" name="password_input">',
      )
      expect(response.body).to include(
        '<label for="password_confirm">Password confirmation</label>',
      )
      expect(response.body).to include(
        '<input id="password_confirm" type="password" name="password_digest">',
      )
      expect(response.body).to include('<input type="submit" value="Sign up">')
    end
  end

  context "POST /users" do
    it "should take request params and post a new user to the homepage" do
      response =
        post(
          "/users",
          email_address: "paul@makers.com",
          password_input: "swordfish007!",
          password_digest: "swordfish007!",
        )
      expect(response.status).to eq 200
      expect(response.body).to include('Congratulations! You have signed up to MakersBnB')
      repo = UserRepository.new
      users = repo.all
      expect(users[4].id).to eq "5"
      expect(users[4].email_address).to eq "paul@makers.com"
    end

    it "validates the email address" do
      response =
        post(
          "/users",
          email_address: "eddie.at.makers.com",
          password_input: "mypassword123!",
          password_digest: "mypassword123!",
        )
      expect(response.status).to eq 400
      expect(response.body).to eq "Invalid email address"

      response =
        post(
          "/users",
          email_address: "jack@makers.com",
          password_input: "blackwillow99!",
          password_digest: "blackwillow99!",
        )
      expect(response.status).to eq 400
      expect(response.body).to eq "User email already exists"
    end

    it "validates the password" do
      response =
        post(
          "/users",
          email_address: "eddie@makers.com",
          password_input: "mypassword321!",
          password_digest: "mypassword123!",
        )
      expect(response.status).to eq 400
      expect(response.body).to eq "Passwords don't match"

      response =
        post(
          "/users",
          email_address: "samir@makers.com",
          password_input: "mypassword",
          password_digest: "mypassword",
        )
      expect(response.status).to eq 400
      expect(
        response.body,
      ).to eq "Password must include 1 special character, 1 number and be at least 8 characters long"

      response =
        post(
          "/users",
          email_address: "dana@makers.com",
          password_input: "mypassword!",
          password_digest: "mypassword!",
        )
      expect(response.status).to eq 400
      expect(
        response.body,
      ).to eq "Password must include 1 special character, 1 number and be at least 8 characters long"

      response =
        post(
          "/users",
          email_address: "dana@makers.com",
          password_input: "mypassword1",
          password_digest: "mypassword1",
        )
      expect(response.status).to eq 400
      expect(
        response.body,
      ).to eq "Password must include 1 special character, 1 number and be at least 8 characters long"
    end
  end

  context "GET/space/new" do
    it "takes you to the create a list page" do
      response = get("/space/new")
      expect(response.status).to eq(200)
      expect(response.body).to include(
        "<h1><center>List your place here!</center></h1><br/>",
      )
    end
  end

  context "POST/space/new" do
    it "add new space to database" do
      response =
        post(
          "/space/new",
          spacename: "Villa in Spain",
          description: "Muy bonita",
          available_from: "2023-04-05",
          available_to: "2023-06-02",
          space_price: 300,
          user_id: 1,
        )
      expect(response.status).to eq(200)
      expect(response.body).to include("<title>MakersBnB</title>")
    end
  end

  context "GET space/:id" do
    it "returns a specific space from the database by id" do
      response = get("/space/2")
      expect(response.status).to eq 200
      expect(response.body).to include("<html>")
      expect(response.body).to include("Amazing cottage")
      response = get("/space/3")
      expect(response.status).to eq 200
      expect(response.body).to include("<html>")
      expect(response.body).to include("Glamping spot")
    end

    it "returns html for the name, description, price and dates for the space" do
      response = get("/space/2")
      expect(response.body).to include("<html>")
      expect(response.body).to include("<h1>Amazing cottage")
      expect(response.body).to include(
        "<p>Cozy cottage in the middle of the countryside</p>",
      )
      expect(response.body).to include("<h3>£200 per night</h3>")
      expect(response.body).to include('<form method="POST" action="/requests"')
      expect(response.body).to include('<label for="date_select_1"')
      expect(response.body).to include('<input type="date"')
      expect(response.body).to include("2023-04-21")
      expect(response.body).to include("2023-06-21")
    end

    it "features a button to make a request for a space" do
      response = get("/space/2")
      expect(response.body).to include("<html>")
      expect(response.body).to include('<input type="submit" value="Request to Book">')
    end
  end

  context "POST /requests" do
    it "takes user params and adds a request to the database" do
      response =
        post(
          "/requests",
          user_id: "1",
          space_id: "3",
          requested_from: "2023-08-01",
          requested_to: "2023-08-05",
          status: false,
        )
        expect(response.status).to eq 200
        expect(response.body).to eq "Your request to the owner of this space has been added"
        repo = RequestRepository.new
        requests = repo.all
        expect(requests[2].id).to eq "3"
        expect(requests[2].requested_from).to eq "2023-08-01"
    end
  end

  context 'GET/spaces' do
    it 'takes you to the page where you can see all the spaces available' do
      response = get('/spaces')
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Click here to list your own space</p>')
      expect(response.body).to include('<div class="SpaceList">')
      expect(response.body).to include('<div class="cardbox">')
    end
  end

  context 'GET/spaces/by_date' do
    it 'only shows the spaces following the required filters' do
      response = get('/spaces/by_date', available_from: '2023-09-27', available_to: '2023-09-28')
      expect(response.status).to eq(200)
      expect(response.body).to include('<label  class="avail1" for="available_from">Available from:</label>')
      expect(response.body).to include('<form action="/space/new" method="GET"')
    end
  end

  context "GET /login" do
    it 'returns 200 OK' do
      response = get('/login')
      expect(response.status).to eq(200)
    end

    it 'returns html' do
      response = get('/login')
      expect(response.body).to include('<h1>Log in to MakersBnB</h1>')
      expect(response.body).to include('<input type="submit" value="Login"/>')
    end
  end

  context "GET /logout" do
    it 'returns 404 Not Found' do
      response = get('/logout')
      expect(response.status).to eq(404)
    end
  end

  # Once the merge for the All Spaces Page has been completed, this test needs to be corrected
  context "POST /login" do
    it "check email and password against the db" do
      response = post('/login', email_address: 'shilpa@makers.com', password_digest: 'qwerty456!' )
      expect(response.status).to eq(200)
      expect(response.body).to include('<input type="date" name="available_to">')
      expect(response.body).to include('<form action="/listing_space" method="GET" class="form1">') 
      expect(response.body).to include('<input type="date" name="available_to">') 
    end

    it "print error message if details are wrong" do
      response = post('/login', email_address: 'noelia@makers.com', password_digest: 'qwerty000!' )
      expect(response.status).to eq(200)
      expect(response.body).to include('<div>We could not find this user. Try again?</div>')
      expect(response.body).to include('<input type="submit" value="Go back">')
      expect(response.body).to include('<head>Wrong Details</head>')
    end
  end
end
