require_relative "request"

class RequestRepository
  def all
    sql = 'SELECT id, user_id, space_id, requested_from, requested_to, status FROM requests;'
    result = DatabaseConnection.exec_params(sql, []);
    requests = []
    result.each do |record|
      request = Request.new
      request.id = record['id']
      request.user_id = record['user_id']
      request.space_id = record['space_id']
      request.requested_from = record['requested_from']
      request.requested_to= record['requested_to']
      request.status= record['status']
      requests << request
    end
    return requests
  end

  def create(request)
    sql = 'INSERT INTO requests ("user_id", "space_id", "requested_from", "requested_to", "status") VALUES ($1, $2, $3, $4, $5);'
    params = [ request.user_id, request.space_id, request.requested_from, request.requested_to, request.status]
    DatabaseConnection.exec_params(sql, params);
  end
end