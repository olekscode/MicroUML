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
MicroUMLClassNodeTest >> testAddTrait [

	class addTrait: #TFoo.
	class addTrait: #TBar.
	self assert: class traits equals: { #TFoo. #TBar }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributeAt [

	| foo |
	foo := class addAttribute: #foo.
	self assert: (class memberAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributes [

	| foo |
	foo := class addAttribute: #foo.
	class addMethod: #bar.
	self assert: class attributes equals: { foo }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributesCollect [

	| foo bar baz quuux |
	foo := class addAttribute: #foo.
	bar := class addMethod: #bar.
	baz := class addMethod: #baz.
	quuux := class addAttribute: #quuux.
	self assert: (class attributesCollect: #name) equals: #( foo quuux )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testAttributesDo [

	| foo bar baz quuux |
	foo := class addAttribute: #foo.
	bar := class addMethod: #bar.
	baz := class addMethod: #baz.
	quuux := class addAttribute: #quuux.
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
	foo := class addAttribute: #foo.
	self assert: class currentMember identicalTo: foo.
	bar := class addAttribute: #bar.
	self deny: bar identicalTo: foo.
	self assert: class currentMember identicalTo: bar
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testKeywords [

	self deny: (class keywords includes: #trait).
	class beTrait.
	self assert: (class keywords includes: #trait)
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMemberAt [

	| foo bar |
	foo := class addAttribute: #foo.
	self assert: (class memberAt: #foo) identicalTo: foo.
	bar := class addMethod: #bar.
	self assert: (class memberAt: #bar) identicalTo: bar
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMembers [

	| foo |
	foo := class addMethod: #foo.
	self assert: class members equals: { foo }.
	foo argumentTypes: #(  ).
	self assert: class members equals: { foo }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodAt [

	| foo |
	foo := class addMethod: #foo.
	self assert: (class methodAt: #foo) identicalTo: foo
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethods [

	| foo |
	foo := class addMethod: #foo.
	self assert: class methods equals: { foo }
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodsCollect [

	| foo bar baz quuux |
	foo := class addAttribute: #foo.
	bar := class addMethod: #bar.
	baz := class addMethod: #baz.
	quuux := class addAttribute: #quuux.
	self assert: (class methodsCollect: #name) equals: #( bar baz )
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testMethodsDo [

	| foo bar baz quuux |
	foo := class addAttribute: #foo.
	bar := class addMethod: #bar.
	baz := class addMethod: #baz.
	quuux := class addAttribute: #quuux.
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

{ #category : 'utilities' }
MicroUMLClassNodeTest >> testPrintMicroUML: aString [

	| association generatedSource1 generatedSource2 |
	association := (OpalCompiler new evaluate: aString) currentClass.
	generatedSource1 := association microUMLSource.
	association := (OpalCompiler new evaluate: aString) currentClass.
	generatedSource2 := association microUMLSource.
	self assert: generatedSource2 equals: generatedSource1
]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testPrintMicroUMLOn [

	self
		testPrintMicroUML: 'MicroUMLAstBuilder === #Foo --|> #Bar --@ #TBar - #baz -- #Quuux';
		testPrintMicroUML: 'MicroUMLAstBuilder === #Foo - #bar > #baz <>-- #Quuux';
		testPrintMicroUML: 'MicroUMLAstBuilder === #Foo *-- #Quuux';
		testPrintMicroUML: 'MicroUMLAstBuilder === #Foo --> #Quuux @ ''quuux'''

]

{ #category : 'tests' }
MicroUMLClassNodeTest >> testSuperclass [

	self assert: class superclass isNil.
	class superclass: #Quuuuuuux.
	self assert: class superclass equals: #Quuuuuuux
]
