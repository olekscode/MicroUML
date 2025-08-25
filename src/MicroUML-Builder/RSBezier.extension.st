Extension { #name : 'RSBezier' }

{ #category : '*MicroUML-Builder' }
RSBezier >> atT: aNumber [

	| c b a via1 via2 start end cp t |
	cp := controlPoints.
	cp size < 3 ifTrue: [ ^ nil ].
	start := cp first.
	via1 := cp second.
	via2 := cp third.
	end := cp size = 3
		       ifTrue: [ via2 ]
		       ifFalse: [ cp fourth ].
	c := 3 * (via1 - start).
	b := 3 * (via2 - via1) - c.
	a := end - start - c - b.
	t := aNumber asFloat min: 1.0 max: 0.0.
	^ a * (t raisedTo: 3) + (b * (t * t)) + (c * t) + start
]
