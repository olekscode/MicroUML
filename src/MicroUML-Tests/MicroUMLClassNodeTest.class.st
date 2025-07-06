Class {
	#name : 'MicroUMLClassNodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'class'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLClassNodeTest >> setUp [

	class := MicroUMLClassNode new
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddAttribute [

	class addAttribute: #bar.
	self assert: class attributes size equals: 1.
	self assert: (class attributes at: #bar) name equals: #bar
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddAttributeType [

	class addAttribute: #bar.
	class addAttribute: #buzz.
	class addAttributeType: #BuzzType.
	self assert: (class attributeAt: #buzz) type equals: #BuzzType
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddMethod [

	class addMethod: #buzz.
	self assert: class methods size equals: 1.
	self assert: (class methods at: #buzz) name equals: #buzz
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddMethodArgumentTypes [

	class
		addMethod: #operation;
		addMethodArgumentTypes: #( Type1 Type2 ).
	self
		assert: (class methodAt: #operation) argumentTypes
		equals: { #Type1. #Type2 }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddMethodReturnTypes [

	class
		addMethod: #operation;
		addMethodArgumentTypes: #( Type1 Type2 );
		addMethodReturnType: #int.
	self assert: (class methodAt: #operation) returnType equals: #int
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testName [

	class name: #Foo.
	self assert: class name equals: #Foo
]
