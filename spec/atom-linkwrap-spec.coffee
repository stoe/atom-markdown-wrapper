AtomLinkwrap = require '../lib/atom-linkwrap'
Linkwrap = require '../lib/linkwrap'

describe 'AtomLinkwrap', ->
  [editor, selection, clipboard] = []

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
    it 'should be defined', ->
      expect(@linkwrap).toBeDefined()

    describe '.paste()', ->
      beforeEach ->
        editor = atom.workspace.getActiveTextEditor()
        selection = 'selection'
        clipboard = 'https://example.com'

      afterEach ->
        editor = null
        selection = null
        clipboard = null

      it 'should be defined', ->
        expect(@linkwrap.paste).toBeDefined()

      it 'should require three parameters', ->
        spyOn(@linkwrap, 'paste')

        @linkwrap.paste(1, 2, 3)
        expect(@linkwrap.paste).toHaveBeenCalledWith(1, 2, 3)

      it 'should replace `selection` with [selection](https://example.com)', ->
        spyOn(@linkwrap, 'paste').andCallThrough()

        res = @linkwrap.paste(editor, selection, clipboard)
        expect(@linkwrap.paste).toHaveBeenCalledWith(editor, selection, clipboard)
        expect(res).toBe '[selection](https://example.com)'
