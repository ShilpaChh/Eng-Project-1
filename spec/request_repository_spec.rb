require "request_repository"
require "spec_helper"

def reset_requests_table
  seed_sql = File.read("spec/seeds/seeds_tests.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe RequestRepository do
  before(:each) { reset_requests_table }

  context "all method" do
    it "returns all requests" do
      repo = RequestRepository.new
      requests = repo.all
      expect(requests.length).to eq 2
      expect(requests[0].id).to eq "1"
      expect(requests[0].requested_from).to eq "2023-05-21"
      expect(requests[1].id).to eq "2"
      expect(requests[1].requested_to).to eq "2023-05-05"
    end
  end

  context "create method" do
    it "adds a request to the database" do
      repo = RequestRepository.new
      request = Request.new
      request.user_id = "1"
      request.space_id = "3"
      request.requested_from = "2023-08-01"
      request.requested_to = "2023-08-05"
      request.status = false
      repo.create(request)
      requests = repo.all
      expect(requests.length).to eq 3
      expect(requests[2].id).to eq "3"
      expect(requests[2].requested_from).to eq "2023-08-01"
    end
  end
end
