chai = require 'chai'
expect = chai.expect

describe 'Markdown', ->

  beforeEach ->
    @markdown = require '../vendor/markdown'

  it 'should work with example input', ->
    markdown = "# Heading\n\nParagraph"
    expectedHtml = '<h1>Heading</h1>\n\n<p>Paragraph</p>'
    expect(@markdown.toHTML(markdown)).to.equal expectedHtml
