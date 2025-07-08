Class {
	#name : 'MicroUMLAstBuilderTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLAstBuilderTest >> setUp [

	builder := MicroUMLAstBuilder new
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddMemberType [

	builder === #Foo + #attribute addMemberType: #string.
	self
		assert: (builder currentClass attributeAt: #attribute) type
		equals: #string
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddMethodArgumentTypes [

	builder === #Foo + #op addMethodArgumentTypes: { #string. #uint }.
	self
		assert: (builder currentClass methodAt: #op) argumentTypes
		equals: #( string uint )
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddSubclass [

	builder === #Foo + #attribute addSubclass: #Bar.
	self assert: (builder classAt: #Bar) superclass equals: #Foo
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddSuperclass [

	builder === #Foo + #attribute addSuperclass: #Bar.
	self assert: builder currentClass superclass equals: #Bar
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testExampleComics [

	| abstractSerie comixSerie |
builder :=
#ComixSerie
	--|> #AbstractSerie 
	+ #isPrime @ Boolean
	- #size @ Integer 
	+ #factorial ~ #( int int ) @ #int
===
#AbstractSerie 
	+ #name @ String 
	- #size @ Integer 
	- #factorial~ #( uint uint ) @ #uint.

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
		assert: (comixSerie methodAt: #factorial) type
		equals: #int
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testFinishCurrentClassAndStartNewClass [

	self assert: builder currentClass equals: nil.
	self assert: builder === #Foo identicalTo: builder.
	self assert: builder currentClass name equals: #Foo.
	self assert: builder === Object identicalTo: builder.
	self assert: builder currentClass name equals: #Object
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPrivateMember [

	builder === #Foo startPrivateMember: #attribute.
	self assert: (builder currentClass memberAt: #attribute) isPrivate
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPublicMember [

	builder === #Foo startPublicMember: #attribute.
	self assert: (builder currentClass memberAt: #attribute) isPublic
]
