Class {
	#name : 'UMLVariable',
	#superclass : 'Object',
	#traits : 'TUMLNamedEntity + TUMLTypedEntity',
	#classTraits : 'TUMLNamedEntity classTrait + TUMLTypedEntity classTrait',
	#instVars : [
		'ownerClass'
	],
	#category : 'MicroUML',
	#package : 'MicroUML'
}

{ #category : 'as yet unclassified' }
UMLVariable >> ownerClass [

	^ ownerClass
]

{ #category : 'as yet unclassified' }
UMLVariable >> ownerClass: aClass [

	ownerClass := aClass
]
