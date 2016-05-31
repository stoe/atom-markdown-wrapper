{ CompositeDisposable } = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-linkwrap:paste': => @paste()

  deactivate: ->
    @subscriptions.dispose()

  paste: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      clipboard = atom.clipboard.read()

      if selection
        insert = '[$name]($href)'
        .replace('$name', selection)
        .replace('$href', clipboard)

        editor.insertText(insert)
