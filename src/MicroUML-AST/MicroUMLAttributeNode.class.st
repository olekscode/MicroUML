"
I represent an AST node for UML class attribute.
I have name(symbol) and type (symbol or nil if omitted).
My visibility is either #public or #private.
"
Class {
	#name : 'MicroUMLAttributeNode',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'visibility'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLAttributeNode >> bePrivate [

	visibility := #private
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> bePublic [

	visibility := #public
]

{ #category : 'testing' }
MicroUMLAttributeNode >> isPrivate [

	^ visibility = #private
]

{ #category : 'testing' }
MicroUMLAttributeNode >> isPublic [

	^ visibility = #public
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> name: aSymbol [

	name := aSymbol asSymbol
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> type [

	^ type
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> type: aSymbol [

	type := aSymbol asSymbol
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
MicroUMLAttributeNode >> visibility: aSymbol [

	visibility := aSymbol
]
