mdwrap = require './mdwrap.coffee'
{Notification} = require 'atom'

module.exports =
  config: {}

  activate: ->
    @mdwrap = new mdwrap()

    @command = atom.commands.add 'atom-text-editor',
        'atom-markdown-wrapper:paste', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()
            clipboard = atom.clipboard.read()

            try
              @mdwrap.paste(editor, selection, clipboard)
            catch
              atom.notifications.addError('Not a valid URL', {
                dismissable: true,
                detail: clipboard,
                icon: 'zap'
              })

    @command = atom.commands.add 'atom-text-editor',
        'atom-markdown-wrapper:image', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            clipboard = atom.clipboard.read()
            selection = editor.getSelectedText()

            try
              @mdwrap.image(editor, clipboard, selection)
            catch
              atom.notifications.addError('Not a valid image URL', {
                dismissable: true,
                detail: clipboard,
                icon: 'zap'
              })

    @command = atom.commands.add 'atom-text-editor',
        'atom-markdown-wrapper:bold', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()

            @mdwrap.bold(editor, selection)

    @command = atom.commands.add 'atom-text-editor',
        'atom-markdown-wrapper:italic', (event) =>
            editor = atom.workspace.getActiveTextEditor()
            selection = editor.getSelectedText()

            @mdwrap.italic(editor, selection)

  deactivate: ->
    @command.dispose()
    @mdwrap.destroy()
