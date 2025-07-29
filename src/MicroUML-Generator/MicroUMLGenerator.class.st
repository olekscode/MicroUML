Class {
	#name : 'MicroUMLGenerator',
	#superclass : 'Object',
	#instVars : [
		'diagram'
	],
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'examples' }
MicroUMLGenerator class >> example [

	(MicroUMLRoassalBuilder new classDiagramNode: (self new
				  generateClass: self;
				  ensureClassNamed: self superclass name;
				  diagram)) build
		zoomToFit;
		@ RSCanvasController;
		openWithTitle: self name
]

{ #category : 'class access' }
MicroUMLGenerator >> associationNodeClass [

	^ MicroUMLAssociationNode
]

{ #category : 'class access' }
MicroUMLGenerator >> classDiagramClass [

	^ MicroUMLClassDiagramNode
]

{ #category : 'class access' }
MicroUMLGenerator >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLGenerator >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLGenerator >> ensureClassNamed: aSymbol [

	^ diagram ensureClassNamed: aSymbol
]

{ #category : 'generating' }
MicroUMLGenerator >> generateAttribute: aSymbol in: aClass [

	| attributeNode |
	attributeNode := (diagram ensureClassNamed:
		                  aClass instanceSide name asSymbol) addAttribute:
		                 aSymbol asSymbol.
	aClass
		compiledMethodAt: (aSymbol , ':') asSymbol
		ifPresent: [ :compiledMethod |
				| parameter |
				parameter := compiledMethod ast arguments first name asString.
				attributeNode type: (self guessParameterType: parameter) asSymbol ].
	aClass isMeta
		ifTrue: [ attributeNode beClassSide ]
		ifFalse: [ attributeNode beInstanceSide ].
	^ attributeNode
]

{ #category : 'generating' }
MicroUMLGenerator >> generateClass: aClass [

	| classNode |
	classNode := diagram ensureClassNamed: aClass name asSymbol.
	aClass superclass ifNotNil: [ :s |
		classNode superclass: s name asSymbol ].
	aClass instVarNames do: [ :var |
		self generateAttribute: var asSymbol in: aClass ].
	aClass isMeta ifFalse: [
			aClass class instVarNames do: [ :var |
				self generateAttribute: var asSymbol in: aClass class ] ].
	aClass selectors do: [ :selector |
		self generateMethod: selector asSymbol in: aClass ].
	aClass isMeta ifFalse: [
			aClass class selectors do: [ :selector |
				self generateMethod: selector asSymbol in: aClass class ] ].
	^ classNode
]

{ #category : 'generating' }
MicroUMLGenerator >> generateMethod: aSymbol in: aClass [

	| methodNode |
	methodNode := (diagram ensureClassNamed:
		               aClass instanceSide name asSymbol) addMethod:
		              aSymbol asSymbol.
	aClass
		compiledMethodAt: aSymbol asSymbol
		ifPresent: [ :compiledMethod |
				methodNode argumentTypes:
					(compiledMethod ast arguments collect: [ :arg |
						 self guessParameterType: arg name ]) asArray.
				compiledMethod isAbstract
					ifTrue: [ methodNode beAbstract ]
					ifFalse: [ methodNode beConcrete ] ].
	aClass isMeta
		ifTrue: [ methodNode beClassSide ]
		ifFalse: [ methodNode beInstanceSide ].
	^ methodNode
]

{ #category : 'private' }
MicroUMLGenerator >> guessParameterType: aString [

	(aString size > 2 and: [
		 (aString beginsWith: 'an') and: [ (aString at: 3) isUppercase ] ])
		ifTrue: [ ^ (aString allButFirst: 2) asSymbol ].
	(aString size > 1 and: [
		 (aString beginsWith: 'a') and: [ (aString at: 2) isUppercase ] ])
		ifTrue: [ ^ aString allButFirst asSymbol ].
	^ aString asSymbol
]

{ #category : 'initialization' }
MicroUMLGenerator >> initialize [

	super initialize.
	diagram := self classDiagramClass new
]

{ #category : 'class access' }
MicroUMLGenerator >> memberNodeClass [

	^ MicroUMLMemberNode
]
