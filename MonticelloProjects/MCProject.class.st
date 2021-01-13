Class {
	#name : #MCProject,
	#superclass : #Object,
	#instVars : [
		'location',
		'infos',
		'definitions',
		'repository',
		'errors'
	],
	#category : #MonticelloProjects
}

{ #category : #'as yet unclassified' }
MCProject class >> from: aFileName [

	|zipStream fileRef theNew|
	fileRef := File named: aFileName. 
	fileRef readStreamDo: [ :s |
		theNew := (FLMaterializer newDefault materializeFrom: s) .].
	^theNew

]

{ #category : #'as yet unclassified' }
MCProject >> deduplicate [
	|infoDict|
	infoDict := Dictionary new.
	self infos do: [ :info | info packageVersions do: [ :version | 
		infoDict at: version info id put: version info.
		version info ancestors do: [  :an | 
			infoDict at: an id put: an ] ]].
	infoDict valuesDo: [ :anInfo | anInfo ancestors ifNotEmpty: [ |newAncestors| 
		newAncestors := Array new: anInfo ancestors size.
		anInfo ancestors withIndexDo: [ :ancestor :index | 
			newAncestors at: index put: (infoDict at: 	ancestor id ifAbsent: [ancestor id]) ].
		anInfo setAncestors: newAncestors ] ].
	self infos do: [ :info | info packageVersions do: [ :version | 
		version info: (infoDict at: version info id) ] ].
]

{ #category : #accessing }
MCProject >> definitions [
	^ definitions ifNil: [ definitions := OCLiteralSet new ]
]

{ #category : #accessing }
MCProject >> definitions: anObject [
	definitions := anObject
]

{ #category : #'as yet unclassified' }
MCProject >> ensureInfo: aPackageName [
	^self infos at: aPackageName ifAbsent: [ 
		|info|
		info := MCPackageInfo new
			packageName: aPackageName;
			yourself.
		self infos at: aPackageName put: info.
		info ] 
]

{ #category : #'as yet unclassified' }
MCProject >> errors [
	^errors ifNil: [errors := OrderedCollection new]
]

{ #category : #'as yet unclassified' }
MCProject >> fileName [
"smalltalkhub specific"
	|split nr|
	split := (location findTokens: '/').
	nr := split size.
	^(split at: (nr-1)),'-',(split at: nr)
]

{ #category : #accessing }
MCProject >> infos [
	^ infos ifNil: [ infos := Dictionary new ]
]

{ #category : #accessing }
MCProject >> infos: anObject [
	infos := anObject
]

{ #category : #accessing }
MCProject >> location [
	^ location
]

{ #category : #accessing }
MCProject >> location: anObject [
	location := anObject
]

{ #category : #'as yet unclassified' }
MCProject >> parse: aVersion [
	|info|
	info := self ensureInfo: aVersion package.
	info addVersion: aVersion in: self
	
]

{ #category : #'as yet unclassified' }
MCProject >> read [
	| filenames |
	repository := MCHttpRepository location: location user: '' password: ''.
	filenames := repository readableFileNames.
	filenames do: [ :each | self read: each ]
	
]

{ #category : #'as yet unclassified' }
MCProject >> read: aFileName [
	"Needs a rate limiter!!!"
	|mcVersion|
	[  
	(Delay forSeconds: 0.2) wait.
	mcVersion := repository loadNotCachedVersionFromFileNamed: aFileName.
	mcVersion snapshot.
	self parse: mcVersion.
	repository flushCache.] on: Exception do: [:ex | self errors add: aFileName->ex printString] 
	
]

{ #category : #'as yet unclassified' }
MCProject >> repository: anUndefinedObject [ 
	repository := anUndefinedObject
]

{ #category : #'as yet unclassified' }
MCProject >> saveToFile [
	| fileRef|
	self deduplicate. 
	fileRef := File named: (FileLocator home / 'SmalltalkHub' / (self fileName, '.mcp')) pathString.
	fileRef writeStreamDo: [ :s |
		repository := nil.
		FLSerializer serialize: self on: s].
	LibC runCommand: 'zip ',((FileLocator home / 'SmalltalkHub' / (self fileName, '.zip')) pathString),
		' ', ((FileLocator home / 'SmalltalkHub' / (self fileName, '.mcp')) pathString)

]
