Class {
	#name : 'MicroUMLBrowser',
	#superclass : 'SpPresenter',
	#instVars : [
		'packageList',
		'packageFilter',
		'editor',
		'packageName',
		'showsPackageList',
		'showsCode',
		'showsPreview'
	],
	#category : 'MicroUML-Editor-Spec2',
	#package : 'MicroUML-Editor',
	#tag : 'Spec2'
}

{ #category : 'examples' }
MicroUMLBrowser class >> example [

	<example>
	self new open
]

{ #category : 'examples' }
MicroUMLBrowser class >> examplePackage [

	<example>
	self new
		packageFilter: 'MicroUML';
		packageName: 'MicroUML-AST';
		open
]

{ #category : 'menu operations' }
MicroUMLBrowser >> addPackage [

	(self
		 request: 'Name of the new package:'
		 initialAnswer: (packageName ifNil: [ '' ])
		 title: 'Create a new package') ifNotNil: [ :string |
			string trim ifNotEmpty: [ :newPackageName |
					self packageOrganizer packageNamed: newPackageName ifAbsent: [
							self packageOrganizer addPackage: newPackageName.
							self updatePackageList ].
					self packageName: newPackageName ] ]
]

{ #category : 'accessing' }
MicroUMLBrowser >> colorFor: aMicroUMLAstNode [

	self packageDo: [ :package |
			aMicroUMLAstNode isMicroUMLClassNode ifTrue: [
					aMicroUMLAstNode pharoClass ifNotNil: [ :class |
						class package name ~= package name ifTrue: [
							^ self outOfPackageColor ] ].
					^ self defaultColor ].
			aMicroUMLAstNode isMicroUMLMemberNode ifTrue: [
					aMicroUMLAstNode isAttribute
						ifTrue: [ ^ self colorFor: aMicroUMLAstNode classNode ]
						ifFalse: [
								aMicroUMLAstNode pharoMethod ifNotNil: [ :method |
										method package name ~= package name ifTrue: [
											^ self outOfPackageColor ] ].
								^ self defaultColor ] ] ].
	^ self defaultColor
]

{ #category : 'ui requests' }
MicroUMLBrowser >> confirm: queryString label: titleString [

	^ self application newConfirm
		  title: titleString;
		  label: queryString;
		  openModal
]

{ #category : 'initialization' }
MicroUMLBrowser >> connectPresenters [

	packageList whenSelectionChangedDo: [ :selection |
		self packageListSelectionChanged ].
	
	packageFilter whenSubmitDo: [ :txt | self packageFilterChanged ]
]

{ #category : 'accessing' }
MicroUMLBrowser >> defaultColor [

	^ Color black
]

{ #category : 'layout' }
MicroUMLBrowser >> defaultLayout [

	^ SpPanedLayout newHorizontal
		positionOfSlider: 0.2;
		add: (SpBoxLayout newVertical
			add: packageList;
			add: packageFilter expand: false;
			yourself);
		add: editor;
		yourself
]

{ #category : 'accessing' }
MicroUMLBrowser >> defaultPackageName [

	^ '__MicroUML-Generated__'
]

{ #category : 'examples' }
MicroUMLBrowser >> example [

	<script: 'self example'>
]

{ #category : 'examples' }
MicroUMLBrowser >> examplePackage [

	<script: 'self examplePackage'>
]

{ #category : 'generating' }
MicroUMLBrowser >> generateFromPharoPackage [

	self packageDo: [ :package |
			(MicroUMLClassDiagramGenerator classDiagramFromPackage: package)
				ifNotNil: [ :uml | editor showDiagram: uml ] ]
]

{ #category : 'initialization' }
MicroUMLBrowser >> initialize [

	super initialize.
	packageName := self defaultPackageName.
]

{ #category : 'initialization' }
MicroUMLBrowser >> initializePresenters [

	packageList := self newList
		               contextMenu: [ self packageListContextMenu ];
		               yourself.
	packageFilter := self newTextInput
		                 placeholder: 'Filter...';
		                 yourself.
	self updatePackageList.
	
	editor := MicroUMLEditor new.
]

{ #category : 'initialization' }
MicroUMLBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 1300 @ 800
]

{ #category : 'accessing' }
MicroUMLBrowser >> outOfPackageColor [

	^ Color lightGray
]

{ #category : 'accessing' }
MicroUMLBrowser >> packageDo: aBlock [

	^ self packageOrganizer
		  packageNamed: self packageName
		  ifPresent: aBlock
]

{ #category : 'accessing' }
MicroUMLBrowser >> packageFilter: aString [

	packageFilter text: aString.
	self packageFilterChanged
]

{ #category : 'updating' }
MicroUMLBrowser >> packageFilterChanged [

	self updatePackageList
]

{ #category : 'menus' }
MicroUMLBrowser >> packageListContextMenu [

	^ self newMenu
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'New package';
								  iconName: #add;
								  action: [ self addPackage ] ].
				  packageList selectedItem ifNotNil: [
						  group addItem: [ :item |
								  item
									  name: 'Remove';
									  iconName: #remove;
									  action: [ self removePackage ] ] ] ];
		  yourself
]

{ #category : 'updating' }
MicroUMLBrowser >> packageListSelectionChanged [

	packageList selectedItem ifNotNil: [ :selectedPackageName |
		self packageName: selectedPackageName ]
]

{ #category : 'accessing' }
MicroUMLBrowser >> packageName [

	^ packageName
]

{ #category : 'accessing' }
MicroUMLBrowser >> packageName: aString [

	| newPackageName |
	newPackageName := aString asString trim.
	newPackageName = packageName ifFalse: [
			packageName := aString asString trim.
			self packageNameChanged ]
]

{ #category : 'updating' }
MicroUMLBrowser >> packageNameChanged [

	self updateWindowTitle.
	self updatePackageListSelection.
	self generateFromPharoPackage
]

{ #category : 'testing' }
MicroUMLBrowser >> pharoPackageIncludesClassNamed: aString [

	self packageDo: [ :package |
		^ package classes contains: [ :class |
			  class name asString = aString ] ].
	^ false
]

{ #category : 'menu operations' }
MicroUMLBrowser >> removePackage [

	self packageDo: [ :package |
			(self
				 confirm: 'Are you sure you want to delete the ' , package name
					 , ' package with its contents?'
				 label: 'Remove package: ' , package name) ifTrue: [
					package removeFromSystem.
					self updatePackageList.
					^ self ] ].
	^ nil
]

{ #category : 'updating' }
MicroUMLBrowser >> updatePackageList [

	packageList items: (((packageFilter text asString substrings: '|')
			  collect: #trim
			  thenSelect: #notEmpty)
			 ifNotEmpty: [ :keywords |
					 self packageOrganizer packageNames select: [ :name |
						 keywords anySatisfy: [ :keyword |
							 (name findString: keyword) > 0 ] ] ]
			 ifEmpty: [ self packageOrganizer packageNames ]) sorted.
	self updatePackageListSelection
]

{ #category : 'updating' }
MicroUMLBrowser >> updatePackageListSelection [

	packageList selectItem: packageName
]

{ #category : 'updating' }
MicroUMLBrowser >> updateWindowTitle [

	self window ifNotNil: [ :window |
		window title: 'MicroUML : ' , packageName ]
]

{ #category : 'updating' }
MicroUMLBrowser >> windowTitle [

	^ packageName
		  ifNotNil: [ :name | 'MicroUML : ' , name ]
		  ifNil: [ 'MicroUML' ]
]
