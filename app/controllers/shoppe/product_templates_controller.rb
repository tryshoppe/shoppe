module Shoppe
  class ProductTemplatesController < Shoppe::ApplicationController

    before_filter { @active_nav = :product_templates }

    def index
      load_product_templates
    end

    def new
      build_product_template
    end

    def show
      load_product_template
    end

    def create
      build_product_template
      save_product_template or render 'new'
    end

    def edit
      load_product_template
    end

    def update
      load_product_template
      build_product_template
      save_product_template or render 'edit'
    end

    def destroy
      load_product_template
      @product_template.destroy
      redirect_to product_templates_path, notice: t('shoppe.product_templates.destroy_notice')
    end

    def dialog
      @product_templates ||= product_template_scope
      if request.xhr?
        render :action => 'dialog', :layout => false
      end
    end

    def template_attributes
      @product_template = Shoppe::ProductTemplate.find(params[:template_attributes][:template_id])
      build_product_attributes_for_template

      if request.xhr?
        render 'template_attributes', :layout => false
      end
    end

    private

    def product_template_scope
      @scope ||= Shoppe::ProductTemplate.all
    end

    def product_template_params
      template_attributes = [ :id, :key, :position, :searchable, :public, :_destroy ]
      permit_params = [ :name, product_template_attributes_attributes: template_attributes ]

      params[:product_template] ? params[:product_template].permit(permit_params) : {}
    end

    def load_product_template
      @product_template ||= product_template_scope.find(params[:id])
    end

    def load_product_templates
      @product_templates ||= product_template_scope
    end

    def build_product_template
      @product_template ||= product_template_scope.build
      @product_template.attributes = product_template_params
    end

    def save_product_template
      if @product_template.save
        redirect_to [:edit, @product_template], notice: t('shoppe.product_templates.save_notice')
      end
    end

    def build_product_attributes_for_template
      @product_attributes = []
      @product_template.product_template_attributes.each do |attribute|
        @product_attributes << Shoppe::ProductAttribute.new({
          key: attribute.key,
          searchable: attribute.searchable,
          public: attribute.public,
          position: attribute.position
        })
      end
    end

  end
end
