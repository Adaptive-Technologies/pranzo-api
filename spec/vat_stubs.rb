RSpec.configure do |config|
  config.before(:each) do
    service_uri = 'https://ec.europa.eu/taxation_customs/vies/services/checkVatService'
    fixture_data = file_fixture('vat_response.xml')
                   .read
                   .clean_up_xml_string
    stub_request(:post, service_uri)
      .to_return(status: 200,
                 body: fixture_data,
                 headers: {})
  end
end
