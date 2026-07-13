Extension { #name : 'RSAthensMorph' }

{ #category : '*MicroUML-Editor' }
RSAthensMorph >> handleKeystroke: anEvent [
	super handleKeystroke: anEvent.
	eventProcessor eventKeystroke: anEvent
]
