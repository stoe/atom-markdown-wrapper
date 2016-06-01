AtomLinkwrap = require '../lib/atom-linkwrap'
Linkwrap = require '../lib/linkwrap'

describe 'AtomLinkwrap', ->
  [editor, sel, txt, img] = []

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-gfm'

    waitsForPromise ->
      atom.workspace.open 'sample.md'

    @linkwrap = new Linkwrap()

  afterEach ->
    atom.reset()

    @linkwrap.destroy()

  it 'should load correctly', ->
    expect(AtomLinkwrap).toBeDefined()

  describe '@linkwrap', ->
    beforeEach ->
      editor = atom.workspace.getActiveTextEditor()
      sel = 'selection'
      txt = 'https://example.com'
      img = 'https://example.com/image.png'

    afterEach ->
      editor = null
      sel = null
      txt = null
      img = null

    it 'should be defined', ->
      expect(@linkwrap).toBeDefined()

    describe '.paste()', ->

      it 'should be defined', ->
        expect(@linkwrap.paste).toBeDefined()

      it 'should require three parameters', ->
        spyOn(@linkwrap, 'paste')

        @linkwrap.paste(1, 2, 3)
        expect(@linkwrap.paste).toHaveBeenCalledWith(1, 2, 3)

      it 'should replace `selection` with [selection](https://example.com)', ->
        spyOn(@linkwrap, 'paste').andCallThrough()

        res = @linkwrap.paste(editor, sel, txt)
        expect(@linkwrap.paste).toHaveBeenCalledWith(editor, sel, txt)
        expect(res).toBe '[selection](https://example.com)'

    describe '.image()', ->

      it 'should be defined', ->
        expect(@linkwrap.image).toBeDefined()

      it 'should require 2 parameters', ->
        spyOn(@linkwrap, 'image')

        @linkwrap.image(1, 2)
        expect(@linkwrap.image).toHaveBeenCalledWith(1, 2)

      it 'should accept 3 parameters', ->
        spyOn(@linkwrap, 'image')

        @linkwrap.image(1, 2, 3)
        expect(@linkwrap.image).toHaveBeenCalledWith(1, 2, 3)

      it 'should insert ![](https://example.com/image.png)', ->
        spyOn(@linkwrap, 'image').andCallThrough()

        res = @linkwrap.image(editor, img)
        expect(@linkwrap.image).toHaveBeenCalledWith(editor, img)
        expect(res).toBe '![](https://example.com/image.png)'

      it 'should replace `selection` with ![selection](https://example.com/image.png)', ->
        spyOn(@linkwrap, 'image').andCallThrough()

        res = @linkwrap.image(editor, img, sel)
        expect(@linkwrap.image).toHaveBeenCalledWith(editor, img, sel)
        expect(res).toBe '![selection](https://example.com/image.png)'
