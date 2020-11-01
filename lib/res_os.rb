# frozen_string_literal: true
require 'rest-client'

module ResOs
  class Configuration
    attr_accessor :api_key, :api_url

    def initialize
      @api_key = ''
      @api_url = 'https://api.resos.com/v1'
    end

    def headers
      {
        Authorization: "Basic #{Base64.strict_encode64 @api_key}"
      }.freeze
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.tables
    response = RestClient.get(
      configuration.api_url + '/tables',
      headers = configuration.headers
    )
    JSON.parse response.body.force_encoding('UTF-8')
  end

  def self.bookings(options = {})
    method = (options[:type] || :get)
    case method
    when :post
      payload = booking_options(options).to_json
      headers = configuration.headers.deep_dup.merge!(content_type: :json, accept: :json)
    when :put
      raise StandardError, 'No booking id given' unless options[:id]

      payload = booking_options(options).to_json
      headers = configuration.headers.deep_dup.merge!(content_type: :json, accept: :json)
    when :get
      params = bookings_period(options)
      headers = configuration.headers.deep_dup.merge!(params: params)
    end
    request = RestClient::Request.new(
      method: method,
      url: configuration.api_url + "/bookings#{options[:id] && '/' + options[:id]}",
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
