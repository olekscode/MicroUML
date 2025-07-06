Class {
	#name : 'MicroUMLMethodNodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'method'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLMethodNodeTest >> setUp [

	method := MicroUMLMethodNode new
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testArgumentTypes [

	method argumentTypes: #( Type1 Type2 ).
	self assert: method argumentTypes equals: { #Type1. #Type2 }
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testName [

	method name: #foo.
	self assert: method name equals: #foo
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testReturnType [

	method returnType: #Foo.
	self assert: method returnType equals: #Foo
]
