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
		'rightLabel',
		'label',
		'leftMultiplicity',
		'rightMultiplicity',
		'associationClass',
		'line'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLAssociationNode >> addLabel: aStringOrAssociation [

	aStringOrAssociation isString ifTrue: [
			self label: aStringOrAssociation.
			^ aStringOrAssociation ].
	aStringOrAssociation isAssociation ifTrue: [
			self leftLabel: aStringOrAssociation key.
			self rightLabel: aStringOrAssociation value.
			^ aStringOrAssociation ].
	^ nil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> associationClass [

	^ associationClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> associationClass: aSymbol [

	associationClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beAggregation [

	leftHead := #aggregation
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beComposition [

	leftHead := #composition
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDashed [

	line := #dashed
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDependency [

	leftHead := nil.
	rightHead := #wedge.
	line := #dashed
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDirected [

	rightHead := #wedge
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beSolid [

	line := #solid
]

{ #category : 'defaults' }
MicroUMLAssociationNode >> defaultLine [

	^ #solid
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> label [

	^ label
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> label: aString [

	label := aString
]

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

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftMultiplicity [

	^ leftMultiplicity
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftMultiplicity: aString [

	leftMultiplicity := aString
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> line [

	^ line ifNil: [ self defaultLine ]
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> line: aSymbol [

	line := aSymbol
]

{ #category : 'printing' }
MicroUMLAssociationNode >> microUMLSource [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLAssociationClassOn: aStream [

	self associationClass ifNotNil: [
			aStream nextPutAll: '  @= '.
			self associationClass storeOn: aStream.
			aStream cr ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLInLeftClassOn: aStream [

	self printMicroUMLLinkOn: aStream.
	rightClass storeOn: aStream.
	self
		printMicroUMLLabelsOn: aStream;
		printMicroUMLMultiplicityOn: aStream;
		printMicroUMLAssociationClassOn: aStream
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLLabelsOn: aStream [

	self label ifNotNil: [
			aStream
				cr;
				nextPutAll: '  @ '.
			self label storeOn: aStream ].
	(self leftLabel notNil or: [ self rightLabel notNil ]) ifTrue: [
			aStream
				cr;
				nextPutAll: '  @ '.
			self leftLabel -> self rightLabel storeOn: aStream ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLLinkOn: aStream [

	self leftHead = #aggregation ifTrue: [ aStream nextPutAll: '<>' ].
	self leftHead = #composition ifTrue: [ aStream nextPutAll: '*' ].
	self rightHead ifNil: [ aStream nextPutAll: '-- ' ].
	self rightHead = #wedge ifTrue: [
			self line = #solid ifTrue: [ aStream nextPutAll: '=> ' ].
			self line = #dashed ifTrue: [ aStream nextPutAll: '--> ' ] ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLMultiplicityOn: aStream [

	self leftMultiplicity ifNotNil: [
			aStream
				cr;
				nextPutAll: '  %< '.
			self leftMultiplicity storeOn: aStream ].
	self rightMultiplicity ifNotNil: [
			aStream
				cr;
				nextPutAll: '  %> '.
			self rightMultiplicity storeOn: aStream ]
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

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightMultiplicity [

	^ rightMultiplicity
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightMultiplicity: aString [

	rightMultiplicity := aString
]
