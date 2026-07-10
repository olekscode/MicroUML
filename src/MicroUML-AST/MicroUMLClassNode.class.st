"
I represent an AST node for UML class.
I have name(symbol) and ordered dictionaries of attributes and methods.
I also hold my superclass (symbol).

"
Class {
	#name : 'MicroUMLClassNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'diagram',
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

{ #category : 'adding' }
MicroUMLClassNode >> addAssociation: aSymbolOrNil [

	^ diagram ifNotNil: [
			  diagram addAssociation: (self associationNodeClass new
					   leftClass: name;
					   rightClass: aSymbolOrNil) ]
]

{ #category : 'menu operations' }
MicroUMLClassNode >> addAttribute [

	(self
		 request: 'Attribute name'
		 initialAnswer: ''
		 title: 'Add attribute') ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newAttributeName |
					self
						addAttribute: newAttributeName;
						announceDiagramChange ] ]
]

{ #category : 'adding' }
MicroUMLClassNode >> addAttribute: aSymbolOrNil [

	^ members add: (self attributeNodeClass new
			   name: aSymbolOrNil;
			   classNode: self)
]

{ #category : 'menu operations' }
MicroUMLClassNode >> addMethod [

	(self request: 'Method name' initialAnswer: '' title: 'Add method')
		ifNotNil: [ :answer |
				answer trim ifNotEmpty: [ :newMethodName |
						self
							addMethod: newMethodName;
							announceDiagramChange ] ]
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethod: aSymbolOrNil [

	^ members add: (self methodNodeClass new
			   name: aSymbolOrNil;
			   classNode: self;
			   yourself)
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
	^ nil
]

{ #category : 'menu operations' }
MicroUMLClassNode >> addTrait [

	(self
		 request: 'Add trait named'
		 initialAnswer: ''
		 title: 'Add trait to ' , self name , ' class') ifNotNil: [ :answer |
			(answer trim ifNotEmpty: #asSymbol) ifNotEmpty: [ :traitName |
					(traits includes: traitName) ifFalse: [
							self addTrait: traitName.
							self announceDiagramChange ] ] ]
]

{ #category : 'adding' }
MicroUMLClassNode >> addTrait: aSymbol [

	^ traits add: aSymbol
]

{ #category : 'announcing' }
MicroUMLClassNode >> announceDiagramChange [

	diagram ifNotNil: #announceChange
]

{ #category : 'class access' }
MicroUMLClassNode >> associationNodeClass [

	^ MicroUMLAssociationNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributeAt: aSymbol [

	^ members
		  detect: [ :member |
		  member name = aSymbol and: [ member isAttribute ] ]
		  ifNone: [ nil ]
]

{ #category : 'class access' }
MicroUMLClassNode >> attributeNodeClass [

	^ MicroUMLAttributeNode
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

	members do: [ :member |
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

{ #category : 'menu operations' }
MicroUMLClassNode >> changeSuperclass [

	| oldSuperclass |
	oldSuperclass := superclass.
	(self
		 request: 'Name of superclass'
		 initialAnswer: oldSuperclass
		 title: 'Superclass of ' , self name) ifNotNil: [ :answer |
			self superclass:
				(answer trim ifNotEmpty: #asSymbol ifEmpty: [ nil ]).
			self announceDiagramChange ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> children [

	^ (OrderedCollection
		withAll: self attributes)
		addAll: self methods;
		yourself
]

{ #category : 'accessing' }
MicroUMLClassNode >> currentMember [

	^ members ifNotEmpty: #last ifEmpty: [ nil ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLClassNode >> diagram: aMicroUMLDiagramNode [

	diagram := aMicroUMLDiagramNode
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
MicroUMLClassNode >> isClass [

	^ self isTrait not
]

{ #category : 'testing' }
MicroUMLClassNode >> isConcrete [

	^ self isAbstract not
]

{ #category : 'testing' }
MicroUMLClassNode >> isEmptyDefinition [

	^ superclass isNil and: [ members isEmpty ]
]

{ #category : 'testing' }
MicroUMLClassNode >> isMicroUMLClassNode [

	^ true
]

{ #category : 'testing' }
MicroUMLClassNode >> isTrait [

	^ isTrait = true
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

{ #category : 'accessing' }
MicroUMLClassNode >> members [

	^ members asArray
]

{ #category : 'accessing' }
MicroUMLClassNode >> methodAt: aSymbol [

	^ members
		  detect: [ :member |
		  member name = aSymbol and: [ member isMethod ] ]
		  ifNone: [ nil ]
]

{ #category : 'class access' }
MicroUMLClassNode >> methodNodeClass [

	^ MicroUMLMethodNode
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

	members do: [ :member |
		member isMethod ifTrue: [ aBlock value: member ] ]
]

{ #category : 'printing' }
MicroUMLClassNode >> microUMLSource [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
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

{ #category : 'accessing' }
MicroUMLClassNode >> pharoClass [

	^ Smalltalk classNamed: self name
]

{ #category : 'printing' }
MicroUMLClassNode >> printMicroUMLOn: aStream [

	self name asSymbol storeOn: aStream.
	self modifiers ifNotNil: [ :modifiers |
			modifiers do: [ :modifier |
					aStream nextPutAll: ' % '.
					modifier storeOn: aStream ] ].
	self printActionBlockAndCommentOn: aStream.
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

{ #category : 'printing' }
MicroUMLClassNode >> printOn: aStream [

	super printOn: aStream.
	aStream << $( << name << $)
]

{ #category : 'menu operations' }
MicroUMLClassNode >> remove [

	(diagram notNil and: [
			 self
				 confirm: 'OK to remove ' , self name , '?'
				 title: 'Confirm remove class' ]) ifTrue: [
			diagram removeClass: self.
			self announceDiagramChange ]
]

{ #category : 'removing' }
MicroUMLClassNode >> removeAllMembers [

	members removeAll
]

{ #category : 'adding' }
MicroUMLClassNode >> removeMember: aMicroUMLMemberNode [

	^ members remove: aMicroUMLMemberNode ifAbsent: [ ]
]

{ #category : 'menu operations' }
MicroUMLClassNode >> removeTrait: aSymbol [

	traits remove: aSymbol ifAbsent: [ ^ self ].
	self announceDiagramChange
]

{ #category : 'menu operations' }
MicroUMLClassNode >> rename [

	| oldName |
	oldName := self name.
	(self
		 request: 'New name for the class'
		 initialAnswer: oldName
		 title: 'Rename ' , oldName) ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newName |
					(diagram ifNil: [ self ])
						symbolsDo: [ :symbol |
								symbol = newName ifTrue: [
											^ self alert:
													  'The name ' , newName
													  , ' is already used. Try another one.' ] ];
						renameClass: oldName asSymbol to: newName asSymbol.
					self announceDiagramChange ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> renameClass: aSymbol to: anotherSymbol [

	name = aSymbol ifTrue: [ name := anotherSymbol ].
	superclass = aSymbol ifTrue: [ superclass := anotherSymbol ].
	(traits includes: aSymbol) ifTrue: [
		traits := traits copyReplaceAll: aSymbol with: anotherSymbol ].
	members do: [ :memberNode |
		memberNode renameClass: aSymbol to: anotherSymbol ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass [

	^ superclass
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass: aSymbol [

	superclass := aSymbol
]

{ #category : 'enumerating' }
MicroUMLClassNode >> symbolsDo: aBlock [

	aBlock value: name.
	superclass ifNotNil: aBlock.
	traits do: aBlock.
	members do: [ :memberNode | memberNode symbolsDo: aBlock ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> traits [

	^ traits asArray
]

{ #category : 'enumerating' }
MicroUMLClassNode >> traitsDo: aBlock [

	traits do: aBlock
]
