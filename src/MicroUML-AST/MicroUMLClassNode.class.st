"
I represent an AST node for UML class.
I have name(symbol) and ordered dictionaries of attributes and methods.
I also hold my superclass (symbol).

"
Class {
	#name : 'MicroUMLClassNode',
	#superclass : 'Object',
	#instVars : [
		'name',
		'superclass',
		'attributes',
		'methods',
		'links'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'examples' }
MicroUMLClassNode class >> exampleAbstractSerie [

	^ MicroUMLAstBuilder exampleSerie classAt: #AbstractSerie
]

{ #category : 'examples' }
MicroUMLClassNode class >> exampleComixSerie [

	^ MicroUMLAstBuilder exampleSerie classAt: #ComixSerie
]

{ #category : 'examples' }
MicroUMLClassNode class >> exampleRoassal [

	| canvas node1 node2 inheritance |
	canvas := RSCanvas new.
	canvas
		addShape: (node1 := self exampleAbstractSerie asRSShape);
		addShape:
			(node2 := self exampleComixSerie asRSShape position: 0 @ 200).
	inheritance := RSLine new
		               color: Color black;
		               markerEnd: ((RSPolygon new
	points: {
			(-8 @ 8).
			(0 @ 0).
			(8 @ 8) };
	color: Color white;
	borderColor: Color black;
	borderWidth: 1;
	asMarker) offset: 4);
		               attachPoint: RSBorderAttachPoint new;
		               from: node2;
		               to: node1;
		               yourself.
	canvas
		addNode: node1;
		addNode: node2;
		addEdge: inheritance;
		addShape: inheritance.
	RSTreeLayout on: canvas nodes.
	canvas @ RSCanvasController.
	canvas
		zoomToFit;
		open
]

{ #category : 'adding' }
MicroUMLClassNode >> addAttribute: aSymbol [

	attributes
		at: aSymbol
		put: (self attributeNodeClass new name: aSymbol)
]

{ #category : 'adding' }
MicroUMLClassNode >> addAttributeType: aSymbol [

	attributes values last type: aSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addLink: aMicroUMLLink [

	links add: aMicroUMLLink
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethod: aSymbol [

	methods
		at: aSymbol asSymbol
		put: (self methodNodeClass new name: aSymbol)
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethodArgumentTypes: anArrayOfSymbol [

	methods values last argumentTypes: anArrayOfSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addMethodReturnType: aSymbol [

	methods values last returnType: aSymbol
]

{ #category : 'adding' }
MicroUMLClassNode >> addPrivateAttribute: aSymbol [

	attributes at: aSymbol put: (self attributeNodeClass new
			 name: aSymbol;
			 bePrivate)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPrivateMethod: aSymbol [

	methods at: aSymbol asSymbol put: (self methodNodeClass new
			 name: aSymbol;
			 bePrivate)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPublicAttribute: aSymbol [

	attributes at: aSymbol put: (self attributeNodeClass new
			 name: aSymbol;
			 bePublic)
]

{ #category : 'adding' }
MicroUMLClassNode >> addPublicMethod: aSymbol [

	methods at: aSymbol asSymbol put: (self methodNodeClass new
			 name: aSymbol;
			 bePublic)
]

{ #category : 'converting' }
MicroUMLClassNode >> asRSShape [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 box |
	myLabel := RSLabel text: name model: self.
	attributeShapes := attributes values collect: #asRSShape.
	RSVerticalLineLayout new alignLeft on: attributeShapes.
	attributeShapes := attributeShapes asShape.
	methodShapes := methods values collect: #asRSShape.
	RSVerticalLineLayout new alignLeft on: methodShapes.
	methodShapes := methodShapes asShape.
	RSVerticalLineLayout new alignLeft on: {
			attributeShapes.
			methodShapes }.
	memberShapes := {
		                attributeShapes.
		                methodShapes } asShape.
	RSVerticalLineLayout new alignCenter on: {
			myLabel.
			memberShapes }.
	rect := {
		        myLabel.
		        memberShapes } asShape encompassingRectangle.
	y1 := myLabel encompassingRectangle bottom + 6.
	y2 := y1 + attributeShapes encompassingRectangle height.

	^ {
		  (RSBox new
			   extent: rect extent + (10 @ 6);
			   color: Color white;
			   borderColor: Color black;
			   borderWidth: 1).
		  (RSLine new
			   startPoint: rect extent x / -2 - 5 @ y1;
			   endPoint: rect extent x / 2 + 5 @ y1).
		  (RSLine new
			   startPoint: rect extent x / -2 - 5 @ y2;
			   endPoint: rect extent x / 2 + 5 @ y2).
		  myLabel.
		  memberShapes } asShapeFor: self
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributeAt: aSymbol [

	^ attributes at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> attributeNodeClass [

	^ MicroUMLAttributeNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributes [

	^ attributes
]

{ #category : 'initialization' }
MicroUMLClassNode >> initialize [

	attributes := OrderedDictionary new.
	methods := OrderedDictionary new.
	links := OrderedCollection new
]

{ #category : 'accessing' }
MicroUMLClassNode >> links [

	^ links
]

{ #category : 'accessing' }
MicroUMLClassNode >> methodAt: aSymbol [

	^ methods at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> methodNodeClass [

	^ MicroUMLMethodNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> methods [

	^ methods
]

{ #category : 'accessing' }
MicroUMLClassNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLClassNode >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass [

	^ superclass
]

{ #category : 'accessing' }
MicroUMLClassNode >> superclass: aSymbol [

	superclass := aSymbol
]
