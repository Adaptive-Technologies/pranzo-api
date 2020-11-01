# frozen_string_literal: true

module ResOsService
  key = 'OpBmGrJ5i03KBAq8pstw-4ZHX5YyyaOaGgmoV2zfcHK'
  encoded_key = Base64.strict_encode64 key
  HEADERS = {
    Authorization: "Basic #{encoded_key}"
  }.freeze
  API_URL = 'https://api.resos.com/v1'

  def self.tables
    response = RestClient.get(API_URL + '/tables', headers = HEADERS)
    JSON.parse response.body.force_encoding('UTF-8')
  end

  def self.bookings(options = {})
    method = (options[:type] || :get)
    case method
    when :post
      payload = booking_options(options).to_json
      headers = HEADERS.deep_dup.merge!(content_type: :json, accept: :json)
    when :put
      raise StandardError, 'No booking id given' unless options[:id]

      payload = booking_options(options).to_json
      headers = HEADERS.deep_dup.merge!(content_type: :json, accept: :json)
    when :get
      params = bookings_period(options)
      headers = HEADERS.deep_dup.merge!(params: params)
    end
    request = RestClient::Request.new(
      method: method,
      url: API_URL + "/bookings#{options[:id] && '/' + options[:id]}",
      payload: payload,
      headers: headers
    )
    begin
      response = request.execute
    rescue StandardError => e
      error = e
    end
    JSON.parse response.body.force_encoding('UTF-8')
  end

  private

  def self.booking_options(options = {})
    booking_options = { date: (options[:date] || Date.today.to_s),
                        time: (options[:time] || '12:15'),
                        people: (options[:people] || 2),
                        duration: (options[:duration] || 60),
                        guest: { name: (options[:name] || 'Walk-in Guest'),
                                 email: (options[:email] || 'info@bocado.se'),
                                 notificationEmail: (options[:notificationEmail] || false),
                                 notificationSms: (options[:notificationSms] || false),
                                 phone: (options[:phone] || '') },
                        languageCode: 'sv' }
    booking_options
  end

  def self.bookings_period(options = {})
    date = DateTime.parse(options[:date] || Date.today.to_s)
    bookings_period =
      {
        fromDateTime: date.beginning_of_day.to_s,
        toDateTime: date.end_of_day.to_s,
        limit: (options[:limit] || 10),
        skip: (options[:skip] || 0)
      }
    bookings_period
  end
end
