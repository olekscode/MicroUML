Class {
	#name : 'MicroUMLAstNode',
	#superclass : 'Object',
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'printing' }
MicroUMLAstNode >> microUML [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'printing' }
MicroUMLAstNode >> printMicroUMLOn: aStream [

	^ self subclassResponsibility
]
