chai = require 'chai'
expect = chai.expect

sinon = require 'sinon'
$ = require 'jquery'


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

