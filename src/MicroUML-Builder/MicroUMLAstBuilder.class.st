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
	<>--#ComicSeries 
	    @ (nil -> ''based on'') 
=== 
#AnimeSeries	 -- #NovelSeries
	    @ (nil -> ''original'') 
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
	<>--#ComicSeries 
	    @ (nil -> 'based on') 
=== 
#AnimeSeries	 -- #NovelSeries
	    @ (nil -> 'original') 

]

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleSerie2 [

^ MicroUMLAstBuilder
===
#AbstractSeries % #abstract
   --@ #TSearch
	--@ #TArtifact
	- #name @ String 
	- #numEpisodes @ Integer % #abstract % #private
	|> #findByName ~#(String) @ #AbstractSeries
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
	- #storyAuthor @ String 
	> #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	- #director @ String 
	- #animators @ String % #private
	- #voiceActors @ String % #private
	> #play~{} 
	<>-- #ComicSeries @ ('original' -> 'comicalize') %< '1' %> '0..*'
	<>-- #NovelSeries @ ('main' ->'side stories') %< '1..*' %> '*'.
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> % aSymbol [

	currentClass ifNotNil: [
			currentClass currentMember
				ifNil: [ self addClassModifier: aSymbol asSymbol ]
				ifNotNil: [ self addMemberModifier: aSymbol asSymbol ] ]
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> %< aString [

	self addLeftMultiplicity: aString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> %> aString [

	self addRightMultiplicity: aString
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> *-- aSymbolOrClass [

	(self startAssociation: aSymbolOrClass) beComposition
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> *=> aSymbolOrClass [

	(self startAssociation: aSymbolOrClass)
		beComposition;
		beDirected
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> - aSymbolOrArray [

	self startAttribute: (self getSymbol: aSymbolOrArray)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> -- aSymbolOrClass [

	self startAssociation: aSymbolOrClass
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> --> aSymbolOrClass [

	(self startAssociation: aSymbolOrClass) beDependency
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
MicroUMLAstBuilder >> <>-- aSymbolOrClass [

	(self startAssociation: aSymbolOrClass) beAggregation
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> <>=> aSymbolOrClass [

	(self startAssociation: aSymbolOrClass)
		beAggregation;
		beDirected
]

{ #category : 'UML - inheritance' }
MicroUMLAstBuilder >> <|-- aSymbolOrClass [

	self addSubclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - class separators' }
MicroUMLAstBuilder >> === aSymbolOrClass [

	self startClass:
		(self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> => aSymbolOrClass [

	(self startAssociation: aSymbolOrClass) beDirected
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> > aSymbolOrArray [

	self startMethod: (self getSymbol: aSymbolOrArray)
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> @ aClassOrSymbolOrStringOrAssociation [

	currentAssociation
		ifNil: [
				self addMemberType:
					(self getSymbol: aClassOrSymbolOrStringOrAssociation) ]
		ifNotNil: [
		self addAssociationLabel: aClassOrSymbolOrStringOrAssociation ]
]

{ #category : 'UML - associations' }
MicroUMLAstBuilder >> @= aSymbolOrClass [

	self addAssociationClass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationClass: aSymbol [

	currentAssociation associationClass:
		(self ensureClassAt: aSymbol) name
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationLabel: aStringOrAssociation [

	currentAssociation addLabel: aStringOrAssociation
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addClassModifier: aSymbol [

	currentClass addModifier: aSymbol asSymbol
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addLeftMultiplicity: aString [

	currentAssociation leftMultiplicity: aString
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

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addRightMultiplicity: aString [

	currentAssociation rightMultiplicity: aString
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
MicroUMLAstBuilder >> startAssociation: aSymbolOrClass [

	currentAssociation := self newAssociationNode
		                      leftClass: currentClass name;
		                      rightClass: (self getSymbol: aSymbolOrClass);
		                      yourself.
	associations add: currentAssociation.
	^ currentAssociation
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startAttribute: aSymbol [

	currentAssociation := nil.
	^ self currentClass addAttribute: aSymbol asSymbol
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> startClass: aSymbol [

	currentClass := classes
		                at: aSymbol
		                ifAbsentPut: [ self newClassNode name: aSymbol ].
	currentAssociation := nil.
	^ currentClass
]

{ #category : 'building - members' }
MicroUMLAstBuilder >> startMethod: aSymbol [

	currentAssociation := nil.
	^ self currentClass addMethod: aSymbol asSymbol
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> |- aSymbolOrArray [

	(self startAttribute: (self getSymbol: aSymbolOrArray)) beClassSide
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> |> aSymbolOrArray [

	(self startMethod: (self getSymbol: aSymbolOrArray)) beClassSide
]

{ #category : 'UML - members' }
MicroUMLAstBuilder >> ~ anArrayOfSymbol [

	self addMethodArgumentTypes:
		(anArrayOfSymbol collect: [ :symbol | self getSymbol: symbol ])
]
