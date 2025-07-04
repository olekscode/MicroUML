Trait {
	#name : 'TUMLNamedEntity',
	#instVars : [
		'name'
	],
	#category : 'MicroUML',
	#package : 'MicroUML'
}

{ #category : 'instance creation' }
TUMLNamedEntity classSide >> named: aString [

	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
TUMLNamedEntity >> name [

	^ name
]

{ #category : 'accessing' }
TUMLNamedEntity >> name: aString [

	name := aString
]
