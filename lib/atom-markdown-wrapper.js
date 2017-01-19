'use babel';

const MDWwrap = require('./mdwrap');

const cb = fn => {
  let clipboard = atom.clipboard.read();
  let editor = atom.workspace.getActiveTextEditor();
  let selection = editor.getSelectedText();

  try {
    return this.mdwrap[fn](editor, selection, clipboard);
  } catch (err) {
    return atom.notifications.addError(err.message, {
      dismissable: true,
      detail: clipboard,
      icon: 'zap'
    });
  }
};

module.exports = {
  config: {},
  activate: () => {
    this.mdwrap = new MDWwrap();

    this.command = atom.commands.add('atom-text-editor', {
      'atom-markdown-wrapper:paste': cb.bind(this, 'paste'),
      'atom-markdown-wrapper:image': cb.bind(this, 'image'),
      'atom-markdown-wrapper:bold': cb.bind(this, 'bold'),
      'atom-markdown-wrapper:italic': cb.bind(this, 'italic'),
      'atom-markdown-wrapper:strikethrough': cb.bind(this, 'strikethrough')
    });

    return this.command;
  },
  deactivate: () => {
    this.command.dispose();

    return this.mdwrap.destroy();
  }
};
