"
I represent an AST node for UML class.
I have name(symbol) and ordered dictionaries of attributes and methods.
I also hold my superclass (symbol).

"
Class {
	#name : 'MicroUMLClassNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'name',
		'superclass',
		'traits',
		'members',
		'isAbstract',
		'isTrait'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'examples' }
MicroUMLClassNode class >> exampleAbstractSerie [

	^ MicroUMLAstBuilder exampleSerie classAt: #AbstractSerie
]

{ #category : 'examples' }
MicroUMLClassNode class >> exampleComixSerie [

	^ MicroUMLAstBuilder exampleSerie classAt: #ComixSerie
]

{ #category : 'adding' }
MicroUMLClassNode >> addAttribute: aSymbolOrNil [

	^ members add: (self memberNodeClass new
			   name: aSymbolOrNil;
			   isMethod: false)
]

{ #category : 'adding' }
MicroUMLClassNode >> addMember: aSymbolOrNil [

	^ members add: (self memberNodeClass new name: aSymbolOrNil)
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethod: aSymbolOrNil [

	^ members add: (self memberNodeClass new
			   name: aSymbolOrNil;
			   isMethod: true)
]

{ #category : 'adding' }
MicroUMLClassNode >> addModifier: aSymbol [

	| mod |
	mod := aSymbol asSymbol.
	mod = #abstract ifTrue: [
			isAbstract := true.
			^ aSymbol ].
	mod = #trait ifTrue: [
			isTrait := true.
			^ aSymbol ].
	^ aSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addTrait: aSymbol [

	^ traits add: aSymbol
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributeAt: aSymbol [

	^ members
		  detect: [ :member |
		  member name = aSymbol and: [ member isAttribute ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributes [

	^ self members select: #isAttribute
]

{ #category : 'enumerating' }
MicroUMLClassNode >> attributesCollect: aBlock [

	^ (members select: #isAttribute thenCollect: aBlock) asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> attributesDo: aBlock [

	self membersDo: [ :member |
		member isAttribute ifTrue: [ aBlock value: member ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> beAbstract [

	isAbstract := true
]

{ #category : 'accessing' }
MicroUMLClassNode >> beClass [

	isTrait := false
]

{ #category : 'accessing' }
MicroUMLClassNode >> beConcrete [

	isAbstract := false
]

{ #category : 'accessing' }
MicroUMLClassNode >> beTrait [

	isTrait := true
]

{ #category : 'accessing' }
MicroUMLClassNode >> currentMember [

	^ members ifNotEmpty: #last ifEmpty: [ nil ]
]

{ #category : 'adding' }
MicroUMLClassNode >> currentMemberName: aSymbol [

	self currentMember name: aSymbol.
	^ aSymbol
]

{ #category : 'initialization' }
MicroUMLClassNode >> initialize [

	traits := OrderedCollection new.
	members := OrderedCollection new.
	isAbstract := false.
	isTrait := false
]

{ #category : 'testing' }
MicroUMLClassNode >> isAbstract [

	^ isAbstract = true
]

{ #category : 'testing' }
MicroUMLClassNode >> isConcrete [

	^ self isAbstract not
]

{ #category : 'testing' }
MicroUMLClassNode >> isEmptyDefinition [

	^ superclass isNil and: [ members isEmpty ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> keywords [

	^ Array streamContents: [ :stream |
		  self keywordsDo: [ :keyword | stream nextPut: keyword ] ]
]

{ #category : 'enumerating' }
MicroUMLClassNode >> keywordsDo: aBlock [

	isTrait ifTrue: [ aBlock value: #trait ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> memberAt: aSymbol [

	^ members detect: [ :member | member name = aSymbol ] ifNone: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> memberNodeClass [

	^ MicroUMLMemberNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> members [

	^ members asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> membersCollect: aBlock [

	^ (members collect: aBlock) asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> membersDo: aBlock [

	members do: aBlock
]

{ #category : 'accessing' }
MicroUMLClassNode >> methodAt: aSymbol [

	^ members
		  detect: [ :member |
		  member name = aSymbol and: [ member isMethod ] ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> methods [

	^ self members select: #isMethod
]

{ #category : 'enumerating' }
MicroUMLClassNode >> methodsCollect: aBlock [

	^ (members select: #isMethod thenCollect: aBlock) asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> methodsDo: aBlock [

	self membersDo: [ :member |
		member isMethod ifTrue: [ aBlock value: member ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> modifiers [

	^ Array streamContents: [ :stream |
			  isAbstract ifTrue: [ stream nextPut: #abstract ].
			  isTrait ifTrue: [ stream nextPut: #trait ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> modifiers: anArrayOfSymbol [

	anArrayOfSymbol
		ifNotNil: [
				isAbstract := anArrayOfSymbol includes: #abstract.
				isTrait := anArrayOfSymbol includes: #trait ]
		ifNil: [
				isAbstract := false.
				isTrait := false ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLClassNode >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'printing' }
MicroUMLClassNode >> printMicroUMLOn: aStream [

	self name asSymbol storeOn: aStream.
	self modifiers ifNotNil: [ :modifiers |
			modifiers do: [ :modifier |
					aStream nextPutAll: ' % '.
					modifier storeOn: aStream ] ].

	self superclass ifNotNil: [ :superclassName |
			(traits isEmpty and: [ members isEmpty ]) ifFalse: [
					aStream
						cr;
						space ].
			aStream nextPutAll: ' --|> '.
			superclassName asSymbol storeOn: aStream ].
	self traitsDo: [ :traitName |
			aStream
				cr;
				nextPutAll: '  --@ '.
			traitName asSymbol storeOn: aStream ].
	self members ifNotEmpty: [
			aStream cr.
			self members
				do: [ :member |
						aStream
							space;
							space.
						member printMicroUMLOn: aStream ]
				separatedBy: [ aStream cr ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass [

	^ superclass
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass: aSymbol [

	superclass := aSymbol
]

{ #category : 'accessing' }
MicroUMLClassNode >> traits [

	^ traits asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> traitsDo: aBlock [

	traits do: aBlock
]
