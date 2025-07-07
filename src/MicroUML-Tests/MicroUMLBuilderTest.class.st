Class {
	#name : 'MicroUMLBuilderTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLBuilderTest >> setUp [

	builder := MicroUMLAstBuilder new
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testAddAttributeType [

	builder === #Foo ++ #attribute addAttributeType: #string.
	self
		assert: (builder currentClass attributeAt: #attribute) type
		equals: #string
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testAddMethodArgumentTypes [

	builder === #Foo >+ #op addMethodArgumentTypes: { #string. #uint }.
	self
		assert: (builder currentClass methodAt: #op) argumentTypes
		equals: #( string uint )
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testAddMethodReturnType [

	builder === #Foo >+ #op addMethodReturnType: #char.
	self
		assert: (builder currentClass methodAt: #op) returnType
		equals: #char
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testExampleComics [

	| abstractSerie comixSerie |
builder :=
#ComixSerie
	--|> #AbstractSerie 
	++ #isPrime @ Boolean
	-- #size @ Integer 
	>+ #factorial ~ #( int int ) => #int
===
#AbstractSerie 
	++ #name @ String 
	-- #size @ Integer 
	>- #factorial~ #( uint uint ) => #uint.

	abstractSerie := builder classAt: #AbstractSerie.
	comixSerie := builder classAt: #ComixSerie.
	self assert: abstractSerie name equals: #AbstractSerie.
	self assert: comixSerie name equals: #ComixSerie.
	self assert: comixSerie superclass equals: #AbstractSerie.
	self assert: (abstractSerie attributeAt: #name) isPublic.
	self assert: (abstractSerie attributeAt: #name) type equals: #String.
	self assert: (comixSerie attributeAt: #size) isPrivate.
	self assert: (comixSerie attributeAt: #size) type equals: #Integer.
	self
		assert: (abstractSerie methodAt: #factorial) argumentTypes
		equals: #( uint uint ).
	self
		assert: (comixSerie methodAt: #factorial) returnType
		equals: #int
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testFinishCurrentClassAndStartNewClass [

	self assert: builder currentClass equals: nil.
	self assert: builder === #Foo identicalTo: builder.
	self assert: builder currentClass name equals: #Foo.
	self assert: builder === Object identicalTo: builder.
	self assert: builder currentClass name equals: #Object
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testStartPrivateAttribute [

	builder === #Foo startPrivateAttribute: #attribute.
	self assert: (builder currentClass attributeAt: #attribute) isPrivate
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testStartPrivateMethod [

	builder === #Foo startPrivateMethod: #op.
	self assert: (builder currentClass methodAt: #op) isPrivate
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testStartPublicAttribute [

	builder === #Foo startPublicAttribute: #attribute.
	self assert: (builder currentClass attributeAt: #attribute) isPublic
]

{ #category : 'tests' }
MicroUMLBuilderTest >> testStartPublicMethod [

	builder === #Foo startPublicMethod: #op.
	self assert: (builder currentClass methodAt: #op) isPublic
]
