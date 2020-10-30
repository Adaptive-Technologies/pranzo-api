## ResOS

# API usage example

```ruby
key = "OpBmGrJ5i03KBAq8pstw-4ZHX5YyyaOaGgmoV2zfcHK"
encoded_key = Base64.strict_encode64 key
table_url = "https://api.resos.com/v1/tables"
bookings_url = "https://api.resos.com/v1/bookings?fromDateTime=2020-10-30T00%3A00%3A00%2B01%3A00&toDateTime=2020-10-30T23%3A59%3A59%2B01%3A00&limit=2&skip=1"
RestClient.get(url, headers={})
```