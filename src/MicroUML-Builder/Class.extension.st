Extension { #name : 'Class' }

{ #category : '*MicroUML-Builder' }
Class >> ++ aSymbol [

	^ MicroUMLBuilder new === self ++ aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> -- aSymbol [

	^ MicroUMLBuilder new === self -- aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> --|> aSymbolOrClass [

	^ MicroUMLBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> <|-- aSymbolOrClass [

	^ MicroUMLBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> === aSymbolOrClass [

	^ MicroUMLBuilder new === self === aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> >+ aSymbol [

	^ MicroUMLBuilder new === self >+ aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> >- aSymbol [

	^ MicroUMLBuilder new === self >- aSymbol
]
