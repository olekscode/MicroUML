"
I represent an AST node for UML class.
I have name(symbol) and ordered dictionaries of attributes and methods.
I also hold my superclass (symbol).

"
Class {
	#name : 'MicroUMLClassNode',
	#superclass : 'Object',
	#instVars : [
		'name',
		'superclass',
		'attributes',
		'methods',
		'links'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'adding' }
MicroUMLClassNode >> addAttribute: aSymbol [

	attributes
		at: aSymbol
		put: (self attributeNodeClass new name: aSymbol)
]

{ #category : 'adding' }
MicroUMLClassNode >> addAttributeType: aSymbol [

	attributes values last type: aSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addLink: aMicroUMLLink [

	links add: aMicroUMLLink
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethod: aSymbol [

	methods
		at: aSymbol asSymbol
		put: (self methodNodeClass new name: aSymbol)
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethodArgumentTypes: anArrayOfSymbol [

	methods values last argumentTypes: anArrayOfSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethodReturnType: aSymbol [

	methods values last returnType: aSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addPrivateAttribute: aSymbol [

	attributes at: aSymbol put: (self attributeNodeClass new
			 name: aSymbol;
			 bePrivate)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPrivateMethod: aSymbol [

	methods at: aSymbol asSymbol put: (self methodNodeClass new
			 name: aSymbol;
			 bePrivate)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPublicAttribute: aSymbol [

	attributes at: aSymbol put: (self attributeNodeClass new
			 name: aSymbol;
			 bePublic)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPublicMethod: aSymbol [

	methods at: aSymbol asSymbol put: (self methodNodeClass new
			 name: aSymbol;
			 bePublic)
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributeAt: aSymbol [

	^ attributes at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> attributeNodeClass [

	^ MicroUMLAttributeNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributes [

	^ attributes
]

{ #category : 'initialization' }
MicroUMLClassNode >> initialize [

	attributes := OrderedDictionary new.
	methods := OrderedDictionary new.
	links := OrderedCollection new
]

{ #category : 'accessing' }
MicroUMLClassNode >> links [

	^ links
]

{ #category : 'accessing' }
MicroUMLClassNode >> methodAt: aSymbol [

	^ methods at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> methodNodeClass [

	^ MicroUMLMethodNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> methods [

	^ methods
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
