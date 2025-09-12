Class {
	#name : 'MicroUMLCodeGenerationInconsistency',
	#superclass : 'Error',
	#instVars : [
		'umlClass',
		'pharoClass'
	],
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'signalling' }
MicroUMLCodeGenerationInconsistency class >> signalUmlClass: aMicroUMLClassNode pharoClass: aClass [

	^ self new
		  umlClass: aMicroUMLClassNode;
		  pharoClass: aClass;
		  signal
]

{ #category : 'accessing' }
MicroUMLCodeGenerationInconsistency >> messageText [
	"Return an exception's message text."

	^ messageText ifNil: [
			  (umlClass notNil and: [ pharoClass notNil ])
				  ifTrue: [
						  umlClass name , ' is a ' , (umlClass isTrait
							   ifTrue: [ 'trait' ]
							   ifFalse: [ 'class' ])
						  , ', while the existing global in Pharo is a '
						  , (pharoClass isTrait
								   ifTrue: [ 'trait' ]
								   ifFalse: [ 'class' ]) , '.' ]
				  ifFalse: [ '' ] ]
]

{ #category : 'accessing' }
MicroUMLCodeGenerationInconsistency >> pharoClass [

	^ pharoClass
]

{ #category : 'accessing' }
MicroUMLCodeGenerationInconsistency >> pharoClass: aClass [

	pharoClass := aClass
]

{ #category : 'accessing' }
MicroUMLCodeGenerationInconsistency >> umlClass [

	^ umlClass
]

{ #category : 'accessing' }
MicroUMLCodeGenerationInconsistency >> umlClass: aMicroUMLClassNode [

	umlClass := aMicroUMLClassNode
]
