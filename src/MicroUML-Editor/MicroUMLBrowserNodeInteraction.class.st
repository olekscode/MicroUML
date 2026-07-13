Class {
	#name : 'MicroUMLBrowserNodeInteraction',
	#superclass : 'RSInteraction',
	#instVars : [
		'box'
	],
	#category : 'MicroUML-Editor-Roassal3',
	#package : 'MicroUML-Editor',
	#tag : 'Roassal3'
}

{ #category : 'menus' }
MicroUMLBrowserNodeInteraction >> contextMenuFor: aRSShape [

	aRSShape model ifNotNil: [ :model |
			(model isKindOf: MicroUMLClassNode) ifTrue: [
				^ self contextMenuForClassNode: model ].
			(model isKindOf: MicroUMLAttributeNode) ifTrue: [
				^ self contextMenuForAttributeNode: model ].
			(model isKindOf: MicroUMLMethodNode) ifTrue: [
				^ self contextMenuForMethodNode: model ].
			(model isKindOf: MicroUMLAssociationNode) ifTrue: [
				^ self contextMenuForAssociationNode: model ] ].
	^ nil
]

{ #category : 'menus' }
MicroUMLBrowserNodeInteraction >> contextMenuForAssociationNode: aMicroUMLAssociationNode [

	^ SpMenuPresenter new
		  title: aMicroUMLAssociationNode leftClass , ' - '
			  , aMicroUMLAssociationNode rightClass;
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: aMicroUMLAssociationNode removeIcon;
								  action: [ aMicroUMLAssociationNode remove ] ] ];
		  addGroup: [ :group |
				  aMicroUMLAssociationNode isAggregation ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be aggregation';
									  action: [
											  aMicroUMLAssociationNode
												  beAggregation;
												  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isComposition ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be composition';
									  action: [
											  aMicroUMLAssociationNode
												  beComposition;
												  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isNoAggregation ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be non-aggregation';
									  action: [
											  aMicroUMLAssociationNode
												  beNoAggregation;
												  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isDependency ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dependency';
									  action: [
											  aMicroUMLAssociationNode
												  beDependency;
												  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isDirected
					  ifTrue: [
							  group addItem: [ :item |
									  item
										  name: 'Be not directed';
										  action: [
												  aMicroUMLAssociationNode
													  beNotDirected;
													  announceDiagramChange ] ] ]
					  ifFalse: [
							  group addItem: [ :item |
									  item
										  name: 'Be directed';
										  action: [
												  aMicroUMLAssociationNode
													  beDirected;
													  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isSolid ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be solid line';
									  action: [
											  aMicroUMLAssociationNode
												  beSolid;
												  announceDiagramChange ] ] ].
				  aMicroUMLAssociationNode isDashed ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dashed line';
									  action: [
											  aMicroUMLAssociationNode
												  beDashed;
												  announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: aMicroUMLAssociationNode leftClass;
								  subMenu: aMicroUMLAssociationNode contextMenuOnLeft ];
					  addItem: [ :item |
							  item
								  name: aMicroUMLAssociationNode rightClass;
								  subMenu: aMicroUMLAssociationNode contextMenuOnRight ];
					  addItem: [ :item |
							  item
								  name: 'Change label...';
								  action: [ aMicroUMLAssociationNode changeLabel ] ] ];
		  yourself
]

{ #category : 'menus' }
MicroUMLBrowserNodeInteraction >> contextMenuForAttributeNode: aMicroUMLAttributeNode [

	^ SpMenuPresenter new
		  title: aMicroUMLAttributeNode name;
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ aMicroUMLAttributeNode rename ] ];
					  addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: aMicroUMLAttributeNode removeIcon;
								  action: [ aMicroUMLAttributeNode remove ] ] ];
		  addGroup: [ :group |
				  aMicroUMLAttributeNode isPublic ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be public';
									  action: [
											  aMicroUMLAttributeNode bePublic.
											  aMicroUMLAttributeNode announceDiagramChange ] ] ].
				  aMicroUMLAttributeNode isProtected ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be protected';
									  action: [
											  aMicroUMLAttributeNode beProtected.
											  aMicroUMLAttributeNode announceDiagramChange ] ] ].
				  aMicroUMLAttributeNode isPrivate ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be private';
									  action: [
											  aMicroUMLAttributeNode bePrivate.
											  aMicroUMLAttributeNode announceDiagramChange ] ] ].
				  group
					  addItem: [ :item |
							  aMicroUMLAttributeNode isAbstract
								  ifTrue: [
										  item
											  name: 'Be implementation';
											  action: [
													  aMicroUMLAttributeNode beConcrete.
													  aMicroUMLAttributeNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be abstract';
											  action: [
													  aMicroUMLAttributeNode beAbstract.
													  aMicroUMLAttributeNode announceDiagramChange ] ] ];
					  addItem: [ :item |
							  aMicroUMLAttributeNode isClassSide
								  ifTrue: [
										  item
											  name: 'Be instance side';
											  action: [
													  aMicroUMLAttributeNode beInstanceSide.
													  aMicroUMLAttributeNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class side';
											  action: [
													  aMicroUMLAttributeNode beClassSide.
													  aMicroUMLAttributeNode announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group addItem: [ :item |
						  item
							  name: 'Change type...';
							  action: [ aMicroUMLAttributeNode changeType ] ] ];
		  yourself
]

{ #category : 'menus' }
MicroUMLBrowserNodeInteraction >> contextMenuForClassNode: aMicroUMLClassNode [

	^ SpMenuPresenter new
		  title: aMicroUMLClassNode name;
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ aMicroUMLClassNode rename ] ];
					  addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: aMicroUMLClassNode removeIcon;
								  action: [ aMicroUMLClassNode remove ] ].
				  (Smalltalk classNamed: aMicroUMLClassNode name) ifNotNil: [
						  :class |
						  group addItem: [ :item |
								  item
									  name: 'Browse...';
									  iconName: #browse;
									  action: [ class browse ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  aMicroUMLClassNode isAbstract
								  ifTrue: [
										  item
											  name: 'Be concrete';
											  action: [
													  aMicroUMLClassNode beConcrete.
													  aMicroUMLClassNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be abstract';
											  action: [
													  aMicroUMLClassNode beAbstract.
													  aMicroUMLClassNode announceDiagramChange ] ] ];
					  addItem: [ :item |
							  aMicroUMLClassNode isClass
								  ifTrue: [
										  item
											  name: 'Be trait';
											  action: [
													  aMicroUMLClassNode beTrait.
													  aMicroUMLClassNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class';
											  action: [
													  aMicroUMLClassNode beClass.
													  aMicroUMLClassNode announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group addItem: [ :item |
						  item
							  name: 'Superclass...';
							  action: [ aMicroUMLClassNode changeSuperclass ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  | traitMenu |
							  traitMenu := SpMenuPresenter new.
							  traitMenu addItem: [ :addTraitItem |
										  addTraitItem
											  name: 'Add trait...';
											  icon: aMicroUMLClassNode addIcon;
											  action: [ aMicroUMLClassNode addTrait ] ].
							  aMicroUMLClassNode traits do: [ :traitName |
									  traitMenu addItem: [ :removeTraitItem |
											  removeTraitItem
												  name: 'Remove ' , traitName;
												  icon: aMicroUMLClassNode removeIcon;
												  action: [ aMicroUMLClassNode removeTrait: traitName ] ] ].
							  item
								  name: 'Traits';
								  subMenu: traitMenu ];
					  addItem: [ :item |
							  | attributeMenu |
							  attributeMenu := SpMenuPresenter new.
							  attributeMenu addItem: [ :addAttributeItem |
									  addAttributeItem
										  name: 'Add attribute...';
										  icon: aMicroUMLClassNode addIcon;
										  action: [ aMicroUMLClassNode addAttribute ] ].
							  aMicroUMLClassNode attributesDo: [ :attributeNode |
									  attributeMenu addItem: [ :attributeNodeMenu |
											  attributeNodeMenu
												  name: attributeNode name;
												  subMenu:
													  (self contextMenuForAttributeNode: attributeNode) ] ].
							  item
								  name: 'Attributes';
								  subMenu: attributeMenu ];
					  addItem: [ :item |
							  | methodMenu |
							  methodMenu := SpMenuPresenter new.
							  methodMenu addItem: [ :addMethodItem |
									  addMethodItem
										  name: 'Add method...';
										  icon: aMicroUMLClassNode addIcon;
										  action: [ aMicroUMLClassNode addMethod ] ].

							  aMicroUMLClassNode methodsDo: [ :methodNode |
									  methodMenu addItem: [ :attributeNodeMenu |
											  attributeNodeMenu
												  name: methodNode name;
												  subMenu: (self contextMenuForMethodNode: methodNode) ] ].
							  item
								  name: 'Methods';
								  subMenu: methodMenu ];
					  addItem: [ :item |
							  | associationMenu |
							  associationMenu := SpMenuPresenter new.
							  aMicroUMLClassNode diagram ifNotNil: [ :diagram |
									  associationMenu addItem: [ :addAssociationItem |
											  | addAssociationMenu |
											  addAssociationMenu := SpMenuPresenter new.
											  diagram classesDo: [ :classNode |
													  classNode ~~ aMicroUMLClassNode ifTrue: [
															  addAssociationMenu addItem: [
																	  :addAssociationClassItem |
																	  addAssociationClassItem
																		  name: classNode name;
																		  action: [
																				  aMicroUMLClassNode addAssociation:
																						  classNode name.
																				  aMicroUMLClassNode announceDiagramChange ] ] ] ].
											  addAssociationItem
												  name: 'Add association with';
												  icon: aMicroUMLClassNode addIcon;
												  subMenu: addAssociationMenu ].
									  diagram associationsDo: [ :associationNode |
											  associationNode leftClass = aMicroUMLClassNode name
												  ifTrue: [
														  associationMenu addItem: [ :associationNodeMenu |
																  associationNodeMenu
																	  name: 'with ' , associationNode rightClass;
																	  subMenu:
																		  (self contextMenuForAssociationNode:
																				   associationNode) ] ].
											  associationNode rightClass = aMicroUMLClassNode name
												  ifTrue: [
														  associationMenu addItem: [ :attributeNodeMenu |
																  attributeNodeMenu
																	  name: 'with ' , associationNode leftClass;
																	  subMenu:
																		  (self contextMenuForAssociationNode:
																				   associationNode) ] ] ] ].
							  item
								  name: 'Associations';
								  subMenu: associationMenu ] ];
		  yourself
]

{ #category : 'menus' }
MicroUMLBrowserNodeInteraction >> contextMenuForMethodNode: aMicroUMLMethodNode [

	^ SpMenuPresenter new
		  title: aMicroUMLMethodNode name;
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ aMicroUMLMethodNode rename ] ];
					  addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: aMicroUMLMethodNode removeIcon;
								  action: [ aMicroUMLMethodNode remove ] ].
				  (Smalltalk classNamed:
					   (aMicroUMLMethodNode classNode ifNotNil: #name)) ifNotNil: [
						  :class |
						  class
							  compiledMethodAt: aMicroUMLMethodNode name
							  ifPresent: [ :method |
									  group addItem: [ :item |
											  item
												  name: 'Browse...';
												  iconName: #browse;
												  action: [ method browse ] ] ] ] ];
		  addGroup: [ :group |
				  aMicroUMLMethodNode isPublic ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be public';
									  action: [
											  aMicroUMLMethodNode bePublic.
											  aMicroUMLMethodNode announceDiagramChange ] ] ].
				  aMicroUMLMethodNode isProtected ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be protected';
									  action: [
											  aMicroUMLMethodNode beProtected.
											  aMicroUMLMethodNode announceDiagramChange ] ] ].
				  aMicroUMLMethodNode isPrivate ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be private';
									  action: [
											  aMicroUMLMethodNode bePrivate.
											  aMicroUMLMethodNode announceDiagramChange ] ] ].
				  group
					  addItem: [ :item |
							  aMicroUMLMethodNode isAbstract
								  ifTrue: [
										  item
											  name: 'Be implementation';
											  action: [
													  aMicroUMLMethodNode beConcrete.
													  aMicroUMLMethodNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be abstract';
											  action: [
													  aMicroUMLMethodNode beAbstract.
													  aMicroUMLMethodNode announceDiagramChange ] ] ];
					  addItem: [ :item |
							  aMicroUMLMethodNode isClassSide
								  ifTrue: [
										  item
											  name: 'Be instance side';
											  action: [
													  aMicroUMLMethodNode beInstanceSide.
													  aMicroUMLMethodNode announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class side';
											  action: [
													  aMicroUMLMethodNode beClassSide.
													  aMicroUMLMethodNode announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Change argument type...';
								  action: [ aMicroUMLMethodNode changeArgumentTypes ] ];
					  addItem: [ :item |
							  item
								  name: 'Change return type...';
								  action: [ aMicroUMLMethodNode changeType ] ] ];
		  yourself
]

{ #category : 'event handling' }
MicroUMLBrowserNodeInteraction >> mouseEnter: event [

	event shape encompassingRectangle ifNotNil: [ :rect |
			box ifNotNil: #remove.
			box := RSPolyline new
				       controlPoints: {
						       rect topLeft.
						       rect topRight.
						       rect bottomRight.
						       rect bottomLeft.
						       rect topLeft };
				       width: 5;
				       color: UITheme current selectionColor;
				       yourself.
			event shape parent add: box; pushBack: box.
			event canvas signalUpdate ]
]

{ #category : 'event handling' }
MicroUMLBrowserNodeInteraction >> mouseLeave: event [

	box ifNotNil: #remove.
	box := nil.
	event canvas signalUpdate
]

{ #category : 'hooks' }
MicroUMLBrowserNodeInteraction >> onShape: aShape [
	"opens my context menu with a right click."

	aShape
		when: RSMouseRightClick do: [ :evt |
				(self contextMenuFor: evt shape) ifNotNil: [ :menu |
						menu openWithSpecAtPointer ] ]
		for: self;
		when: RSMouseLeave do: [ :evt | self mouseLeave: evt ] for: self;
		when: RSMouseEnter do: [ :evt | self mouseEnter: evt ] for: self
]
