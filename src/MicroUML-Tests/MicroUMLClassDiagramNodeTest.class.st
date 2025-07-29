Class {
	#name : 'MicroUMLClassDiagramNodeTest',
	#superclass : 'TestCase',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'tests' }
MicroUMLClassDiagramNodeTest >> testPrintMicroUMLWithAssociationsOutsideClassesOn [
	| diagram |
	diagram := (MicroUMLAstBuilder 
===
#Foo --|> #Bar
	<>--- #Baz
	<*>--- #Quuux
===
#Baz <*>--- #Quuux) diagram.
	self assert: (String streamContents: [:stream | diagram printMicroUMLWithAssociationsOutsideClassesOn: stream]) equals: 'MicroUMLAstBuilder
===
#Foo --|> #Bar
===
#Foo <>--- #Baz
===
#Foo <*>--- #Quuux
===
#Baz <*>--- #Quuux'
]

{ #category : 'tests' }
MicroUMLClassDiagramNodeTest >> testPrintMicroUMLWithAssociationsUnderClassesOn [
	| diagram |
	diagram := (MicroUMLAstBuilder 
===
#Foo --|> #Bar
	<>--- #Baz
	<*>--- #Quuux
===
#Baz <*>--- #Quuux) diagram.
	self assert: (String streamContents: [:stream | diagram printMicroUMLWithAssociationsUnderClassesOn: stream]) equals: 'MicroUMLAstBuilder
===
#Foo --|> #Bar
  <>--- #Baz
  <*>--- #Quuux
===
#Baz <*>--- #Quuux'
]
