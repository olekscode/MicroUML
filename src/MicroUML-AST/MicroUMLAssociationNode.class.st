"
I represent an association between two classes.
One class is called *left* while the other is *right*.
I store and answer the multiplicity of each class.
Multiplicity is nil iff no multiplicity is set to the class.
"
Class {
	#name : 'MicroUMLAssociationNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'leftClass',
		'leftHead',
		'leftLabel',
		'rightClass',
		'rightHead',
		'rightLabel'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftClass [

	^ leftClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftClass: aSymbol [

	leftClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftHead [

	^ leftHead
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftHead: aSymbolOrNil [

	leftHead := aSymbolOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftLabel [

	^ leftLabel
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftLabel: aStringOrNil [

	leftLabel := aStringOrNil
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLInLeftClassOn: aStream [

	| heads |
	heads := {
		         (#composition -> '<*>').
		         (#aggregation -> '<>') } asDictionary.
	aStream nextPutAll: (heads at: leftHead ifAbsent: [ '' ]).
	leftLabel ifNotNil: [
			aStream nextPut: $<.
			leftLabel storeOn: aStream.
			aStream nextPut: $> ].
	aStream nextPutAll: '---'.
	rightLabel ifNotNil: [
			aStream nextPut: $<.
			rightLabel storeOn: aStream.
			aStream nextPut: $> ].
	aStream
		nextPutAll: (heads at: rightHead ifAbsent: [ '' ]);
		space.
	rightClass storeOn: aStream
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLOn: aStream [

	leftClass storeOn: aStream.
	aStream space.
	self printMicroUMLInLeftClassOn: aStream
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightClass [

	^ rightClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightClass: aSymbol [

	rightClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightHead [

	^ rightHead
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightHead: aSymbolOrNil [

	rightHead := aSymbolOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightLabel [

	^ rightLabel
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightLabel: aStringOrNil [

	rightLabel := aStringOrNil
]
