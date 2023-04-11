# {{ LOGIN }} {{ /login }} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method "GET" "POST"
  * the path "/login"
  * any query parameters (passed in the URL) n/a
  * or body parameters (passed in the request body) "email_address" "password_digest"

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head>Login Page</head>
  <body>
    <h1>Loging Page</h1>
    <div>
        <form action="/login" method="POST">
            <input type="text" name="email_address"/>
            <input type="text" name="password_digest"/>
            <input type="submit" value="Login"/>
        </form>
    </div>
  </body>
</html>
```

```html
<!-- EXAMPLE -->
<!-- Response when the post is not found: 404 Not Found -->

<html>
  <head>Wrong Details</head>
  <body>
    <h1>Sorry!</h1>
    <div>We couldn't find this user. Try again?</div>
  </body>
</html>

```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /login

# Expected response:

Response for 200 OK
```

```
# Request:

GET/login?password='12'

# Expected response:

Response for 404 Not Found
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/login')

      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
    end

    it 'returns 404 Not Found' do
      response = get('/logout')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->