require_relative './space'

class SpaceRepository
  def all
    spaces = []

    sql = 'SELECT id, name, description, available_from, available_to, booked_from, booked_to, price FROM spaces;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    result_set.each do |record|

      # Create a new model object
      # with the record data.
      space = Space.new
      space.id = record['id'].to_i
      space.name = record['name']
      space.description = record['description']
      space.available_from = record['available_from']
      space.available_to = record['available_to']
      space.booked_from = record['booked_from']
      space.booked_to = record['booked_to']
      space.price = record['price']
      # binding.irb
      spaces << space
    end

    return spaces
  end

  def find_by_availability(space)
    sql = "SELECT id, name, description, available_from, available_to, booked_from, booked_to, price FROM spaces WHERE available_from <= $1 AND available_to >= $2;"
    result_set = DatabaseConnection.exec_params(sql, [space.available_from, space.available_to])

    spaces = []

    result_set.each do |record|
      space = Space.new
      space.id = record['id'].to_i
      space.name = record['name']
      space.description = record['description']
      space.available_from = record['available_from']
      space.available_to = record['available_to']
      space.booked_from = record['booked_from']
      space.booked_to = record['booked_to']
      space.price = record['price'].to_i  
      spaces << space
    end
    return spaces
  end

  def find(id)
    sql = 'SELECT id, name, description, available_from, available_to, booked_from, booked_to, user_id, price FROM spaces WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    space = Space.new
    space.id = result_set[0]['id'].to_i
    space.name = result_set[0]['name']
    space.description = result_set[0]['description']
    space.available_from = result_set[0]['available_from']
    space.available_to = result_set[0]['available_to']
    space.booked_from = result_set[0]['booked_from']
    space.booked_to = result_set[0]['booked_to']
    space.user_id = result_set[0]['user_id']
    space.price = result_set[0]['price']
    return space
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, description, available_from, available_to, price) VALUES ($1, $2, $3, $4, $5);'

    result_set = DatabaseConnection.exec_params(sql, [space.name, space.description, space.available_from, space.available_to, space.price])
    return space
  end

#   def delete(id)
#     sql = 'DELETE FROM albums WHERE id = $1;';
#     DatabaseConnection.exec_params(sql, [id]);
#   end
end
