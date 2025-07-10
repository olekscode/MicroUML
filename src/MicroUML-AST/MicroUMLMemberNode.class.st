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
		'type'
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
MicroUMLMemberNode >> bePrivate [

	visibility := #private
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePublic [

	visibility := #public
]

{ #category : 'testing' }
MicroUMLMemberNode >> isAttribute [

	^ self isMethod not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isMethod [

	^ argumentTypes notNil
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
