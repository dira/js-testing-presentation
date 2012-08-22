class Presentation

  constructor: (options) ->
    @html = options.html
    @$ = options.jquery


  toDOMTree: ->
    nodes = @$(@html)
    result = @$('<div/>')

    currentSlide = null
    notes = null

    nodes.each (_, node) =>
      node = @$(node)

      if node.is('h1')
        result.append(currentSlide) if currentSlide?
        currentSlide = @newSlide()
        notes = null

      if (container = currentSlide)?
        if node.is('hr')
          notes = node = @newNotes()
        else
          if notes?
            container = notes

        container.append(node)

    result.append(currentSlide) if currentSlide?

    result


  newSlide: ->
    @$('<section/>')

  newNotes: ->
    @$('<div class="notes"/>')


root = exports ? window
root.Presentation = Presentation
