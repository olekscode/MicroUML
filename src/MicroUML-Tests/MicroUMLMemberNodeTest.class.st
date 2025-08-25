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
MicroUMLMemberNodeTest >> testBeClassSide [

	self deny: member isClassSide.
	member beClassSide.
	self assert: member isClassSide
]

{ #category : 'tests' }
MicroUMLMemberNodeTest >> testBeInstanceSide [

	member beClassSide.
	self deny: member isInstanceSide.
	member beInstanceSide.
	self assert: member isInstanceSide
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
	self assert: member modifiers equals: #( abstract )
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
	member := (#Quuux + #foo % #abstract @ #Bar classAt: #Quuux)
		          memberAt: #foo.
	self
		assert:
		(String streamContents: [ :stream | member printMicroUMLOn: stream ])
		equals: '+ #foo @ #Bar % #abstract'.
	member := (#Quuux >- #foo ~ #( Bar ) @ #Baz % #abstract classAt:
		           #Quuux) memberAt: #foo.
	self
		assert:
		(String streamContents: [ :stream | member printMicroUMLOn: stream ])
		equals: '>- #foo ~#(Bar) @ #Baz % #abstract'
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
