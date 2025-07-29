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
