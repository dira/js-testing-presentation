chai = require 'chai'
expect = chai.expect
# chai.should()

sinon = require 'sinon'
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
    slides = $('<div><section>s1</section><section>s2</section><section>s3</section></div>')

    @container = $('<div/>')
    @view = new @PresentationView
      container: @container
      presentation: { toDOMTree: sinon.stub().returns(slides) }

    @getNav = (role) ->
      @container.find("nav a[data-role='#{role}']")

    @shouldShow = (role, visible) ->
      expect(@getNav(role).is(':visible')).to.equal visible

  describe 'on initialization', ->
    it 'adds all the slides to the document', ->
      expect(@container.find('div section').length).to.equal 3

    it 'creates navigation', ->
      expect(@container.find('nav').get(0)).to.be.ok

    it 'creates a "previous" link in the navigation', ->
      expect(@getNav('previous').get(0)).to.be.ok

    it 'creates a "next" link in the navigation', ->
      expect(@getNav('next').get(0)).to.be.ok

  describe 'show a slide', ->
    it 'makes only that slide visible', ->
      @view.showSlide(0)
      expect(@container.find('section').eq(0).is(':visible')).to.equal true
      expect(@container.find('section').eq(1).is(':visible')).to.equal false
      expect(@container.find('section').eq(2).is(':visible')).to.equal false

    xit 'changes the url bar to include the number of the slide', ->

  describe 'show navigation buttons', ->

    describe 'on the first slide', ->
      beforeEach ->
        @view.showSlide(0)

      it 'does not show a "previous" button', ->
        @shouldShow('previous', false)

      it 'shows a "next" button', ->
        @shouldShow('next', true)


    describe 'on a slide in the middle of the presentation', ->
      beforeEach ->
        @view.showSlide(1)

      it 'shows a "previous" button', ->
        @shouldShow('previous', true)

      it 'shows a "next" button', ->
        @shouldShow('next', true)

    describe 'on the last slide', ->
      beforeEach ->
        @view.showSlide(2)

      it 'shows a "previous" button', ->
        @shouldShow('previous', true)

      it 'does not show a "next" button', ->
        @shouldShow('next', false)

  describe 'navigation', ->
    it 'advances to the next slide when "next" is clicked', ->
      @view.showSlide(1)
      spy = sinon.spy @view, 'showSlide'
      @getNav('next').click()

      expect(spy.calledWith(2)).to.equal true

    it 'does not advance if already on the last slide', ->
      @view.showSlide(2)
      spy = sinon.spy @view, 'showSlide'
      @getNav('next').click()

      expect(spy.called).to.equal false

    it 'goes back to the previous slide when "previous" is clicked', ->
      @view.showSlide(1)
      spy = sinon.spy @view, 'showSlide'
      @getNav('previous').click()

      expect(spy.calledWith(0)).to.equal true

    it 'does not go back if on the first slide', ->
      @view.showSlide(0)
      spy = sinon.spy @view, 'showSlide'
      @getNav('previous').click()

      expect(spy.called).to.equal false



