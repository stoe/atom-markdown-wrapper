LinkWrap = require './linkwrap.coffee'
{Notification} = require 'atom'

module.exports =
  config: {}

  activate: ->
    @linkWrap = new LinkWrap()

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:paste', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()
            clipboard = atom.clipboard.read()

            try
              @linkWrap.paste(editor, selection, clipboard)
            catch
              atom.notifications.addError('Not a valid URL', {
                dismissable: true,
                detail: clipboard,
                icon: 'zap'
              })

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:image', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            clipboard = atom.clipboard.read()
            selection = editor.getSelectedText()

            try
              @linkWrap.image(editor, clipboard, selection)
            catch
              atom.notifications.addError('Not a valid image URL', {
                dismissable: true,
                detail: clipboard,
                icon: 'zap'
              })

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:bold', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()

            @linkWrap.bold(editor, selection)

    @command = atom.commands.add 'atom-text-editor',
        'atom-linkwrap:italic', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()

            @linkWrap.italic(editor, selection)

  deactivate: ->
    @command.dispose()
    @linkWrap.destroy()
