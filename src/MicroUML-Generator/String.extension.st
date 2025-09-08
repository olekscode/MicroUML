Extension { #name : 'String' }

{ #category : '*MicroUML-Generator' }
String >> withoutPrefix: prefix ifFollowedByUppercase: aBlock [
	"Remove the given prefix, if it's followed by an uppercase letter."

	self size > prefix size ifFalse: [ ^ self ].
	(self beginsWith: prefix) ifFalse: [ ^ self ].
	^ (self at: prefix size + 1) isUppercase
		  ifTrue: [
		  aBlock cull:(self copyFrom: prefix size + 1 to: self size) ]
		  ifFalse: [ self copyFrom: prefix size + 1 to: self size ]
]

{ #category : '*MicroUML-Generator' }
String >> withoutPrefixFollowedByUppercase: prefix [
	"Remove the given prefix, if it's followed by an uppercase letter."

	self size <= prefix size ifTrue: [ ^ self ].
	(self beginsWith: prefix) ifFalse: [ ^ self ].
	(self at: prefix size + 1) isUppercase ifFalse: [ ^ self ].
	^ self copyFrom: 1 + prefix size to: self size
]
