# README

If `config/master.key` file is need, create the file with value `dfa16bb2caccf02b8d5348e53d5b8235`.

## Tests

Run:

```
be rails test
```

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

Or use this static API key `0241779ada9b54f47227` after running `rails db:seed` on local or on production.

Use any tool of your choice to send API requests. Just make sure the
request has a `x-api-key` header of the above key or any generated ones.


## Test Message page

Visit `/` of the hosted domain to view messages. The page does not auto update, please refresh the page to see updates.


## Local Testing

GET:
```
localhost:3000/
```

### Send message endpiont

POST: 
```
localhost:3000/api/v1/texter/send_message?message=Hi Y'all!&to_number=1234567890
```

### Callback endpoint

POST:
```
localhost:3000/api/v1/texter/delivery_status?status=delivered&message_id=a1sdasdf-asdf1123123-asdfa-12312
```


## WWW Testing

Currently not live until requested, please email time when needing to be turned on.

GET:
```
https://samholst.com/texting_service
```

### Send message endpiont

POST: 
```
https://samholst.com/texting_service/api/v1/texter/send_message?message=Hi Y'all!&to_number=1234567890
```

### Callback endpoint

POST:
```
https://samholst.com/texting_service/api/v1/texter/delivery_status?status=delivered&message_id=a1sdasdf-asdf1123123-asdfa-12312
```


