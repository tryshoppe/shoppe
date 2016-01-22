require 'globalize'

module Shoppe
  class ProductLocalisationsController < ApplicationController

    before_filter { @active_nav = :products }
    before_filter { @product = Shoppe::Product.find(params[:product_id]) }
    before_filter { params[:id] && @localisation = @product.translations.find(params[:id]) }

    def index
      @localisations = @product.translations
    end

    def new
      @localisation = @product.translations.new
      render action: 'form'
    end

    def create
      if I18n.available_locales.include? safe_params[:locale].to_sym
        I18n.locale = safe_params[:locale].to_sym

        if @product.update(safe_params)
          I18n.locale = I18n.default_locale
          redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_created') }
        else
          render action: 'form'
        end
      else
        redirect_to [@product, :localisations]
      end
    end

    def edit
      render action: 'form'
    end

    def update
      if @localisation.update(safe_params)
        redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_updated') }
      else
        render action: 'form'
      end
    end

    def destroy
      @localisation.destroy
      redirect_to [@product, :localisations], flash: { notice: t('shoppe.localisations.localisation_destroyed') }
    end

    private

    def safe_params
      params[:product_translation].permit(:name, :locale, :permalink, :description, :short_description)
    end

  end
end
