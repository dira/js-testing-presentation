chai  = require 'chai'
chai.should()
$     = require 'jquery'


describe 'The presentation', ->




  it 'should create a new slide from each <h1> tag until the next <h1> tag, or until the end', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p>
                             <h1>Slide2</h1><p>contents2</p>"

    sections.size().should.equal 2

    sections.first().find('h1').get(0).should.be
    sections.first().find('p') .get(0).should.be

    sections.last(). find('h1').get(0).should.be
    sections.last(). find('p') .get(0).should.be






  it 'should create one slide when there is only one <h1> tag', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p>"

    sections.size().should.equal 1


  it 'should not crash if there is something before the first <h1> tag', ->
    sections = @getSections "I put something here <h1>Slide1</h1><p>contents1</p>"

    sections.size().should.equal 1


  it 'should create a notes tag for everything that is under a <hr>', ->
    sections = @getSections "<h1>Slide1</h1><p>contents1</p><hr/><p>these are notes</p>
                             <h1>Slide2</h1><p>contents2</p>"

    sections.length.should.equal 2
    sections.first().find('.notes').length.should.equal 1
    sections.first().find('.notes').html().trim().should.equal('<p>these are notes</p>')

    sections.last().find('.notes').length.should.equal 0


  beforeEach ->
    @Presentation = (require '../src/presentation').Presentation

    @getOutput = (input) ->
      presentation = new @Presentation html: input, jquery: $
      presentation.toDOMTree()

    @getSections = (input) ->
      @getOutput(input).find('section')
