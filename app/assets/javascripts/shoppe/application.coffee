#= require jquery
#= require jquery_ujs
#= require shoppe/mousetrap
#= require shoppe/jquery_ui
#= require shoppe/chosen.jquery
#= require nifty/dialog
#= require_tree .

$ ->
  # Automatically focus all fields with the 'focus' class
  $('input.focus').focus()

  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()

  # Chosen
  $('select.chosen').chosen()
  $('select.chosen-with-deselect').chosen({allow_single_deselect: true})
  $('select.chosen-basic').chosen({disable_search_threshold:100})

  # Printables
  $('a[rel=print]').on 'click', ->
    window.open($(this).attr('href'), 'despatchnote', 'width=700,height=800')
    false

  # Close dialog
  $('body').on 'click', 'a[rel=closeDialog]', Nifty.Dialog.closeTopDialog

  # Open AJAX dialogs
  $('a[rel=dialog]').on 'click', ->
    element = $(this)
    options = {}
    options.width = element.data('dialog-width') if element.data('dialog-width')
    options.offset = element.data('dialog-offset') if element.data('dialog-offset')
    options.behavior = element.data('dialog-behavior') if element.data('dialog-behavior')
    options.id = 'ajax'
    options.url = element.attr('href')
    Nifty.Dialog.open(options)
    false

  # Format money values to 2 decimal places
  $('div.moneyInput input').each formatMoneyField
  $('body').on('blur', 'div.moneyInput input', formatMoneyField)

#
# Format money values to 2 decimal places
#
window.formatMoneyField = ->
  value = $(this).val().replace /,/, ""
  $(this).val(parseFloat(value).toFixed(2)) if value.length

#
# Stock Level Adjustment dialog beavior
#
Nifty.Dialog.addBehavior
  name: 'stockLevelAdjustments'
  onLoad: (dialog,options)->
    $('input[type=text]:first', dialog).focus()
    $(dialog).on 'submit', 'form', ->
      form = $(this)
      $.ajax
        url: form.attr('action')
        method: 'POST'
        data: form.serialize()
        dataType: 'text'
        success: (data)->
          $('div.table', dialog).replaceWith(data)
          $('input[type=text]:first', dialog).focus()
        error: (xhr)->
          if xhr.status == 422
            alert xhr.responseText
          else
            alert 'An error occurred while saving the stock level.'
      false
    $(dialog).on 'click', 'nav.pagination a', ->
      $.ajax
        url: $(this).attr('href')
        success: (data)->
          $('div.table', dialog).replaceWith(data)
      false

#
# Always fire keyboard shortcuts when focused on fields
#
Mousetrap.stopCallback = -> false

#
# Close dialogs on escape
#
Mousetrap.bind 'escape', ->
  Nifty.Dialog.closeTopDialog()
  false

