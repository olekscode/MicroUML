Class {
	#name : 'BAselineOfMicroUML',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicroUML',
	#package : 'BaselineOfMicroUML'
}

{ #category : 'baselines' }
BAselineOfMicroUML >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec
			package: 'MicroUML';
			package: 'MicroUML-Tests' with: [ spec requires: #( 'MicroUML' ) ] ]
]
