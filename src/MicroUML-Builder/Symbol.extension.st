Extension { #name : 'Symbol' }

{ #category : '*MicroUML-Builder' }
Symbol >> ++ aSymbol [

	^ MicroUMLAstBuilder new === self ++ aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> -- aSymbol [

	^ MicroUMLAstBuilder new === self -- aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> --|> aSymbolOrClass [

	^ MicroUMLAstBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> <|-- aSymbolOrClass [

	^ MicroUMLAstBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> === aSymbolOrClass [

	^ MicroUMLAstBuilder new === self === aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> >+ aSymbol [

	^ MicroUMLAstBuilder new === self >+ aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> >- aSymbol [

	^ MicroUMLAstBuilder new === self >- aSymbol
]
