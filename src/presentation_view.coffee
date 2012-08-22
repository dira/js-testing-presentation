class PresentationView

  constructor: (options) ->
    @container = options.container

    @createNavigation()

  createNavigation: ->
    @container.append '<nav><a href="#" data-role="previous">Previous</a> | <a href="#" data-role="next">Next</a></nav>'

root = exports ? window
root.PresentationView = PresentationView
