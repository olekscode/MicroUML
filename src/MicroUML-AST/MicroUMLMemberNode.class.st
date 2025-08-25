"
I represent an AST node for UML class operation.
I have name(symbol), argument types (array of symbol, or nil if omitted), and return type (symbol or nil if omitted).
My visibility is either #public or #private.
"
Class {
	#name : 'MicroUMLMemberNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'name',
		'argumentTypes',
		'visibility',
		'type',
		'isClassSide',
		'isAbstract',
		'isMethod'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'adding' }
MicroUMLMemberNode >> addModifier: aSymbol [

	aSymbol = #abstract ifTrue: [
			isAbstract := true.
			^ aSymbol ].
	(#( public protected private ) includes: aSymbol) ifTrue: [
			visibility := aSymbol.
			^ aSymbol ].
	^ nil
]

{ #category : 'accessing' }
MicroUMLMemberNode >> argumentTypes [

	^ argumentTypes
]

{ #category : 'accessing' }
MicroUMLMemberNode >> argumentTypes: anArrayOfSymbol [

	argumentTypes := anArrayOfSymbol
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beClassSide [

	isClassSide := true
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
MicroUMLMemberNode >> beProtected [

	visibility := #protected
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePublic [

	visibility := #public
]

{ #category : 'accessing' }
MicroUMLMemberNode >> defaultVisibility [

	^ self isMethod
		  ifTrue: [ #public ]
		  ifFalse: [ #protected ]
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

	^ self visibility = #private
]

{ #category : 'testing' }
MicroUMLMemberNode >> isProtected [

	^ self visibility = #protected
]

{ #category : 'testing' }
MicroUMLMemberNode >> isPublic [

	^ self visibility = #public
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers [

	^ Array streamContents: [ :stream |
			  self isAbstract ifTrue: [ stream nextPut: #abstract ].
			  self visibility ~= self defaultVisibility ifTrue: [
				  stream nextPut: self visibility ] ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers: anArrayOfSymbol [

	isAbstract := anArrayOfSymbol includes: #abstract.
	(anArrayOfSymbol includes: #public) ifTrue: [ visibility := #public ].
	(anArrayOfSymbol includes: #protected) ifTrue: [
		visibility := #protected ].
	(anArrayOfSymbol includes: #private) ifTrue: [
		visibility := #private ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name: anObject [

	name := anObject
]

{ #category : 'printing' }
MicroUMLMemberNode >> printMicroUMLOn: aStream [
	" #argumentTypes  . #type   "

	aStream nextPutAll: (isMethod = true
			 ifTrue: [
					 {
						 (#public -> '>+ ').
						 (#private -> '>- ') } asDictionary
						 at: visibility
						 ifAbsent: [ '>> ' ] ]
			 ifFalse: [
					 {
						 (#public -> '+ ').
						 (#private -> '- ') } asDictionary
						 at: visibility
						 ifAbsent: [ '* ' ] ]).
	self name storeOn: aStream.
	self argumentTypes ifNotNil: [ :symbols |
			aStream nextPutAll: ' ~#('.
			symbols
				do: [ :symbol | aStream nextPutAll: symbol ]
				separatedBy: [ aStream space ].
			aStream nextPutAll: ')' ].
	self type ifNotNil: [ :symbol |
			aStream nextPutAll: ' @ '.
			symbol storeOn: aStream ].
	self modifiers ifNotNil: [ :symbols |
			symbols do: [ :symbol |
					aStream nextPutAll: ' % '.
					symbol storeOn: aStream ] ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type [

	^ type
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type: aSymbol [

	type := aSymbol
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility [

	^ visibility ifNil: [ self defaultVisibility ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility: aSymbol [

	visibility := aSymbol
]
