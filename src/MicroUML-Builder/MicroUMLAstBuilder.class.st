"
# Class Comment for MicroUMLAstBuilder

## Purpose and Role in the System

The `MicroUMLAstBuilder` class is a critical component within the MicroUML framework, designed to construct abstract syntax trees (ASTs) for UML class diagrams. It serves as a builder that interprets textual descriptions of UML classes and their relationships, transforming them into structured nodes that can be rendered into visual diagrams. This builder is essential for developers who need to generate UML diagrams programmatically or through textual specifications, facilitating the creation of clear and consistent class diagrams without manual drawing.

## Main Collaborators or Dependencies

The `MicroUMLAstBuilder` collaborates closely with several other classes within the MicroUML framework:

- **MicroUMLClassNode**: Represents individual classes in the UML diagram, including their attributes, methods, and modifiers.
- **MicroUMLAssociationNode**: Represents relationships between classes, such as associations, aggregations, compositions, and dependencies.
- **MicroUMLClassDiagramNode**: Aggregates class and association nodes to form a complete diagram.
- **MicroUMLRoassalBuilder**: Utilises the Roassal visualisation engine to render the UML diagram from the AST nodes.

These collaborators work together to ensure that the textual specifications are accurately translated into visual representations.

## Important Invariants or Design Constraints

1. **Class and Association Management**: The builder maintains collections of classes and associations, ensuring that each class and association is uniquely identified and correctly linked.
2. **Context Awareness**: The builder keeps track of the current class and association being processed, allowing it to apply modifiers and types appropriately.
3. **Symbol Handling**: The builder handles symbols and strings uniformly, converting them into symbols for consistent processing and storage.
4. **Error Handling**: The builder includes error handling for cases where invalid inputs are provided, such as non-string or non-class inputs for symbol conversion.

## Illustrative Usage Examples

### Example 1: Creating a Simple Class Diagram

```smalltalk
builder := MicroUMLAstBuilder new.
builder === #Person.
builder - #name @ #String.
builder - #age @ #Integer.
builder > #introduce ~ {}.
builder === #Student.
builder --|> #Person.
builder - #studentId @ #String.
builder > #study ~ {}.
builder --> #Course.
builder extent: 600 @ 400.
```

This example demonstrates how to create a simple UML diagram with two classes, `Person` and `Student`, where `Student` inherits from `Person` and has a dependency on `Course`.

### Example 2: Creating a Diagram with Associations

```smalltalk
builder := MicroUMLAstBuilder new.
builder === #Department.
builder - #name @ #String.
builder === #Employee.
builder - #name @ #String.
builder - #department @ #Department.
builder <>-- #Department @ ('employs' -> 'employed by') %< '1..*' %> '1'.
builder extent: 600 @ 400.
```

In this example, an aggregation relationship is established between `Employee` and `Department`, indicating that a department employs multiple employees, and each employee is employed by one department.

By following these examples, developers can leverage the `MicroUMLAstBuilder` to create complex UML diagrams with ease, ensuring clarity and consistency in their design documentation.
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

{ #category : 'UML - class separators' }
MicroUMLAstBuilder class >> empty [

	^ self new
]

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleMicrodown [

	^ (MicrodownPresenter new document: '
Example of novel and comic derrived from anime

```pharoscript
MU
===
#AbstractSeries // ''the base class of story published in series.''
	- #name @ String // ''the title of the story''
	- #numEpisodes @ Integer % #private // ''the number of episodes in the story''
	> #findByName % #abstract // ''search by name''
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
MU 
===
#AbstractSeries // 'the base class of story published in series.' + [ :ast | ast microUMLSource inspect ]
	- #name @ String // 'the title of the story'
	- #numEpisodes @ Integer % #private // 'the number of episodes in the story'
	> #findByName % #abstract // 'search by name' + [ :ast | ast microUMLSource inspect ]
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

{ #category : 'UML - sapplementals' }
MicroUMLAstBuilder >> + aBlock [

	currentAssociation
		ifNil: [
				currentClass ifNil: [ ] ifNotNil: [
						currentClass currentMember
							ifNil: [ self addClassAction: aBlock ]
							ifNotNil: [ self addMemberAction: aBlock ] ] ]
		ifNotNil: [ self addAssociationAction: aBlock ]
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

{ #category : 'UML - sapplementals' }
MicroUMLAstBuilder >> // aString [

	currentAssociation
		ifNil: [
				currentClass ifNil: [ ] ifNotNil: [
						currentClass currentMember
							ifNil: [ self addClassComment: aString ]
							ifNotNil: [ self addMemberComment: aString ] ] ]
		ifNotNil: [ self addAssociationComment: aString ]
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

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addAssociationAction: aBlock [

	currentAssociation actionBlock: aBlock
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationClass: aSymbol [

	currentAssociation associationClass:
		(self ensureClassAt: aSymbol) name
]

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addAssociationComment: aString [

	currentAssociation comment: aString
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addAssociationLabel: aStringOrAssociation [

	currentAssociation addLabel: aStringOrAssociation
]

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addClassAction: aBlock [

	currentClass actionBlock: aBlock
]

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addClassComment: aString [

	currentClass comment: aString
]

{ #category : 'building - classes' }
MicroUMLAstBuilder >> addClassModifier: aSymbol [

	currentClass addModifier: aSymbol asSymbol
]

{ #category : 'building - associations' }
MicroUMLAstBuilder >> addLeftMultiplicity: aString [

	currentAssociation leftMultiplicity: aString
]

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addMemberAction: aBlock [

	currentClass currentMember actionBlock: aBlock
]

{ #category : 'building - supplementals' }
MicroUMLAstBuilder >> addMemberComment: aString [

	currentClass currentMember comment: aString
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

	currentClass superclass: (self ensureClassAt: aSymbol) name
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

	^ classes at: aSymbol ifAbsentPut: [
			  self newClassNode
				  name: aSymbol;
				  yourself ]
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
		                      rightClass:
			                      (self ensureClassAt:
					                       (self getSymbol: aSymbolOrClass)) name;
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
