Class {
	#name : #ERStonPackingTest,
	#superclass : #EREventPackingTest,
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #accessing }
ERStonPackingTest >> packingClass [
	^ ERStonPacking
]

{ #category : #test }
ERStonPackingTest >> testFallbackSanitizeAndSerialize [

	self
		assert: (ERStonPacking new materialize:
				 (ERStonPacking new fallbackSanitizeAndSerialize: '’'))
		isString.
		self
		assert: (ERStonPacking new materialize:
				 (ERStonPacking new fallbackSanitizeAndSerialize: '.’/'))
		isString.

]
