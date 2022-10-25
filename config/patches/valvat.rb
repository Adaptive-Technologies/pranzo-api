class Valvat
  class Lookup
    class VIES < Base
      def parse(body)
        <<~AID
          Not sure if we need to do this, but while in test mode
          I had some issues with responses from the EC service
          not being properly encoded.
        AID
        doc = REXML::Document.new(body.force_encoding('UTF-8'))
        elements = doc.get_elements('/env:Envelope/env:Body').first.first
        convert_values(elements.each_with_object({}) do |el, hash|
          hash[convert_key(el.name)] = convert_value(el.text)
        end)
      end
    end
  end
end
