Extension { #name : 'Class' }

{ #category : '*MicroUML-Builder' }
Class >> + aSymbol [

	^ MicroUMLAstBuilder new === self + aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> - aSymbol [

	^ MicroUMLAstBuilder new === self - aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> --|> aSymbolOrClass [

	^ MicroUMLAstBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> <|-- aSymbolOrClass [

	^ MicroUMLAstBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> === aSymbolOrClass [

	^ MicroUMLAstBuilder new === self === aSymbolOrClass
]
