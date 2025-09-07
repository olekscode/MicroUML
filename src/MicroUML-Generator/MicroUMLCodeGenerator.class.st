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
MicroUMLCodeGenerator class >> forDiagram: aDiagram [

	^ self new
		diagram: aDiagram;
		yourself
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> classesInOrderOfInheritance [
	"Superclasses should appear before their subclasses"
	
	| classes orderedClasses classesToAdd |
	
	classes := OrderedCollection withAll: diagram classes.
	orderedClasses := OrderedCollection new.
	
	[ classes isEmpty ] whileFalse: [
		classesToAdd := classes reject: [ :each |
			classes anySatisfy: [ :aClass | each superclass = aClass name ] ].
		
		orderedClasses addAll: classesToAdd.
		classes removeAll: classesToAdd ].
	
	^ orderedClasses
	
	
]

{ #category : 'accessing' }
MicroUMLCodeGenerator >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLCodeGenerator >> diagram: aMicroUmlDiagram [

	diagram := aMicroUmlDiagram 
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> ensureSuperclasses [
	"A diagram like this: #Cat --|> #Animal is valid even if Animal class is not defined. But to generate a Cat class, the Animal must be generated as well.
	
	This method checks all superclasses and if they don't exist neither in the environment (Pharo image) nor in the UML definition, it adds them to the UML as subclasses of Object.
	
	It also replacess all nil superclasses with Object"
		
	diagram classes do: [ :each |
		diagram ensureClassNamed: each superclass ].
	
	diagram classes do: [ :each |
		each superclass ifNil: [ each superclass: Object ] ].
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateClass: umlClassNode inPackageNamed: aPackageName [

	| superclass newClass instanceVariableNames classSideVariables |
	
	superclass := umlClassNode superclass.
	
	superclass isString ifTrue: [
		superclass := self class environment classNamed: superclass ]. 
	
	instanceVariableNames := umlClassNode attributes
		reject: [ :each | each isClassSide ]
		thenCollect: [ :each | each name ].
		
	classSideVariables := umlClassNode attributes
		select: [ :each | each isClassSide ]
		thenCollect: [ :each | each name ].
	
	newClass := (superclass << umlClassNode name asSymbol
		slots: instanceVariableNames;
		classSlots: classSideVariables;
		package: aPackageName) install.
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateClassesInPackageNamed: aPackageName [

	self ensureSuperclasses.

	self classesInOrderOfInheritance do: [ :umlClassNode |
		"Don't generate classes that already exist in the system"
		(self class environment hasClassNamed: umlClassNode name) ifFalse: [ 
			self generateClass: umlClassNode inPackageNamed: aPackageName ] ].
]
