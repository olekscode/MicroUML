Class {
	#name : 'MicroUMLAssociationNodeTest',
	#superclass : 'TestCase',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testPrintMicroUMLInLeftClassOn [

	| association |
	association := (MicroUMLAstBuilder new === #Foo --- #Bar)
		               associations first.
	self
		assert: (String streamContents: [ :stream |
				 association printMicroUMLInLeftClassOn: stream ])
		equals: '--- #Bar'.
	association := (MicroUMLAstBuilder new === #Foo <>< 'bar' >---< 'baz'
	                ><*> #Quuux) associations first.
	self
		assert: (String streamContents: [ :stream |
				 association printMicroUMLInLeftClassOn: stream ])
		equals: '<><''bar''>---<''baz''><*> #Quuux'
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testPrintMicroUMLOn [

	| association |
	association := (MicroUMLAstBuilder new === #Foo --- #Bar)
		               associations first.
	self
		assert: (String streamContents: [ :stream |
				 association printMicroUMLOn: stream ])
		equals: '#Foo --- #Bar'.
	association := (MicroUMLAstBuilder new === #Foo <>< 'bar' >---< 'baz'
	                ><*> #Quuux) associations first.
	self
		assert: (String streamContents: [ :stream |
				 association printMicroUMLOn: stream ])
		equals: '#Foo <><''bar''>---<''baz''><*> #Quuux'
]
