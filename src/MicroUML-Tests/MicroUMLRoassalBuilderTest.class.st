Class {
	#name : 'MicroUMLRoassalBuilderTest',
	#superclass : 'TestCase',
	#instVars : [
		'builder'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLRoassalBuilderTest >> setUp [

	super setUp.
	builder := MicroUMLRoassalBuilder new
]

{ #category : 'tests' }
MicroUMLRoassalBuilderTest >> testEmpty [

	| uml canvas |
	uml := MicroUMLAstBuilder new.
	
	canvas := MicroUMLRoassalBuilder new 
		classDiagramNode: uml diagram;
		build.
		
	self assert: canvas shapes isEmpty
]

{ #category : 'tests' }
MicroUMLRoassalBuilderTest >> testOneClass [

	| uml canvas shapes |
	uml := MicroUMLAstBuilder === #Object.

	canvas := MicroUMLRoassalBuilder new
		          classDiagramNode: uml diagram;
		          build.

	self assert: canvas shapes size equals: 1.

	shapes := canvas shapes select: [ :shape |
		          shape model isMicroUMLClassNode ].

	self assert: shapes size equals: 1.
	self assert: shapes anyOne model name equals: #Object
]

{ #category : 'tests' }
MicroUMLRoassalBuilderTest >> testTwoClassesInheritance [

	| uml canvas classShapes associationShapes |
	uml := MicroUMLAstBuilder === #Object === #Integer --|> #Object.
	canvas := MicroUMLRoassalBuilder new
		          classDiagramNode: uml diagram;
		          build.
	classShapes := canvas shapes select: [ :shape |
		               shape model isMicroUMLClassNode ].
	associationShapes := canvas shapes select: [ :shape |
		                     shape model isMicroUMLAssociationNode ].
	self assert: classShapes size equals: 2.
	self assert:
		(classShapes anySatisfy: [ :shape | shape model name = #Object ]).
	self assert:
		(classShapes anySatisfy: [ :shape | shape model name = #Integer ]).
	self assert: associationShapes isEmpty
]

{ #category : 'tests' }
MicroUMLRoassalBuilderTest >> testTwoClassesInheritanceAndAggregation [

	| uml canvas classShapes associationShapes |
	uml := MicroUMLAstBuilder === #Object === #Collection --|> #Object
	       <>-- #Object.
	canvas := MicroUMLRoassalBuilder new
		          classDiagramNode: uml diagram;
		          build.
	classShapes := canvas shapes select: [ :shape |
		               shape model isMicroUMLClassNode ].
	associationShapes := canvas shapes select: [ :shape |
		                     shape model isMicroUMLAssociationNode ].
	self assert: classShapes size equals: 2.
	self assert:
		(classShapes anySatisfy: [ :shape | shape model name = #Object ]).
	self assert:
		(classShapes anySatisfy: [ :shape | shape model name = #Collection ]).
	self assert: associationShapes size equals: 1.
	self assert: associationShapes anyOne model isAggregation.
	self
		assert: associationShapes anyOne model leftClass
		equals: #Collection.
	self
		assert: associationShapes anyOne model rightClass
		equals: #Object
]
