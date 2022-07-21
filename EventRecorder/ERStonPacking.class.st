"
I serialize or materialize objects using STON framework. Create instance of me calling GTEventPacking ston.
"
Class {
	#name : #ERStonPacking,
	#superclass : #EREventPacking,
	#category : #'EventRecorder-Support'
}

{ #category : #'as yet unclassified' }
ERStonPacking >> fallbackSanitizeAndSerialize: anObject [

	^ anObject isString
		  ifTrue: [ self fallbackSanitizeAndSerializeString: anObject ]
		  ifFalse: [ self serialize: anObject ]
]

{ #category : #'as yet unclassified' }
ERStonPacking >> fallbackSanitizeAndSerializeString: aString [

	| sanitizer sanitizedString |
	sanitizer := ERSTONTextSanitizer new.
	self trySerialize: aString callback: [ :success :serialization | 
		success
			ifTrue: [ ^ serialization ]
			ifFalse: [ "should register the error somehow" ] ].
	sanitizedString := sanitizer removeWideCharacters: aString.
	self
		trySerialize: sanitizedString
		callback: [ :success :serialization | 
			success
				ifTrue: [ ^ serialization ]
				ifFalse: [ "should register the error somehow" ] ].
	sanitizedString := sanitizer removeNonAlphanumericNorSpace:
		                   sanitizedString.
	self
		trySerialize: sanitizedString
		callback: [ :success :serialization | 
			success
				ifTrue: [ ^ serialization ]
				ifFalse: [ "should register the error somehow" ] ].
	self error: 'All fallback serialization attempts failed'
]

{ #category : #private }
ERStonPacking >> materialize: aByteArray [
	| stream gzstream |
	stream := aByteArray asString readStream.
	gzstream := GZipReadStream on: stream.
	^ [ STON fromStream: gzstream ] ensure: [ gzstream close. stream close ]
]

{ #category : #private }
ERStonPacking >> serialize: anObject [
	^ (String streamContents: [ :stream | | gzstream |
		gzstream := GZipWriteStream on: stream.
		[ STON put: anObject onStreamPretty: gzstream ]
			ensure: [ gzstream close ] ]) asByteArray
]

{ #category : #accessing }
ERStonPacking >> technologyName [
	^ 'ston'
]

{ #category : #'as yet unclassified' }
ERStonPacking >> trySerialize: aString callback: aBlock [

	"aBlock is a closure with two parameters, the first is a boolean that tells if there were no errors, and the second is the result of the serialization"

	| serialization success |
	[ serialization := self serialize: aString.
	  self materialize: serialization.
	  success := true.
	  aBlock value: true value: serialization ]
		on: Exception
		do: [ "remove wideCharacters" success := false ].
	aBlock value: success value: serialization
]

{ #category : #'as yet unclassified' }
ERStonPacking >> trySerializeNoWideCharacters: aString callback: aBlock [

	"aBlock is a closure with two parameters, the first is a boolean that tells if there were no errors, and the second is the result of the serialization"

	| serialization success |
	[ serialization := self serialize: aString.
	  self materialize: serialization.
	  success := true.
	  aBlock value: true value: serialization ]
		on: Exception
		do: [ "remove wideCharacters" success := false ].
	aBlock value: success value: serialization
]
