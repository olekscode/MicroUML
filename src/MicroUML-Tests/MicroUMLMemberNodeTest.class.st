Class {
	#name : 'MicroUMLMemberNodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'member'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLMemberNodeTest >> setUp [

	member := MicroUMLMemberNode new
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testArgumentTypes [

	member argumentTypes: #( Type1 Type2 ).
	self assert: member argumentTypes equals: { #Type1. #Type2 }
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBeAbstract [

	self deny: member isAbstract.
	member beAbstract.
	self assert: member isAbstract
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBeClassSide [

	self deny: member isClassSide.
	member beClassSide.
	self assert: member isClassSide
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBeConcrete [

	member beAbstract.
	self deny: member isConcrete.
	member beConcrete.
	self assert: member isConcrete
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBeInstanceSide [

	member beClassSide.
	self deny: member isInstanceSide.
	member beInstanceSide.
	self assert: member isInstanceSide
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBePrivate [

	self deny: member isPrivate.
	member bePrivate.
	self assert: member isPrivate
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBePublic [

	self deny: member isPublic.
	member bePublic.
	self assert: member isPublic
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testIsAttribute [

	member argumentTypes: nil.
	self assert: member isAttribute.
	member argumentTypes: {  }.
	self deny: member isAttribute.
	member argumentTypes: { #int }.
	self deny: member isAttribute
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testIsMethod [

	member argumentTypes: nil.
	self deny: member isMethod.
	member argumentTypes: {  }.
	self assert: member isMethod.
	member argumentTypes: { #int }.
	self assert: member isMethod
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testIsPrivate [

	member visibility: #public.
	self deny: member isPrivate.
	member visibility: #private.
	self assert: member isPrivate
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testIsPublic [

	member visibility: #public.
	self assert: member isPublic.
	member visibility: #private.
	self deny: member isPublic
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testModifiers [

	self deny: member isAbstract.
	member modifiers: #( abstract ).
	self assert: member isAbstract.
	self assert: member modifiers equals: #( abstract ).
	self deny: member isClassSide.
	member modifiers: #( static ).
	self deny: member isAbstract.
	self assert: member isClassSide.
	self assert: member modifiers equals: #( static )
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testName [

	member name: #foo.
	self assert: member name equals: #foo
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testPrintMicroUMLOn [

	member := (#Quuux * #foo classAt: #Quuux) memberAt: #foo.
	self
		assert:
		(String streamContents: [ :stream | member printMicroUMLOn: stream ])
		equals: '* #foo'.
	member := (#Quuux + {#abstract . #static} % #foo @ #Bar classAt: #Quuux) memberAt: #foo.
	self
		assert:
		(String streamContents: [ :stream | member printMicroUMLOn: stream ])
		equals: '+ { #abstract . #static } % #foo @ #Bar'.
	member := (#Quuux >- {#abstract . #static} % #foo ~ {#Bar} @ #Baz classAt: #Quuux) memberAt: #foo.
	self
		assert:
		(String streamContents: [ :stream | member printMicroUMLOn: stream ])
		equals: '>- { #abstract . #static } % #foo~{ #Bar } @ #Baz'.

]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testType [

	member type: #Foo.
	self assert: member type equals: #Foo
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testVisibility [

	member visibility: #public.
	self assert: member visibility equals: #public.
	member visibility: #private.
	self assert: member visibility equals: #private
]
