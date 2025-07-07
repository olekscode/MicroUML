"
I represent an AST node for UML class operation.
I have name(symbol), argument types (array of symbol, or nil if omitted), and return type (symbol or nil if omitted).
My visibility is either #public or #private.
"
Class {
	#name : 'MicroUMLMethodNode',
	#superclass : 'Object',
	#instVars : [
		'name',
		'argumentTypes',
		'returnType',
		'visibility'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLMethodNode >> argumentTypes [

	^ argumentTypes
]

{ #category : 'adding' }
MicroUMLMethodNode >> argumentTypes: anArrayOfSymbol [

	argumentTypes := anArrayOfSymbol
]

{ #category : 'converting' }
MicroUMLMethodNode >> asRSShape [

	^ RSLabel
		  text: (String streamContents: [ :stream |
					   self isPublic ifTrue: [ stream nextPut: $+ ].
					   self isPrivate ifTrue: [ stream nextPut: $- ].
					   stream nextPutAll: name.
					   stream
						   nextPut: $(;
						   nextPutAll: (', ' join: (argumentTypes ifNil: [ {  } ]));
						   nextPut: $).
					   returnType ifNotNil: [
							   stream
								   nextPut: $:;
								   nextPutAll: returnType ] ])
		  model: self
]

{ #category : 'accessing' }
MicroUMLMethodNode >> bePrivate [

	visibility := #private
]

{ #category : 'accessing' }
MicroUMLMethodNode >> bePublic [

	visibility := #public
]

{ #category : 'testing' }
MicroUMLMethodNode >> isPrivate [

	^ visibility = #private
]

{ #category : 'testing' }
MicroUMLMethodNode >> isPublic [

	^ visibility = #public
]

{ #category : 'accessing' }
MicroUMLMethodNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLMethodNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
MicroUMLMethodNode >> returnType [

	^ returnType
]

{ #category : 'accessing' }
MicroUMLMethodNode >> returnType: anObject [

	returnType := anObject
]

{ #category : 'accessing' }
MicroUMLMethodNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
MicroUMLMethodNode >> visibility: aSymbol [

	visibility := aSymbol
]
