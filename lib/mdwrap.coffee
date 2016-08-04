{ CompositeDisposable } = require 'atom'
validUrl = require 'valid-url'

module.exports =
  class mdwrap
    subscriptions: []

    constructor: ->
      @subscriptions = new CompositeDisposable
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-markdown-wrapper:paste': => @paste()
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-markdown-wrapper:image': => @image()
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-markdown-wrapper:bold': => @bold()
      @subscriptions.add atom.commands.add 'atom-workspace',
        'atom-markdown-wrapper:italic': => @italic()

    destroy: ->
      @subscriptions.dispose()

    paste: (editor, selection, clipboard) ->
      if editor && selection && clipboard
        insert = '[$selection]($href)'
          .replace('$selection', selection)
          .replace('$href', clipboard)

        if !(validUrl.isWebUri(clipboard) || clipboard.match(/^\#/))
          throw new Error('Not a valid URL or #anchor')

        editor.insertText(insert)

        return insert

    image: (editor, clipboard, selection) ->
      if editor && clipboard
        insert = '![$selection]($img)'
          .replace('$selection', selection || '')
          .replace('$img', clipboard)

        if !validUrl.isWebUri(clipboard)
          throw new Error('Not a valid image URL')

        editor.insertText(insert)

        return insert

    bold: (editor, selection) ->
      if editor && selection
        insert = '**$selection**'
          .replace('$selection', selection)

        editor.insertText(insert)

        return insert

    italic: (editor, selection) ->
      if editor && selection
        insert = '_$selection_'
          .replace('$selection', selection)

        editor.insertText(insert)

        return insert
