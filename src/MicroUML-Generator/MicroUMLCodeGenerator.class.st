Class {
	#name : 'MicroUMLCodeGenerator',
	#superclass : 'Object',
	#instVars : [
		'diagram'
	],
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> classesInOrderOfInheritance [
	"Superclasses should appear before their subclasses"
	
	| classes orderedClasses classesToAdd |
	
	classes := OrderedCollection withAll: diagram classes.
	orderedClasses := OrderedCollection new.
	self halt.
	
	[ classes isEmpty ] whileFalse: [
		classesToAdd := classes reject: [ :each | classes includes: each superclass ].
		orderedClasses addAll: classesToAdd.
		classes removeAll: classesToAdd ].
	
	^ orderedClasses
	
	
]

{ #category : 'accessing' }
MicroUMLCodeGenerator >> diagram: aMicroUmlDiagram [

	diagram := aMicroUmlDiagram 
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateClassesInPackageNamed: aPackageName [

	diagram classes do: [ :umlClassNode |
		self generateClass: umlClassNode inPackageNamed: aPackageName ]
]
