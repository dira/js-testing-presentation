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

  it 'should create a new slide from each <h1> tag until the next <h1> tag, or until the end', ->
    input = "<h1>Slide1</h1><p>contents1</p><h1>Slide2</h1><p>contents2</p>"
    @presentation = new @Presentation
      html: input
      jquery: $

    output = @presentation.toDOMTree()
    sections = $('section', output)
    expect(sections.size()).to.equal 2
    expect(sections.first().find('h1').get(0)).to.be
    expect(sections.last(). find('h1').get(0)).to.be

  it 'should create one slide when there is only one <h1> tag', ->
    input = "<h1>Slide1</h1><p>contents1</p>"
    @presentation = new @Presentation
      html: input
      jquery: $

    output = @presentation.toDOMTree()
    expect($('section', output).size()).to.equal 1

  it 'should not crash if there is something before the first <h1> tag', ->
    input = "I put something here <h1>Slide1</h1><p>contents1</p>"
    @presentation = new @Presentation
      html: input
      jquery: $

