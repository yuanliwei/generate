{CompositeDisposable} = require 'atom'

module.exports =
class SearchView

  subscriptions: null

  constructor: (serializedState) ->
    # Create root element
    @subscriptions = new CompositeDisposable
    @element = document.createElement('div')
    @element.classList.add('search_root')
    # Create input element
    input = document.createElement('div')
    input.textContent = 'this is input box'
    input.classList.add('search_input')
    @subscriptions.add atom.tooltips.add(input, {title: 'This is a tooltip'})
    @element.appendChild(input)
    window.input = input
    input.on

    # Create message element
    message = document.createElement('search_msg')
    message.textContent = "The Generate package is Alive! It's ALIVE!-----------------"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @subscriptions.dispose()
    @element.remove()

  getElement: ->
    @element
