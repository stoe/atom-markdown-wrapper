LinkWrap = require './linkwrap.coffee'

module.exports =
  config: {}

  activate: ->
    @linkWrap = new LinkWrap()

    @command = atom.commands.add "atom-text-editor",
        "atom-linkwrap:paste", (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()
            clipboard = atom.clipboard.read()

            @linkWrap.paste(editor, selection, clipboard)

  deactivate: ->
    @command.dispose()
    @linkWrap.destroy()
