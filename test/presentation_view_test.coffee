chai = require 'chai'
expect = chai.expect

sinon = require 'sinon'
$ = require 'jquery'

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
      expect(@container.find('section').eq(0).is(':visible')).to.be.true
      expect(@container.find('section').eq(1).is(':visible')).to.be.false
      expect(@container.find('section').eq(2).is(':visible')).to.be.false

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
    it 'advances when "next" is clicked', ->
      spy = sinon.spy @view, 'advance'
      @getNav('next').click()
      expect(spy.called).to.be.true

    describe 'advance', ->
      it 'shows the next slide', ->
        @view.showSlide(1)

        spy = sinon.spy @view, 'showSlide'
        @view.advance()
        expect(spy.calledWith(2)).to.be.true

      it 'does not show the next slide if already on the last slide', ->
        @view.showSlide(2)
        spy = sinon.spy @view, 'showSlide'
        @view.advance()

        expect(spy.called).to.be.false

    it 'goes back when "previous" is clicked', ->
      spy = sinon.spy @view, 'goBack'
      @getNav('previous').click()
      expect(spy.calledOnce).to.be.true

    describe 'go back', ->
      it 'shows the previous slide', ->
        @view.showSlide(1)

        spy = sinon.spy @view, 'showSlide'
        @view.goBack()
        expect(spy.calledWith(0)).to.be.true

      it 'does not show the previous slide if on the first slide', ->
        @view.showSlide(0)
        spy = sinon.spy @view, 'showSlide'
        @view.goBack()

        expect(spy.called).to.be.false


