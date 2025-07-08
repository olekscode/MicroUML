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
		'currentLink',
		'currentClass',
		'classes'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLAstBuilder class >> exampleSerie [

	^ 
#ComixSerie
	--|> #AbstractSerie 
	+ #isPrime @ Boolean
	- #size @ Integer 
	+ #factorial ~ #( int int ) @ #int
===
#AbstractSerie 
	+ #name @ String 
	- #size @ Integer 
	- #factorial~ #( uint uint ) @ #uint
	+ #foo @ String
	+ #bar ~ {} @ String 
	+ #baz ~ {String} @ String 
	+ #quuux @ Symbol.

]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> + aSymbol [

	self startPublicMember: (self getSymbol: aSymbol)
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> - aSymbol [

	self startPrivateMember: (self getSymbol: aSymbol)
]

{ #category : 'UML - relations' }
MicroUMLAstBuilder >> --|> aSymbolOrClass [

	self addSuperclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - relations' }
MicroUMLAstBuilder >> <|-- aSymbolOrClass [

	self addSubclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - class separators' }
MicroUMLAstBuilder >> === aSymbolOrClass [

	self finishCurrentClassAndStartNewClass:
		(self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> @ aClassOrSymbol [

	self addMemberType: (self getSymbol: aClassOrSymbol)
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

{ #category : 'accessing' }
MicroUMLAstBuilder >> classAt: aSymbol [

	^ classes at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLAstBuilder >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> classesDo: aBlock [

	classes valuesDo: aBlock
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> currentClass [

	^ currentClass
]

{ #category : 'accessing' }
MicroUMLAstBuilder >> ensureClassAt: aSymbol [

	^ classes at: aSymbol ifAbsentPut: [ self newClassNode ]
]

{ #category : 'building' }
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
	classes := Dictionary new
]

{ #category : 'instance creation' }
MicroUMLAstBuilder >> newClassNode [

	^ self classNodeClass new
]

{ #category : 'instance creation' }
MicroUMLAstBuilder >> newRoassalBuilder [

	^ MicroUMLRoassalBuilder new
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPrivateMember: aSymbol [

	(self currentClass addMember: aSymbol asSymbol) bePrivate
]

{ #category : 'building' }
MicroUMLAstBuilder >> startPublicMember: aSymbol [

	(self currentClass addMember: aSymbol asSymbol) bePublic
]

{ #category : 'UML - attributes and methods' }
MicroUMLAstBuilder >> ~ anArrayOfSymbol [

	self addMethodArgumentTypes:
		(anArrayOfSymbol collect: [ :symbol | self getSymbol: symbol ])
]
