Class {
	#name : 'MicroUMLCanvasController',
	#superclass : 'RSCanvasController',
	#instVars : [
		'builder'
	],
	#category : 'MicroUML-Editor-Roassal3',
	#package : 'MicroUML-Editor',
	#tag : 'Roassal3'
}

{ #category : 'accessing' }
MicroUMLCanvasController >> builder [

	^ builder
]

{ #category : 'accessing' }
MicroUMLCanvasController >> builder: aMicroUMLRoassalBuilder [

	builder := aMicroUMLRoassalBuilder
]

{ #category : 'operations' }
MicroUMLCanvasController >> decreaseMargin [

	builder ifNotNil: [
			builder
				horizontalMargin: (builder horizontalMargin - 5 min: 100 max: 15);
				verticalMargin: (builder verticalMargin - 5 min: 100 max: 15).
			builder canvas shapes do: #remove.
			builder build signalUpdate ]
]

{ #category : 'initialization' }
MicroUMLCanvasController >> defaultInteractions [
	"create a subclass of RSCanvasController and define your own custom interactions for your canvas"

	^ {
		  RSDraggableCanvasInteraction.
		  RSKeyNavigationCanvasInteraction.
		  RSScrollBarsCanvasInteraction.
		  RSSearchInCanvasInteraction.
		  RSZoomToFitCanvasInteraction }
]

{ #category : 'operations' }
MicroUMLCanvasController >> increaseMargin [

	builder ifNotNil: [
			builder
				horizontalMargin: (builder horizontalMargin + 5 min: 100 max: 5);
				verticalMargin: (builder verticalMargin + 5 min: 100 max: 5).
			builder canvas shapes do: #remove.
			builder build signalUpdate ]
]

{ #category : 'hooks' }
MicroUMLCanvasController >> onShape: aRSCanvas [

	super onShape: aRSCanvas.
	aRSCanvas when: RSKeyStroke send: #processKeystroke: to: self
]

{ #category : 'events' }
MicroUMLCanvasController >> processKeyDown: event [
	event keyValue = $< codePoint ifTrue: [ ^self decreaseMargin ].
	event keyValue = $> codePoint ifTrue: [ ^ self increaseMargin ]
	"event shiftKeyPressed ifTrue: [
			| keyName |
			keyName := event keyName.
			keyName = #PERIOD ifTrue: [ ^ self increaseMargin ].
			keyName = #COMMA ifTrue: [ ^ self decreaseMargin ] ]"
]

{ #category : 'events' }
MicroUMLCanvasController >> processKeystroke: event [

	event keyValue = $< codePoint ifTrue: [ ^ self decreaseMargin ].
	event keyValue = $> codePoint ifTrue: [ ^ self increaseMargin ]
]

{ #category : 'hooks' }
MicroUMLCanvasController >> renderLegendOn: aCanvas [

	| lb |
	self shouldShowLegend ifFalse: [ ^ self ].
	lb := RSLegend new
		      container: aCanvas;
		      yourself.
	lb defaultTitle fontSize: 12.
	lb defaultLabel fontSize: 10.
	lb defaultBoldText fontSize: 10.
	lb legendDo: [ :l |
			l
				border: RSBorder new;
				color: (Color white alpha: 0.8);
				padding: 10 ].
	lb title: 'Shortcuts'.
	self interactions do: [ :int | int renderLegendOn: lb ].
	lb
		text: '<' description: 'Decrease margins between classes';
		text: '>' description: 'Increase margins between classes'.
	lb onDemand.
	lb build
]
