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

{ #category : 'examples' }
MicroUMLEditor class >> exampleWithDiagram [
	<example>
	| uml |
	
	uml :=
	#AbstractSeries 
    	+ #name @ String 
    	* #numEpisodes @ Integer
	=== 
	#NovelSeries 
    	--|> #AbstractSeries
    	+ #author @ String 
    	+ #Publisher @ String 
    	>+ #read~{}
	=== 
	#ComicSeries 
    	--|> #AbstractSeries 
    	+ #toonAuthor @ String
    	* #storyAuthor @ String
   		>+ #print~{}
	=== 
	#AnimeSeries
		--|> #AbstractSeries 
		+ #director @ String 
		* #animators @ String
		* #voiceActors @ String
		>+ #play~{} <>---<'based on'> #ComicSeries
	=== 
	#ComicSeries ---<'original'> #NovelSeries.
	
	(self withDiagram: uml diagram) open
]

{ #category : 'as yet unclassified' }
MicroUMLEditor class >> withDiagram: aDiagram [

	^ self new
		showDiagram: aDiagram;
		yourself
]

{ #category : 'compiling' }
MicroUMLEditor >> compileUml [

	^ Smalltalk compiler evaluate: code text
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
		       ifNotEmpty: [ self compileUml ].

	builder classDiagramNode: uml diagram.
	builder canvas clear.
	builder build.
	builder canvas @ RSCanvasController.
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
		whenActivatedDo: [ 
			self drawDiagram.
			drawButton disable ];
		whenDeactivatedDo: [ drawButton enable ];
		yourself.
		
	toolbar add: drawButton.
	toolbar add: liveDrawingButton.
	
	toolbar add: (self newToolbarButton
		label: 'Save PNG';
		icon: (self iconNamed: #smallScreenshot);
		action: [ self saveAsPng ];
		yourself).
		
	toolbar add: (self newToolbarButton
		label: 'Inspect';
		icon: (self iconNamed: #inspect);
		action: [ self compileUml inspect ])
]

{ #category : 'initialization' }
MicroUMLEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter 
		title: 'MicroUML';
		initialExtent: 1300@800.
]

{ #category : 'as yet unclassified' }
MicroUMLEditor >> saveAsPng [

	(StSaveFilePresenter extensions: {'png'})
		okAction: [ :fileReference | 
			RSPNGExporter new
				canvas: preview canvas;
				exportToFile: fileReference ]

	
]

{ #category : 'as yet unclassified' }
MicroUMLEditor >> showDiagram: aDiagram [

	code text: aDiagram microUML.
	self drawDiagram
]
