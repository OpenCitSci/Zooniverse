window.zooniverse ?= {}
window.zooniverse.controllers ?= {}
window.zooniverse.views ?= {}

BaseController = window.zooniverse.controllers.BaseController || require './base-controller'
template = window.zooniverse.views.paginator || require '../views/paginator'
User = window.zooniverse.models.User || require '../models/user'
$ = window.jQuery

class Paginator extends BaseController
  type: null
  itemTemplate: null

  className: 'zooniverse-paginator'
  template: template

  pages: 0
  perPage: 10

  events:
    'click button[name="page"]': 'onClickPage'

  elements:
    '.items': 'itemsContainer'
    '.numbered': 'numbersContainer'

  constructor: ->
    super
    User.on 'change', @onUserChange

    @type.on 'from-classification', @onItemFromClassification
    @type.on 'destroy', @onItemDestroyed

  onUserChange: (e, user) =>
    @reset @typeCount()
    @onFetch []
    @goTo 1 if user?

  reset: (itemCount) ->
    @pages = Math.ceil itemCount / @perPage

    @numbersContainer.empty()
    for i in [0...@pages]
      button = $("<button name='page' value='#{i + 1}'>#{i + 1}</button>")
      @numbersContainer.append button

  onClickPage: ({target}) ->
    page = +$(target).val()
    @goTo page

  goTo: (page) ->
    page = Math.max page, 1

    @el.removeClass 'failed'
    @numbersContainer.children().removeClass 'active'
    @numbersContainer.children("[value='#{page}']").addClass 'active'

    @el.addClass 'loading'
    fetch = @type.fetch page: page, per_page: @perPage
    fetch.then @onFetch, @onFetchFail
    fetch.always => @el.removeClass 'loading'

  typeCount: ->
    User.current?.project?.classification_count || 0

  onFetch: (items) =>
    @itemsContainer.empty()
    @el.toggleClass 'empty', items.length is 0

    @addItemToContainer item for item in items

  getItemEl: (item) ->
    itemEl = @itemsContainer.find "[data-item-id='#{item.id}']"

    if itemEl.length is 0
      inner = if @itemTemplate?
        @itemTemplate item
      else
        """<div class='item'><a href="#{item.subjects[0]?.talkHref() || '#/SUBJECT-ERROR'}">#{item.subjects[0]?.zooniverse_id || 'Error in subject'}</a></div>"""

      itemEl = $($.trim inner)
      itemEl.attr 'data-item-id': item.id

    itemEl

  addItemToContainer: (item) =>
    itemEl = @getItemEl item
    itemEl.prependTo @itemsContainer
    itemEl

  onFetchFail: =>
    @el.addClass 'failed'

  onItemFromClassification: (e, item) =>
    @addItemToContainer(item).addClass 'new'

    if @itemsContainer.children().length > @perPage
      until @itemsContainer.children().length is @perPage
        @itemsContainer.children().last().remove()

  onItemDestroyed: (e, item) =>
    @getItemEl(item).remove()

window.zooniverse.controllers.Paginator = Paginator
module?.exports = Paginator
