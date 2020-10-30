# frozen_string_literal: true

module ResOsService
  key = 'OpBmGrJ5i03KBAq8pstw-4ZHX5YyyaOaGgmoV2zfcHK'
  encoded_key = Base64.strict_encode64 key
  HEADERS = { Authorization: "Basic #{encoded_key}" }.freeze
  API_URL = 'https://api.resos.com/v1'
  def self.tables
    response = RestClient.get(API_URL + '/tables', headers = HEADERS)
    JSON.parse response.body.force_encoding('UTF-8')
  end

  # USAGE
  # Collection of bookings:
  # ResOsService.bookings

  # Single booking:
  # ResOsService.bookings(id: 'CRJE9Bbrqz2L8NbjT')
  # Createe booking:
  # ResOsService.bookings(type: :post, )

  def self.bookings(options = { })
    params = {
      fromDateTime: (options.try(:from) || DateTime.now.beginning_of_day.to_s),
      toDateTime: (options.try(:to) || DateTime.now.end_of_day.to_s),
      limit: (options.try(:limit) || 2),
      skip: (options.try(:skip) || 0)
    }
    payload = options.try(:payload)
    response = RestClient::Request.execute(
      method: (options[:type] || :get),
      url: API_URL + "/bookings#{options[:id] && '/' + options[:id]}",
      payload: payload,
      headers: HEADERS.deep_dup.merge!(params: params)
    )
    JSON.parse response.body.force_encoding('UTF-8')
  end
end
