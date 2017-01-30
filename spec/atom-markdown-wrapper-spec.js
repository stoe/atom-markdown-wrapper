'use babel';
const AtomMDWrap = require('../lib/atom-markdown-wrapper');
const MDWrap = require('../lib/mdwrap');

describe('Atom Markdown Wrapper', () => {
  let [editor, sel, txt, anchor, img, res] = [];

  beforeEach(() => {
    waitsForPromise(() => {
      return atom.workspace.open('sample.md');
    });

    waitsForPromise(() => {
      return atom.packages.activatePackage('language-gfm');
    });

    this.MDWrap = new MDWrap();

    return this.MDWrap;
  });

  afterEach(() => {
    atom.reset();

    return this.MDWrap.destroy();
  });

  it('should load correctly', () => {
    expect(AtomMDWrap).toBeDefined();
  });

  describe('MDWrap', () => {
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
      expect(this.MDWrap).toBeDefined();
    });

    describe('.paste()', () => {
      it('should be defined', () => {
        expect(this.MDWrap.paste).toBeDefined();
      });

      it('should require three parameters', () => {
        spyOn(this.MDWrap, 'paste');

        this.MDWrap.paste(1, 2, 3);
        expect(this.MDWrap.paste).toHaveBeenCalledWith(1, 2, 3);
      });

      it('should only paste valid links', () => {
        let res = () => new MDWrap().paste(editor, sel, 'foobar');

        expect(res).toThrow('Not a valid URL or #anchor');
      });

      it(
        'should replace `selection` with [selection](https://example.com) for web links',
        () => {
          spyOn(this.MDWrap, 'paste').andCallThrough();

          res = this.MDWrap.paste(editor, sel, txt);
          expect(this.MDWrap.paste).toHaveBeenCalledWith(editor, sel, txt);
          expect(res).toBe('[selection](https://example.com)');
        }
      );

      it(
        'should replace `selection` with [selection](#example) for anchor links',
        () => {
          spyOn(this.MDWrap, 'paste').andCallThrough();

          res = this.MDWrap.paste(editor, sel, anchor);
          expect(this.MDWrap.paste).toHaveBeenCalledWith(editor, sel, anchor);
          expect(res).toBe('[selection](#example)');
        }
      );
    });

    describe('.image()', () => {
      it('should be defined', () => {
        expect(this.MDWrap.image).toBeDefined();
      });

      it('should require two parameters', () => {
        spyOn(this.MDWrap, 'image');

        this.MDWrap.image(1, 2);
        expect(this.MDWrap.image).toHaveBeenCalledWith(1, 2);
      });

      it('should accept three parameters', () => {
        spyOn(this.MDWrap, 'image');

        this.MDWrap.image(1, 2, 3);
        expect(this.MDWrap.image).toHaveBeenCalledWith(1, 2, 3);
      });

      it('should only paste valid URLs', () => {
        let res = () => new MDWrap().image(editor, sel, 'image');

        expect(res).toThrow('Not a valid image URL');
      });

      it('should insert ![](https://example.com/image.png)', () => {
        spyOn(this.MDWrap, 'image').andCallThrough();

        res = this.MDWrap.image(editor, undefined, img);
        expect(this.MDWrap.image).toHaveBeenCalledWith(editor, undefined, img);
        expect(res).toBe('![](https://example.com/image.png)');
      });

      it(
        'should replace `selection` with ![selection](https://example.com/image.png)',
        () => {
          spyOn(this.MDWrap, 'image').andCallThrough();

          res = this.MDWrap.image(editor, sel, img);
          expect(this.MDWrap.image).toHaveBeenCalledWith(editor, sel, img);
          expect(res).toBe('![selection](https://example.com/image.png)');
        }
      );
    });

    describe('.bold()', () => {
      it('should be defined', () => {
        expect(this.MDWrap.bold).toBeDefined();
      });

      it('should require 1 parameter', () => {
        spyOn(this.MDWrap, 'bold');

        this.MDWrap.bold(1);
        expect(this.MDWrap.bold).toHaveBeenCalledWith(1);
      });

      it('should insert **selection**', () => {
        spyOn(this.MDWrap, 'bold').andCallThrough();

        res = this.MDWrap.bold(editor);
        expect(this.MDWrap.bold).toHaveBeenCalledWith(editor);
        expect(typeof res).toBe('object');
        expect(res.length).toBe(1);
        expect(res[0]).toBe(false);
      });
    });

    describe('.italic()', () => {
      it('should be defined', () => {
        expect(this.MDWrap.italic).toBeDefined();
      });

      it('should require 1 parameter', () => {
        spyOn(this.MDWrap, 'italic');

        this.MDWrap.italic(1);
        expect(this.MDWrap.italic).toHaveBeenCalledWith(1);
      });

      it('should insert _selection_', () => {
        spyOn(this.MDWrap, 'italic').andCallThrough();

        res = this.MDWrap.italic(editor);
        expect(this.MDWrap.italic).toHaveBeenCalledWith(editor);
        expect(typeof res).toBe('object');
        expect(res.length).toBe(1);
        expect(res[0]).toBe(false);
      });
    });

    describe('.strikethrough()', () => {
      it('should be defined', () => {
        expect(this.MDWrap.strikethrough).toBeDefined();
      });

      it('should require 1 parameter', () => {
        spyOn(this.MDWrap, 'strikethrough');

        this.MDWrap.strikethrough(1);
        expect(this.MDWrap.strikethrough).toHaveBeenCalledWith(1);
      });

      it('should insert ~~selection~~', () => {
        spyOn(this.MDWrap, 'strikethrough').andCallThrough();

        res = this.MDWrap.strikethrough(editor);
        expect(this.MDWrap.strikethrough).toHaveBeenCalledWith(editor);
        expect(typeof res).toBe('object');
        expect(res.length).toBe(1);
        expect(res[0]).toBe(false);
      });
    });
  });
});
