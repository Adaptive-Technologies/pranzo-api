stub_request(:post, 'https://ec.europa.eu/taxation_customs/vies/services/checkVatService')
  .with(
    body: "<soapenv:Envelope\nxmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"\nxmlns:urn=\"urn:ec.europa.eu:taxud:vies:services:checkVat:types\">\n<soapenv:Header/>\n<soapenv:Body>\n<urn:checkVat>\n<urn:countryCode>SE</urn:countryCode>\n<urn:vatNumber>556012579001</urn:vatNumber>\n\n</urn:checkVat>\n</soapenv:Body>\n</soapenv:Envelope>\n",
    headers: {
      'Accept' => 'text/xml;charset=UTF-8',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'text/xml;charset=UTF-8',
      'Soapaction' => '',
      'User-Agent' => 'Ruby'
    }
  )
  .to_return(status: 200, body: '', headers: {})
