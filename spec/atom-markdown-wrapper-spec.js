'use babel';

const Atommdwrap = require('../lib/atom-markdown-wrapper');
const mdwrap = require('../lib/mdwrap');

describe('Atom Markdown Wrapper', () => {
  [editor, sel, txt, anchor, img] = [];

  beforeEach(() => {
    waitsForPromise(() => {
      return atom.packages.activatePackage('language-gfm');
    });

    waitsForPromise(() => {
      return atom.workspace.open('sample.md');
    });

    return this.mdwrap = new mdwrap();
  });

  afterEach(() => {
    atom.reset();

    return this.mdwrap.destroy();
  });

  it('should load correctly', () => {
    expect(Atommdwrap).toBeDefined();
  });

  describe('mdwrap', () => {

    beforeEach(() => {
      editor = atom.workspace.getActiveTextEditor();
      sel = 'selection';
      txt = 'https://example.com';
      anchor = '#example';
      img = 'https://example.com/image.png';
    });

    afterEach(() => {
      editor = null;
      sel = null;
      txt = null;
      anchor = null;
      img = null;
    });

    it('should be defined', () => {
      expect(this.mdwrap).toBeDefined();
    });

    describe('.paste()', () => {

      it('should be defined', () => {
        expect(this.mdwrap.paste).toBeDefined();
      });

      it('should require three parameters', () => {
        spyOn(this.mdwrap, 'paste');

        this.mdwrap.paste(1, 2, 3);
        expect(this.mdwrap.paste).toHaveBeenCalledWith(1, 2, 3);
      });

      it('should only paste valid links', () => {
        expect(() => new mdwrap().paste(editor, sel, 'foobar')).toThrow('Not a valid URL or #anchor');
      });

      it('should replace `selection` with [selection](https://example.com) for web links', () => {
        spyOn(this.mdwrap, 'paste').andCallThrough();

        res = this.mdwrap.paste(editor, sel, txt);
        expect(this.mdwrap.paste).toHaveBeenCalledWith(editor, sel, txt);
        expect(res).toBe('[selection](https://example.com)');
      });

      it('should replace `selection` with [selection](#example) for anchor links', () => {
        spyOn(this.mdwrap, 'paste').andCallThrough()

        res = this.mdwrap.paste(editor, sel, anchor)
        expect(this.mdwrap.paste).toHaveBeenCalledWith(editor, sel, anchor)
        expect(res).toBe('[selection](#example)');
      });

    });

    describe('.image()', () => {

      it('should be defined', () => {
        expect(this.mdwrap.image).toBeDefined();
      });

      it('should require two parameters', () => {
        spyOn(this.mdwrap, 'image');

        this.mdwrap.image(1, 2);
        expect(this.mdwrap.image).toHaveBeenCalledWith(1, 2);
      });

      it('should accept three parameters', () => {
        spyOn(this.mdwrap, 'image');

        this.mdwrap.image(1, 2, 3);
        expect(this.mdwrap.image).toHaveBeenCalledWith(1, 2, 3);
      });

      it('should only paste valid URLs', () => {
        expect(() => new mdwrap().image(editor, sel, 'image')).toThrow('Not a valid image URL');
      });

      it('should insert ![](https://example.com/image.png)', () => {
        spyOn(this.mdwrap, 'image').andCallThrough();

        res = this.mdwrap.image(editor, undefined, img);
        expect(this.mdwrap.image).toHaveBeenCalledWith(editor, undefined, img);
        expect(res).toBe('![](https://example.com/image.png)');
      });

      it('should replace `selection` with ![selection](https://example.com/image.png)', () => {
        spyOn(this.mdwrap, 'image').andCallThrough();

        res = this.mdwrap.image(editor, sel, img);
        expect(this.mdwrap.image).toHaveBeenCalledWith(editor, sel, img);
        expect(res).toBe('![selection](https://example.com/image.png)');
      });

    });

    describe('.bold()', () => {
      it('should be defined', () => {
        expect(this.mdwrap.bold).toBeDefined();
      });

      it('should require 2 parameters', () => {
        spyOn(this.mdwrap, 'bold');

        this.mdwrap.bold(1, 2);
        expect(this.mdwrap.bold).toHaveBeenCalledWith(1, 2);
      });

      it('should insert **selection**', () => {
        spyOn(this.mdwrap, 'bold').andCallThrough();

        res = this.mdwrap.bold(editor, sel);
        expect(this.mdwrap.bold).toHaveBeenCalledWith(editor, sel);
        expect(res).toBe('**selection**');
      });
    });

    describe('.italic()', () => {
      it('should be defined', () => {
        expect(this.mdwrap.italic).toBeDefined();
      });

      it('should require 2 parameters', () => {
        spyOn(this.mdwrap, 'italic');

        this.mdwrap.italic(1, 2);
        expect(this.mdwrap.italic).toHaveBeenCalledWith(1, 2);
      });

      it('should insert _selection_', () => {
        spyOn(this.mdwrap, 'italic').andCallThrough();

        res = this.mdwrap.italic(editor, sel);
        expect(this.mdwrap.italic).toHaveBeenCalledWith(editor, sel);
        expect(res).toBe('_selection_');
      });
    });
  });
});
