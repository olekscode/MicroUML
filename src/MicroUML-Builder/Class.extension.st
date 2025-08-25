Extension { #name : 'Class' }

{ #category : '*MicroUML-Builder' }
Class >> - aSymbol [

	^ MicroUMLAstBuilder new === self - aSymbol
]

{ #category : '*MicroUML-Builder' }
Class >> --@ aSymbolOrClass [
	"Defines a subclass of the receiver. Note that this method is to define class description based on # e.g. #Point"
	
	^ MicroUMLAstBuilder new === self --@ aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> --|> aSymbolOrClass [

	^ MicroUMLAstBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> <|-- aSymbolOrClass [
	"Defines a subclass of the receiver. Note that this method is to mix real class and class description based on # e.g. #Point"
	
	^ MicroUMLAstBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> === aSymbolOrClass [

	^ MicroUMLAstBuilder new === self === aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Class >> > aSymbol [

	^ MicroUMLAstBuilder new === self > aSymbol
]
