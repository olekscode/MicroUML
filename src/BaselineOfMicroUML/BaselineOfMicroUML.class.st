Class {
	#name : 'BaselineOfMicroUML',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicroUML',
	#package : 'BaselineOfMicroUML'
}

{ #category : 'baselines' }
BaselineOfMicroUML >> baseline: spec [

	<baseline>
	spec for: #common do: [
			"Dependencies"
			spec
				baseline: 'RoassalExporters'
				with: [ spec repository: 'github://pharo-graphics/RoassalExporters:v1.02' ].
			
			"Packages"
			spec
				package: 'MicroUML-AST';
				package: 'MicroUML-Builder';
				package: 'MicroUML-Generator';
				package: 'MicroUML-Editor'
				with: [ spec requires: #(RoassalExporters) ];
				package: 'MicroUML-Tests'
				with: [ spec requires: #('MicroUML-AST' 'MicroUML-Builder' 'MicroUML-Generator' 'MicroUML-Editor') ] ]
]
