Extension { #name : 'MicroUMLMemberNode' }

{ #category : '*MicroUML-Generator' }
MicroUMLMemberNode >> printMicroUMLOn: aStream [
	" #argumentTypes  . #type   "

	aStream nextPutAll: (isMethod = true
			 ifTrue: [
					 {
						 (#public -> '>+ ').
						 (#private -> '>- ') } asDictionary
						 at: visibility
						 ifAbsent: [ '>> ' ] ]
			 ifFalse: [
					 {
						 (#public -> '+ ').
						 (#private -> '- ') } asDictionary
						 at: visibility
						 ifAbsent: [ '* ' ] ]).
	self modifiers ifNotNil: [ :symbols |
			aStream nextPutAll: '{ '.
			symbols
				do: [ :symbol | symbol storeOn: aStream ]
				separatedBy: [ aStream nextPutAll: ' . ' ].
			aStream nextPutAll: ' } % ' ].
	self name storeOn: aStream.
	self argumentTypes ifNotNil: [ :symbols |
			aStream nextPutAll: '~{ '.
			symbols
				do: [ :symbol | symbol storeOn: aStream ]
				separatedBy: [ aStream nextPutAll: ' . ' ].
			aStream nextPutAll: ' }' ].
	self type ifNotNil: [ :symbol |
			aStream nextPutAll: ' @ '.
			symbol storeOn: aStream ]
]
