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

	| uml canvas shape node |
	uml := MicroUMLAstBuilder === #Object.
	
	canvas := MicroUMLRoassalBuilder new 
		classDiagramNode: uml diagram;
		build.
		
	self assert: canvas shapes size equals: 1.
		
	shape := canvas shapes first.
	node := shape model.
	
	self assert: node class equals: MicroUMLClassNode.
	self assert: node name equals: #Object
	
]

{ #category : 'tests' }
MicroUMLRoassalBuilderTest >> testTwoClassesInheritance [

	| uml canvas classShapes arrowShape |
	
	uml := MicroUMLAstBuilder
		=== #Object
		=== #Integer --|> #Object.
	
	canvas := MicroUMLRoassalBuilder new 
		classDiagramNode: uml diagram;
		build.
		
	self assert: canvas shapes size equals: 3.
		
	classShapes := canvas shapes select: [ :each | each class = RSComposite ].
	arrowShape := canvas shapes detect: [ :each | each class  = RSBezier ].
	
	self assert: classShapes size equals: 2.
	self assert: (classShapes includes: arrowShape from).
	self assert: (classShapes includes: arrowShape to).
	
	"TODO: from and to have to be reversed"
	self assert: arrowShape to model name equals: #Integer.
	self assert: arrowShape from model name equals: #Object
	
]
