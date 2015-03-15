module Shoppe::ProductsHelper
  def link_to_add_product_attribute(f)
    new_attribute = Shoppe::ProductAttribute.new
    id = new_attribute.object_id

    fields = f.fields_for(:product_attributes, new_attribute, child_index: id) do |builder|
      render 'product_attribute', f: builder
    end

    link_to t('shoppe.products.add_attribute'), '#', :data => {
      :behavior => 'addAttributeToProductAttributesTable',
      :template => fields.gsub("\n", ''),
      :id => id
    }, :class => 'button button-mini green'
  end
end
