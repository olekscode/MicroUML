"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRoassalBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'classDiagramNode'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie [

	| uml builder |
	uml := MicroUMLAstBuilder exampleSerie.
	builder := MicroUMLRoassalBuilder new
		           classDiagramNode: uml diagram;
		           build.
	builder
		@ RSCanvasController;
		open
]

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie2 [

	| uml builder |
	uml := MicroUMLAstBuilder exampleSerie2.
	builder := MicroUMLRoassalBuilder new
		           classDiagramNode: uml diagram;
		           build.
	builder
		@ RSCanvasController;
		open
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> attachPointFromBottomOf: aRectangle to: anotherRectangle [

	| theta |
	theta := (anotherRectangle center - aRectangle center) theta.
	^ aRectangle bottomCenter + (aRectangle width * 0.3 * theta cos @ 0)
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> attachPointFromLeftOf: aRectangle to: anotherRectangle [

	| theta |
	theta := (anotherRectangle center - aRectangle center) theta.
	^ aRectangle leftCenter + (0 @ (aRectangle height * 0.3 * theta sin))
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> attachPointFromRightOf: aRectangle to: anotherRectangle [

	| theta |
	theta := (anotherRectangle center - aRectangle center) theta.
	^ aRectangle rightCenter + (0 @ (aRectangle height * 0.3 * theta sin))
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> attachPointFromTopOf: aRectangle to: anotherRectangle [

	| theta |
	theta := (anotherRectangle center - aRectangle center) theta.
	^ aRectangle topCenter + (aRectangle width * 0.3 * theta cos @ 0)
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode [

	^ classDiagramNode
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode: aMicroUMLClassDiagramNode [

	classDiagramNode := aMicroUMLClassDiagramNode
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> controlPointsFrom: aRectangle to: anotherRectangle inCanvas: aRSCanvas [

	| geometries leastPenalty bestControlPoints |
	geometries := self geometriesInCanvas: aRSCanvas.
	leastPenalty := Float infinity.
	bestControlPoints := nil.
	self
		possibleControlPointsFrom: aRectangle
		to: anotherRectangle
		do: [ :cp |
				| penalty |
				penalty := self
					           penaltyAgainstControlPoints: cp
					           withGeometries: geometries.
				penalty < leastPenalty ifTrue: [
						leastPenalty := penalty.
						bestControlPoints := cp ] ].
	^ bestControlPoints
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> gap [

	^ 100
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> geometriesInCanvas: aRSCanvas [

	^ aRSCanvas shapes asArray
		  select: [ :shape | shape isKindOf: RSBoundingShape ]
		  thenCollect: [ :shape |
				  | rect |
				  rect := shape encompassingRectangle.
				  GRectangle origin: rect origin corner: rect corner ]
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> horizontalGap [

	^ 80
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isBottommostShape: aRSShape in: aCollectionOfRSShape [

	| left right y |
	left := aRSShape encompassingRectangle left.
	right := aRSShape encompassingRectangle right.
	y := aRSShape encompassingRectangle top.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  y > shape encompassingRectangle bottom or: [
					  shape encompassingRectangle right < left or: [
						  shape encompassingRectangle left > right ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isLeftmostShape: aRSShape in: aCollectionOfRSShape [

	| x top bottom |
	x := aRSShape encompassingRectangle right.
	top := aRSShape encompassingRectangle top.
	bottom := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  x < shape encompassingRectangle left or: [
					  shape encompassingRectangle bottom < top or: [
						  shape encompassingRectangle top > bottom ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isRightmostShape: aRSShape in: aCollectionOfRSShape [

	| x top bottom |
	x := aRSShape encompassingRectangle left.
	top := aRSShape encompassingRectangle top.
	bottom := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  x > shape encompassingRectangle right or: [
					  shape encompassingRectangle bottom < top or: [
						  shape encompassingRectangle top > bottom ] ] ]
]

{ #category : 'testing' }
MicroUMLRoassalBuilder >> isTopmostShape: aRSShape in: aCollectionOfRSShape [

	| left right y |
	left := aRSShape encompassingRectangle left.
	right := aRSShape encompassingRectangle right.
	y := aRSShape encompassingRectangle bottom.
	^ aCollectionOfRSShape allSatisfy: [ :shape |
			  y < shape encompassingRectangle top or: [
					  shape encompassingRectangle right < left or: [
						  shape encompassingRectangle left > right ] ] ]
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newClassBoxFor: aMicroUMLClassNode [

	| myLabel attributeShapes methodShapes memberShapes rect y1 y2 |
	myLabel := Array streamContents: [ :stream |
			           | label |
			           aMicroUMLClassNode keywordsDo: [ :keyword |
					           stream nextPut: (RSLabel new
							            text: '<<' , keyword , '>>';
							            color: Color darkGray) ].
			           label := RSLabel new
				                    model: aMicroUMLClassNode;
				                    text: aMicroUMLClassNode name;
				                    color: Color black.
			           aMicroUMLClassNode isAbstract ifTrue: [ label italic ].
			           stream nextPut: label ].
	RSVerticalLineLayout new
		alignCenter;
		on: myLabel.
	myLabel := myLabel asShape.
	myLabel extent x < 100 ifTrue: [
		myLabel extent: 100 @ myLabel extent y ].
	aMicroUMLClassNode isEmptyDefinition
		ifTrue: [
				^ {
					  (RSBox new
						   extent: myLabel extent + (10 @ 6);
						   position: myLabel position;
						   color: Color white;
						   borderColor: Color black;
						   borderWidth: 1).
					  myLabel } asShapeFor: aMicroUMLClassNode ]
		ifFalse: [
				attributeShapes := aMicroUMLClassNode attributesCollect: [
					                   :attribute |
					                   self newMemberLabelFor: attribute ].
				RSVerticalLineLayout new
					alignLeft;
					on: attributeShapes.
				attributeShapes := attributeShapes asShape.

				methodShapes := aMicroUMLClassNode methodsCollect: [ :method |
					                self newMemberLabelFor: method ].
				RSVerticalLineLayout new
					alignLeft;
					on: methodShapes.
				methodShapes := methodShapes asShape.

				RSVerticalLineLayout new
					alignLeft;
					gapSize: 10;
					on: {
							attributeShapes.
							methodShapes }.
				memberShapes := {
					                attributeShapes.
					                methodShapes } asShape.

				myLabel extent x < memberShapes extent x ifTrue: [
					myLabel extent: memberShapes extent x @ myLabel extent y ].
				RSVerticalLineLayout new
					alignLeft;
					gapSize: 10;
					on: {
							myLabel.
							memberShapes }.
				rect := {
					        myLabel.
					        memberShapes } asShape encompassingRectangle.
				y1 := myLabel encompassingRectangle bottom + 5.
				y2 := y1 + attributeShapes encompassingRectangle height + 10.

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
					  memberShapes } asShapeFor: aMicroUMLClassNode ]
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newEdgeFor: aMicroUMLAssociationNode [

	| bazier |
	bazier := RSBezier new
		          model: aMicroUMLAssociationNode;
		          color: Color black;
		          markerStart:
			          (self newMarkerFor: aMicroUMLAssociationNode leftHead);
		          markerEnd:
			          (self newMarkerFor: aMicroUMLAssociationNode rightHead);
		          attachPoint: RSBorderAttachPoint new;
		          yourself.
	aMicroUMLAssociationNode line = #dashed ifTrue: [ bazier dashed ].
	^ bazier
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newInheritanceLinkBetween: aMicroUMLClassBox andSuperclass: anotherMicroUMLClassBox [

	^ RSBezier new
		  color: Color black;
		  markerStart: ((RSPolygon new
				    points: {
						    (-8 @ 8).
						    (0 @ 0).
						    (8 @ 8) };
				    color: Color white;
				    borderColor: Color black;
				    borderWidth: 1;
				    asMarker) offset: 4);
		  attachPoint: RSBorderAttachPoint new;
		  from: anotherMicroUMLClassBox;
		  to: aMicroUMLClassBox;
		  controlPointsController: RSVerticalCPAPController new;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMarkerFor: aSymbol [

	aSymbol = #aggregation ifTrue: [
			^ (RSPolygon new
				   points: {
						   (-6 @ 0).
						   (0 @ 8).
						   (6 @ 0).
						   (0 @ -8) };
				   color: Color white;
				   borderColor: Color black;
				   borderWidth: 1;
				   asMarker) offset: 8 ].
	aSymbol = #composition ifTrue: [
			^ (RSPolygon new
				   points: {
						   (-6 @ 0).
						   (0 @ 8).
						   (6 @ 0).
						   (0 @ -8) };
				   color: Color black;
				   borderColor: Color black;
				   borderWidth: 1;
				   asMarker) offset: 8 ].
	aSymbol = #arrowhead ifTrue: [
			^ RSPolygon new
				  points: {
						  (-5 @ 5).
						  (0 @ 0).
						  (5 @ 5).
						  (0 @ 0) };
				  color: Color black;
				  asMarker ].
	aSymbol = #wedge ifTrue: [
			^ RSPolygon new
				  points: {
						  (-5 @ 5).
						  (0 @ 0).
						  (5 @ 5).
						  (0 @ 2) };
				  color: Color black;
				  asMarker ].
	^ nil
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMemberLabelFor: aMicroUMLMemberNode [

	| label |
	label := RSLabel
		         text: (String streamContents: [ :stream |
					          aMicroUMLMemberNode isPrivate
						          ifTrue: [ stream nextPut: $- ]
						          ifFalse: [ stream nextPut: Character space ].
					          stream nextPutAll: aMicroUMLMemberNode name.
					          aMicroUMLMemberNode argumentTypes ifNotNil: [
							          :argumentTypes |
							          stream
								          nextPut: $(;
								          nextPutAll: (', ' join: argumentTypes);
								          nextPut: $) ].
					          aMicroUMLMemberNode type ifNotNil: [ :type |
							          stream
								          nextPut: $:;
								          nextPutAll: type ] ])
		         model: aMicroUMLMemberNode.
	aMicroUMLMemberNode isAbstract ifTrue: [
		label emphasis: TextEmphasis italic ].
	aMicroUMLMemberNode isClassSide ifTrue: [
		label emphasis: TextEmphasis underlined ].
	^ label
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newTraitLinkBetween: aRSShape andLollipop: anotherRSShape [

	^ RSBezier new
		  color: Color black;
		  attachPoint: RSCenteredAttachPoint new;
		  from: aRSShape;
		  to: anotherRSShape;
		  controlPointsController: RSVerticalCPAPController new;
		  yourself
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> offsetForLabel: aRSLabel markerExtent: aPoint directing: anotherPoint to: yetAnotherPoint [

	^ anotherPoint y abs <= anotherPoint x abs
		  ifTrue: [
				  aRSLabel width * 0.5 + 2 + aPoint x abs
				  * (anotherPoint x sign + 0.1) sign @ (aRSLabel height * 0.5 + 2
				   * (yetAnotherPoint y sign + 0.1) sign negated) ]
		  ifFalse: [
				  aRSLabel width * 0.5 + 2
				  * (yetAnotherPoint x sign + 0.1) sign negated
				  @ (aRSLabel height * 0.5 + 2 + aPoint y abs
					   * (anotherPoint y sign + 0.5) sign) ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> penaltyAgainstControlPoints: anArrayOfPoint withGeometries: aCollectionOfGeometry [

	| points lines penalty |
	points := (RSBezier new controlPoints: anArrayOfPoint) lines.
	lines := (1 to: points size - 1) collect: [ :i |
		         GLine through: (points at: i) and: (points at: i + 1) ].
	penalty := 0.
	aCollectionOfGeometry do: [ :geometry |
			(lines anySatisfy: [ :line |
				 (geometry intersectionsWithLine: line) notEmpty ]) ifTrue: [
				penalty := penalty + 1 ] ].
	^ penalty
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFrom: aRectangle to: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromLeft: aRectangle
		toRight: anotherRectangle
		do: aBlock;
		possibleControlPointsFromRight: aRectangle
		toLeft: anotherRectangle
		do: aBlock;
		possibleControlPointsFromBottom: aRectangle
		toTop: anotherRectangle
		do: aBlock;
		possibleControlPointsFromTop: aRectangle
		toBottom: anotherRectangle
		do: aBlock.

	self
		possibleControlPointsFromLeft: aRectangle
		toLeft: anotherRectangle
		do: aBlock;
		possibleControlPointsFromRight: aRectangle
		toRight: anotherRectangle
		do: aBlock.

	self
		possibleControlPointsFromRight: aRectangle
		toBottom: anotherRectangle
		do: aBlock;
		possibleControlPointsFromBottom: aRectangle
		toRight: anotherRectangle
		do: aBlock;
		possibleControlPointsFromBottom: aRectangle
		toLeft: anotherRectangle
		do: aBlock;
		possibleControlPointsFromLeft: aRectangle
		toBottom: anotherRectangle
		do: aBlock;
		possibleControlPointsFromBottom: aRectangle
		toBottom: anotherRectangle
		do: aBlock.

	self
		possibleControlPointsFromLeft: aRectangle
		toTop: anotherRectangle
		do: aBlock;
		possibleControlPointsFromRight: aRectangle
		toTop: anotherRectangle
		do: aBlock;
		possibleControlPointsFromTop: aRectangle
		toRight: anotherRectangle
		do: aBlock;
		possibleControlPointsFromTop: aRectangle
		toLeft: anotherRectangle
		do: aBlock;
		possibleControlPointsFromTop: aRectangle
		toTop: anotherRectangle
		do: aBlock
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromBottom: aRectangle toBottom: anotherRectangle do: aBlock [

	| bottom p1 p2 |
	bottom := (aRectangle bottom max: anotherRectangle bottom)
	          + self verticalGap.
	p1 := self attachPointFromBottomOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromBottomOf: anotherRectangle to: aRectangle.
	(p1 x between: anotherRectangle left and: anotherRectangle right)
		ifTrue: [ ^ self ].
	(p2 x between: aRectangle left and: aRectangle right) ifTrue: [
		^ self ].
	aBlock value: {
			p1.
			(p1 x @ bottom).
			(p2 x @ bottom).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromBottom: aRectangle toLeft: anotherRectangle do: aBlock [

	| p1 p2 |
	aRectangle bottom <= anotherRectangle center y ifFalse: [ ^ self ].
	aRectangle center x <= anotherRectangle left ifFalse: [ ^ self ].
	p1 := self attachPointFromBottomOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromLeftOf: anotherRectangle to: aRectangle.
	aBlock value: {
			p1.
			(p1 x @ p2 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromBottom: aRectangle toRight: anotherRectangle do: aBlock [

	| p1 p2 |
	aRectangle bottom <= anotherRectangle center y ifFalse: [ ^ self ].
	anotherRectangle right <= aRectangle center x ifFalse: [ ^ self ].
	p1 := self attachPointFromBottomOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromRightOf: anotherRectangle to: aRectangle.
	aBlock value: {
			p1.
			(p1 x @ p2 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromBottom: aRectangle toTop: anotherRectangle do: aBlock [

	| p1 p2 middle |
	aRectangle bottom < anotherRectangle top ifFalse: [ ^ self ].
	p1 := self attachPointFromBottomOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromTopOf: anotherRectangle to: aRectangle.
	middle := p1 y + p2 y / 2.0.
	aBlock value: {
			p1.
			(p1 x @ middle).
			(p2 x @ middle).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromLeft: aRectangle toBottom: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromBottom: anotherRectangle
		toLeft: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromLeft: aRectangle toLeft: anotherRectangle do: aBlock [

	| left p1 p2 |
	left := (aRectangle left min: anotherRectangle left)
	        - self horizontalGap.
	p1 := self attachPointFromLeftOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromLeftOf: anotherRectangle to: aRectangle.
	(p1 y between: anotherRectangle top and: anotherRectangle bottom)
		ifTrue: [ ^ self ].
	(p2 y between: aRectangle top and: aRectangle bottom) ifTrue: [
		^ self ].
	aBlock value: {
			p1.
			(left @ p1 y).
			(left @ p2 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromLeft: aRectangle toRight: anotherRectangle do: aBlock [

	| p1 p2 middle |
	anotherRectangle right < aRectangle left ifFalse: [ ^ self ].
	p1 := self attachPointFromLeftOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromRightOf: anotherRectangle to: aRectangle.
	middle := p1 x + p2 x / 2.0.
	aBlock value: {
			p1.
			(middle @ p1 y).
			(middle @ p2 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromLeft: aRectangle toTop: anotherRectangle do: aBlock [

	| p1 p2 |
	anotherRectangle center x <= aRectangle left ifFalse: [ ^ self ].
	aRectangle center y <= anotherRectangle top ifFalse: [ ^ self ].
	p1 := self attachPointFromLeftOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromTopOf: anotherRectangle to: aRectangle.
	aBlock value: {
			p1.
			(p2 x @ p1 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromRight: aRectangle toBottom: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromBottom: anotherRectangle
		toRight: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromRight: aRectangle toLeft: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromLeft: anotherRectangle
		toRight: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromRight: aRectangle toRight: anotherRectangle do: aBlock [

	| right p1 p2 |
	right := (aRectangle right max: anotherRectangle right)
	         + self horizontalGap.
	p1 := self attachPointFromRightOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromRightOf: anotherRectangle to: aRectangle.
	(p1 y between: anotherRectangle top and: anotherRectangle bottom)
		ifTrue: [ ^ self ].
	(p2 y between: aRectangle top and: aRectangle bottom) ifTrue: [
		^ self ].
	aBlock value: {
			p1.
			(right @ p1 y).
			(right @ p2 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromRight: aRectangle toTop: anotherRectangle do: aBlock [

	| p1 p2 |
	aRectangle right <= anotherRectangle center x ifFalse: [ ^ self ].
	aRectangle center y <= anotherRectangle top ifFalse: [ ^ self ].
	p1 := self attachPointFromRightOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromTopOf: anotherRectangle to: aRectangle.
	aBlock value: {
			p1.
			(p2 x @ p1 y).
			p2 }
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromTop: aRectangle toBottom: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromBottom: anotherRectangle
		toTop: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromTop: aRectangle toLeft: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromLeft: anotherRectangle
		toTop: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromTop: aRectangle toRight: anotherRectangle do: aBlock [

	self
		possibleControlPointsFromRight: anotherRectangle
		toTop: aRectangle
		do: [ :cp | aBlock value: cp reversed ]
]

{ #category : 'edge layouting' }
MicroUMLRoassalBuilder >> possibleControlPointsFromTop: aRectangle toTop: anotherRectangle do: aBlock [

	| top p1 p2 |
	top := (aRectangle top min: anotherRectangle top) - self verticalGap.
	p1 := self attachPointFromTopOf: aRectangle to: anotherRectangle.
	p2 := self attachPointFromTopOf: anotherRectangle to: aRectangle.
	(p1 x between: anotherRectangle left and: anotherRectangle right)
		ifTrue: [ ^ self ].
	(p2 x between: aRectangle left and: aRectangle right) ifTrue: [
		^ self ].
	aBlock value: {
			p1.
			(p1 x @ top).
			(p2 x @ top).
			p2 }
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderExtraLink: aRSBezier from: aRSShape to: anotherRSShape in: aRSCanvas [

	(self
		 controlPointsFrom: aRSShape encompassingRectangle
		 to: anotherRSShape encompassingRectangle
		 inCanvas: aRSCanvas)
		ifNotNil: [ :cp | aRSBezier controlPoints: cp ]
		ifNil: [
				aRSBezier
					attachPoint: RSBorderAttachPoint new;
					from: aRSShape;
					to: anotherRSShape;
					controlPointsController: RSDirectedBezierCPAPController new ].
	aRSCanvas add: aRSBezier
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderIn: aRSCanvas [

	| nodes edges lollipops connectedNodes extraEdges |
	nodes := Dictionary new.
	edges := OrderedCollection new.
	lollipops := Dictionary new.
	connectedNodes := IdentitySet new.
	extraEdges := OrderedCollection new.
	classDiagramNode classesDo: [ :classAst |
			| node |
			node := self newClassBoxFor: classAst.
			aRSCanvas
				add: node;
				addNode: node.
			nodes at: classAst name put: node.
			classAst traitsDo: [ :traitName |
					| lollipop |
					lollipop := RSCircle new
						            extent: 20 @ 20;
						            color: Color white;
						            border: (RSBorder new color: Color black);
						            yourself.
					aRSCanvas
						add: lollipop;
						addNode: lollipop.
					lollipops
						at: {
								node.
								traitName }
						put: lollipop ] ].
	classDiagramNode classesDo: [ :classAst |
			classAst superclass ifNotNil: [ :superclassName |
					(nodes includesKey: superclassName) ifTrue: [
							| link |
							link := self
								        newInheritanceLinkBetween: (nodes at: classAst name)
								        andSuperclass: (nodes at: superclassName).
							connectedNodes
								add: (nodes at: classAst name);
								add: (nodes at: superclassName).
							aRSCanvas add: link ] ] ].
	lollipops keysAndValuesDo: [ :classNodeAndTraitName :lollipop |
			| link |
			link := self
				        newTraitLinkBetween: classNodeAndTraitName first
				        andLollipop: lollipop.
			aRSCanvas add: link.
			link pushBack ].
	classDiagramNode associationsDo: [ :associationNode |
			| edge leftNode rightNode |
			leftNode := nodes at: associationNode leftClass.
			rightNode := nodes at: associationNode rightClass.
			edge := self newEdgeFor: associationNode.
			edges add: edge.
			((connectedNodes includes: leftNode) and: [
				 connectedNodes includes: rightNode ])
				ifTrue: [ extraEdges add: edge ]
				ifFalse: [
						edge
							from: leftNode;
							to: rightNode;
							controlPointsController: RSVerticalCPAPController new.
						aRSCanvas
							add: edge;
							addEdge: edge.
						edge pushBack ] ].
	RSTreeLayout new
		verticalGap: self verticalGap;
		horizontalGap: self horizontalGap;
		on: (nodes values , lollipops values as: RSGroup).
	extraEdges do: [ :edge |
			| leftNode rightNode |
			leftNode := nodes at: edge model leftClass.
			rightNode := nodes at: edge model rightClass.
			self
				renderExtraLink: edge
				from: leftNode
				to: rightNode
				in: aRSCanvas ].
	edges do: [ :bezier | self renderLinkLabelsFor: bezier in: aRSCanvas ].
	lollipops keysAndValuesDo: [ :classNodeAndTraitName :lollipop |
			self
				renderTraitLabelAt: lollipop
				classNode: classNodeAndTraitName first
				traitName: classNodeAndTraitName second
				in: aRSCanvas ].
	aRSCanvas zoomToFit
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderLinkLabelsFor: aRSBezier in: aRSCanvas [

	aRSBezier model ifNotNil: [ :edge |
			edge leftLabel ifNotNil: [ :text |
					| label |
					label := RSLabel new text: text.
					label translateTo: aRSBezier controlPoints first + (self
							 offsetForLabel: label
							 markerExtent: (aRSBezier markerStart
									  ifNotNil: [ :m | m shape encompassingRectangle extent ]
									  ifNil: [ 0 @ 0 ])
							 directing:
							 aRSBezier controlPoints second - aRSBezier controlPoints first
							 to:
							 aRSBezier controlPoints last - aRSBezier controlPoints first).
					aRSCanvas add: label ].
			edge rightLabel ifNotNil: [ :text |
					| label |
					label := RSLabel new text: text.
					label translateTo: aRSBezier controlPoints last + (self
							 offsetForLabel: label
							 markerExtent: (aRSBezier markerEnd
									  ifNotNil: [ :m | m shape encompassingRectangle extent ]
									  ifNil: [ 0 @ 0 ])
							 directing:
							 (aRSBezier controlPoints atLast: 2)
							 - aRSBezier controlPoints last
							 to:
							 aRSBezier controlPoints first - aRSBezier controlPoints last).
					aRSCanvas add: label ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderTraitLabelAt: aRSShape classNode: anotherRSShape traitName: aSymbol in: aRSCanvas [

	| label extent |
	label := RSLabel new
		         text: aSymbol asString;
		         color: Color black;
		         yourself.
	extent := label extent.
	anotherRSShape position y < aRSShape position y
		ifTrue: [
				label position:
					aRSShape encompassingRectangle bottomCenter + (0 @ extent y) ]
		ifFalse: [
				label position:
					aRSShape encompassingRectangle topCenter - (0 @ extent y) ].
	aRSCanvas add: label
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> verticalGap [

	^ 100
]
