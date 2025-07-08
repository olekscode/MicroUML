"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRoassalBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'astBuilder'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie [

	| builder |
	builder := MicroUMLRoassalBuilder new
		           astBuilder: MicroUMLAstBuilder exampleSerie;
		           build.
	builder
		@ RSCanvasController;
		open
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> astBuilder [

	^ astBuilder
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> astBuilder: aMicroUMLAstBuilder [

	astBuilder := aMicroUMLAstBuilder
]

{ #category : 'building' }
MicroUMLRoassalBuilder >> canvasFrom: aMicroUMLAstBuilder [

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
MicroUMLRoassalBuilder >> newClassBoxFor: aMicroUMLClassNode [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 |
	myLabel := RSLabel
		           text: aMicroUMLClassNode name
		           model: aMicroUMLClassNode.
	attributeShapes := aMicroUMLClassNode attributesCollect: [ :attribute |
		                   self newMemberLabelFor: attribute ].
	RSVerticalLineLayout new alignLeft on: attributeShapes.
	attributeShapes := attributeShapes asShape.
	methodShapes := aMicroUMLClassNode methodsCollect: [ :method |
		                self newMemberLabelFor: method ].
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
MicroUMLRoassalBuilder >> newInheritanceLinkBetween: aMicroUMLClassBox andSuperclass: anotherMicroUMLClassBox [

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
MicroUMLRoassalBuilder >> newMemberLabelFor: aMicroUMLMemberNode [

	^ RSLabel
		  text: (String streamContents: [ :stream |
					   aMicroUMLMemberNode isPublic ifTrue: [ stream nextPut: $+ ].
					   aMicroUMLMemberNode isPrivate ifTrue: [ stream nextPut: $- ].
					   stream nextPutAll: aMicroUMLMemberNode name.
					   aMicroUMLMemberNode argumentTypes ifNotNil: [ :argumentTypes |
							   stream
								   nextPut: $(;
								   nextPutAll: (', ' join: argumentTypes);
								   nextPut: $) ].
					   aMicroUMLMemberNode type ifNotNil: [ :type |
							   stream
								   nextPut: $:;
								   nextPutAll: type ] ])
		  model: aMicroUMLMemberNode
]

{ #category : 'building' }
MicroUMLRoassalBuilder >> objects [

	^ Array streamContents: [ :stream |
			  | nodes |
			  nodes := Dictionary new.
			  astBuilder classesDo: [ :classAst |
					  | node |
					  node := self newClassBoxFor: classAst.
					  nodes at: classAst name put: node.
					  stream nextPut: node ].
			  astBuilder classesDo: [ :classAst |
					  classAst superclass ifNotNil: [ :superclassName |
							  | link |
							  link := self
								          newInheritanceLinkBetween: (nodes at: classAst name)
								          andSuperclass: (nodes at: superclassName).
							  stream nextPut: link ] ].
			  RSTreeLayout on: nodes values asArray ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderIn: aRSCanvas [

	| nodes |
	nodes := Dictionary new.
	astBuilder classesDo: [ :classAst |
			| node |
			node := self newClassBoxFor: classAst.
			aRSCanvas add: node.
			nodes at: classAst name put: node ].
	astBuilder classesDo: [ :classAst |
			classAst superclass ifNotNil: [ :superclassName |
					| link |
					link := self
						        newInheritanceLinkBetween: (nodes at: classAst name)
						        andSuperclass: (nodes at: superclassName).
					aRSCanvas add: link ] ].
	RSTreeLayout on: nodes values asArray.
	aRSCanvas zoomToFit
]
