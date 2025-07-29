Class {
	#name : 'MicroUMLGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [
		'generator',
		'dummy'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'accessing' }
MicroUMLGeneratorTest >> dummy [

	^ dummy
]

{ #category : 'accessing' }
MicroUMLGeneratorTest >> dummy: aString [

	dummy := aString
]

{ #category : 'running' }
MicroUMLGeneratorTest >> setUp [

	generator := MicroUMLGenerator new
]

{ #category : 'running' }
MicroUMLGeneratorTest >> testGenerateAttributeIn [

	| attribute |
	generator generateAttribute: #dummy in: self class.
	attribute := (generator diagram classAt: self class name) attributeAt:
		             #dummy.
	self assert: attribute isAttribute.
	self assert: attribute name equals: #dummy.
	self assert: attribute type equals: #String
]

{ #category : 'running' }
MicroUMLGeneratorTest >> testGenerateClass [

	| attribute getter setter |
	generator generateClass: self class.
	attribute := (generator diagram classAt: self class name)
		             attributeAt: #dummy.
	self assert: attribute isAttribute.
	self assert: attribute name equals: #dummy.
	self assert: attribute argumentTypes isNil.
	self assert: attribute type equals: #String.

	getter := (generator diagram classAt: self class name) methodAt:
		          #dummy.
	self assert: getter isMethod.
	self assert: getter name equals: #dummy.
	self assert: getter argumentTypes equals: #(  ).
	self assert: getter type isNil.

	setter := (generator diagram classAt: self class name) methodAt:
		          #dummy:.
	self assert: setter isMethod.
	self assert: setter name equals: #dummy:.
	self assert: setter argumentTypes equals: #( String ).
	self assert: setter type isNil
]

{ #category : 'running' }
MicroUMLGeneratorTest >> testGenerateMethodIn [

	| method |
	generator generateMethod: #dummy: in: self class.
	method := (generator diagram classAt: self class name) methodAt:
		          #dummy:.
	self assert: method isMethod.
	self assert: method name equals: #dummy:.
	self assert: method argumentTypes equals: #( String ).
	self assert: method type isNil.
	generator generateMethod: #dummy in: self class.
	method := (generator diagram classAt: self class name) methodAt:
		          #dummy.
	self assert: method isMethod.
	self assert: method name equals: #dummy.
	self assert: method argumentTypes equals: #(  ).
	self assert: method type isNil
]
