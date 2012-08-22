$ ->
  $.ajax '/presentation.mkd',
    success: (text) ->
      html = markdown.toHTML(text)
      presentation = new Presentation
        html: html
        jquery: $

      $('body').html('')
      view = new PresentationView
        presentation: presentation
        container: $('body')
      view.showSlide(0)
    error: ->
      alert 'error ' + arguments
