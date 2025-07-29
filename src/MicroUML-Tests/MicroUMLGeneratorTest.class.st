Class {
	#name : 'MicroUMLGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [
		'generator',
		'dummy'
	],
	#classInstVars : [
		'classDummy'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'accessing' }
MicroUMLGeneratorTest class >> classDummy [

	^ classDummy
]

{ #category : 'accessing' }
MicroUMLGeneratorTest class >> dummyAbstractMethod [

	^ self subclassResponsibility
]

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
	attribute := (generator diagram classAt: self class name)
		             attributeAt: #dummy.
	self assert: attribute isAttribute.
	self assert: attribute isInstanceSide.
	self assert: attribute name equals: #dummy.
	self assert: attribute type equals: #String.
	generator generateAttribute: #classDummy in: self class class.
	attribute := (generator diagram classAt: self class name)
		             attributeAt: #classDummy.
	self assert: attribute isAttribute.
	self assert: attribute isClassSide.
	self assert: attribute name equals: #classDummy.
	self assert: attribute type isNil
]

{ #category : 'running' }
MicroUMLGeneratorTest >> testGenerateClass [

	| attribute getter setter classMethod classAbstractMethod |
	generator generateClass: self class.
	attribute := (generator diagram classAt: self class name)
		             attributeAt: #dummy.
	self assert: attribute isAttribute.
	self assert: attribute isInstanceSide.
	self assert: attribute name equals: #dummy.
	self assert: attribute argumentTypes isNil.
	self assert: attribute type equals: #String.

	getter := (generator diagram classAt: self class name) methodAt:
		          #dummy.
	self assert: getter isMethod.
	self assert: attribute isInstanceSide.
	self assert: attribute isConcrete.
	self assert: getter name equals: #dummy.
	self assert: getter argumentTypes equals: #(  ).
	self assert: getter type isNil.

	setter := (generator diagram classAt: self class name) methodAt:
		          #dummy:.
	self assert: setter isMethod.
	self assert: setter name equals: #dummy:.
	self assert: setter argumentTypes equals: #( String ).
	self assert: setter type isNil.

	classMethod := (generator diagram classAt: self class name)
		               methodAt: #classDummy.
	self assert: classMethod isMethod.
	self assert: classMethod isClassSide.
	self assert: classMethod isConcrete.
	self assert: classMethod name equals: #classDummy.
	self assert: classMethod argumentTypes equals: #(  ).
	self assert: classMethod type isNil.

	classAbstractMethod := (generator diagram classAt: self class name)
		                       methodAt: #dummyAbstractMethod.
	self assert: classAbstractMethod isMethod.
	self assert: classAbstractMethod isClassSide.
	self assert: classAbstractMethod isAbstract.
	self assert: classAbstractMethod name equals: #dummyAbstractMethod.
	self assert: classAbstractMethod argumentTypes equals: #(  ).
	self assert: classAbstractMethod type isNil
]

{ #category : 'running' }
MicroUMLGeneratorTest >> testGenerateMethodIn [

	| method |
	generator generateMethod: #dummy: in: self class.
	method := (generator diagram classAt: self class name) methodAt:
		          #dummy:.
	self assert: method isMethod.
	self assert: method isInstanceSide.
	self assert: method isConcrete.
	self assert: method name equals: #dummy:.
	self assert: method argumentTypes equals: #( String ).
	self assert: method type isNil.
	generator generateMethod: #dummy in: self class.
	method := (generator diagram classAt: self class name) methodAt:
		          #dummy.
	self assert: method isMethod.
	self assert: method isInstanceSide.
	self assert: method isConcrete.
	self assert: method name equals: #dummy.
	self assert: method argumentTypes equals: #(  ).
	self assert: method type isNil.
	generator generateMethod: #classDummy in: self class class.
	method := (generator diagram classAt: self class name) methodAt:
		          #classDummy.
	self assert: method isMethod.
	self assert: method isClassSide.
	self assert: method isConcrete.
	self assert: method name equals: #classDummy.
	self assert: method argumentTypes equals: #(  ).
	self assert: method type isNil.
	generator generateMethod: #dummyAbstractMethod in: self class class.
	method := (generator diagram classAt: self class name) methodAt:
		          #dummyAbstractMethod.
	self assert: method isMethod.
	self assert: method isClassSide.
	self assert: method isAbstract.
	self assert: method name equals: #dummyAbstractMethod.
	self assert: method argumentTypes equals: #(  ).
	self assert: method type isNil
]
