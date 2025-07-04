Trait {
	#name : 'TUMLTypedEntity',
	#instVars : [
		'type'
	],
	#category : 'MicroUML',
	#package : 'MicroUML'
}

{ #category : 'accessing' }
TUMLTypedEntity >> type [

	^ type
]

{ #category : 'accessing' }
TUMLTypedEntity >> type: aClass [

	type := aClass
]
