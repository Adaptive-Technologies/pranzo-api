RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, 'https://ec.europa.eu/taxation_customs/vies/services/checkVatService')
      .to_return(status: 200, body: file_fixture('vat_response.xml').read.clean_up_xml_string, headers: {})
  end
end
