# frozen_string_literal: true

require_relative './credentials'

RSpec.describe 'POST /api/vendors/:vendor_id/affiliates', type: :request do
  include_context 'credentials'
  let!(:vendor_1) { create(:vendor, primary_email: 'the_other_guys@example.com') }
  let!(:vendor_2) { create(:vendor, primary_email: 'not_the_other_guys@example.com') }

  describe "with an existing vendor's primary email" do
    before do
      post "/api/vendors/#{vendor.id}/affiliates",
           params: { primary_email: 'the_other_guys@example.com' },
           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 201
    }

    it {
      expect(vendor.affiliates).to include vendor_1
    }

    it {
      expect(vendor.affiliates).not_to include vendor_2
    }
  end

  describe "with a missing email" do
    before do
      post "/api/vendors/#{vendor.id}/affiliates",
           params: { primary_email: 'not_found@example.com' },
           headers: valid_auth_headers_for_vendor_user
    end

    it {
      expect(response).to have_http_status 422
    }
  end
end
