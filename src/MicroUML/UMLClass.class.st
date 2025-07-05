Class {
	#name : 'UMLClass',
	#superclass : 'Object',
	#traits : 'TUMLNamedEntity',
	#classTraits : 'TUMLNamedEntity classTrait',
	#instVars : [
		'name',
		'superclass',
		'subclasses',
		'variables',
		'methods'
	],
	#category : 'MicroUML',
	#package : 'MicroUML'
}

{ #category : 'composing' }
UMLClass >> -- aString [

	self addVariable: (UMLVariable named: aString)
]

{ #category : 'composing' }
UMLClass >> @ aClass [

	variables last type: aClass uClass
]

{ #category : 'adding' }
UMLClass >> addMenthod: aMethod [

	methods add: aMethod
]

{ #category : 'adding' }
UMLClass >> addSubclass: aClass [

	subclasses add: aClass 
]

{ #category : 'adding' }
UMLClass >> addVariable: aVariable [

	aVariable ownerClass: self.
	variables add: aVariable
]

{ #category : 'initialization' }
UMLClass >> initialize [

	super initialize.
	
	subclasses := OrderedCollection new.
	methods := OrderedCollection new.
	variables := OrderedCollection new
]

{ #category : 'accessing' }
UMLClass >> methods [

	^ methods
]

{ #category : 'printing' }
UMLClass >> printOn: aStream [

	aStream 
		nextPutAll: 'u~';
		nextPutAll: name;
		cr
]

{ #category : 'accessing' }
UMLClass >> subclasses [

	^ subclasses
]

{ #category : 'accessing' }
UMLClass >> superclass [

	^ superclass
]

{ #category : 'accessing' }
UMLClass >> superclass: aClass [

	superclass := aClass
]

{ #category : 'accessing' }
UMLClass >> variables [

	^ variables
]
