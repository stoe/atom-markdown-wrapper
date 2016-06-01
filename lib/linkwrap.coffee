{ CompositeDisposable } = require 'atom'
validUrl = require 'valid-url'

module.exports =
  class LinkWrap
    subscriptions: []

    constructor: ->
      @subscriptions = new CompositeDisposable
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-linkwrap:paste': => @paste()
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-linkwrap:image': => @image()

    destroy: ->
      @subscriptions.dispose()

    paste: (editor, selection, clipboard) ->
      if editor && selection && clipboard
        insert = '[$selection]($href)'
          .replace('$selection', selection)
          .replace('$href', clipboard)

        if !validUrl.isUri(clipboard)
          throw new Error('Not a valid URL')

        editor.insertText(insert)

        return insert

    image: (editor, clipboard, selection) ->
      if editor && clipboard
        insert = '![$selection]($img)'
          .replace('$selection', selection || '')
          .replace('$img', clipboard)

        if !validUrl.isUri(clipboard)
          throw new Error('Not a valid image URL')

        editor.insertText(insert)

        return insert
