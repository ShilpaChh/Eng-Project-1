require "space_repository"
require "spec_helper"

def reset_spaces_table
  seed_sql = File.read("spec/seeds/seeds_tests.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe SpaceRepository do
  before(:each) { reset_spaces_table }
  context "all method" do
    it "returns all spaces" do
      repo = SpaceRepository.new
      spaces = repo.all
      expect(spaces.length).to eq 3
      expect(spaces[0].id).to eq 1
      expect(spaces[0].name).to eq "Bright villa"
      expect(spaces[0].description).to eq "Cute villa on the spanish sea side"
      expect(spaces[1].id).to eq 2
      expect(spaces[1].name).to eq "Amazing cottage"
      expect(spaces[1].price).to eq "200"
    end
  end

  context "create method" do
    it "creates a new space and adds them to the database" do
      space = Space.new
      space.name = "Test"
      space.description = "Testing this space"
      repo = SpaceRepository.new
      repo.create(space)
      spaces = repo.all
      expect(spaces.length).to eq 4
      expect(spaces[3].id).to eq 4
      expect(spaces[3].name).to eq "Test"
      expect(spaces[3].description).to eq "Testing this space"
    end
  end

  context "find by id method" do
    it "returns a specific space by its id" do
      repo = SpaceRepository.new
      space = repo.find(2)
      expect(space.id).to eq 2
      expect(space.name).to eq "Amazing cottage"
      space = repo.find(3)
      expect(space.id).to eq 3
      expect(space.name).to eq "Glamping spot"
    end
  end
end
