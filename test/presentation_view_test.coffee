chai = require 'chai'
chai.should()
sinon = require 'sinon'

$ = require 'jquery'

describe 'Presentation view', ->

  beforeEach ->
    @PresentationView = (require '../src/presentation_view').PresentationView
    slides = $('<div>
                   <section>s1</section>
                   <section>s2</section>
                   <section>s3</section>
                </div>')

    @container = $('<div/>')

    @view = new @PresentationView
      container:    @container
      presentation: { toDOMTree: sinon.stub().returns(slides) }


  describe 'on initialization', ->

    it 'adds all the slides to the container', ->
      @container.find('div section').length.should.equal 3

    it 'creates navigation', ->
      @container.find('nav').get(0).should.be.ok

    it 'creates a "previous" link in the navigation', ->
      @getNav('previous').get(0).should.be.ok

    it 'creates a "next" link in the navigation', ->
      @getNav('next').get(0).should.be.ok


  describe 'show a slide', ->
    it 'makes only that slide visible', ->
      @view.showSlide(0)
      @container.find('section').eq(0).is(':visible').should.be.true
      @container.find('section').eq(1).is(':visible').should.be.false
      @container.find('section').eq(2).is(':visible').should.be.false

    xit 'changes the url bar to include the number of the slide', ->

  describe 'show navigation buttons', ->

    describe 'on the first slide', ->

      beforeEach -> @view.showSlide(0)

      it 'does not show a "previous" button', ->
        @shouldShow('previous', false)

      it 'shows a "next" button', ->
        @shouldShow('next', true)


    describe 'on a slide in the middle of the presentation', ->

      beforeEach -> @view.showSlide(1)

      it 'shows a "previous" button', ->
        @shouldShow('previous', true)

      it 'shows a "next" button', ->
        @shouldShow('next', true)

    describe 'on the last slide', ->

      beforeEach -> @view.showSlide(2)

      it 'shows a "previous" button', ->
        @shouldShow('previous', true)

      it 'does not show a "next" button', ->
        @shouldShow('next', false)

  describe 'navigation', ->

    it 'advances when "next" is clicked', ->
      spy = sinon.spy @view, 'advance'
      @getNav('next').click()
      spy.called.should.be.true

    describe 'advance', ->
      it 'shows the next slide', ->
        @view.showSlide(1)

        spy = sinon.spy @view, 'showSlide'
        @view.advance()
        spy.calledWith(2).should.be.true

      it 'does not show the next slide if already on the last slide', ->
        @view.showSlide(2)
        spy = sinon.spy @view, 'showSlide'
        @view.advance()

        spy.called.should.be.false

    it 'goes back when "previous" is clicked', ->
      spy = sinon.spy @view, 'goBack'
      @getNav('previous').click()
      spy.calledOnce.should.be.true

    describe 'go back', ->
      it 'shows the previous slide', ->
        @view.showSlide(1)

        spy = sinon.spy @view, 'showSlide'
        @view.goBack()
        spy.calledWith(0).should.be.true

      it 'does not show the previous slide if on the first slide', ->
        @view.showSlide(0)
        spy = sinon.spy @view, 'showSlide'
        @view.goBack()

        spy.called.should.be.false


  beforeEach ->

    @getNav = (role) ->
      @container.find("nav a[data-role='#{role}']")

    @shouldShow = (role, visible) ->
      @getNav(role).is(':visible').should.equal visible
