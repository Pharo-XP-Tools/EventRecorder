Extension { #name : 'WorkingSession' }

{ #category : '*EventRecorder' }
WorkingSession >> creationTime [

	^ properties at: #creationTime ifAbsentPut: [ DateAndTime now ]
]
