"
ConfigurationOfXMLTestsConformance load
"
Class {
	#name : #ConfigurationOfXMLTestsConformance,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfXMLTestsConformance
}

{ #category : #'development support' }
ConfigurationOfXMLTestsConformance class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfXMLTestsConformance class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfXMLTestsConformance class >> catalogDescription [

	^ 'XMLTestsConformance is an extra test suite for XMLParser generated from the W3C conformance test suite: http://www.w3.org/XML/Test/'
]

{ #category : #private }
ConfigurationOfXMLTestsConformance class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfXMLTestsConformance class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfXMLTestsConformance class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfXMLTestsConformance class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfXMLTestsConformance class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfXMLTestsConformance class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfXMLTestsConformance class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfXMLTestsConformance class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfXMLTestsConformance >> baseline100: spec [
	<version: '1.0.0-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'XML-Tests-Conformance baseline';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main'.
			spec
				project: 'XMLParser'
				with: [ 
					spec
						className: 'ConfigurationOfXMLParser';
						versionString: #stable;
						loads: #('default');
						repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main' ].
			spec package: 'XML-Tests-Conformance' with: [ spec requires: 'XMLParser' ].
			spec group: 'Tests' with: #('XML-Tests-Conformance').
			spec group: 'default' with: #('Tests')].
]

{ #category : #accessing }
ConfigurationOfXMLTestsConformance >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfXMLTestsConformance >> development: spec [
	<symbolicVersion: #development>
	
	spec for: #'common' version: '1.0.0-baseline'.
]

{ #category : #accessing }
ConfigurationOfXMLTestsConformance >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfXMLTestsConformance >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.0.1'.
]

{ #category : #versions }
ConfigurationOfXMLTestsConformance >> version100: spec [ 
        <version: '1.0.0' imports: #('1.0.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Tests-Conformance' with: 'XML-Tests-Conformance-monty.11'.
                ].
]

{ #category : #versions }
ConfigurationOfXMLTestsConformance >> version101: spec [ 
        <version: '1.0.1' imports: #('1.0.0-baseline')>

        spec for: #common do: [
                spec blessing: #release.
			spec package: 'XML-Tests-Conformance' with: 'XML-Tests-Conformance-monty.12'.
                ].
]