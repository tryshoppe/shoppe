class ProductAttributes
  constructor: ->
    @bindings()

  removeHandler: (event)->
    tr = $(this).parents('tr')
    tr.find('input.destroy').val('1')
    tr.hide()
    @updateAttributesPositions()
    event.preventDefault()

  addHandler: (event) =>
    target = $(event.currentTarget)
    time = new Date().getTime() + Math.ceil(Math.random(new Date().getTime())*10000)
    regexp = new RegExp(target.data('id'), 'g')
    $('table.productAttributes').append(target.data('template').replace(regexp, time))
    @updateAttributesPositions()
    event.preventDefault()

  bindTempateAttributesDialog: ->
    self = @
    Nifty.Dialog.addBehavior
      name: 'productTemplateAddributes'
      onLoad: (dialog, options)->
        $('select.chosen').chosen()
        $('input[type=text]:first', dialog).focus()
        $(dialog).on 'submit', 'form', ->
          form = $(this)
          $.ajax
            url: form.attr('action')
            method: 'GET'
            data: form.serialize()
            dataType: 'text'
            success: (data)->
              $('table.productAttributes tbody').append(data)
              self.updateAttributesPositions()
              $(dialog).data('closeAction').call()
            error: (xhr)->
              if xhr.status == 422
                alert xhr.responseText
              else
                alert 'An error occurred while saving the stock level.'
          false
        $(dialog).on 'click', '.cancel', (event) ->
          $(dialog).data('closeAction').call()
          event.preventDefault()

  updateAttributesPositions: ->
    $('table.productAttributes tbody tr:visible').each (index, tr) -> $(tr).find('input.position').val(index)

  bindings: ->
    $('table.productAttributes').on 'click', '.remove-attribute', @removeHandler
    $('[data-behavior="addAttributeToProductAttributesTable"]').on 'click', @addHandler

    # Sorting on the product attribtues table
    $('table.productAttributes tbody').sortable
      axis: 'y'
      handle: '.handle'
      cursor: 'move',
      stop: (event, ui) => @updateAttributesPositions()

    @bindTempateAttributesDialog()

$ ->
  new ProductAttributes if $('table.productAttributes').length > 0
