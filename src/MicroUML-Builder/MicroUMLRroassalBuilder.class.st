"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRroassalBuilder',
	#superclass : 'Object',
	#instVars : [
		'aMicroUMLClassNode'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLRroassalBuilder class >> exampleSerie [

	| canvas |
	canvas := self new canvasFrom: MicroUMLAstBuilder exampleSerie.
	canvas @ RSCanvasController.
	canvas
		zoomToFit;
		open
]

{ #category : 'building' }
MicroUMLRroassalBuilder >> canvasFrom: aMicroUMLAstBuilder [

	| canvas nodes |
	canvas := RSCanvas new.
	nodes := Dictionary new.
	aMicroUMLAstBuilder classesDo: [ :classAst |
			| node |
			node := self newClassBoxFor: classAst.
			canvas add: node.
			nodes at: classAst name put: node ].
	aMicroUMLAstBuilder classesDo: [ :classAst |
			classAst superclass ifNotNil: [ :superclassName |
					| link |
					link := self
						        newInheritanceLinkBetween: (nodes at: classAst name)
						        andSuperclass: (nodes at: superclassName).
					canvas add: link ] ].
	RSTreeLayout on: nodes values asArray.
	^ canvas
]

{ #category : 'instance creation' }
MicroUMLRroassalBuilder >> newAttributeLabelFor: aMicroUMLAttrtibuteNode [

	^ RSLabel
		  text: (String streamContents: [ :stream |
					   aMicroUMLAttrtibuteNode isPublic ifTrue: [ stream nextPut: $+ ].
					   aMicroUMLAttrtibuteNode isPrivate ifTrue: [
						   stream nextPut: $- ].
					   stream nextPutAll: aMicroUMLAttrtibuteNode name.
					   aMicroUMLAttrtibuteNode type ifNotNil: [
							   stream
								   nextPut: $:;
								   nextPutAll: aMicroUMLAttrtibuteNode type ] ])
		  model: aMicroUMLAttrtibuteNode
]

{ #category : 'instance creation' }
MicroUMLRroassalBuilder >> newClassBoxFor: aMicroUMLClassNode [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 |
	myLabel := RSLabel
		           text: aMicroUMLClassNode name
		           model: aMicroUMLClassNode.
	attributeShapes := aMicroUMLClassNode attributes values collect:
		                   #asRSShape.
	RSVerticalLineLayout new alignLeft on: attributeShapes.
	attributeShapes := attributeShapes asShape.
	methodShapes := aMicroUMLClassNode methods values collect: #asRSShape.
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
		  memberShapes } asShapeFor: aMicroUMLClassNode
]

{ #category : 'instance creation' }
MicroUMLRroassalBuilder >> newInheritanceLinkBetween: aMicroUMLClassBox andSuperclass: anotherMicroUMLClassBox [

	^ RSLine new
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
		  from: aMicroUMLClassBox;
		  to: anotherMicroUMLClassBox;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRroassalBuilder >> newMethodLabelFor: aMicroUMLMethodNode [

	^ RSLabel
		  text: (String streamContents: [ :stream |
					   aMicroUMLMethodNode isPublic ifTrue: [ stream nextPut: $+ ].
					   aMicroUMLMethodNode isPrivate ifTrue: [ stream nextPut: $- ].
					   stream nextPutAll: aMicroUMLMethodNode name.
					   stream
						   nextPut: $(;
						   nextPutAll:
							   (', ' join:
									    (aMicroUMLMethodNode argumentTypes ifNil: [ {  } ]));
						   nextPut: $).
					   aMicroUMLMethodNode returnType ifNotNil: [
							   stream
								   nextPut: $:;
								   nextPutAll: aMicroUMLMethodNode returnType ] ])
		  model: aMicroUMLMethodNode
]
