Class {
	#name : 'MicroUMLEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'code',
		'preview',
		'toolbar',
		'liveDrawingButton',
		'builder'
	],
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'examples' }
MicroUMLEditor class >> example [
	<example>
	self new open
]

{ #category : 'initialization' }
MicroUMLEditor >> connectPresenters [

	code whenSubmitDo: [ :text | self drawDiagram ].
	
	code whenTextChangedDo: [ :text |
		liveDrawingButton isSelected ifTrue: [
			[ self drawDiagram ] onErrorDo: [ "do nothing" ] ] ]
]

{ #category : 'layout' }
MicroUMLEditor >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 4;
		add: toolbar expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 4;
			add: code;
			add: preview;
			yourself);
		yourself
]

{ #category : 'as yet unclassified' }
MicroUMLEditor >> disableLiveDrawing [

	code whenTextChangedDo: [ :text | "do nothing" ]
]

{ #category : 'as yet unclassified' }
MicroUMLEditor >> drawDiagram [

	| uml |
	
	uml := code text trimmed
		ifEmpty: [ MicroUMLAstBuilder new ]
		ifNotEmpty: [ Smalltalk compiler evaluate: code text ].
	
	builder classDiagramNode: uml diagram.
	builder canvas clear.
	builder build.
	builder container signalUpdate
]

{ #category : 'as yet unclassified' }
MicroUMLEditor >> enableLiveDrawing [

	code whenTextChangedDo: [ :text |
		[ self drawDiagram ] onErrorDo: [ "do nothing" ] ]
]

{ #category : 'examples' }
MicroUMLEditor >> example [
	<script: 'self example'>
]

{ #category : 'initialization' }
MicroUMLEditor >> initializePresenters [

	code := self newCode.
	
	builder := MicroUMLRoassalBuilder new.
	self drawDiagram.
	
	preview := builder asPresenter.
	
	toolbar := self newToolbar.
	self initializeToolbar
		
	
]

{ #category : 'initialization' }
MicroUMLEditor >> initializeToolbar [

	| drawButton |

	drawButton := self newToolbarButton
		label: 'Draw';
		icon: (self iconNamed: #go);
		action: [ self drawDiagram ];
		yourself.
		
	liveDrawingButton := self newToolbarToggleButton
		label: 'Live';
		icon: (self iconNamed: #autoReload);
		whenActivatedDo: [ drawButton disable ];
		whenDeactivatedDo: [ drawButton enable ];
		yourself.
		
	toolbar add: drawButton.
	toolbar add: liveDrawingButton
]

{ #category : 'initialization' }
MicroUMLEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter 
		title: 'MicroUML';
		initialExtent: 1300@800.
]
