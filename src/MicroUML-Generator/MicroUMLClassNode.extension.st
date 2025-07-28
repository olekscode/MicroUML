Extension { #name : 'MicroUMLClassNode' }

{ #category : '*MicroUML-Generator' }
MicroUMLClassNode >> printMicroUMLOn: aStream [

	self modifiers ifNotNil: [ :modifiers |
			aStream nextPutAll: '{ '.
			modifiers
				do: [ :modifier | modifier storeOn: aStream ]
				separatedBy: [ aStream nextPutAll: ' . ' ].
			aStream nextPutAll: ' } % ' ].
	self name asSymbol storeOn: aStream.
	self superclass ifNotNil: [ :superclassName |
			aStream nextPutAll: ' --|> '.
			superclassName asSymbol storeOn: aStream ].
	self members ifNotEmpty: [
			aStream cr.
			self members
				do: [ :member |
						aStream
							space;
							space.
						member printMicroUMLOn: aStream ]
				separatedBy: [ aStream cr ] ]
]
