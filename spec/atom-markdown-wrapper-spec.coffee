Atommdwrap = require '../lib/atom-markdown-wrapper'
mdwrap = require '../lib/mdwrap'

describe 'Atom Markdown Wrapper', ->
  [editor, sel, txt, anchor, img] = []

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-gfm'

    waitsForPromise ->
      atom.workspace.open 'sample.md'

    @mdwrap = new mdwrap()

  afterEach ->
    atom.reset()

    @mdwrap.destroy()

  it 'should load correctly', ->
    expect(Atommdwrap).toBeDefined()

  describe '@mdwrap', ->
    beforeEach ->
      editor = atom.workspace.getActiveTextEditor()
      sel = 'selection'
      txt = 'https://example.com'
      anchor = '#example'
      img = 'https://example.com/image.png'

    afterEach ->
      editor = null
      sel = null
      txt = null
      anchor = null
      img = null

    it 'should be defined', ->
      expect(@mdwrap).toBeDefined()

    describe '.paste()', ->
      it 'should be defined', ->
        expect(@mdwrap.paste).toBeDefined()

      it 'should require three parameters', ->
        spyOn(@mdwrap, 'paste')

        @mdwrap.paste(1, 2, 3)
        expect(@mdwrap.paste).toHaveBeenCalledWith(1, 2, 3)

      it 'should only paste valid links', ->
        expect(-> new mdwrap().paste(editor, sel, 'foobar')).toThrow('Not a valid URL or #anchor')

      it 'should replace `selection` with [selection](https://example.com) for web links', ->
        spyOn(@mdwrap, 'paste').andCallThrough()

        res = @mdwrap.paste(editor, sel, txt)
        expect(@mdwrap.paste).toHaveBeenCalledWith(editor, sel, txt)
        expect(res).toBe '[selection](https://example.com)'

      it 'should replace `selection` with [selection](#example) for anchor links', ->
        spyOn(@mdwrap, 'paste').andCallThrough()

        res = @mdwrap.paste(editor, sel, anchor)
        expect(@mdwrap.paste).toHaveBeenCalledWith(editor, sel, anchor)
        expect(res).toBe '[selection](#example)'

    describe '.image()', ->
      it 'should be defined', ->
        expect(@mdwrap.image).toBeDefined()

      it 'should require 2 parameters', ->
        spyOn(@mdwrap, 'image')

        @mdwrap.image(1, 2)
        expect(@mdwrap.image).toHaveBeenCalledWith(1, 2)

      it 'should accept 3 parameters', ->
        spyOn(@mdwrap, 'image')

        @mdwrap.image(1, 2, 3)
        expect(@mdwrap.image).toHaveBeenCalledWith(1, 2, 3)

      it 'should only paste valid URLs', ->
        expect(-> new mdwrap().image(editor, sel, 'image')).toThrow('Not a valid image URL')

      it 'should insert ![](https://example.com/image.png)', ->
        spyOn(@mdwrap, 'image').andCallThrough()

        res = @mdwrap.image(editor, undefined, img)
        expect(@mdwrap.image).toHaveBeenCalledWith(editor, undefined, img)
        expect(res).toBe '![](https://example.com/image.png)'

      it 'should replace `selection` with ![selection](https://example.com/image.png)', ->
        spyOn(@mdwrap, 'image').andCallThrough()

        res = @mdwrap.image(editor, sel, img)
        expect(@mdwrap.image).toHaveBeenCalledWith(editor, sel, img)
        expect(res).toBe '![selection](https://example.com/image.png)'

    describe '.bold()', ->
      it 'should be defined', ->
        expect(@mdwrap.bold).toBeDefined()

      it 'should require 2 parameters', ->
        spyOn(@mdwrap, 'bold')

        @mdwrap.bold(1, 2)
        expect(@mdwrap.bold).toHaveBeenCalledWith(1, 2)

      it 'should insert **selection**', ->
        spyOn(@mdwrap, 'bold').andCallThrough()

        res = @mdwrap.bold(editor, sel)
        expect(@mdwrap.bold).toHaveBeenCalledWith(editor, sel)
        expect(res).toBe '**selection**'

    describe '.italic()', ->
      it 'should be defined', ->
        expect(@mdwrap.italic).toBeDefined()

      it 'should require 2 parameters', ->
        spyOn(@mdwrap, 'italic')

        @mdwrap.italic(1, 2)
        expect(@mdwrap.italic).toHaveBeenCalledWith(1, 2)

      it 'should insert _selection_', ->
        spyOn(@mdwrap, 'italic').andCallThrough()

        res = @mdwrap.italic(editor, sel)
        expect(@mdwrap.italic).toHaveBeenCalledWith(editor, sel)
        expect(res).toBe '_selection_'
