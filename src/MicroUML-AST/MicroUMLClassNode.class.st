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
		'members',
		'isAbstract'
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

{ #category : 'converting' }
MicroUMLClassNode >> asRSShape [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 box |
	myLabel := RSLabel text: name model: self.
	attributeShapes := self attributesCollect: #asRSShape.
	RSVerticalLineLayout new alignLeft on: attributeShapes.
	attributeShapes := attributeShapes asShape.
	methodShapes := self methodsCollect: #asRSShape.
	RSVerticalLineLayout new alignLeft on: methodShapes.
	methodShapes := methodShapes asShape.
	RSVerticalLineLayout new alignLeft on: {
			attributeShapes.
			methodShapes }.
	memberShapes := {
		                attributeShapes.
		                methodShapes } asShape.
	RSVerticalLineLayout new alignCenter on: {
			myLabel.
			memberShapes }.
	rect := {
		        myLabel.
		        memberShapes } asShape encompassingRectangle.
	y1 := myLabel encompassingRectangle bottom + 6.
	y2 := y1 + attributeShapes encompassingRectangle height.

	^ {
		  (RSBox new
			   extent: rect extent + (10 @ 6);
			   color: Color white;
			   borderColor: Color black;
			   borderWidth: 1).
		  (RSLine new
			   startPoint: rect extent x / -2 - 5 @ y1;
			   endPoint: rect extent x / 2 + 5 @ y1).
		  (RSLine new
			   startPoint: rect extent x / -2 - 5 @ y2;
			   endPoint: rect extent x / 2 + 5 @ y2).
		  myLabel.
		  memberShapes } asShapeFor: self
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributeAt: aSymbol [

	^ (self memberAt: aSymbol) ifNotNil: [ :member |
			  member isAttribute
				  ifTrue: [ member ]
				  ifFalse: [ nil ] ]
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
MicroUMLClassNode >> beConcrete [

	isAbstract := false
]

{ #category : 'accessing' }
MicroUMLClassNode >> currentMember [

	^ members last
]

{ #category : 'adding' }
MicroUMLClassNode >> currentMemberName: aSymbol [

	self currentMember name: aSymbol.
	^ aSymbol
]

{ #category : 'initialization' }
MicroUMLClassNode >> initialize [

	members := OrderedCollection new.
	isAbstract := false
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
	^ superclass isNil and: [members isEmpty and: [ isAbstract not ]]
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

	^ (self memberAt: aSymbol) ifNotNil: [ :member |
			  member isMethod
				  ifTrue: [ member ]
				  ifFalse: [ nil ] ]
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

	^ (Array streamContents: [ :stream |
		   self isAbstract ifTrue: [ stream nextPut: #abstract ] ])
		  ifEmpty: [ nil ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> modifiers: anArrayOfSymbol [

	isAbstract := anArrayOfSymbol includes: #abstract
]

{ #category : 'accessing' }
MicroUMLClassNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLClassNode >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass [

	^ superclass
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass: aSymbol [

	superclass := aSymbol
]
