Class {
	#name : 'MicroUMLMermaidGenerator',
	#superclass : 'Object',
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'examples' }
MicroUMLMermaidGenerator class >> example [

	^ MicroUMLAstBuilder exampleSerie2 diagram mermaidSource
]

{ #category : 'examples' }
MicroUMLMermaidGenerator class >> examplePNG [

	^ MicroUMLAstBuilder exampleSerie2 diagram mermaidPNG asPresenter
		  autoScale: true;
		  open
]

{ #category : 'utilities' }
MicroUMLMermaidGenerator class >> pakoFrom: aString [

	| json zipped pako |
	json := STONJSON toString: { ('code' -> aString) } asDictionary.
	zipped := ByteArray streamContents: [ :stream |
			          (ZLibWriteStream on: stream)
				          nextPutAll: json utf8Encoded;
				          close ].
	pako := zipped base64Encoded.
	pako := pako copyReplaceAll: '/' with: '_'.
	pako := pako copyReplaceAll: '+' with: '-'.
	[ pako last = $= ] whileTrue: [ pako := pako allButLast ].
	^ pako
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateAssociation: aMicroUMLAssociationNode into: aStream [

	aStream
		nextPutAll: aMicroUMLAssociationNode leftClass;
		space.
	aMicroUMLAssociationNode leftMultiplicity ifNotNil: [ :card |
			aStream
				nextPut: $";
				nextPutAll: card;
				nextPut: $";
				space ].
	aStream
		nextPutAll:
			(self generateLeftHead: aMicroUMLAssociationNode leftHead);
		nextPutAll: (self generateLine: aMicroUMLAssociationNode line);
		nextPutAll:
			(self generateRightHead: aMicroUMLAssociationNode rightHead);
		space.
	aMicroUMLAssociationNode rightMultiplicity ifNotNil: [ :card |
			aStream
				nextPut: $";
				nextPutAll: card;
				nextPut: $";
				space ].
	aStream nextPutAll: aMicroUMLAssociationNode rightClass.
	aMicroUMLAssociationNode label ifNotNil: [ :label |
			aStream
				nextPutAll: ' : ';
				nextPutAll: label ].
	aStream cr
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateAttribute: aMicroUMLMemberNode into: aStream [

	aStream
		space;
		space.
	aMicroUMLMemberNode visibility
	~= aMicroUMLMemberNode defaultVisibility ifTrue: [
			aMicroUMLMemberNode isPublic ifTrue: [ aStream nextPut: $+ ].
			aMicroUMLMemberNode isProtected ifTrue: [ aStream nextPut: $# ].
			aMicroUMLMemberNode isPrivate ifTrue: [ aStream nextPut: $- ] ].
	aMicroUMLMemberNode type ifNotNil: [ :type |
			aStream
				nextPutAll: type;
				space ].
	aStream nextPutAll: aMicroUMLMemberNode name.
	aMicroUMLMemberNode isClassSide ifTrue: [ aStream nextPut: $$ ].
	aMicroUMLMemberNode isAbstract ifTrue: [ aStream nextPut: $* ].
	aStream cr
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateClass: aMicroUMLClassNode into: aStream [

	aMicroUMLClassNode superclass ifNotNil: [
			aStream
				nextPutAll: aMicroUMLClassNode name;
				nextPutAll: ' --|> ';
				nextPutAll: aMicroUMLClassNode superclass;
				cr ].
	aMicroUMLClassNode traitsDo: [ :trait |
			aStream
				nextPutAll: aMicroUMLClassNode name;
				nextPutAll: ' --() ';
				nextPutAll: trait;
				cr ].
	aStream
		nextPutAll: 'class ';
		nextPutAll: aMicroUMLClassNode name;
		nextPutAll: ' {';
		cr.
	aMicroUMLClassNode isAbstract ifTrue: [
			aStream
				space;
				space;
				nextPutAll: '<<abstract>>';
				cr ].
	aMicroUMLClassNode keywordsDo: [ :keyword |
			aStream
				space;
				space;
				nextPutAll: '<<';
				nextPutAll: keyword;
				nextPutAll: '>>';
				cr ].
	aMicroUMLClassNode attributesDo: [ :memberNode |
		self generateAttribute: memberNode into: aStream ].
	aMicroUMLClassNode methodsDo: [ :memberNode |
		self generateMethod: memberNode into: aStream ].
	aStream
		nextPut: $};
		cr
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateDiagram: aMicroUMLDiagramNode [

	^ String streamContents: [ :stream |
		  self generateDiagram: aMicroUMLDiagramNode into: stream ]
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateDiagram: aMicroUMLDiagramNode into: aStream [

	aStream
		nextPutAll: 'classDiagram';
		cr.
	aMicroUMLDiagramNode classesDo: [ :classNode |
		self generateClass: classNode into: aStream ].
	aMicroUMLDiagramNode associationsDo: [ :associationNode |
		self generateAssociation: associationNode into: aStream ]
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateLeftHead: aSymbol [

	aSymbol = #aggregation ifTrue: [ ^ 'o' ].
	aSymbol = #composition ifTrue: [ ^ '*' ].
	aSymbol = #wedge ifTrue: [ ^ '<' ].
	^ ''
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateLine: aSymbol [

	aSymbol = #dashed ifTrue: [ ^ '..' ].
	^ '--'
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateMethod: aMicroUMLMemberNode into: aStream [

	aStream
		space;
		space.
	aMicroUMLMemberNode visibility
	~= aMicroUMLMemberNode defaultVisibility ifTrue: [
			aMicroUMLMemberNode isPublic ifTrue: [ aStream nextPut: $+ ].
			aMicroUMLMemberNode isProtected ifTrue: [ aStream nextPut: $# ].
			aMicroUMLMemberNode isPrivate ifTrue: [ aStream nextPut: $- ] ].
	aStream
		nextPutAll: aMicroUMLMemberNode name;
		nextPut: $(.
	aMicroUMLMemberNode argumentTypes ifNotNil: [ :types |
			types
				do: [ :type | aStream nextPutAll: type ]
				separatedBy: [ aStream nextPutAll: ', ' ] ].
	aStream nextPut: $).
	aMicroUMLMemberNode type ifNotNil: [ :type |
			aStream
				nextPutAll: ' : ';
				nextPutAll: type ].
	aStream nextPutAll: aMicroUMLMemberNode name.
	aMicroUMLMemberNode isClassSide ifTrue: [ aStream nextPut: $$ ].
	aMicroUMLMemberNode isAbstract ifTrue: [ aStream nextPut: $* ].
	aStream cr
]

{ #category : 'generating' }
MicroUMLMermaidGenerator >> generateRightHead: aSymbol [

	aSymbol = #aggregation ifTrue: [ ^ 'o' ].
	aSymbol = #composition ifTrue: [ ^ '*' ].
	aSymbol = #wedge ifTrue: [ ^ '>' ].
	^ ''
]
