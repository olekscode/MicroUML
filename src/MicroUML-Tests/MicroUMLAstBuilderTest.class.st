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
MicroUMLAstBuilderTest >> testAddClassModifier [

	builder === #Foo.
	self assert: builder currentClass name equals: #Foo.
	self assert: builder currentClass currentMember isNil.
	self
		assert: (builder addClassModifier: #abstract)
		identicalTo: builder.
	self assert: builder currentClass modifiers equals: #( abstract )
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddClassName [

	builder === #Foo.
	self assert: builder currentClass name equals: #Foo
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddMemberModifier [

	builder === #Foo - #bar.
	self assert: builder currentClass name equals: #Foo.
	self assert: builder currentClass currentMember name equals: #bar.
	self
		assert: (builder addMemberModifier: #abstract)
		identicalTo: builder.
	self
		assert: builder currentClass currentMember modifiers
		equals: #( abstract ).
	self
		assert: (builder addMemberModifier: #private)
		identicalTo: builder.
	self
		assert: builder currentClass currentMember modifiers
		equals: #( abstract private )
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddMemberType [

	builder === #Foo - #attribute addMemberType: #string.
	self
		assert: (builder currentClass attributeAt: #attribute) type
		equals: #string
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddMethodArgumentTypes [

	builder === #Foo > #op addMethodArgumentTypes: { #string. #uint }.
	self
		assert: (builder currentClass methodAt: #op) argumentTypes
		equals: #( string uint )
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddSubclass [

	builder === #Foo - #attribute addSubclass: #Bar.
	self assert: (builder classAt: #Bar) superclass equals: #Foo
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddSuperclass [

	builder === #Foo - #attribute addSuperclass: #Bar.
	self assert: builder currentClass superclass equals: #Bar
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAddTrait [

	builder === #Foo - #attribute addTrait: #Bar.
	self assert: builder currentClass traits equals: { #Bar }
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAssociations [

	builder === 
	#Foo 
		-- #Bar 
		<>-- #Baz 
		*-- #Quuux
		--> #Zeta
		*=> #TurnA.
	self assert: builder associations size = 5.
	self assert: (builder associations collect: #leftClass) equals: #(Foo Foo Foo Foo Foo).
	self assert: (builder associations collect: #rightClass) equals: #(Bar Baz Quuux Zeta TurnA).
	self assert: (builder associations collect: #leftHead) equals: #(nil aggregation composition nil composition).
	self assert: (builder associations collect: #rightHead) equals: #(nil nil nil wedge wedge).
	self assert: (builder associations collect: #line) equals: #(solid solid solid dashed solid).
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testExampleComics [

	| abstractSerie comixSerie |
builder :=
#ComixSerie
	--|> #AbstractSerie 
	- #isPrime @ Boolean
	- #size @ Integer % #private
	> #factorial ~ #( int int ) @ #int
===
#AbstractSerie 
	- #name @ String 
	- #size @ Integer % #private
	> #factorial~ #( uint uint ) @ #uint % #private.

	abstractSerie := builder classAt: #AbstractSerie.
	comixSerie := builder classAt: #ComixSerie.
	self assert: abstractSerie name equals: #AbstractSerie.
	self assert: comixSerie name equals: #ComixSerie.
	self assert: comixSerie superclass equals: #AbstractSerie.
	self assert: (abstractSerie attributeAt: #name) isProtected.
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
MicroUMLAstBuilderTest >> testStartAttribute [

	builder === #Foo.
	builder startAttribute: #bar.
	self assert: builder currentClass currentMember name equals: #bar.
	self assert: builder currentClass currentMember isAttribute.
	self assert: builder currentClass currentMember isInstanceSide
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartClass [

	self assert: builder currentClass equals: nil.
	builder startClass: #Foo.
	self assert: builder currentClass name equals: #Foo.
	self assert: builder === Object identicalTo: builder.
	self assert: builder currentClass name equals: #Object
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartMethod [

	builder === #Foo.
	builder startMethod: #bar.
	self assert: builder currentClass currentMember name equals: #bar.
	self assert: builder currentClass currentMember isMethod.
	self assert: builder currentClass currentMember isInstanceSide
]
