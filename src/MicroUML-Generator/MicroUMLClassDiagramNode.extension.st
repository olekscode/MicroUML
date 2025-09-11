Extension { #name : 'MicroUMLClassDiagramNode' }

{ #category : '*MicroUML-Generator' }
MicroUMLClassDiagramNode >> mermaidPNG [

	| url |
	url := 'https://mermaid.ink/img/pako:'
	       , (MicroUMLMermaidGenerator pakoFrom: self mermaidSource)
	       , '?type=png'.
	^ ZnEasy getPng: url asZnUrl
]

{ #category : '*MicroUML-Generator' }
MicroUMLClassDiagramNode >> mermaidSource [

	^ MicroUMLMermaidGenerator new generateDiagram: self
]

{ #category : '*MicroUML-Generator' }
MicroUMLClassDiagramNode >> writeMermaidSourceInto: aStream [

	^ MicroUMLMermaidGenerator new generateDiagram: self into: aStream
]
