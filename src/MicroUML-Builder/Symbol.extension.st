Extension { #name : 'Symbol' }

{ #category : '*MicroUML-Builder' }
Symbol >> ++ aSymbol [

	^ MicroUMLBuilder new === self ++ aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> -- aSymbol [

	^ MicroUMLBuilder new === self -- aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> --|> aSymbolOrClass [

	^ MicroUMLBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> <|-- aSymbolOrClass [

	^ MicroUMLBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> === aSymbolOrClass [

	^ MicroUMLBuilder new === self === aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> >+ aSymbol [

	^ MicroUMLBuilder new === self >+ aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> >- aSymbol [

	^ MicroUMLBuilder new === self >- aSymbol
]
