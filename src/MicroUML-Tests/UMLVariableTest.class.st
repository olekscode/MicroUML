Class {
	#name : 'UMLVariableTest',
	#superclass : 'TestCase',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'tests' }
UMLVariableTest >> testCreateVariableNamed [

	| var |
	var := UMLVariable named: #age.
	
	self assert: var class equals: UMLVariable.
	self assert: var name equals: #age
]
