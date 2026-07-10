Class {
	#name : 'MicroUMLAttributeNode',
	#superclass : 'MicroUMLMemberNode',
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'menu operations' }
MicroUMLAttributeNode >> changeType [

	| oldType |
	oldType := self type ifNil: [ '' ].
	(self
		 request: 'Type'
		 initialAnswer: oldType
		 title: 'Change type of ' , self name) ifNotNil: [ :answer |
			self type:
				(answer trim capitalized ifNotEmpty: #asSymbol ifEmpty: [ nil ]).
			self announceDiagramChange ]
]

{ #category : 'testing' }
MicroUMLAttributeNode >> isMethod [

	^ false
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> pharoSlot [

	^ self pharoClass ifNotNil: [ :class |
			  (self isInstanceSide
				   ifTrue: [ class ]
				   ifFalse: [ class class ])
				  slotNamed: self name
				  ifFound: #yourself
				  ifNone: [ nil ] ]
]

{ #category : 'printing' }
MicroUMLAttributeNode >> printMicroUMLOn: aStream [
	" #argumentTypes  . #type   "

	aStream nextPutAll: (self isMethod
			 ifTrue: [ '> ' ]
			 ifFalse: [ '- ' ]).
	self name storeOn: aStream.
	self type ifNotNil: [ :symbol |
			aStream nextPutAll: ' @ '.
			symbol storeOn: aStream ].
	self modifiers ifNotNil: [ :symbols |
			symbols do: [ :symbol |
					aStream nextPutAll: ' % '.
					symbol storeOn: aStream ] ].
	self printActionBlockAndCommentOn: aStream
]

{ #category : 'menu operations' }
MicroUMLAttributeNode >> rename [

	| oldName |
	oldName := self name.
	(self
		 request: 'New name for the attribute'
		 initialAnswer: oldName
		 title: 'Rename ' , oldName) ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newName |
					(classNode ifNil: [ self ]) symbolsDo: [ :symbol |
							symbol = newName ifTrue: [
									^ self alert:
										  'The name ' , newName
										  , ' is already used. Try another one.' ] ].
					self name: newName asSymbol.
					self announceDiagramChange ] ]
]
