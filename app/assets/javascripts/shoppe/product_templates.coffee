class ProductTemplates
  constructor: ->
    @bindings()

  addHandler: (event) ->
    time = new Date().getTime() + Math.ceil(Math.random(new Date().getTime())*10000)
    regexp = new RegExp($(this).data('id'), 'g')
    $('table.productTemplateAttributes').append($(this).data('template').replace(regexp, time))
    event.preventDefault()

  removeHandler: (event)->
    tr = $(this).parents('tr')
    tr.find('input.destroy').val('1')
    tr.hide()
    event.preventDefault()

  bindings: ->
    $('table.productTemplateAttributes').on 'click', '.remove-attribute', @removeHandler

    $('[data-behavior="addAttributeToProductTemplateAttributesTable"]').on 'click', @addHandler

    # Sorting on the product attribtues table
    $('table.productTemplateAttributes tbody').sortable
      axis: 'y'
      handle: '.handle'
      cursor: 'move',
      stop: (event, ui) ->
        $('table.productTemplateAttributes tbody tr').each (index, tr) -> $(tr).find('input.position').val(index)

$ ->
  new ProductTemplates if $('table.productTemplateAttributes').length > 0
