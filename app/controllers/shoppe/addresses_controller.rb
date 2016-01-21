module Shoppe
  class AddressesController < Shoppe::ApplicationController

    before_filter { @active_nav = :customers }
    before_filter { params[:customer_id] && @customer = Shoppe::Customer.find(params[:customer_id])}
    before_filter { params[:id] && @address = @customer.addresses.find(params[:id])}

    def new
      @address = Shoppe::Address.new
    end

    def edit
    end

    def create
      @address = @customer.addresses.build(safe_params)

      if @customer.addresses.count == 0
        @address.default = true
      end

      if @customer.save
        redirect_to @customer, flash: { notice: t('shoppe.addresses.created_successfully') }
      else
        render action: 'new'
      end
    end

    def update
      if @address.update(safe_params)
        redirect_to @customer, flash: { notice: t('shoppe.addresses.updated_successfully') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @address.destroy
      redirect_to @customer, flash: { notice: t('shoppe.addresses.deleted_successfully') }
    end

    private

    def safe_params
      params[:address].permit(:address_type, :address1, :address2, :address3, :address4, :postcode, :country_id)
    end
  end
end
