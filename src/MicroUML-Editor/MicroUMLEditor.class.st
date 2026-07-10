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
MicroUMLEditor class >> exampleArrayHierarchy [

	<example>
	| uml |
	uml := MicroUMLClassDiagramGenerator new
		       generateClass: ArrayedCollection;
		       generateClass: Array;
		       generateClass: Float64Array;
		       generateClass: IntegerArray;
		       generateClass: PointArray;
		       diagram.
	(self withDiagram: uml) open
]

{ #category : 'examples' }
MicroUMLEditor class >> examplePackage [

	<example>
	self new
		packageFilter: 'MicroUML';
		packageName: 'MicroUML-AST';
		open
]

{ #category : 'examples' }
MicroUMLEditor class >> exampleWithDiagram [
	<example>
	| uml |
	uml := MicroUMLAstBuilder exampleSerie2.
	(self withDiagram: uml diagram) open
]

{ #category : 'instance creation' }
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
				[ self drawDiagram ] onErrorDo: [ "do nothing" ] ] ].
]

{ #category : 'layout' }
MicroUMLEditor >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 4;
		add: toolbar expand: false;
		add: (SpPanedLayout newHorizontal
			add: code;
			add: preview;
			yourself);
		yourself
]

{ #category : 'updating' }
MicroUMLEditor >> diagramChanged: aMicroUMLClassDiagramChangedAnnouncement [

	self showDiagram: aMicroUMLClassDiagramChangedAnnouncement diagram
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> disableLiveDrawing [

	code whenTextChangedDo: [ :text | "do nothing" ]
]

{ #category : 'drawing' }
MicroUMLEditor >> drawDiagram [

	| diagram astNodeInteraction |
	diagram := (code text trimmed
		            ifEmpty: [ MicroUMLAstBuilder new ]
		            ifNotEmpty: [ self compileUml ]) diagram.
	diagram announcer
		when: MicroUMLClassDiagramChangedAnnouncement
		send: #diagramChanged:
		to: self.
	builder classDiagramNode: diagram.
	builder canvas shapes copy do: [ :shape | shape remove ].
	builder build.
	astNodeInteraction := MicroUMLBrowserNodeInteraction new.
	builder canvas allChildren do: [ :shape |
		shape model isMicroUMLAstNode ifTrue: [ shape @ astNodeInteraction ] ].
	builder canvas @ (MicroUMLCanvasController new builder: builder).
	builder canvas @ (MicroUMLClassDiagramNodeInteraction new
		 diagram: diagram;
		 yourself).
	builder container signalUpdate
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> enableLiveDrawing [

	code whenTextChangedDo: [ :text |
		[ self drawDiagram ] onErrorDo: [ "do nothing" ] ]
]

{ #category : 'examples' }
MicroUMLEditor >> example [
	<script: 'self example'>
]

{ #category : 'generating' }
MicroUMLEditor >> generateClasses [

	| generator |
	generator := MicroUMLCodeGenerator forDiagram:
		             self compileUml diagram.
	generator generateClassesInPackageNamed: self packageName
]

{ #category : 'accessing' }
MicroUMLEditor >> horizontalMargin [

	^ builder
]

{ #category : 'initialization' }
MicroUMLEditor >> initializePresenters [

	code := self newCode.
	builder := MicroUMLRoassalBuilder new yourself.
	"colorBlock: [ :node | self colorFor: node ];"

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

	"	toolbar add: (self newToolbarButton
			 label: 'Generate';
			 icon: (self iconNamed: #smallNew);
			 action: [ self generateClasses ];
			 yourself)."

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
	aWindowPresenter initialExtent: 1300 @ 800
]

{ #category : 'file IO' }
MicroUMLEditor >> saveAsPng [

	(StSaveFilePresenter extensions: {'png'})
		okAction: [ :fileReference | 
			RSPNGExporter new
				canvas: preview canvas;
				exportToFile: fileReference ]

	
]

{ #category : 'drawing' }
MicroUMLEditor >> showDiagram: aDiagram [

	code text: aDiagram microUML.
	self drawDiagram
]
