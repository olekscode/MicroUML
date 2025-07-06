Class {
	#name : 'MicroUMLAttributeNodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'attribute'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLAttributeNodeTest >> setUp [

	attribute := MicroUMLAttributeNode new
]

{ #category : 'tests' }
MicroUMLAttributeNodeTest >> testName [

	attribute name: #foo.
	self assert: attribute name equals: #foo
]

{ #category : 'tests' }
MicroUMLAttributeNodeTest >> testType [

	attribute type: #Bar.
	self assert: attribute type equals: #Bar
]
