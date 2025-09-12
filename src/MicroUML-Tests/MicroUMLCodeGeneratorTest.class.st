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

{ #category : 'utilities' }
MicroUMLCodeGeneratorTest >> doesClassExist: aClassName [

	^ self class environment hasClassNamed: aClassName 
]

{ #category : 'utilities' }
MicroUMLCodeGeneratorTest >> doesPackageExist: aPackageName [

	^ self packageOrganizer hasPackage: aPackageName 
]

{ #category : 'utilities' }
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

{ #category : 'tests' }
MicroUMLCodeGeneratorTest >> testIsReadyToGenerateClass [

	| animal cat |
	animal := uml classAt: #Animal__.
	cat := uml classAt: #Cat__.
	self assert: (generator isReadyToGenerateClass: animal).
	animal superclass: #Object.
	self assert: (generator isReadyToGenerateClass: animal).
	self deny: (generator isReadyToGenerateClass: cat).
	cat superclass: nil.
	self assert: (generator isReadyToGenerateClass: cat)
]
