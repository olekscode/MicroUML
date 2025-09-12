Class {
	#name : 'MicroUMLCodeGenerator',
	#superclass : 'Object',
	#instVars : [
		'diagram'
	],
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'instance creation' }
MicroUMLCodeGenerator class >> forDiagram: aDiagram [

	^ self new
		diagram: aDiagram;
		yourself
]

{ #category : 'testing' }
MicroUMLCodeGenerator >> checkConsistencyWithExistingClassesAndTraits [

	diagram classesDo: [ :classNode |
			(self checkConsistencyWithExistingClassesAndTraits: classNode)
				ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'testing' }
MicroUMLCodeGenerator >> checkConsistencyWithExistingClassesAndTraits: aMicroUMLClassNode [

	Smalltalk globals
		at: aMicroUMLClassNode name
		ifPresent: [ :pharoGlobal |
				(aMicroUMLClassNode isTrait not xor: [ pharoGlobal isTrait ])
					ifFalse: [
							^ MicroUMLCodeGenerationInconsistency
								  signalUmlClass: aMicroUMLClassNode
								  pharoClass: pharoGlobal ] ].
	^ true
]

{ #category : 'accessing' }
MicroUMLCodeGenerator >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLCodeGenerator >> diagram: aMicroUmlDiagram [

	diagram := aMicroUmlDiagram 
]

{ #category : 'private' }
MicroUMLCodeGenerator >> ensureClass: aSymbol inPackageNamed: aPackageName [

	^ aSymbol
		  ifNotNil: [
				  Smalltalk globals
					  at: aSymbol asSymbol
					  ifAbsent: [
					  (Object << aSymbol asSymbol package: aPackageName) install ] ]
		  ifNil: [ Object ]
]

{ #category : 'private' }
MicroUMLCodeGenerator >> ensureTrait: aSymbol inPackageNamed: aPackageName [

	^ aSymbol
		  ifNotNil: [
				  Smalltalk globals
					  at: aSymbol asSymbol
					  ifAbsent: [
					  (Trait << aSymbol asSymbol package: aPackageName) install ] ]
		  ifNil: [ Trait ]
]

{ #category : 'generating' }
MicroUMLCodeGenerator >> generateClass: umlClassNode inPackageNamed: aPackageName [

	| superclass traits newClass instanceVariableNames classSideVariables |
	superclass := umlClassNode isTrait
		              ifTrue: [
			              self
				              ensureTrait: umlClassNode superclass
				              inPackageNamed: aPackageName ]
		              ifFalse: [
			              self
				              ensureClass: umlClassNode superclass
				              inPackageNamed: aPackageName ].

	traits := umlClassNode traits collect: [ :name |
		          self ensureTrait: name inPackageNamed: aPackageName ].

	instanceVariableNames := umlClassNode attributes
		                         reject: [ :each | each isClassSide ]
		                         thenCollect: [ :each | each name ].

	classSideVariables := umlClassNode attributes
		                      select: [ :each | each isClassSide ]
		                      thenCollect: [ :each | each name ].

	newClass := ((superclass << umlClassNode name asSymbol)
		             traits: traits;
		             slots: instanceVariableNames;
		             classSlots: classSideVariables;
		             package: aPackageName) install.

	self generateMethodsOfClass: newClass from: umlClassNode
]

{ #category : 'generating' }
MicroUMLCodeGenerator >> generateClassesInPackageNamed: aPackageName [

	| agenda |
	self checkConsistencyWithExistingClassesAndTraits.
	agenda := OrderedCollection withAll: diagram classes.
	[ agenda notEmpty ] whileTrue: [
			| classNode |
			classNode := agenda
				             detect: [ :node | self isReadyToGenerateClass: node ]
				             ifNone: [ ^ self error: 'Cyclic inheritance?' ].
			agenda remove: classNode.
			self generateClass: classNode inPackageNamed: aPackageName ]
]

{ #category : 'generating' }
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

{ #category : 'generating' }
MicroUMLCodeGenerator >> generateMethodsOfClass: aClass from: umlClassNode [

	| instanceSideMethods classSideMethods |
	
	instanceSideMethods := umlClassNode methods reject: [ :each | each isClassSide ].
	classSideMethods := umlClassNode methods select: [ :each | each isClassSide ].
	
	instanceSideMethods do: [ :method | self generateMethod: method inClass: aClass ].
	classSideMethods do: [ :method | self generateMethod: method inClass: aClass class ]
]

{ #category : 'testing' }
MicroUMLCodeGenerator >> isReadyToGenerateClass: aMicroUMLClassNode [

	(self checkConsistencyWithExistingClassesAndTraits:
		 aMicroUMLClassNode) ifFalse: [ ^ false ].
	aMicroUMLClassNode superclass ifNotNil: [ :superclassName |
			Smalltalk globals
				at: superclassName
				ifPresent: [ :superclass |
						(aMicroUMLClassNode isTrait not xor: [
							 superclass = Trait or: [ superclass isTrait ] ]) ifFalse: [
							^ false ] ]
				ifAbsent: [ ^ (diagram hasClassNamed: superclassName) not ] ].
	aMicroUMLClassNode traitsDo: [ :traitName |
			Smalltalk globals
				at: traitName
				ifPresent: [ :trait | trait isTrait ifFalse: [ ^ false ] ]
				ifAbsent: [ ^ (diagram hasClassNamed: traitName) not ] ].
	^ true
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
