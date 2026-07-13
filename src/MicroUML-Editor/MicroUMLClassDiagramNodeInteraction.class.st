Class {
	#name : 'MicroUMLClassDiagramNodeInteraction',
	#superclass : 'RSAbstractControlCanvasInteraction',
	#instVars : [
		'diagram'
	],
	#category : 'MicroUML-Editor-Roassal3',
	#package : 'MicroUML-Editor',
	#tag : 'Roassal3'
}

{ #category : 'menus' }
MicroUMLClassDiagramNodeInteraction >> contextMenu [

	^ SpMenuPresenter new
		  title: 'Class Diagram';
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'Add class...';
								  action: [ diagram ifNotNil: #addClass ] ] ];
		  yourself
]

{ #category : 'accessing' }
MicroUMLClassDiagramNodeInteraction >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLClassDiagramNodeInteraction >> diagram: aMicroUMLClassDiagramNode [

	diagram := aMicroUMLClassDiagramNode
]

{ #category : 'hooks' }
MicroUMLClassDiagramNodeInteraction >> onShape: aCanvas [

	aCanvas removeInteractionIfPresent: self class.
	aCanvas
		when: RSMouseRightClick
		do: [ :event | self contextMenu openWithSpecAtPointer ]
		for: self
]

{ #category : 'rendering' }
MicroUMLClassDiagramNodeInteraction >> renderLegendOn: anRSLegend [

	
]
