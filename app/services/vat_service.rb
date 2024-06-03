class VatService
  def self.transform_org_number_to_vat(org_number)
    "SE#{org_number.delete('-')}01"
  end

  def self.fetch_legal_name(vat_number)
    data = Valvat.new(vat_number).exists?(detail: true)
    data[:name] if data
  rescue StandardError => e
    Rails.logger.error "Error fetching legal name: #{e.message}"
    nil
  end
end
