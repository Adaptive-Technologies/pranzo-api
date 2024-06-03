class VatDataController < ApplicationController
  def validate_vat
    org_number = params[:org_number]
    vat_number = VatService.transform_org_number_to_vat(org_number)
    legal_name = VatService.fetch_legal_name(vat_number)

    if legal_name
      render json: { vat_number: vat_number, legal_name: legal_name }, status: :ok
    else
      render json: { error: 'Invalid VAT number or organization number' }, status: :unprocessable_entity
    end
  end
end