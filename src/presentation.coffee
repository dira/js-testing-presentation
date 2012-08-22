class Presentation

  constructor: (options) ->
    @html = options.html
    @$ = options.jquery


  toDOMTree: ->
    nodes = @$(@html)

    result = @$('<div/>')
    currentSlide = null
    nodes.each (_, node) =>

      node = @$(node)
      if node.is('h1')
        result.append(currentSlide) if currentSlide?
        currentSlide = @newSlide()

      currentSlide.append(node) if currentSlide?

    result.append(currentSlide) if currentSlide?

    result


  newSlide: ->
    @$('<section/>')

# class TaskList
  # constructor: () ->
    # @tasks = []
    # @length = 0
  # add: (task) ->
    # if typeof task is 'string'
      # @tasks.push new Task task
    # else
      # @tasks.push task
    # @length = @tasks.length
  # remove: (task) ->
    # i = @tasks.indexOf task
    # @tasks = @tasks[0...i].concat @tasks[i+1..] if i > -1
    # @length = @tasks.length
  # print: ->
    # str = "Tasks\n\n"
    # for task in @tasks
      # str += "- #{task.name}"
      # str += " (depends on '#{task.parent.name}')" if task.parent?
      # str += ' (complete)' if task.status is 'complete'
      # str += "\n"
    # str

# class Task
  # constructor: (@name) ->
    # @status = 'incomplete'
  # dependsOn: (@parent) ->
    # @parent.child = @
    # @status = 'dependent'
  # complete: ->
    # if @parent? and @parent.status isnt 'completed'
      # throw "Dependent task '#{@parent.name}' is not completed."
    # @status = 'complete'
    # true

root = exports ? window
root.Presentation = Presentation
# root.Task = Task
