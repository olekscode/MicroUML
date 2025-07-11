"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRoassalBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'astBuilder',
		'associationEdges'
	],
	#category : 'MicroUML-Builder',
	#package : 'MicroUML-Builder'
}

{ #category : 'examples' }
MicroUMLRoassalBuilder class >> exampleSerie [

	| uml builder |
	uml := 
#(abstract) % #AbstractSeries 
	+ #name @ String 
	- #(abstract) % #numEpisodes @ Integer
	+ #(static) % #findByName ~ {#String} @ #AbstractSeries
=== 
#NovelSeries 
	--|> #AbstractSeries
	+ #author @ String 
	* #Publisher @ String 
	+ #read~{}
=== 
#ComicSeries 
	--|> #AbstractSeries 
	+ #toonAuthor @ String
	* #storyAuthor @ String 
	+ #print~{} 
=== 
#AnimeSeries
	--|> #AbstractSeries 
	+ #director @ String 
	- #animators @ String
	- #voiceActors @ String 
	+ #play~{} 
	<'original'>---<'comicalize'> #ComicSeries 
	<><'main'>---<'side stories'> #NovelSeries .
	builder := MicroUMLRoassalBuilder new
		           astBuilder: uml;
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

	astBuilder := aMicroUMLAstBuilder.
	associationEdges := OrderedCollection new
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> gap [

	^ 100
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> horizontalGap [

	^ 80
]

{ #category : 'initialization' }
MicroUMLRoassalBuilder >> initialize [

	super initialize.
	associationEdges := OrderedCollection new
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
	myLabel := RSLabel
		           text: aMicroUMLClassNode name
		           model: aMicroUMLClassNode.
	aMicroUMLClassNode isAbstract ifTrue: [
		myLabel emphasis: TextEmphasis italic ].
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
MicroUMLRoassalBuilder >> newEdgeFor: aMicroUMLAssociationNode [

	^ RSBezier new
		  model: aMicroUMLAssociationNode;
		  color: Color black;
		  markerStart:
			  (self newMarkerFor: aMicroUMLAssociationNode leftHead);
		  markerEnd: (self newMarkerFor: aMicroUMLAssociationNode rightHead);
		  attachPoint: RSBorderAttachPoint new;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newInheritanceLinkBetween: aMicroUMLClassBox andSuperclass: anotherMicroUMLClassBox [

	^ RSBezier new
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
	^ nil
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMemberLabelFor: aMicroUMLMemberNode [

	| label |
	label := RSLabel
		         text: (String streamContents: [ :stream |
					          aMicroUMLMemberNode isPublic ifTrue: [
						          stream nextPut: $+ ].
					          aMicroUMLMemberNode isPrivate ifTrue: [
						          stream nextPut: $- ].
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
MicroUMLRoassalBuilder >> renderExtraLink: aRSBezier from: aRSShape to: anotherRSShape in: aRSCanvas [

	| margin others others1 others2 |
	aRSCanvas add: aRSBezier.
	margin := self horizontalGap max: self verticalGap.
	others := aRSCanvas nodes copyWithoutAll: {
			          aRSShape.
			          anotherRSShape }.
	others1 := aRSCanvas nodes copyWithout: aRSShape.
	others2 := aRSCanvas nodes copyWithout: anotherRSShape.
	((self isRightmostShape: aRSShape in: others1) and: [
		 self isRightmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| right |
			right := (((others select: [ :shape |
					            shape encompassingRectangle center y
						            between: (aRSShape encompassingRectangle top min:
								             anotherRSShape encompassingRectangle top)
						            and: (aRSShape encompassingRectangle bottom max:
								             anotherRSShape encompassingRectangle bottom) ])
				           copyWithAll: {
						           aRSShape.
						           anotherRSShape }) collect: [ :shape |
				          shape encompassingRectangle right ]) max.
			right := right
			         + (right - (aRSShape encompassingRectangle right max:
					           anotherRSShape encompassingRectangle right)) + margin.
			aRSBezier controlPoints: {
					aRSShape encompassingRectangle rightCenter.
					(right @ aRSShape encompassingRectangle center y).
					(right @ anotherRSShape encompassingRectangle center y).
					anotherRSShape encompassingRectangle rightCenter }.
			^ self ].
	((self isLeftmostShape: aRSShape in: others1) and: [
		 self isLeftmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| left |
			left := (((others select: [ :shape |
					           shape encompassingRectangle center y
						           between: (aRSShape encompassingRectangle top min:
								            anotherRSShape encompassingRectangle top)
						           and: (aRSShape encompassingRectangle bottom max:
								            anotherRSShape encompassingRectangle bottom) ])
				          copyWithAll: {
						          aRSShape.
						          anotherRSShape }) collect: [ :shape |
				         shape encompassingRectangle left ]) min.
			left := left + ((aRSShape encompassingRectangle left min:
				          anotherRSShape encompassingRectangle left) - left)
			        - margin.
			aRSBezier controlPoints: {
					aRSShape encompassingRectangle leftCenter.
					(left @ aRSShape encompassingRectangle center y).
					(left @ anotherRSShape encompassingRectangle center y).
					anotherRSShape encompassingRectangle leftCenter }.
			^ self ].
	((self isBottommostShape: aRSShape in: others1) and: [
		 self isBottommostShape: anotherRSShape in: others2 ]) ifTrue: [
			| bottom |
			bottom := (((others select: [ :shape |
					             shape encompassingRectangle center x
						             between: (aRSShape encompassingRectangle left min:
								              anotherRSShape encompassingRectangle left)
						             and: (aRSShape encompassingRectangle right max:
								              anotherRSShape encompassingRectangle right) ])
				            copyWithAll: {
						            aRSShape.
						            anotherRSShape }) collect: [ :shape |
				           shape encompassingRectangle bottom ]) max.
			bottom := bottom
			          + (bottom - (aRSShape encompassingRectangle bottom max:
					            anotherRSShape encompassingRectangle bottom))
			          + margin.

			aRSBezier controlPoints: {
					aRSShape encompassingRectangle bottomCenter.
					(aRSShape encompassingRectangle center x @ bottom).
					(anotherRSShape encompassingRectangle center x @ bottom).
					anotherRSShape encompassingRectangle bottomCenter }.
			^ self ].
	((self isTopmostShape: aRSShape in: others1) and: [
		 self isTopmostShape: anotherRSShape in: others2 ]) ifTrue: [
			| top |
			top := (((others select: [ :shape |
					          shape encompassingRectangle center x
						          between: (aRSShape encompassingRectangle left min:
								           anotherRSShape encompassingRectangle left)
						          and: (aRSShape encompassingRectangle right max:
								           anotherRSShape encompassingRectangle right) ])
				         copyWithAll: {
						         aRSShape.
						         anotherRSShape }) collect: [ :shape |
				        shape encompassingRectangle top ]) min.
			top := top + ((aRSShape encompassingRectangle top min:
				         anotherRSShape encompassingRectangle top) - top) - margin.

			aRSBezier controlPoints: {
					aRSShape encompassingRectangle topCenter.
					(aRSShape encompassingRectangle center x @ top).
					(anotherRSShape encompassingRectangle center x @ top).
					anotherRSShape encompassingRectangle topCenter }.
			^ self ].

	aRSBezier
		attachPoint: RSBorderAttachPoint new;
		from: aRSShape;
		to: anotherRSShape;
		controlPointsController: RSDirectedBezierCPAPController new
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderIn: aRSCanvas [

	| nodes edges connectedNodes extraEdges |
	nodes := Dictionary new.
	edges := OrderedCollection new.
	connectedNodes := IdentitySet new.
	extraEdges := OrderedCollection new.
	astBuilder classesDo: [ :classAst |
			| node |
			node := self newClassBoxFor: classAst.
			aRSCanvas
				add: node;
				addNode: node.
			nodes at: classAst name put: node ].
	astBuilder classesDo: [ :classAst |
			classAst superclass ifNotNil: [ :superclassName |
					| link |
					link := self
						        newInheritanceLinkBetween: (nodes at: classAst name)
						        andSuperclass: (nodes at: superclassName).
					connectedNodes
						add: (nodes at: classAst name);
						add: (nodes at: superclassName).
					aRSCanvas add: link ] ].
	astBuilder associationsDo: [ :associationNode |
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
		on: nodes values asArray.
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
	aRSCanvas zoomToFit
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderLinkLabelsFor: aRSBezier in: aRSCanvas [

	aRSBezier model ifNotNil: [ :edge |
			edge leftLabel ifNotNil: [ :text |
					| label vector markerOffset |
					label := RSLabel new text: text.
					aRSCanvas add: label.
					vector := aRSBezier controlPoints second
					          - aRSBezier controlPoints first.
					markerOffset := aRSBezier markerStart
						                ifNotNil: [ :m |
								                | extent |
								                extent := m shape encompassingRectangle extent.
								                (extent x max: extent y) / 2 ]
						                ifNil: [ 0 ].
					vector x >= vector y abs ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6 + markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector x <= vector y abs negated ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / -2 - 6 - markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector y > vector x abs ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / 2 + 6 + markerOffset)) ].
					vector y < vector x abs negated ifTrue: [
							label position: aRSBezier startPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / -2 - 6 - markerOffset)) ] ].
			edge rightLabel ifNotNil: [ :text |
					| label vector markerOffset |
					label := RSLabel new text: text.
					aRSCanvas add: label.
					vector := aRSBezier controlPoints third
					          - aRSBezier controlPoints fourth.
					markerOffset := aRSBezier markerEnd
						                ifNotNil: [ :m |
								                | extent |
								                extent := m shape encompassingRectangle extent.
								                (extent x max: extent y) / 2 ]
						                ifNil: [ 0 ].
					vector x >= vector y abs ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6 + markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector x <= vector y abs negated ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / -2 - 6 - markerOffset
								 @ (label textHeight / 2 + 6)) ].
					vector y > vector x abs ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / 2 + 6 + markerOffset)) ].
					vector y < vector x abs negated ifTrue: [
							label position: aRSBezier endPoint
								+
								(label textWidth / 2 + 6
								 @ (label textHeight / -2 - 6 - markerOffset)) ] ] ]
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> verticalGap [

	^ 100
]
