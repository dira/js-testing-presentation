$ ->
  success = (text) ->
    presentation = new Presentation
      html: markdown.toHTML(text)
      jquery: $

    $('body').html('')

    view = new PresentationView
      presentation: presentation
      container: $('body')

    view.showSlide(0)

    document.onkeydown = (e) ->
      switch e.which
        when 37
          view.goBack()
        when 39
          view.advance()

    $('code').attr('data-language', 'javascript')
    Rainbow.color()

  $.ajax './presentation.mkd',
    success: success
    error: ->
      alert 'error ' + arguments
