# frozen_string_literal: true
require 'rest-client'

module IZet
  class Config
    attr_accessor :client_id, :assertion, :grant_type
    attr_reader :token

    def initialize
      @client_id = 'eyJraWQiOiIwIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJpWmV0dGxlIiwiYXVkIjoiQVBJIiwiZXhwIjoyNTUyODcwMzg1LCJzdWIiOiI0ZDA0YjIxYy04NTE5LTExZWEtYjIzMS01NWMzMTk3NTlhNGEiLCJpYXQiOjE2MDYxNjI2MDksInJlbmV3ZWQiOmZhbHNlLCJ0eXBlIjoidXNlci1hc3NlcnRpb24iLCJ1c2VyIjp7InVzZXJUeXBlIjoiVVNFUiIsInV1aWQiOiI0ZDA0YjIxYy04NTE5LTExZWEtYjIzMS01NWMzMTk3NTlhNGEiLCJvcmdVdWlkIjoiNGQwMjE2MDYtODUxOS0xMWVhLWFmNjUtNmY4YTE5N2E1ZDY5IiwidXNlclJvbGUiOiJPV05FUiJ9LCJzY29wZSI6WyJSRUFEOlBST0RVQ1QiLCJXUklURTpQUk9EVUNUIiwiUkVBRDpQVVJDSEFTRSIsIldSSVRFOlBVUkNIQVNFIl0sImNsaWVudF9pZCI6ImQxNjRlZTI5LTJkYzgtMTFlYi04Mzc3LWVhM2NjNzJjOTdiOCJ9.VIvoijmuCjfpcSf_ynNXtAit9XHdqD6mJrogYW_9wuoT63mxJ3UiRDysgEZnz9J1ACbYb4cbKjE3F1YTyTYT1fTnHJ5rH0qb9fOLs-xGcBOvJN4tTZrpoVvWtDDifOG069SLIjznJ_mo0Gz97qisAw0Tg6nmza04feBb3hGarWAy1H6bzlxNpn_q49aAkDGkOym1krJUOcQJoe5ZtQ5lIZ1uX4xjoFEW2FtfnJNpryrJ82nSUbLctVWgX_0TnOzYWsRtggyu-uzvKkSdMHx9_zM7YKYpLyuPvh2yL3BaSTIagge96ZYJn1kM1ZQ-Cafp26RF00CGshdIU0IbCgzoCQ'
      @assertion = 'd164ee29-2dc8-11eb-8377-ea3cc72c97b8'
      @grant_type = 'urn:ietf:params:oauth:grant-type:jwt-bearer'
      @token = get_token
    end


    def headers
      {
        Authorization: "Bearer #{@token}"
      }
    end

    private

    def get_token
      options = {
        assertion: 'eyJraWQiOiIwIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJpWmV0dGxlIiwiYXVkIjoiQVBJIiwiZXhwIjoyNTUyODcwMzg1LCJzdWIiOiI0ZDA0YjIxYy04NTE5LTExZWEtYjIzMS01NWMzMTk3NTlhNGEiLCJpYXQiOjE2MDYxNjI2MDksInJlbmV3ZWQiOmZhbHNlLCJ0eXBlIjoidXNlci1hc3NlcnRpb24iLCJ1c2VyIjp7InVzZXJUeXBlIjoiVVNFUiIsInV1aWQiOiI0ZDA0YjIxYy04NTE5LTExZWEtYjIzMS01NWMzMTk3NTlhNGEiLCJvcmdVdWlkIjoiNGQwMjE2MDYtODUxOS0xMWVhLWFmNjUtNmY4YTE5N2E1ZDY5IiwidXNlclJvbGUiOiJPV05FUiJ9LCJzY29wZSI6WyJSRUFEOlBST0RVQ1QiLCJXUklURTpQUk9EVUNUIiwiUkVBRDpQVVJDSEFTRSIsIldSSVRFOlBVUkNIQVNFIl0sImNsaWVudF9pZCI6ImQxNjRlZTI5LTJkYzgtMTFlYi04Mzc3LWVhM2NjNzJjOTdiOCJ9.VIvoijmuCjfpcSf_ynNXtAit9XHdqD6mJrogYW_9wuoT63mxJ3UiRDysgEZnz9J1ACbYb4cbKjE3F1YTyTYT1fTnHJ5rH0qb9fOLs-xGcBOvJN4tTZrpoVvWtDDifOG069SLIjznJ_mo0Gz97qisAw0Tg6nmza04feBb3hGarWAy1H6bzlxNpn_q49aAkDGkOym1krJUOcQJoe5ZtQ5lIZ1uX4xjoFEW2FtfnJNpryrJ82nSUbLctVWgX_0TnOzYWsRtggyu-uzvKkSdMHx9_zM7YKYpLyuPvh2yL3BaSTIagge96ZYJn1kM1ZQ-Cafp26RF00CGshdIU0IbCgzoCQ',
        client_id: 'd164ee29-2dc8-11eb-8377-ea3cc72c97b8',
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer'
      }
      request = RestClient.post('https://oauth.izettle.com/token', options)
      token = JSON.parse(response.body)['access_token']
      token
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end
end
