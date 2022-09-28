module PassKitService
  KEY = Rails.application.credentials.passkit.rest[:key]
  SECRET = Rails.application.credentials.passkit.rest[:secret]
  LUNCH_CARDS_PROGRAM = Rails.application.credentials.passkit.pranzo_programs[:lunch_cards]
  DEFAULT_LUNCH_CARD_TIER = 'bocado_goteborg'
  API_URL = 'https://api.pub1.passkit.io'
  include RestClient

  def self.token
    payload = { uid: KEY, iat: Time.now.to_i, exp: Time.now.to_i + 6000, web: true }
    token = JWT.encode(payload, SECRET, 'HS256')
  end

  def self.get_program(id = LUNCH_CARDS_PROGRAM)
    json = RestClient.get(API_URL + "/members/program/#{id}", { Authorization: token, content_type: :json })
    JSON.parse(json)
  end

  def self.update_program(payload, id = LUNCH_CARDS_PROGRAM)
    payload = payload.merge({ id: id }).to_json
    json = RestClient.put(API_URL + '/members/program', payload,
                          { Authorization: token, content_type: :json })
    JSON.parse(json)
  rescue StandardError => e
    JSON.parse(e.response.body)
  end

  def self.templates
    json = RestClient.post(API_URL + '/templates/list', {}.to_json, { Authorization: token, content_type: :json })
    JSON.parse(json)
  end

  def self.create_tier(name, program_id = LUNCH_CARDS_PROGRAM)
    payload = {
      id: name.gsub(' ', '_').downcase,
      tierIndex: 99,
      name: name,
      programId: program_id,
      passTemplateId: '1y9V94wqXQnPSdiFIQpSiu',
      timezone: 'UTC' # not documented in PassKit API
    }
    begin
      json = RestClient.post(API_URL + '/members/tier', payload.to_json,
                             { Authorization: token, content_type: :json, accept: :json })
      JSON.parse(json)
    rescue StandardError => e
      JSON.parse(e.response.body)
    end
  end

  # This is the one. Everything else is cosmetics
  # First iteration
  def self.enroll(code = null, points = 10, partner = 'Lerjedalens Café & Bistro', program_id = LUNCH_CARDS_PROGRAM, tier_id = DEFAULT_LUNCH_CARD_TIER)
    payload = {
      programId: program_id,
      tierId: tier_id,
      externalId: code,
      points: points,
      metaData: { venue: partner }
    }
    begin
      json = RestClient.post(API_URL + '/members/member', payload.to_json,
                             { Authorization: token, content_type: :json, accept: :json })
      JSON.parse(json)
    rescue StandardError => e
      JSON.parse(e.response.body)
    end
  end

  # And this one of course.
  # Also first iteration
  def self.consume_points(code, points, program_id = '6J04tre0z4XYq6NuvPhEx8')
    payload = {
      programId: program_id,
      externalId: code,
      points: points

    }
    begin
      json = RestClient.put(API_URL + '/members/member/points/burn', payload.to_json,
                            { Authorization: token, content_type: :json, accept: :json })
      JSON.parse(json)
    rescue StandardError => e
      JSON.parse(e.response.body)
    end
  end
end
