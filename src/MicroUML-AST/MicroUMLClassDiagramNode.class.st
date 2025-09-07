Class {
	#name : 'MicroUMLClassDiagramNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'classes',
		'associations'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> associations [

	^ Array streamContents: [ :stream |
		  self associationsDo: [ :association | stream nextPut: association ] ]
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> associations: aCollectionOfMicroUMLAssociationNode [

	| newAssociations |
	newAssociations := OrderedDictionary new.
	aCollectionOfMicroUMLAssociationNode do: [ :associationNode |
			(newAssociations
				 at: associationNode leftClass
				 ifAbsentPut: [ OrderedCollection new ]) add: associationNode ].
	associations := newAssociations
]

{ #category : 'enumerating' }
MicroUMLClassDiagramNode >> associationsDo: aBlock [

	associations valuesDo: [ :assocs | assocs do: aBlock ]
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> associationsForLeftClass: aSymbol [

	^ associations at: aSymbol ifPresent: #asArray ifAbsent: [ #(  ) ]
]

{ #category : 'class access' }
MicroUMLClassDiagramNode >> astBuilderClass [

	^ MicroUMLAstBuilder
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> classAt: aSymbol [

	^ classes at: aSymbol
]

{ #category : 'class access' }
MicroUMLClassDiagramNode >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> classes [

	^ classes values asArray
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> classes: aCollectionOfMicroUMLClassNode [

	classes := (aCollectionOfMicroUMLClassNode collect: [ :classNode |
		            classNode name -> classNode ]) asOrderedDictionary
]

{ #category : 'enumerating' }
MicroUMLClassDiagramNode >> classesDo: aBlock [

	classes valuesDo: aBlock
]

{ #category : 'accessing' }
MicroUMLClassDiagramNode >> ensureClassNamed: aSymbol [

	^ classes at: aSymbol ifAbsentPut: [
			  self classNodeClass new
				  name: aSymbol;
				  yourself ]
]

{ #category : 'initialization' }
MicroUMLClassDiagramNode >> initialize [

	super initialize.
	classes := OrderedDictionary new.
	associations := OrderedDictionary new
]

{ #category : 'printing' }
MicroUMLClassDiagramNode >> microUMLSource [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'printing' }
MicroUMLClassDiagramNode >> printMicroUMLOn: aStream [

	self printMicroUMLOn: aStream associationsUnderClasses: true
]

{ #category : 'printing' }
MicroUMLClassDiagramNode >> printMicroUMLOn: aStream associationsUnderClasses: aBoolean [

	aBoolean = true
		ifTrue: [ self printMicroUMLWithAssociationsUnderClassesOn: aStream ]
		ifFalse: [
		self printMicroUMLWithAssociationsOutsideClassesOn: aStream ]
]

{ #category : 'printing' }
MicroUMLClassDiagramNode >> printMicroUMLWithAssociationsOutsideClassesOn: aStream [

	aStream nextPutAll: self astBuilderClass name.
	self classesDo: [ :classNode |
			classNode isEmptyDefinition ifFalse: [
					aStream
						cr;
						nextPutAll: '===';
						cr.
					classNode printMicroUMLOn: aStream ] ].
	self associationsDo: [ :associationNode |
			aStream
				cr;
				nextPutAll: '===';
				cr.
			associationNode printMicroUMLOn: aStream ]
]

{ #category : 'printing' }
MicroUMLClassDiagramNode >> printMicroUMLWithAssociationsUnderClassesOn: aStream [

	aStream nextPutAll: self astBuilderClass name.
	self classesDo: [ :classNode |
			aStream
				cr;
				nextPutAll: '===';
				cr.
			classNode printMicroUMLOn: aStream.
			(self associationsForLeftClass: classNode name) ifNotEmpty: [
					:assocs |
					(classNode isEmptyDefinition and: [ assocs size = 1 ])
						ifTrue: [
								aStream space.
								assocs first printMicroUMLInLeftClassOn: aStream ]
						ifFalse: [
								assocs do: [ :associationNode |
										aStream
											cr;
											nextPutAll: '  '.
										associationNode printMicroUMLInLeftClassOn: aStream ] ] ] ]
]
