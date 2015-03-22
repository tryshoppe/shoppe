$ ->

  #
  # Refresh the order
  #
  calculateTax = (form, invokeField)->
    if $('select#product_tax_rate_id', form).val().length > 0
      $('input#product_price_including_tax', form).prop('disabled', false)
    else
      $('input#product_price_including_tax', form).prop('disabled', true)
      $('input#product_price_including_tax', form).val($('input#product_price', form).val())

  #
  # Setup the product form to calculate tax
  #
  setupProductForm = (form)->
    # All select boxes should use Chosen
    $('select#product_tax_rate_id', form).on 'change', -> calculateTax $(this).parents('form'), $(this).attr('id')
    calculateTax form, null
  
  # 
  # Automatically set up the form on page load if one exists.
  #
  if $('select#product_tax_rate_id').length
    setupProductForm $('form.productForm')