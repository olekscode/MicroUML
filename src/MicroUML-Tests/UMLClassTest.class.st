Class {
	#name : 'UMLClassTest',
	#superclass : 'TestCase',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'tests' }
UMLClassTest >> testClassCreatedFromClass [

	| uClass |
	uClass := Integer uClass.
	
	self assert: uClass class equals: UMLClass.
	self assert: uClass name equals: #Integer
]

{ #category : 'tests' }
UMLClassTest >> testClassCreatedFromString [

	| uClass |
	uClass := 'Cat' uClass.
	
	self assert: uClass class equals: UMLClass.
	self assert: uClass name equals: #Cat
]

{ #category : 'tests' }
UMLClassTest >> testClassCreatedFromSymbol [

	| uClass |
	uClass := #Cat uClass.
	
	self assert: uClass class equals: UMLClass.
	self assert: uClass name equals: #Cat
]

{ #category : 'tests' }
UMLClassTest >> testClassCreatedFromTrait [

	| uClass |
	uClass := TEquality uClass.
	
	self assert: uClass class equals: UMLClass.
	self assert: uClass name equals: #TEquality
]
