module Shoppe::ProductTemplatesHelper
  def link_to_add_product_template_attribute(f)
    new_attribute = Shoppe::ProductTemplateAttribute.new
    id = new_attribute.object_id

    fields = f.fields_for(:product_template_attributes, new_attribute, child_index: id) do |builder|
      render 'product_template_attribute', f: builder
    end

    link_to t('shoppe.product_templates.add_attribute'), '#', :data => {
      :behavior => 'addAttributeToProductTemplateAttributesTable',
      :template => fields.gsub("\n", ''),
      :id => id
    }, :class => 'button button-mini green'
  end

end
