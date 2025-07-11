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
		'members',
		'attributes',
		'methods',
		'isAbstract',
		'modifiers'
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
MicroUMLClassNode >> addMember: aSymbolOrNil [

	^ members
		  at: aSymbolOrNil
		  put: (self memberNodeClass new name: aSymbolOrNil)
]

{ #category : 'converting' }
MicroUMLClassNode >> asRSShape [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 box |
	myLabel := RSLabel text: name model: self.
	attributeShapes := self attributesCollect: #asRSShape.
	RSVerticalLineLayout new alignLeft on: attributeShapes.
	attributeShapes := attributeShapes asShape.
	methodShapes := self methodsCollect: #asRSShape.
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

	^ (self memberAt: aSymbol) ifNotNil: [ :member |
			  member isAttribute
				  ifTrue: [ member ]
				  ifFalse: [ nil ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> attributes [

	^ self members select: #isAttribute
]

{ #category : 'enumerating' }
MicroUMLClassNode >> attributesCollect: aBlock [

	^ members values select: #isAttribute thenCollect: aBlock
]

{ #category : 'enumerating' }
MicroUMLClassNode >> attributesDo: aBlock [

	self membersDo: [ :member |
		member isAttribute ifTrue: [ aBlock value: member ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> beAbstract [

	isAbstract := true
]

{ #category : 'accessing' }
MicroUMLClassNode >> beConcrete [

	isAbstract := false
]

{ #category : 'accessing' }
MicroUMLClassNode >> currentMember [

	^ members values last
]

{ #category : 'adding' }
MicroUMLClassNode >> currentMemberName: aSymbol [

	| member |
	member := self currentMember.
	members removeKey: member name.
	member name: aSymbol.
	members at: member name put: member
]

{ #category : 'initialization' }
MicroUMLClassNode >> initialize [

	members := OrderedDictionary new.
	isAbstract := false
]

{ #category : 'testing' }
MicroUMLClassNode >> isAbstract [

	^ isAbstract = true
]

{ #category : 'testing' }
MicroUMLClassNode >> isConcrete [

	^ self isAbstract not
]

{ #category : 'accessing' }
MicroUMLClassNode >> memberAt: aSymbol [

	^ members at: aSymbol ifAbsent: [ ]
]

{ #category : 'class access' }
MicroUMLClassNode >> memberNodeClass [

	^ MicroUMLMemberNode
]

{ #category : 'accessing' }
MicroUMLClassNode >> members [

	^ members values
]

{ #category : 'enumerating' }
MicroUMLClassNode >> membersCollect: aBlock [

	^ members values collect: aBlock
]

{ #category : 'enumerating' }
MicroUMLClassNode >> membersDo: aBlock [

	members valuesDo: aBlock
]

{ #category : 'accessing' }
MicroUMLClassNode >> methodAt: aSymbol [

	^ (self memberAt: aSymbol) ifNotNil: [ :member |
			  member isMethod
				  ifTrue: [ member ]
				  ifFalse: [ nil ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> methods [

	^ self members select: #isMethod
]

{ #category : 'enumerating' }
MicroUMLClassNode >> methodsCollect: aBlock [

	^ members values select: #isMethod thenCollect: aBlock
]

{ #category : 'enumerating' }
MicroUMLClassNode >> methodsDo: aBlock [

	self membersDo: [ :member |
		member isMethod ifTrue: [ aBlock value: member ] ]
]

{ #category : 'accessing' }
MicroUMLClassNode >> modifiers [

	^ modifiers
]

{ #category : 'accessing' }
MicroUMLClassNode >> modifiers: anArrayOfSymbol [

	modifiers := anArrayOfSymbol.
	(modifiers includes: #abstract) ifTrue: [ self beAbstract ]
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
