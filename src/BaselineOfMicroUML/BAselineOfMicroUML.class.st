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
			"Packages"
			spec
				package: 'MicroUML-AST';
				package: 'MicroUML-Builder';
				package: 'MicroUML-Generator';
				package: 'MicroUML-Editor';
				package: 'MicroUML-Tests'
				with: [ spec requires: #( 'MicroUML-AST' 'MicroUML-Builder' 'MicroUML-Generator' 'MicroUML-Editor' ) ] ]
]
