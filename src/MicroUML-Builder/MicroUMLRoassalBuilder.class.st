"
I build Roassal objects based on the MicroUML's AST.
See my class method `exampleSerie` to see how to use me.
"
Class {
	#name : 'MicroUMLRoassalBuilder',
	#superclass : 'RSBuilder',
	#instVars : [
		'classDiagramNode',
		'nodes',
		'colorBlock',
		'interaction'
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

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> associationEdgeColor [

	^ Color lightGray
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> attachInteraction: aRSShape [

	aRSShape model ifNotNil: [ :model |
			(model comment notNil or: [ model actionBlock notNil ]) ifTrue: [
				aRSShape @ interaction ] ]
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> basicNewClassBoxFor: aMicroUMLClassNode [

	| color myLabel attributeShapes methodShapes memberShapes rect y1 y2 |
	color := self colorFor: aMicroUMLClassNode.
	myLabel := Array streamContents: [ :stream |
			           | label |
			           aMicroUMLClassNode keywordsDo: [ :keyword |
					           stream nextPut: (RSLabel new
							            text: '<<' , keyword , '>>';
							            color: Color darkGray) ].
			           label := RSLabel new
				                    text: aMicroUMLClassNode name;
				                    color: color.
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
						   borderColor: color;
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
						   borderColor: color;
						   borderWidth: 1).
					  (RSLine new
						   startPoint: rect extent x / -2 - 5 @ y1;
						   endPoint: rect extent x / 2 + 5 @ y1;
						   color: color).
					  (RSLine new
						   startPoint: rect extent x / -2 - 5 @ y2;
						   endPoint: rect extent x / 2 + 5 @ y2;
						   color: color).
					  myLabel.
					  memberShapes } asShapeFor: aMicroUMLClassNode ]
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode [

	^ classDiagramNode
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> classDiagramNode: aMicroUMLClassDiagramNode [

	classDiagramNode := aMicroUMLClassDiagramNode
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> colorBlock [

	^ colorBlock
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> colorBlock: aBlock [

	colorBlock := aBlock
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> colorFor: aMicroUMLAstNode [

	^ colorBlock
		  ifNotNil: [ colorBlock cull: aMicroUMLAstNode ]
		  ifNil: [ self defaultColor ]
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> defaultColor [

	^ Color black
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> horizontalMargin [

	^ 70.0
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> inheritanceEdgeColor [

	^ Color lightGray
]

{ #category : 'initialization' }
MicroUMLRoassalBuilder >> initialize [

	super initialize.
	nodes := Dictionary new.
	interaction := MicroUMLRoassalInteraction new
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newClassBoxFor: aMicroUMLClassNode [

	| box |
	box := self basicNewClassBoxFor: aMicroUMLClassNode.
	self attachInteraction: box.
	^ box
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newEdgeFor: aMicroUMLAssociationNode [

	| bazier |
	bazier := RSBezier new
		          model: aMicroUMLAssociationNode;
		          color: self associationEdgeColor;
		          markerStart:
			          (self newMarkerFor: aMicroUMLAssociationNode leftHead);
		          markerEnd:
			          (self newMarkerFor: aMicroUMLAssociationNode rightHead);
		          yourself.
	aMicroUMLAssociationNode line = #dashed ifTrue: [ bazier dashed ].
	^ bazier
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newInheritanceMarker [

	^ RSPolygon new
		  points: {
				  (-8 @ 8).
				  (0 @ 0).
				  (8 @ 8) };
		  color: Color white;
		  borderColor: Color black;
		  borderWidth: 1;
		  yourself
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newLollipopMarker [

	^ RSCircle new
		  extent: 20.0 @ 20.0;
		  color: Color white;
		  border: (RSBorder new color: Color black);
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
			^ (RSPolygon new
				   points: {
						   (-5 @ 5).
						   (0 @ 0).
						   (5 @ 5) };
				   color: Color black;
				   asMarker) offset: 2.5 ].
	aSymbol = #wedge ifTrue: [
			^ (RSPolygon new
				   points: {
						   (-7 @ 7).
						   (0 @ 0).
						   (7 @ 7).
						   (0 @ 3) };
				   color: Color black;
				   asMarker) offset: 7 ].
	^ nil
]

{ #category : 'instance creation' }
MicroUMLRoassalBuilder >> newMemberLabelFor: aMicroUMLMemberNode [

	| label |
	label := RSLabel new
		         text: (String streamContents: [ :stream |
						          stream nextPutAll:
								          (self visibilityMarkFor: aMicroUMLMemberNode).
						          stream nextPutAll: aMicroUMLMemberNode name.
						          aMicroUMLMemberNode isMethod ifTrue: [
									          aMicroUMLMemberNode argumentTypes ifNotNil: [
												          :argumentTypes |
												          stream
													          nextPut: $(;
													          nextPutAll:
														          (', ' join: aMicroUMLMemberNode argumentTypes);
													          nextPut: $) ] ].
						          aMicroUMLMemberNode type ifNotNil: [ :type |
								          stream
									          nextPut: $:;
									          nextPutAll: type ] ]);
		         color: (self colorFor: aMicroUMLMemberNode);
		         model: aMicroUMLMemberNode.
	aMicroUMLMemberNode isAbstract ifTrue: [
		label emphasis: TextEmphasis italic ].
	aMicroUMLMemberNode isClassSide ifTrue: [
		label emphasis: TextEmphasis underlined ].
	self attachInteraction: label.
	^ label
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

{ #category : 'private' }
MicroUMLRoassalBuilder >> offsetForMultiplicity: aRSLabel markerExtent: aPoint directing: anotherPoint to: yetAnotherPoint [

	^ anotherPoint y abs <= anotherPoint x abs
		  ifTrue: [
				  aRSLabel width * 0.5 + 2 + aPoint x abs
				  * (anotherPoint x sign + 0.1) sign
				  @
				  (aRSLabel height * 0.5 + 2 * (yetAnotherPoint y sign + 0.1) sign
				   * 1.5) ]
		  ifFalse: [
				  aRSLabel width * 0.5 + 2
				  * ((yetAnotherPoint x sign + 0.1) sign * 1.5)
				  @ (aRSLabel height * 0.5 + 2 + aPoint y abs
					   * (anotherPoint y sign + 0.5) sign) ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderAssociationsIn: aRSCanvas [

	| associationsOnLeft associationsOnRight leftClassSides leftClassFractions rightClassSides rightClassFractions |
	associationsOnLeft := Dictionary new.
	associationsOnRight := Dictionary new.
	leftClassSides := IdentityDictionary new.
	leftClassFractions := IdentityDictionary new.
	rightClassSides := IdentityDictionary new.
	rightClassFractions := IdentityDictionary new.
	classDiagramNode associationsDo: [ :association |
			nodes at: association leftClass ifPresent: [ :classShape1 |
					nodes at: association rightClass ifPresent: [ :classShape2 |
							(classShape1 encompassingRectangle left
							 > classShape2 encompassingRectangle right
								 ifTrue: [
										 associationsOnLeft
											 at: association leftClass
											 ifAbsentPut: [ OrderedCollection new ] ]
								 ifFalse: [
										 associationsOnRight
											 at: association leftClass
											 ifAbsentPut: [ OrderedCollection new ] ]) addLast:
								association.
							(classShape2 encompassingRectangle left
							 > classShape1 encompassingRectangle right
								 ifTrue: [
										 associationsOnLeft
											 at: association rightClass
											 ifAbsentPut: [ OrderedCollection new ] ]
								 ifFalse: [
										 associationsOnRight
											 at: association rightClass
											 ifAbsentPut: [ OrderedCollection new ] ]) addLast:
								association ] ] ].
	associationsOnLeft keysAndValuesDo: [ :className :associations |
			associations withIndexDo: [ :association :index |
					association leftClass = className
						ifTrue: [
								leftClassSides
									at: association
									ifPresent: [
											rightClassSides at: association put: #left.
											rightClassFractions
												at: association
												put: index asFloat / (associations size asFloat + 1.0) ]
									ifAbsent: [
											leftClassSides at: association put: #left.
											leftClassFractions
												at: association
												put: index asFloat / (associations size asFloat + 1.0) ] ]
						ifFalse: [
								rightClassSides at: association put: #left.
								rightClassFractions
									at: association
									put: index asFloat / (associations size asFloat + 1.0) ] ] ].
	associationsOnRight keysAndValuesDo: [ :className :associations |
			associations withIndexDo: [ :association :index |
					association leftClass = className
						ifTrue: [
								leftClassSides
									at: association
									ifPresent: [
											rightClassSides at: association put: #right.
											rightClassFractions
												at: association
												put: index asFloat / (associations size asFloat + 1.0) ]
									ifAbsent: [
											leftClassSides at: association put: #right.
											leftClassFractions
												at: association
												put: index asFloat / (associations size asFloat + 1.0) ] ]
						ifFalse: [
								rightClassSides at: association put: #right.
								rightClassFractions
									at: association
									put: index asFloat / (associations size asFloat + 1.0) ] ] ].
	classDiagramNode associationsDo: [ :association |
			nodes at: association leftClass ifPresent: [ :leftShape |
					nodes at: association rightClass ifPresent: [ :rightShape |
							| leftPoint rightPoint edge |
							leftPoint := ((leftClassSides at: association ifAbsent: [ nil ])
							              = #left
								              ifTrue: [
								              leftShape encompassingRectangle topLeft ]
								              ifFalse: [
								              leftShape encompassingRectangle topRight ])
							             +
								             (0
								              @
									              ((leftClassFractions
										                at: association
										                ifAbsent: [ 0.5 ])
									               * leftShape encompassingRectangle height)).
							rightPoint := ((rightClassSides
								                at: association
								                ifAbsent: [ nil ]) = #left
								               ifTrue: [
								               rightShape encompassingRectangle topLeft ]
								               ifFalse: [
								               rightShape encompassingRectangle topRight ])
							              +
								              (0
								               @
									               ((rightClassFractions
										                 at: association
										                 ifAbsent: [ 0.5 ])
									                * rightShape encompassingRectangle height)).
							edge := self newEdgeFor: association.
							edge controlPoints: {
									leftPoint.
									(leftPoint x + rightPoint x * 0.5 @ leftPoint y).
									(leftPoint x + rightPoint x * 0.5 @ rightPoint y).
									rightPoint }.
							self renderLinkLabelsFor: edge in: aRSCanvas.
							aRSCanvas
								addShape: edge;
								addEdge: edge ] ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderClass: aMicroUMLClassNode left: left top: top subclasses: aDictionary in: aRSCanvas [

	| right bottom |
	right := left.
	bottom := top.
	nodes at: aMicroUMLClassNode name ifAbsent: [
			| shape |
			shape := self newClassBoxFor: aMicroUMLClassNode.
			shape translateBy:
				left @ top - shape encompassingRectangle topLeft
				+ (self horizontalMargin @ self verticalMargin).
			right := right max:
				         shape encompassingRectangle right + self horizontalMargin.
			bottom := bottom max:
				          shape encompassingRectangle bottom + self verticalMargin.
			aRSCanvas
				add: shape;
				addNode: shape.
			nodes at: aMicroUMLClassNode name put: shape.
			self renderLollipopsOfClass: aMicroUMLClassNode in: aRSCanvas ].
	aDictionary
		at: aMicroUMLClassNode name
		ifPresent: [ :subclassNames |
				| subclassLeft |
				subclassLeft := left.
				subclassNames do: [ :subclassName |
						(classDiagramNode classAt: subclassName) ifNotNil: [
								:subclassNode |
								subclassLeft := self
									                renderClass: subclassNode
									                left: subclassLeft
									                top: bottom
									                subclasses: aDictionary
									                in: aRSCanvas ] ].
				right := right max: subclassLeft ].
	^ right
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderClassesIn: aRSCanvas [

	| numClasses roots subclasses left |
	nodes removeAll.
	numClasses := 0.
	roots := OrderedCollection new.
	subclasses := OrderedDictionary new.
	classDiagramNode classesDo: [ :classNode |
			numClasses := numClasses + 1.
			classNode superclass
				ifNotNil: [ :superclassName |
						(classDiagramNode classAt: superclassName)
							ifNotNil: [ :superclassNode |
									(subclasses
										 at: superclassNode name
										 ifAbsentPut: [ OrderedCollection new ]) add: classNode name ]
							ifNil: [ roots add: classNode ] ]
				ifNil: [ roots add: classNode ] ].
	left := 0.0.
	roots do: [ :classNode |
			left := self
				        renderClass: classNode
				        left: left
				        top: 0.0
				        subclasses: subclasses
				        in: aRSCanvas ].
	subclasses keysAndValuesDo: [ :superclassName :subclassNames |
			(classDiagramNode classAt: superclassName) ifNotNil: [
					:superclassNode |
					(subclassNames
						 collect: [ :name | classDiagramNode classAt: name ]
						 thenSelect: #notNil) ifNotEmpty: [ :subclassNodes |
							self
								renderInheritanceFrom: superclassNode
								subclasses: subclassNodes
								in: aRSCanvas ] ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderIn: aRSCanvas [

	self renderClassesIn: aRSCanvas.
	self renderAssociationsIn: aRSCanvas.
	aRSCanvas camera translateTo: (aRSCanvas camera positionFromSpace:
			 aRSCanvas encompassingRectangle floatCenter)
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderInheritanceFrom: superclassNode subclasses: subclassNodes in: aRSCanvas [

	subclassNodes ifNotEmpty: [
			nodes at: superclassNode name ifPresent: [ :superclassShape |
					| horizontalLineY left right marker |
					horizontalLineY := superclassShape encompassingRectangle bottom
					                   + 20.0.
					left := right := superclassShape encompassingRectangle left
					                 + 10.0.
					marker := self newInheritanceMarker
						          translateBy:
							          left @ superclassShape encompassingRectangle bottom;
						          yourself.
					aRSCanvas add: marker.
					aRSCanvas add: (RSLine new
							 startPoint: left @ marker encompassingRectangle bottom;
							 endPoint: left @ horizontalLineY;
							 color: self inheritanceEdgeColor;
							 yourself).
					subclassNodes do: [ :subclassNode |
							nodes at: subclassNode name ifPresent: [ :subclassShape |
									| x y |
									x := subclassShape encompassingRectangle left + 10.0.
									y := subclassShape encompassingRectangle top.
									left := left min: x.
									right := right max: x.
									aRSCanvas add: (RSLine new
											 startPoint: x @ horizontalLineY;
											 endPoint: x @ y;
											 color: self inheritanceEdgeColor;
											 yourself) ] ].
					aRSCanvas add: (RSLine new
							 startPoint: left @ horizontalLineY;
							 endPoint: right @ horizontalLineY;
							 color: self inheritanceEdgeColor;
							 yourself) ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderLinkLabelsFor: aRSBezier in: aRSCanvas [

	aRSBezier model ifNotNil: [ :edge |
			edge label ifNotNil: [ :text |
					| label |
					label := RSLabel new text: text.
					label translateTo: (aRSBezier atT: 0.5).
					aRSCanvas add: label ].
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
					aRSCanvas add: label ].
			edge leftMultiplicity ifNotNil: [ :text |
					| label |
					label := RSLabel new text: text.
					label translateTo: aRSBezier controlPoints first + (self
							 offsetForMultiplicity: label
							 markerExtent: (aRSBezier markerStart
									  ifNotNil: [ :m | m shape encompassingRectangle extent ]
									  ifNil: [ 0 @ 0 ])
							 directing:
							 aRSBezier controlPoints second - aRSBezier controlPoints first
							 to:
							 aRSBezier controlPoints last - aRSBezier controlPoints first).
					aRSCanvas add: label ].
			edge rightMultiplicity ifNotNil: [ :text |
					| label |
					label := RSLabel new text: text.
					label translateTo: aRSBezier controlPoints last + (self
							 offsetForMultiplicity: label
							 markerExtent: (aRSBezier markerEnd
									  ifNotNil: [ :m | m shape encompassingRectangle extent ]
									  ifNil: [ 0 @ 0 ])
							 directing:
							 (aRSBezier controlPoints atLast: 2)
							 - aRSBezier controlPoints last
							 to:
							 aRSBezier controlPoints first - aRSBezier controlPoints last).
					aRSCanvas add: label ].
			edge associationClass ifNotNil: [ :associationClass |
					nodes at: associationClass ifPresent: [ :shape |
							| point1 point2 line |
							point1 := aRSBezier atT: 0.5.
							point2 := (((shape geometry intersectionsWithLine:
								             (GLine
									              through: point1
									              and: shape encompassingRectangle center))
								            collect: [ :gp |
										            | p |
										            p := gp x @ gp y.
										            (p - point1) r -> p ]) asSortedCollection:
								           #key ascending) first value.
							line := RSLine new
								        startPoint: point1;
								        endPoint: point2;
								        dashed;
								        markerEnd: (self newMarkerFor: #wedge);
								        color: Color black;
								        yourself.
							aRSCanvas add: line ] ] ]
]

{ #category : 'rendering' }
MicroUMLRoassalBuilder >> renderLollipopsOfClass: aMicroUMLClassNode in: aRSCanvas [

	nodes at: aMicroUMLClassNode name ifPresent: [ :classShape |
			| classShapeTop position |
			classShapeTop := classShape encompassingRectangle top.
			position := classShape encompassingRectangle topCenter
			            + classShape encompassingRectangle topRight * 0.5
			            - (0 @ (30.0 * aMicroUMLClassNode traits size)).
			aMicroUMLClassNode traitsDo: [ :traitName |
					| lollipopShape label |
					lollipopShape := self newLollipopMarker.
					lollipopShape translateBy: position.
					aRSCanvas
						add: lollipopShape;
						addNode: lollipopShape.
					aRSCanvas add: (RSLine new
							 startPoint: position + (0.0 @ 10.0);
							 endPoint: position x @ classShapeTop;
							 color: Color black;
							 yourself).
					label := RSLabel new
						         text: traitName asString;
						         color: Color black;
						         yourself.
					aRSCanvas add:
						(label translateTo:
							 position + (label textWidth * 0.5 + 15.0 @ 0.0)).
					position := position + (20.0 @ 30.0) ] ]
]

{ #category : 'accessing' }
MicroUMLRoassalBuilder >> verticalMargin [

	^ 50.0
]

{ #category : 'private' }
MicroUMLRoassalBuilder >> visibilityMarkFor: aMicroUMLMemberNode [

	aMicroUMLMemberNode visibility
	= aMicroUMLMemberNode defaultVisibility ifTrue: [ ^ ' ' ].
	aMicroUMLMemberNode visibility = #public ifTrue: [ ^ '+' ].
	aMicroUMLMemberNode visibility = #protected ifTrue: [ ^ '#' ].
	aMicroUMLMemberNode visibility = #private ifTrue: [ ^ '-' ].
	^ ' '
]
