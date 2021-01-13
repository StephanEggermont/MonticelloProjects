Class {
	#name : #MCPackageInfo,
	#superclass : #Object,
	#instVars : [
		'packageName',
		'packageVersions'
	],
	#category : #MonticelloProjects
}

{ #category : #'as yet unclassified' }
MCPackageInfo >> addVersion: aMcVersion in: aProject [
	|packageVersion|
	packageVersion := MCPackageVersion new
		info: aMcVersion info;
		yourself.
	self packageVersions add: packageVersion.
	aMcVersion snapshot definitions do: [ :aDefinition | 
			packageVersion definitions add: 
				(aProject definitions add: aDefinition ) ]. 

]

{ #category : #accessing }
MCPackageInfo >> packageName [
	^ packageName
]

{ #category : #accessing }
MCPackageInfo >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
MCPackageInfo >> packageVersions [
	^ packageVersions ifNil: [ packageVersions := OrderedCollection new ]
]

{ #category : #accessing }
MCPackageInfo >> packageVersions: anObject [
	packageVersions := anObject
]
