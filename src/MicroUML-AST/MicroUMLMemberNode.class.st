"
I represent an AST node for UML class operation.
I have name(symbol), argument types (array of symbol, or nil if omitted), and return type (symbol or nil if omitted).
My visibility is either #public or #private.
"
Class {
	#name : 'MicroUMLMemberNode',
	#superclass : 'Object',
	#instVars : [
		'name',
		'argumentTypes',
		'visibility',
		'type',
		'isClassSide',
		'isAbstract',
		'modifiers',
		'isMethod'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLMemberNode >> argumentTypes [

	^ argumentTypes
]

{ #category : 'accessing' }
MicroUMLMemberNode >> argumentTypes: anArrayOfSymbol [

	argumentTypes := anArrayOfSymbol
]

{ #category : 'converting' }
MicroUMLMemberNode >> asRSShape [

	^ RSLabel
		  text: (String streamContents: [ :stream |
					   self isPublic ifTrue: [ stream nextPut: $+ ].
					   self isPrivate ifTrue: [ stream nextPut: $- ].
					   stream nextPutAll: name.
					   argumentTypes ifNotNil: [
							   stream
								   nextPut: $(;
								   nextPutAll: (', ' join: argumentTypes);
								   nextPut: $) ].
					   type ifNotNil: [
							   stream
								   nextPut: $:;
								   nextPutAll: type ] ])
		  model: self
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beAbstract [

	isAbstract := true
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beClassSide [

	isClassSide := true
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beConcrete [

	isAbstract := false
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beInstanceSide [

	isClassSide := false
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePrivate [

	visibility := #private
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePublic [

	visibility := #public
]

{ #category : 'initialization' }
MicroUMLMemberNode >> initialize [

	super initialize.
	isClassSide := false.
	isAbstract := false
]

{ #category : 'testing' }
MicroUMLMemberNode >> isAbstract [

	^ isAbstract = true
]

{ #category : 'testing' }
MicroUMLMemberNode >> isAttribute [

	^ self isMethod not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isClassSide [

	^ isClassSide = true
]

{ #category : 'testing' }
MicroUMLMemberNode >> isConcrete [

	^ self isAbstract not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isInstanceSide [

	^ self isClassSide not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isMethod [

	^ isMethod ifNil: [ argumentTypes notNil ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> isMethod: aBooleanOrNil [

	isMethod := aBooleanOrNil
]

{ #category : 'testing' }
MicroUMLMemberNode >> isPrivate [

	^ visibility = #private
]

{ #category : 'testing' }
MicroUMLMemberNode >> isPublic [

	^ visibility = #public
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers [

	^ (Array streamContents: [ :stream |
			   self isAbstract ifTrue: [ stream nextPut: #abstract ].
			   self isClassSide ifTrue: [ stream nextPut: #static ] ])
		  ifEmpty: [ nil ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers: anArrayOfSymbol [

	(anArrayOfSymbol includes: #abstract) ifTrue: [ self beAbstract ].
	(anArrayOfSymbol includes: #static) ifTrue: [ self beClassSide ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type [

	^ type
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility: aSymbol [

	visibility := aSymbol
]
