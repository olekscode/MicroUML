Class {
	#name : 'MicroUMLAssociationNodeTest',
	#superclass : 'TestCase',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testAddLabel [

	| association |
	association := MicroUMLAssociationNode new.
	association addLabel: 'foo'.
	self assert: association label equals: 'foo'.
	association addLabel: nil -> 'bar'.
	self assert: association leftLabel isNil.
	self assert: association rightLabel equals: 'bar'.
	association addLabel: 'bar' -> 'baz'.
	self assert: association leftLabel equals: 'bar'.
	self assert: association rightLabel equals: 'baz'.
	association addLabel: 'quuux' -> nil.
	self assert: association leftLabel equals: 'quuux'.
	self assert: association rightLabel isNil
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testAssociationClass [

	| association |
	association := MicroUMLAssociationNode new.
	association associationClass: #Foo.
	self assert: association associationClass equals: #Foo
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeAggregation [

	| association |
	association := MicroUMLAssociationNode new.
	association rightHead: #wedge.
	association beAggregation.
	self assert: association leftHead equals: #aggregation.
	self assert: association rightHead equals: #wedge
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeComposition [

	| association |
	association := MicroUMLAssociationNode new.
	association rightHead: #wedge.
	association beComposition.
	self assert: association leftHead equals: #composition.
	self assert: association rightHead equals: #wedge
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeDashed [

	| association |
	association := MicroUMLAssociationNode new.
	association beComposition.
	association beDashed.
	self assert: association line equals: #dashed.
	self assert: association leftHead equals: #composition
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeDependency [

	| association |
	association := MicroUMLAssociationNode new.
	association beAggregation.
	self assert: association notNil.
	association beDependency.
	self assert: association leftHead isNil.
	self assert: association rightHead equals: #wedge.
	self assert: association line equals: #dashed
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeDirected [

	| association |
	association := MicroUMLAssociationNode new.
	association
		beComposition;
		beDashed.
	self assert: association line equals: #dashed.
	self assert: association leftHead equals: #composition.
	association beDirected.
	self assert: association line equals: #dashed.
	self assert: association leftHead equals: #composition.
	self assert: association rightHead equals: #wedge
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testBeSolid [

	| association |
	association := MicroUMLAssociationNode new.
	association beDependency.
	self assert: association line equals: #dashed.
	self assert: association leftHead isNil.
	self assert: association rightHead equals: #wedge.
	association beSolid.
	self assert: association line equals: #solid.
	self assert: association leftHead isNil.
	self assert: association rightHead equals: #wedge
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testDependency [

	| association |
	association := MicroUMLAssociationNode new.
	association beComposition.
	self assert: association leftHead equals: #composition.
	association beDependency.
	self assert: association line equals: #dashed.
	self assert: association leftHead isNil.
	self assert: association rightHead equals: #wedge
]

{ #category : 'utilities' }
MicroUMLAssociationNodeTest >> testPrintMicroUML: aString [

	| association generatedSource1 generatedSource2 |
	association := (OpalCompiler new evaluate: aString) associations
		               first.
	generatedSource1 := association microUMLSource.
	association := (OpalCompiler new evaluate: aString) associations
		               first.
	generatedSource2 := association microUMLSource.
	self assert: generatedSource2 equals: generatedSource1
]

{ #category : 'tests' }
MicroUMLAssociationNodeTest >> testPrintMicroUMLOn [

	self
		testPrintMicroUML:
			'MicroUMLAstBuilder === #Foo -- #Bar @ (''left'' -> ''right'') @ ''baz'' %< ''1'' %> ''*'' @= #Quuux';
		testPrintMicroUML:
			'MicroUMLAstBuilder === #Foo => #Bar @ (''left'' -> ''right'') @ ''baz'' %< ''1'' %> ''*'' @= #Quuux';
		testPrintMicroUML:
			'MicroUMLAstBuilder === #Foo <>-- #Bar @ (''left'' -> ''right'') @ ''baz'' %< ''1'' %> ''*'' @= #Quuux';
		testPrintMicroUML:
			'MicroUMLAstBuilder === #Foo *=> #Bar @ (''left'' -> ''right'') @ ''baz'' %< ''1'' %> ''*'' @= #Quuux'
]
