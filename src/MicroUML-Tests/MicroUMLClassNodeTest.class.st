Class {
	#name : 'MicroUMLClassNodeTest',
	#superclass : 'TestCase',
	#instVars : [
		'class'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLClassNodeTest >> setUp [

	class := MicroUMLClassNode new
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddMember [

	| foo |
	foo := class addMember: #foo.
	self assert: foo class equals: MicroUMLMemberNode.
	self assert: class members size equals: 1.
	self assert: (class memberAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAddTrait [

	class addTrait: #TFoo.
	class addTrait: #TBar.
	self assert: class traits equals: { #TFoo. #TBar }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributeAt [

	| foo |
	foo := class addMember: #foo.
	self assert: (class attributeAt: #foo) identicalTo: foo.
	foo argumentTypes: #(  ).
	self assert: (class attributeAt: #foo) isNil
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributes [

	| foo |
	foo := class addMember: #foo.
	self assert: class attributes equals: { foo }.
	foo argumentTypes: #(  ).
	self assert: class attributes isEmpty
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributesCollect [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self assert: (class attributesCollect: #name) equals: #( foo quuux )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributesDo [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self
		assert: (Array streamContents: [ :stream |
				 class attributesDo: [ :attribute |
					 stream nextPut: attribute name ] ])
		equals: #( foo quuux )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testBeClass [

	class beTrait.
	self assert: (class keywords includes: #trait).
	class beClass.
	self deny: (class keywords includes: #trait)
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testBeTrait [

	self deny: (class keywords includes: #trait).
	class beTrait.
	self assert: (class keywords includes: #trait)
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testCurrentMember [

	| foo bar |
	foo := class addMember: #foo.
	self assert: class currentMember identicalTo: foo.
	bar := class addMember: #bar.
	self deny: bar identicalTo: foo.
	self assert: class currentMember identicalTo: bar
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testCurrentMemberName [

	| foo |
	foo := class addMember: nil.
	self assert: class currentMember identicalTo: foo.
	class currentMemberName: #foo.
	self assert: (class memberAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testKeywords [

	self deny: (class keywords includes: #trait).
	class beTrait.
	self assert: (class keywords includes: #trait)
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMemberAt [

	| foo |
	foo := class addMember: #foo.
	self assert: (class memberAt: #foo) identicalTo: foo.
	foo argumentTypes: #(  ).
	self assert: (class memberAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMembers [

	| foo |
	foo := class addMember: #foo.
	self assert: class members equals: { foo }.
	foo argumentTypes: #(  ).
	self assert: class members equals: { foo }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMembersCollect [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self
		assert: (class membersCollect: #name)
		equals: #( foo bar baz quuux )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMembersDo [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self
		assert: (Array streamContents: [ :stream |
				 class membersDo: [ :member | stream nextPut: member name ] ])
		equals: #( foo bar baz quuux )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodAt [

	| foo |
	foo := class addMember: #foo.
	self assert: (class methodAt: #foo) isNil.
	foo argumentTypes: #(  ).
	self assert: (class methodAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethods [

	| foo |
	foo := class addMember: #foo.
	self assert: class methods isEmpty.
	foo argumentTypes: #(  ).
	self assert: class methods equals: { foo }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodsCollect [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self assert: (class methodsCollect: #name) equals: #( bar baz )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodsDo [

	| foo bar baz quuux |
	foo := class addMember: #foo.
	bar := class addMember: #bar.
	baz := class addMember: #baz.
	quuux := class addMember: #quuux.
	bar argumentTypes: #(  ).
	baz argumentTypes: #( int ).
	self
		assert: (Array streamContents: [ :stream |
				 class methodsDo: [ :method | stream nextPut: method name ] ])
		equals: #( bar baz )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testModifiers [

	self deny: class isAbstract.
	class modifiers: #( abstract ).
	self assert: class isAbstract.
	self assert: class modifiers equals: #( abstract )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testName [

	class name: #Foo.
	self assert: class name equals: #Foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testPrintMicroUMLOn [

	class := #Foo --|> #Bar classAt: #Foo.
	self
		assert:
		(String streamContents: [ :stream | class printMicroUMLOn: stream ])
		equals: '#Foo --|> #Bar'.
	class := MicroUMLAstBuilder === #Foo % #abstract --|> #Bar classAt:
		         #Foo.
	self
		assert:
		(String streamContents: [ :stream | class printMicroUMLOn: stream ])
		equals: '#Foo % #abstract --|> #Bar'.
	class := #Foo --@ #TBar * #baz >> #quuux classAt: #Foo.
	self
		assert:
		(String streamContents: [ :stream | class printMicroUMLOn: stream ])
		equals: '#Foo
  --@ #TBar
  * #baz
  >> #quuux'
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testSuperclass [

	self assert: class superclass isNil.
	class superclass: #Quuuuuuux.
	self assert: class superclass equals: #Quuuuuuux
]
