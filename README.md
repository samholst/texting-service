# README

## Setup

Run:

```ruby
bundle install
rails db:create
rails db:migrate
rails db:seed

rails s
```

Enter `rails c` and grab `User.first.access_keys.first.token`.

Use any tool of your choice to send API request. Make sure the
request has a `x-api-key` header of the `User.first.access_keys.first.token`.


### Send message endpiont

localhost:3000/api/v1/texter/send_message?message=Hi Y'all!&to_number=1234567890

### Callback endpoint

localhost:3000/api/v1/texter/delivery_status?status=delivered&message_id=a1sdasdf-asdf1123123-asdfa-12312


