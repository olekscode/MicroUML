"
I build a UML class diagram.
I have a nemaspace of classes to manage references and relations among them.
You can use my explicitly say, like
```MicroUML
MicroUMLBuilder new
===
MyClass
    ++att1@ #int
```
but also imlicit ways, like
```MicroUML
#MyClass
    ++att1 @ #int
```
or even like
```MicroUML
MyClass
    ++att1 @ #int
```
if you actually have a class named `MyClass` in your system.
"
Class {
	#name : 'MicroUMLAstBuilder',
	#superclass : 'Object',
	#instVars : [
		'currentClass',
		'classes',
		'currentAssociation',
		'associations'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleMicrodown [

	^ (MicrodownPresenter new document: '
Example of novel and comic derrived from anime

```pharoscript
#AbstractSeries 
	+ #name @ String 
	- #numEpisodes @ Integer
	>+ #(abstract) % #findByName
=== 
#NovelSeries 
	--|> #AbstractSeries
	+ #author @ String 
	+ #Publisher @ String 
	>+ #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	- #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	+ #director @ String 
	- #animators @ String
	- #voiceActors @ String 
	+ #play~{} 
	<>---<''based on''> #ComicSeries 
=== 
#AnimeSeries	 ---<''original''> #NovelSeries 
extent: 600 @ 400
```
')  open
]

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleSerie [

	^ 
#AbstractSeries 
	+ #name @ String 
	- #numEpisodes @ Integer
=== 
#NovelSeries 
	--|> #AbstractSeries
	+ #author @ String 
	+ #Publisher @ String 
	+ #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	- #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	+ #director @ String 
	- #animators @ String
	- #voiceActors @ String 
	+ #play~{} 
	<>---<'based on'> #ComicSeries 
=== 
#AnimeSeries	 ---<'original'> #NovelSeries 
extent: 800@600
]

{ #category : 'UML - class separators' }
MicroUMLAstBuilder >> % aSymbolOrClass [

	currentClass name isNil
		ifTrue: [ self addClassName: (self getSymbol: aSymbolOrClass) ]
		ifFalse: [ self addMemberName: (self getSymbol: aSymbolOrClass) ]
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> * aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startMemberModifiers: aSymbolOrArray ]
		ifFalse: [ self startMember: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> + aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startPublicMemberModifiers: aSymbolOrArray ]
		ifFalse: [ self startPublicMember: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> - aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startPrivateMemberModifiers: aSymbolOrArray ]
		ifFalse: [
		self startPrivateMember: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> --- aClassOrSymbol [

	self
		startAssociation;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> ---< aString [

	self
		startAssociation;
		addAssociationRightLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> ---<*> aClassOrSymbol [

	self
		startAssociation;
		addAssociationRightHead: #composition;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> ---<> aClassOrSymbol [

	self
		startAssociation;
		addAssociationRightHead: #aggregation;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - inheritance' }
MicroUMLAstBuilder >> --|> aSymbolOrClass [

	self addSuperclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> < aString [

	self
		startAssociation;
		addAssociationLeftLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <*>--- aClassOrSymbol [

	self
		startAssociation;
		addAssociationLeftHead: #composition;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <*>---< aString [

	self
		startAssociation;
		addAssociationLeftHead: #composition;
		addAssociationRightLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <*>< aString [

	self
		startAssociation;
		addAssociationLeftHead: #composition;
		addAssociationLeftLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <>--- aClassOrSymbol [

	self
		startAssociation;
		addAssociationLeftHead: #aggregation;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <>---< aString [

	self
		startAssociation;
		addAssociationLeftHead: #aggregation;
		addAssociationRightLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <>< aString [

	self
		startAssociation;
		addAssociationLeftHead: #aggregation;
		addAssociationLeftLabel: aString asString
]

{ #category : 'UML - inheritance' }
MicroUMLAstBuilder >> <|-- aSymbolOrClass [

	self addSubclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - class separators' }
MicroUMLAstBuilder >> === aSymbolOrClassOrArray [

	aSymbolOrClassOrArray isArray
		ifTrue: [
				self finishCurrentClassAndStartNewClassModifiers:
					aSymbolOrClassOrArray ]
		ifFalse: [
				self finishCurrentClassAndStartNewClass:
					(self getSymbol: aSymbolOrClassOrArray) ]
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> > aClassOrSymbol [

	self finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> >* aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startMethodModifiers: aSymbolOrArray ]
		ifFalse: [ self startMethod: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> >+ aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startPublicMethodModifiers: aSymbolOrArray ]
		ifFalse: [ self startPublicMethod: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> >- aSymbolOrArray [

	aSymbolOrArray isArray
		ifTrue: [ self startPrivateMethodModifiers: aSymbolOrArray ]
		ifFalse: [
		self startPrivateMethod: (self getSymbol: aSymbolOrArray) ]
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> >--- aClassOrSymbol [

	self finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> >---< aString [

	self addAssociationRightLabel: aString asString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> >---<*> aClassOrSymbol [

	self
		addAssociationRightHead: #composition;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> >---<> aClassOrSymbol [

	self
		addAssociationRightHead: #aggregation;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> ><*> aClassOrSymbol [

	self
		addAssociationRightHead: #composition;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> ><> aClassOrSymbol [

	self
		addAssociationRightHead: #aggregation;
		finishAssociation: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> @ aClassOrSymbol [

	self addMemberType: (self getSymbol: aClassOrSymbol)
]

{ #category : 'building' }
MicroUMLAstBuilder >> addAssociationLeftHead: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation leftHead: aSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addAssociationLeftLabel: aString [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation leftLabel: aString
]

{ #category : 'building' }
MicroUMLAstBuilder >> addAssociationRightHead: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightHead: aSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addAssociationRightLabel: aString [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightLabel: aString
]

{ #category : 'building' }
MicroUMLAstBuilder >> addClassName: aSymbol [

	currentClass := (classes at: aSymbol ifAbsentPut: [ currentClass ])
		                name: aSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addMemberName: aSymbol [

	currentClass currentMember name: aSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addMemberType: aSymbol [

	currentClass currentMember type: aSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addMethodArgumentTypes: anArrayOfSymbol [

	currentClass currentMember argumentTypes: anArrayOfSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> addSubclass: aSymbol [

	(self ensureClassAt: aSymbol) superclass: currentClass name
]

{ #category : 'building' }
MicroUMLAstBuilder >> addSuperclass: aSymbol [

	currentClass superclass: aSymbol
]

{ #category : 'class access' }
MicroUMLAstBuilder >> associationNodeClass [

	^ MicroUMLAssociationNode
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> associations [

	^ associations asArray
]

{ #category : 'enumerating' }
MicroUMLAstBuilder >> associationsDo: aBlock [

	associations do: aBlock
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> classAt: aSymbol [

	^ classes at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLAstBuilder >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'enumerating' }
MicroUMLAstBuilder >> classesDo: aBlock [

	classes valuesDo: aBlock
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> currentAssociation [

	^ currentAssociation
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> currentClass [

	^ currentClass
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> ensureClassAt: aSymbol [

	^ classes at: aSymbol ifAbsentPut: [ self newClassNode ]
]

{ #category : 'rendering' }
MicroUMLAstBuilder >> extent: aPoint [

	| canvas |
	canvas := self newRoassalBuilder build.
	aPoint isPoint ifTrue: [ canvas extent: aPoint ].
	canvas zoomToFit.
	^ canvas asForm
]

{ #category : 'building' }
MicroUMLAstBuilder >> finishAssociation: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightClass: aSymbol.
	associations add: currentAssociation.
	currentAssociation := nil
]

{ #category : 'building' }
MicroUMLAstBuilder >> finishCurrentClassAndStartNewClass: aSymbol [

	currentClass := classes
		                   at: aSymbol
		                   ifAbsentPut: [ self newClassNode name: aSymbol ]
]

{ #category : 'building' }
MicroUMLAstBuilder >> finishCurrentClassAndStartNewClassModifiers: anArrayOfSymbol [

	currentClass := self newClassNode modifiers: anArrayOfSymbol
]

{ #category : 'private' }
MicroUMLAstBuilder >> getSymbol: aClassOrString [

	aClassOrString isString ifTrue: [ ^ aClassOrString asSymbol ].
	aClassOrString isClass ifTrue: [ ^ aClassOrString name asSymbol ].
	^ self error: 'A string or class expected'
]

{ #category : 'initialization' }
MicroUMLAstBuilder >> initialize [

	super initialize.
	classes := OrderedDictionary new.
	associations := OrderedCollection new
]

{ #category : 'instance creation' }
MicroUMLAstBuilder >> newAssociationNode [

	^ self associationNodeClass new
]

{ #category : 'instance creation' }
MicroUMLAstBuilder >> newClassNode [

	^ self classNodeClass new
]

{ #category : 'instance creation' }
MicroUMLAstBuilder >> newRoassalBuilder [

	^ MicroUMLRoassalBuilder new
		  astBuilder: self;
		  yourself
]

{ #category : 'building' }
MicroUMLAstBuilder >> startAndFinishAssociation: aSymbol [

	currentAssociation := self newAssociationNode.
	currentAssociation
		leftClass: currentClass name;
		rightClass: aSymbol.
	associations add: currentAssociation.
	currentAssociation := nil
]

{ #category : 'building' }
MicroUMLAstBuilder >> startAssociation [

	currentAssociation := self newAssociationNode leftClass:
		                      currentClass name
]

{ #category : 'building' }
MicroUMLAstBuilder >> startMember: aSymbol [

	self currentClass addMember: aSymbol asSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> startMemberModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil) modifiers: anArrayOfSymbol
]

{ #category : 'building' }
MicroUMLAstBuilder >> startMethod: aSymbol [

	(self currentClass addMember: aSymbol asSymbol) isMethod: true
]

{ #category : 'building' }
MicroUMLAstBuilder >> startMethodModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil)
		modifiers: anArrayOfSymbol;
		isMethod: true
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPrivateMember: aSymbol [

	(self currentClass addMember: aSymbol asSymbol) bePrivate
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPrivateMemberModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil)
		modifiers: anArrayOfSymbol;
		bePrivate
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPrivateMethod: aSymbol [

	(self currentClass addMember: aSymbol asSymbol)
		isMethod: true;
		bePrivate
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPrivateMethodModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil)
		isMethod: true;
		modifiers: anArrayOfSymbol;
		bePrivate
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPublicMember: aSymbol [

	(self currentClass addMember: aSymbol asSymbol) bePublic
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPublicMemberModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil)
		modifiers: anArrayOfSymbol;
		bePublic
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPublicMethod: aSymbol [

	(self currentClass addMember: aSymbol asSymbol)
		isMethod: true;
		bePublic
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPublicMethodModifiers: anArrayOfSymbol [

	(self currentClass addMember: nil)
		isMethod: true;
		modifiers: anArrayOfSymbol;
		bePublic
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> ~ anArrayOfSymbol [

	self addMethodArgumentTypes:
		(anArrayOfSymbol collect: [ :symbol | self getSymbol: symbol ])
]
