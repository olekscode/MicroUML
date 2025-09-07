Class {
	#name : 'MicroUMLCodeGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [
		'generator',
		'packageName',
		'uml'
	],
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'as yet unclassified' }
MicroUMLCodeGeneratorTest >> doesClassExist: aClassName [

	^ self class environment hasClassNamed: aClassName 
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGeneratorTest >> doesPackageExist: aPackageName [

	^ self packageOrganizer hasPackage: aPackageName 
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGeneratorTest >> exampleUML [
	<script: 'self new exampleUML inspect'>
	
	"We add __ to decrease the chance that classes with those names already exists"
	^ #Cat__ --|> #Animal__
	===
	#Dog__ --|> #Animal__
	===
	#Animal__ --|> #Object__
		- #name @ String 
		- #age @ Number
		|- #randomNumbersGenerator  
	===
	#GermanShepherd__ --|> #Dog__
]

{ #category : 'running' }
MicroUMLCodeGeneratorTest >> setUp [

	super setUp.
	
	uml := self exampleUML.
	generator := MicroUMLCodeGenerator forDiagram: uml diagram.
	
	"We add __ to decrease the chance that a package with this names already exists"
	packageName := '__MicroUML__Dummy-Package__'
]

{ #category : 'running' }
MicroUMLCodeGeneratorTest >> tearDown [

	(self packageOrganizer hasPackage: packageName) ifTrue: [ 
		self packageOrganizer removePackage: packageName ].
	
	super tearDown
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testClassesInOrderOfInheritance [

	| expectedClassNames actualClassNames |
	
	expectedClassNames := #(Animal__ Cat__ Dog__ GermanShepherd__) asOrderedCollection.
	actualClassNames := generator classesInOrderOfInheritance collect: [ :each | each name ].

	self assert: actualClassNames equals: expectedClassNames
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testEnsureSuperclasses [

	self deny: (generator diagram hasClassNamed: #Object__).
	generator ensureSuperclasses.
	self assert: (generator diagram hasClassNamed: #Object__)
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testGenerateClassInPackageNamed [

	| umlClass |
	
	umlClass := uml classAt: #Cat__.
	generator generateClass: umlClass inPackageNamed: packageName.
	
	self assert: (self doesPackageExist: packageName).
	self assert: (self doesClassExist: umlClass name)
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testGenerateClassSideVariables [

	| animalClass |
	generator generateClassesInPackageNamed: packageName.
	
	animalClass := self class environment classNamed: #Animal__.
	
	self assert: animalClass class slotNames equals: #(randomNumbersGenerator).
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testGenerateClassesInPackageNamed [

	generator generateClassesInPackageNamed: packageName.
	self assert: (self doesPackageExist: packageName).
	
	#(#Object__ #Animal__ #Cat__ #Dog__ #GermanShepherd__) do: [ :name |
		self assert: (self doesClassExist: name) ]
]

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testGenerateInstanceVariables [

	| animalClass |
	generator generateClassesInPackageNamed: packageName.
	
	animalClass := self class environment classNamed: #Animal__.
	
	self assert: animalClass slotNames equals: #(name age).
]
