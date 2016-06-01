LinkWrap = require './linkwrap.coffee'

module.exports =
  config: {}

  activate: ->
    @linkWrap = new LinkWrap()

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:paste', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()
            clipboard = atom.clipboard.read()

            @linkWrap.paste(editor, selection, clipboard)

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:image', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            clipboard = atom.clipboard.read()
            selection = editor.getSelectedText()

            @linkWrap.image(editor, clipboard, selection)

  deactivate: ->
    @command.dispose()
    @linkWrap.destroy()
