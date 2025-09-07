Extension { #name : 'Symbol' }

{ #category : '*MicroUML-Builder' }
Symbol >> % aSymbol [

	^ MicroUMLAstBuilder new === self % aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> *-- aSymbol [

	^ MicroUMLAstBuilder new === self *-- aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> *=> aSymbol [

	^ MicroUMLAstBuilder new === self *=> aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> - aSymbol [

	^ MicroUMLAstBuilder new === self - aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> -- aSymbol [

	^ MicroUMLAstBuilder new === self -- aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> --> aSymbol [

	^ MicroUMLAstBuilder new === self --> aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> --@ aSymbolOrClass [
	"Defines a subclass of the receiver. Note that this method is to define class description based on # e.g. #Point"
	
	^ MicroUMLAstBuilder new === self --@ aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> --|> aSymbolOrClass [
	"Defines a subclass of the receiver. Note that this method is to define class description based on # e.g. #Point"
	
	^ MicroUMLAstBuilder new === self --|> aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> <>-- aSymbol [

	^ MicroUMLAstBuilder new === self <>-- aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> <>=> aSymbol [

	^ MicroUMLAstBuilder new === self <>=> aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> <|-- aSymbolOrClass [

	^ MicroUMLAstBuilder new === self <|-- aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> === aSymbolOrClass [
	"Used to define a sequence of class definition e.g. 
	
	
	
	
	"
	^ MicroUMLAstBuilder new === self === aSymbolOrClass
]

{ #category : '*MicroUML-Builder' }
Symbol >> => aSymbol [

	^ MicroUMLAstBuilder new === self => aSymbol
]

{ #category : '*MicroUML-Builder' }
Symbol >> classDiagram [

	^ MicroUMLAstBuilder === self
]

{ #category : '*MicroUML-Builder' }
Symbol >> mu [

	^ MicroUMLAstBuilder === self
]
