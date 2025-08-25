"
I build a UML class diagram.
I have a namespace of classes to manage class definitions, references and relations among them.
You can use me explicitly say, like

```MicroUML
MicroUMLBuilder
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

The following is the summary of how you define a class.

```
""Instance side variables""
- #var1 ""protected by default""
- #var2 % #public
- #var3 % #private
- #var4 % #protected

""Class side variables""
|- #var5 ""protected by default""
|- #var6 % #public
|- #var7 % #private
|- #var8 % #protected

""Instance side methods""
> #method1 ""public by default""
> #method2 % #public
> #method3 % #private
> #method4 % #protected

""Class side methods""
|> #method5 ""public by default""
|> #method6 % #public
|> #method7 % #private
|> #method8 % #protected
```
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

{ #category : 'UML - class separators' }
MicroUMLAstBuilder class >> === aSymbolOrClassOrArray [

	^ self new === aSymbolOrClassOrArray
]

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleMicrodown [

	^ (MicrodownPresenter new document: '
Example of novel and comic derrived from anime

```pharoscript
#AbstractSeries 
	- #name @ String 
	- #numEpisodes @ Integer % #private
	> #findByName % #abstract
=== 
#NovelSeries 
	--|> #AbstractSeries
	- #author @ String 
	- #Publisher @ String 
	> #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	- #toonAuthor @ String
	- #storyAuthor @ String % #private
	> #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	- #director @ String 
	- #animators @ String % #private
	- #voiceActors @ String % #private
	> #play~{} 
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
	- #name @ String 
	- #numEpisodes @ Integer % #private
=== 
#NovelSeries 
	--|> #AbstractSeries
	- #author @ String 
	- #Publisher @ String 
	> #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	- #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	- #director @ String 
	- #animators @ String % #private
	- #voiceActors @ String % #private
	> #play~{} 
	<>---<'based on'> #ComicSeries 
=== 
#AnimeSeries	 ---<'original'> #NovelSeries
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> % aSymbol [

	currentClass ifNotNil: [
			currentClass currentMember
				ifNil: [ self addClassModifier: aSymbol asSymbol ]
				ifNotNil: [ self addMemberModifier: aSymbol asSymbol ] ]
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> - aSymbolOrArray [

	self startAttribute: (self getSymbol: aSymbolOrArray)
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
MicroUMLAstBuilder >> --@ aSymbolOrClass [

	self addTrait: (self getSymbol: aSymbolOrClass)
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

	self finishCurrentClassAndStartNewClass:
		(self getSymbol: aSymbolOrClassOrArray)
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> > aSymbolOrArray [

	self startMethod: (self getSymbol: aSymbolOrArray)
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

{ #category : 'UML - members' }
MicroUMLAstBuilder >> @ aClassOrSymbol [

	self addMemberType: (self getSymbol: aClassOrSymbol)
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationLeftHead: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation leftHead: aSymbol
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationLeftLabel: aString [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation leftLabel: aString
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationRightHead: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightHead: aSymbol
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationRightLabel: aString [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightLabel: aString
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addClassModifier: aSymbol [

	currentClass addModifier: aSymbol asSymbol
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> addMemberModifier: aSymbol [

	currentClass currentMember addModifier: aSymbol asSymbol
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> addMemberType: aSymbol [

	currentClass currentMember type: aSymbol
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> addMethodArgumentTypes: anArrayOfSymbol [

	currentClass currentMember argumentTypes: anArrayOfSymbol
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addSubclass: aSymbol [

	(self ensureClassAt: aSymbol) superclass: currentClass name
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addSuperclass: aSymbol [

	currentClass superclass: aSymbol
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addTrait: aSymbol [

	currentClass addTrait: aSymbol
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
MicroUMLAstBuilder >> diagram [

	^ self diagramNodeClass new
		  classes: classes values;
		  associations: associations;
		  yourself
]

{ #category : 'class access' }
MicroUMLAstBuilder >> diagramNodeClass [

	^ MicroUMLClassDiagramNode
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> ensureClassAt: aSymbol [

	^ classes at: aSymbol ifAbsentPut: [ self newClassNode ]
]

{ #category : 'rendering' }
MicroUMLAstBuilder >> extent: aPoint [

	| canvas |
	canvas := self newRoassalBuilder build.
	canvas extent: (aPoint isPoint
			 ifTrue: [ aPoint ]
			 ifFalse: [ canvas encompassingRectangle extent ]).
	canvas zoomToFit.
	^ canvas asForm
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> finishAssociation: aSymbol [

	currentAssociation ifNil: [ ^ self ].
	currentAssociation rightClass: aSymbol.
	associations add: currentAssociation.
	currentAssociation := nil
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> finishCurrentClassAndStartNewClass: aSymbol [

	currentClass := classes
		                   at: aSymbol
		                   ifAbsentPut: [ self newClassNode name: aSymbol ]
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
		  classDiagramNode: self diagram;
		  yourself
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> startAndFinishAssociation: aSymbol [

	currentAssociation := self newAssociationNode.
	currentAssociation
		leftClass: currentClass name;
		rightClass: aSymbol.
	associations add: currentAssociation.
	currentAssociation := nil
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> startAssociation [

	currentAssociation := self newAssociationNode leftClass:
		                      currentClass name
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startAttribute: aSymbol [

	self currentClass addAttribute: aSymbol asSymbol
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startClassSideAttribute: aSymbol [

	(self currentClass addAttribute: aSymbol asSymbol) beClassSide
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startClassSideMethod: aSymbol [

	(self currentClass addMethod: aSymbol asSymbol) beClassSide
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startMethod: aSymbol [

	self currentClass addMethod: aSymbol asSymbol
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> ~ anArrayOfSymbol [

	self addMethodArgumentTypes:
		(anArrayOfSymbol collect: [ :symbol | self getSymbol: symbol ])
]
