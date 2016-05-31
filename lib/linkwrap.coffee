{ CompositeDisposable } = require 'atom'

module.exports =
  class LinkWrap
    subscriptions: []

    constructor: ->
      @subscriptions = new CompositeDisposable
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-linkwrap:paste': => @paste()

    destroy: ->
      @subscriptions.dispose()

    paste: (editor, selection, clipboard) ->
      if editor && selection && clipboard
        insert = '[$selection]($href)'
          .replace('$selection', selection)
          .replace('$href', clipboard)

        editor.insertText(insert)

        return insert
