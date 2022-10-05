# ResOS V1

## API usage example
Documentation: https://documenter.getpostman.com/view/3308304/SzzehLGp?version=latest

```ruby
key = "OpBmGrJ5i03KBAq8pstw-4ZHX5YyyaOaGgmoV2zfcHK"
encoded_key = Base64.strict_encode64 key
table_url = "https://api.resos.com/v1/tables"
bookings_url = "https://api.resos.com/v1/bookings?fromDateTime=2020-10-30T00%3A00%3A00%2B01%3A00&toDateTime=2020-10-30T23%3A59%3A59%2B01%3A00&limit=2&skip=1"
RestClient.get(url, headers={})
```

## ResOs API wrapper

### CONFIGURATION

```ruby
ResOs.configure do |config|
  config.api_key = "OpBmGrJ5i03KBAq8pstw-4ZHX5YyyaOaGgmoV2zfcHK"
end
```

###  USAGE
#### Collection of bookings:
```ruby
ResOs.bookings
```

#### Collection of bookings for a specific date
```ruby
ResOs.bookings(date: '2020-12-01')
```
You can also pass in `:limit` and `:skip`.

#### Single booking:
```ruby
ResOs.bookings(id: 'CRJE9Bbrqz2L8NbjT')
```
#### Create booking:
```ruby
ResOs.bookings(type: :post, <pass in bookings details>)
```

#### Update booking
```ruby
ResOs.bookings(
  type: :put,
  id: 'ip2ynBTToxvBGSdou'
  <pass in bookings details>
  )
```

## VOUCHER

The voucher code is generated at `create`.

A voucher must be activated (set `activated` to `true`)

```ruby
voucher = Voucher.last
doc = CardGenerator.new(voucher)
file = File.open(doc.path)
voucher.pdf_card.attach(io: file, filename: 'test.pdf')
```

## Custom Card Generator
This generator takes more options and can be configured with several templates.

There are currently 3 templates available.
```ruby
# CustomCardGenerator.new(<voucher obj>, <render:boolean/default: true>, <variant:integer>, <locale:symbol/default: :sv>)
CustomCardGenerator.new(voucher, true, 1, :sv)
```

# Formatting Emails

An interesting solution is the [MJML gem](https://github.com/sighmon/mjml-rails). A PR with good examples [can be found here](https://github.com/CraftAcademy/gigafood/pull/69)

# Activity log
One way to gather data of usage, but also to track att activities of a vendor, could be to make use of [Public Activity](https://rubygems.org/gems/public_activity) gem. 

# 