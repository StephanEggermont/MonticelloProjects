Class {
	#name : #MCPackageVersion,
	#superclass : #Object,
	#instVars : [
		'info',
		'definitions'
	],
	#category : #MonticelloProjects
}

{ #category : #accessing }
MCPackageVersion >> definitions [
	^ definitions ifNil: [ definitions := OrderedCollection new ]
]

{ #category : #accessing }
MCPackageVersion >> definitions: anObject [
	definitions := anObject
]

{ #category : #accessing }
MCPackageVersion >> info [
	^ info
]

{ #category : #accessing }
MCPackageVersion >> info: anObject [
	info := anObject
]
