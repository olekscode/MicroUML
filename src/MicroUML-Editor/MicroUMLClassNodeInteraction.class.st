Class {
	#name : 'MicroUMLClassNodeInteraction',
	#superclass : 'RSInteraction',
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'api' }
MicroUMLClassNodeInteraction >> contextMenuFor: aMicroUMLClassNode [

	| className |
	className := aMicroUMLClassNode name.
	^ SpMenuPresenter new addGroup: [ :group |
			  Smalltalk globals at: className ifPresent: [ :global |
					  global isClass ifTrue: [
							  group addItem: [ :item |
									  item
										  name: 'Browse';
										  action: [ global browse ] ] ] ] ]
]

{ #category : 'hooks' }
MicroUMLClassNodeInteraction >> onShape: aShape [
	"opens my context menu with a right click."

	aShape
		when: RSMouseRightClick
		do: [ :evt |
				(self contextMenuFor: evt shape model) ifNotNil: [ :menu |
					menu openWithSpecAtPointer ] ]
		for: self
]
