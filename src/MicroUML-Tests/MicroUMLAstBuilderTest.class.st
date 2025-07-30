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
MicroUMLAstBuilderTest >> testAddClassName [

	builder === #( abstract ) % #Foo.
	self assert: builder currentClass name equals: #Foo
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
MicroUMLAstBuilderTest >> testAddTrait [

	builder === #Foo + #attribute addTrait: #Bar.
	self assert: builder currentClass traits equals: { #Bar }
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAssociations [

	builder === 
	#Foo 
		--- #Bar 
		<>--- #Baz 
		<*>--- #Quuux
		---<> #Zeta
		---<*> #TurnA.
	self assert: builder associations size = 5.
	self assert: (builder associations collect: #leftClass) equals: #(Foo Foo Foo Foo Foo).
	self assert: (builder associations collect: #rightClass) equals: #(Bar Baz Quuux Zeta TurnA).
	self assert: (builder associations collect: #leftHead) equals: #(nil aggregation composition nil nil).
	self assert: (builder associations collect: #rightHead) equals: #(nil nil nil aggregation composition).
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAssociationsWithLeftLabel [

	builder === 
	#Foo 
		<'1'>--- #Bar 
		<><'*'>--- #Baz 
		<*><'1..n'>--- #Quuux
		<'zeta'>---<> #Zeta
		<'* turnA'>---<*> #TurnA.
	self assert: builder associations size = 5.
	self assert: (builder associations collect: #leftClass) equals: #(Foo Foo Foo Foo Foo).
	self assert: (builder associations collect: #rightClass) equals: #(Bar Baz Quuux Zeta TurnA).
	self assert: (builder associations collect: #leftHead) equals: #(nil aggregation composition nil nil).
	self assert: (builder associations collect: #rightHead) equals: #(nil nil nil aggregation composition).
	self assert: (builder associations collect: #leftLabel) equals: #('1' '*' '1..n' 'zeta' '* turnA')
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testAssociationsWithRightLabel [

	builder === 
	#Foo 
		---<'1'> #Bar 
		<>---<'*'> #Baz 
		<*>---<'1..n'> #Quuux
		---<'zeta'><> #Zeta
		---<'* turnA'><*> #TurnA.
	self assert: builder associations size = 5.
	self assert: (builder associations collect: #leftClass) equals: #(Foo Foo Foo Foo Foo).
	self assert: (builder associations collect: #rightClass) equals: #(Bar Baz Quuux Zeta TurnA).
	self assert: (builder associations collect: #leftHead) equals: #(nil aggregation composition nil nil).
	self assert: (builder associations collect: #rightHead) equals: #(nil nil nil aggregation composition).
	self assert: (builder associations collect: #rightLabel) equals: #('1' '*' '1..n' 'zeta' '* turnA')
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
MicroUMLAstBuilderTest >> testFinishCurrentClassAndStartNewClassModifiers [

	self assert: builder currentClass equals: nil.
	self assert: builder === #( abstract ) identicalTo: builder.
	self assert: builder currentClass name isNil.
	self assert: builder currentClass modifiers equals: #( abstract )
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPrivateMember [

	builder === #Foo startPrivateMember: #attribute.
	self assert: (builder currentClass memberAt: #attribute) isPrivate
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPrivateMemberModifiers [

	builder === #Foo startPrivateMemberModifiers: #( abstract static ).
	self assert: builder currentClass currentMember isPrivate.
	self assert: builder currentClass currentMember isAbstract.
	self assert: builder currentClass currentMember isClassSide.
	self assert: builder currentClass currentMember name isNil
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPublicMember [

	builder === #Foo startPublicMember: #attribute.
	self assert: (builder currentClass memberAt: #attribute) isPublic
]

{ #category : 'tests' }
MicroUMLAstBuilderTest >> testStartPublicMemberModifiers [

	builder === #Foo startPublicMemberModifiers: #( abstract static ).
	self assert: builder currentClass currentMember isPublic.
	self assert: builder currentClass currentMember isAbstract.
	self assert: builder currentClass currentMember isClassSide.
	self assert: builder currentClass currentMember name isNil
]
