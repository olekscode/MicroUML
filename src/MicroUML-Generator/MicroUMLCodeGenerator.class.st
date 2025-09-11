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
			each superclass ifNil: [ each superclass: #Object ].
			diagram ensureClassNamed: each superclass ]
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
		
	self generateMethodsOfClass: newClass from: umlClassNode
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateClassesInPackageNamed: aPackageName [

	self ensureSuperclasses.

	self classesInOrderOfInheritance do: [ :umlClassNode |
		"Don't generate classes that already exist in the system"
		(self class environment hasClassNamed: umlClassNode name) ifFalse: [ 
			self generateClass: umlClassNode inPackageNamed: aPackageName ] ].
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateMethod: umlMethodNode inClass: aClass [
	
	| sourceCode method |

	sourceCode := String streamContents: [ :stream |
		stream
			<< (self printMethodSignatureFor: umlMethodNode)
			<< String cr
			<< String tab
			<< '"Generated method. Write your implementation here"' ].
		
	method := aClass compiler compile: sourceCode.
	
	aClass
		addSelector: umlMethodNode name asSymbol
		withMethod: method
		
	
]

{ #category : 'as yet unclassified' }
MicroUMLCodeGenerator >> generateMethodsOfClass: aClass from: umlClassNode [

	| instanceSideMethods classSideMethods |
	
	instanceSideMethods := umlClassNode methods reject: [ :each | each isClassSide ].
	classSideMethods := umlClassNode methods select: [ :each | each isClassSide ].
	
	instanceSideMethods do: [ :method | self generateMethod: method inClass: aClass ].
	classSideMethods do: [ :method | self generateMethod: method inClass: aClass class ]
]

{ #category : 'printing' }
MicroUMLCodeGenerator >> printMethodSignatureFor: umlMethodNode [
	"Prints method's signature (selector with arguments) in Pharo"
	
	| selector argumentNames selectorParts |
	
	selector := umlMethodNode name.
	umlMethodNode argumentTypes ifNil: [ ^ selector ].
	umlMethodNode argumentTypes ifEmpty: [ ^ selector ].
	
	"If it's lowercase then it's probably an argument name. If it's uppercase, then it's probably a type and the argument should be called aString or anInteger"
	argumentNames := umlMethodNode argumentTypes collect: [ :each |
		each first isUppercase
			ifTrue: [ (each first isVowel ifTrue: [ 'an' ] ifFalse: [ 'a' ]), each ]
			ifFalse: [ each ] ].
		
	"Binary selector with 1 argument"
	((argumentNames size = 1) and: [ selector allSatisfy: [ :char | char isSpecial ] ])
		ifTrue: [ ^ selector, ' ', argumentNames first ].
		
	selectorParts := (selector splitOn: $:) reject: #isEmpty.
	
	(selectorParts size = argumentNames size) ifFalse: [ 
		self error: 'Invalid selector for this number of arguments' ].
	
	^ String streamContents: [ :stream |
		selectorParts with: argumentNames do: [ :selectorPart :arg |
			stream << selectorPart << ': ' << arg << ' ' ] ]
]
