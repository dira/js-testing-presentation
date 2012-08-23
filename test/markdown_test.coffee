chai = require 'chai'
chai.should()

describe 'The markdown processor', ->

  it 'should transform markdown into HTML', ->
    processor = require '../vendor/markdown'

    markdown = '# Heading\n\nParagraph'
    html     = '<h1>Heading</h1>\n\n<p>Paragraph</p>'

    processor.toHTML(markdown).should.equal html
