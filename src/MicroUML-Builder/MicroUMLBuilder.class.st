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
	#name : 'MicroUMLBuilder',
	#superclass : 'Object',
	#instVars : [
		'currentLink',
		'currentClass',
		'classes'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'UML - attributes' }
MicroUMLBuilder >> ++ aSymbol [

	self startPublicAttribute: (self getSymbol: aSymbol)
]

{ #category : 'UML - attributes' }
MicroUMLBuilder >> -- aSymbol [

	self startPrivateAttribute: (self getSymbol: aSymbol)
]

{ #category : 'UML - relations' }
MicroUMLBuilder >> --|> aSymbolOrClass [

	currentClass superclass: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - relations' }
MicroUMLBuilder >> <|-- aSymbolOrClass [

	self ensureClassAt: (self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - class separators' }
MicroUMLBuilder >> === aSymbolOrClass [

	self finishCurrentClassAndStartNewClass:
		(self getSymbol: aSymbolOrClass)
]

{ #category : 'UML - methods' }
MicroUMLBuilder >> => aClassOrSymbol [

	self addMethodReturnType: (self getSymbol: aClassOrSymbol)
]

{ #category : 'UML - methods' }
MicroUMLBuilder >> >+ aSymbol [

	self startPublicMethod: (self getSymbol: aSymbol)
]

{ #category : 'UML - methods' }
MicroUMLBuilder >> >- aSymbol [

	self startPrivateMethod: (self getSymbol: aSymbol)
]

{ #category : 'UML - attributes' }
MicroUMLBuilder >> @ aClassOrSymbol [

	self addAttributeType: (self getSymbol: aClassOrSymbol)
]

{ #category : 'building' }
MicroUMLBuilder >> addAttributeType: aSymbol [

	currentClass addAttributeType: aSymbol
]

{ #category : 'building' }
MicroUMLBuilder >> addMethodArgumentTypes: anArrayOfSymbol [

	currentClass addMethodArgumentTypes: anArrayOfSymbol
]

{ #category : 'building' }
MicroUMLBuilder >> addMethodReturnType: aSymbol [

	currentClass addMethodReturnType: aSymbol
]

{ #category : 'accessing' }
MicroUMLBuilder >> classAt: aSymbol [

	^ classes at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLBuilder >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLBuilder >> currentClass [

	^ currentClass
]

{ #category : 'accessing' }
MicroUMLBuilder >> ensureClassAt: aSymbol [

	^ classes at: aSymbol ifAbsentPut: [ self newClassNode ]
]

{ #category : 'building' }
MicroUMLBuilder >> finishCurrentClassAndStartNewClass: aSymbol [

	currentClass := classes
		                   at: aSymbol
		                   ifAbsentPut: [ self newClassNode name: aSymbol ]
]

{ #category : 'private' }
MicroUMLBuilder >> getSymbol: aClassOrString [

	aClassOrString isString ifTrue: [ ^ aClassOrString asSymbol ].
	aClassOrString isClass ifTrue: [ ^ aClassOrString name asSymbol ].
	^ self error: 'A string or class expected'
]

{ #category : 'initialization' }
MicroUMLBuilder >> initialize [

	super initialize.
	classes := Dictionary new
]

{ #category : 'instance creation' }
MicroUMLBuilder >> newClassNode [

	^ self classNodeClass new
]

{ #category : 'building' }
MicroUMLBuilder >> startPrivateAttribute: aSymbol [

	self currentClass addPrivateAttribute: aSymbol asSymbol
]

{ #category : 'building' }
MicroUMLBuilder >> startPrivateMethod: aSymbol [

	self currentClass addPrivateMethod: aSymbol asSymbol
]

{ #category : 'building' }
MicroUMLBuilder >> startPublicAttribute: aSymbol [

	self currentClass addPublicAttribute: aSymbol asSymbol
]

{ #category : 'building' }
MicroUMLBuilder >> startPublicMethod: aSymbol [

	self currentClass addPublicMethod: aSymbol asSymbol
]

{ #category : 'UML - methods' }
MicroUMLBuilder >> ~ anArrayOfSymbol [

	self addMethodArgumentTypes:
		(anArrayOfSymbol collect: [ :symbol | self getSymbol: symbol ])
]
