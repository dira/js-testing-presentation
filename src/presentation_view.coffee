class PresentationView

  constructor: (options) ->
    @container = options.container
    @presentation = options.presentation

    @container.append @presentation.toDOMTree()
    @sections = @container.find('section')

    @createNavigation()

  createNavigation: ->
    @container.append '<nav><a href="#" data-role="previous">Previous</a> | <a href="#" data-role="next">Next</a></nav>'
    @next().click => @advance()
    @previous().click => @goBack()

  showSlide: (number) ->
    @currentSlide = number
    @sections.addClass('hidden')
    @sections.eq(number).removeClass('hidden')

    if number == 0 then @previous().hide() else @previous().show()
    if number == @sections.length - 1 then @next().hide() else @next().show()


  previous: ->
    @container.find('a[data-role="previous"]')

  next: ->
    @container.find('a[data-role="next"]')


  advance: ->
    if @currentSlide < @sections.length - 1
      @showSlide @currentSlide + 1

  goBack: ->
    if @currentSlide > 0
      @showSlide @currentSlide - 1

root = exports ? window
root.PresentationView = PresentationView
