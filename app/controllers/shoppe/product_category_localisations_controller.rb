require "globalize"

module Shoppe
  class ProductCategoryLocalisationsController < ApplicationController

    before_filter { @active_nav = :product_categories }
    before_filter { @product_category = Shoppe::ProductCategory.find_by(permalink: params[:product_category_id]) }
    before_filter { params[:id] && @localisation = @product_category.translations.find(params[:id]) }

    def index
      @localisations = @product_category.translations
    end

    def new
      @localisation = @product_category.translations.new
      render :action => "form"
    end

    def create
      if I18n.available_locales.include? safe_params[:locale].to_sym
        I18n.locale = safe_params[:locale].to_sym

        if @product_category.update(safe_params)
          I18n.locale = I18n.default_locale
          redirect_to [@product_category, :localisations], :flash => { :notice => t("shoppe.localisations.localisation_created") }
        else
          render :action => "edit"
        end
      else
        redirect_to [@product_category, :localisations]
      end
    end

    def edit
      render :action => "form"
    end

    def update
      if @localisation.update(safe_params)
        redirect_to [@product_category, :localisations], :notice => t('shoppe.localisations.localisation_updated')
      else
        render :action => "form"
      end
    end

    def destroy
      @localisation.destroy
      redirect_to [@product_category, :localisations], :notice =>  t('shoppe.localisations.localisation_destroyed')
    end

    private

    def safe_params
      params[:product_category_translation].permit(:name, :locale, :permalink, :description)
    end

  end
end
