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

{ #category : 'tests - dsl' }
UMLClassTest >> testVariable [

	| uClass var |
	
	uClass := #Cat uClass
		-- #breed.
	
	var := uClass variables last.
	
	self assert: var name equals: #breed.
	self assert: var ownerClass equals: uClass. 
]

{ #category : 'tests - dsl' }
UMLClassTest >> testVariableWithTypeDefinedAsClass [

	| uClass var type |
	
	uClass := #Cat uClass
		-- #breed @ String.
	
	var := uClass variables last.
	type := var type.
	
	self assert: var name equals: #breed.
	self assert: var ownerClass equals: uClass. 
	self assert: type class equals: UMLClass.
	self assert: type name equals: #String
]

{ #category : 'tests - dsl' }
UMLClassTest >> testVariableWithTypeDefinedAsString [

	| uClass var type |
	
	uClass := #Cat uClass
		-- #breed @ 'String'.
	
	var := uClass variables last.
	type := var type.
	
	self assert: var name equals: #breed.
	self assert: var ownerClass equals: uClass. 
	self assert: type class equals: UMLClass.
	self assert: type name equals: #String
]

{ #category : 'tests - dsl' }
UMLClassTest >> testVariableWithTypeDefinedAsSymbol [

	| uClass var type |
	
	uClass := #Cat uClass
		-- #breed @ #String.
	
	var := uClass variables last.
	type := var type.
	
	self assert: var name equals: #breed.
	self assert: var ownerClass equals: uClass. 
	self assert: type class equals: UMLClass.
	self assert: type name equals: #String
]
