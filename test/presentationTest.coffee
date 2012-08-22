chai = require 'chai'
expect = chai.expect
chai.should()

$ = require 'jquery'

describe 'Markdown', ->

  beforeEach ->
    @markdown = require '../vendor/markdown'

  it 'should work with example input', ->
    markdown = "# Heading\n\nParagraph"
    expectedHtml = '<h1>Heading</h1>\n\n<p>Paragraph</p>'
    expect(@markdown.toHTML(markdown)).to.equal expectedHtml


describe 'Presentation generator', ->
  beforeEach ->
    @Presentation = (require '../src/presentation').Presentation

    @getOutput = (input) ->
      @presentation = new @Presentation
        html: input
        jquery: $
      @presentation.toDOMTree()

    @getSections = (input) ->
      $('section', @getOutput(input))

  it 'should create a new slide from each <h1> tag until the next <h1> tag, or until the end', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p><h1>Slide2</h1><p>contents2</p>"

    expect(sections.size()).to.equal 2
    expect(sections.first().find('h1').get(0)).to.be
    expect(sections.last(). find('h1').get(0)).to.be

  it 'should create one slide when there is only one <h1> tag', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p>"

    expect(sections.size()).to.equal 1

  it 'should not crash if there is something before the first <h1> tag', ->
    sections = @getSections "I put something here <h1>Slide1</h1><p>contents1</p>"

    expect(sections.size()).to.equal 1

  it 'should create a notes tag for everything that is under a <hr>', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p><hr/><p>these are notes</p><h1>Slide2</h1><p>contents2</p>"

    expect(sections.size()).to.equal 2
    expect(sections.first().find('.notes').get(0)).to.be.ok
    expect(sections.first().find('.notes').html()).to.equal('<p>these are notes</p>')

    expect(sections.first().find('.notes').get(0)).to.not.be

describe 'Presentation view', ->
  beforeEach ->
    @PresentationView = (require '../src/presentation_view').PresentationView
    @container = $('<div/>')
    @view = new @PresentationView container: @container

  describe 'on initialization', ->
    it 'creates navigation', ->
      # XXX better jquery matcher?
      expect(@container.find('nav').get(0)).to.be.ok

    it 'creates a "previous" link in the navigation', ->
      expect(@container.find('nav [data-role="previous"]').get(0)).to.be.ok

    it 'creates a "next" link in the navigation', ->
      expect(@container.find('nav [data-role="next"]').get(0)).to.be.ok

  # describe 'showing the first slide', ->
    # beforeEach:, ->
      # @view.showSlide(0)
      # @shouldShow = (key, visible) ->

    # it 'shows a "next" button', ->
      # # XXX matcher
      # shouldShow('next', true)

    # it 'does not show a "previous" button', ->
      # shouldShow('previous', true)

  # describe 'navigation', ->
    # it 'advances to the next slide when "next" is clicked', ->
    # it 'goes back to the previous slide when "previous" is clicked', ->

  # describe 'on a slide in the middle of the presentation', ->
    # it 'shows a "next" button', ->
    # it 'shows a "previous" button', ->

  # describe 'on the last slide', ->
    # it 'does not show a "next" button', ->
    # it 'does not show a "previous" button', ->

  # describe 'show a slide', ->
    # it 'makes only that slide visible', ->
    # it 'changes the url bar to include the number of the slide', ->
