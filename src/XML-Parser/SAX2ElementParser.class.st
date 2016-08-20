"
This class is a SAX2Parser that uses SAX2ElementHandlers to handle the  #startElement*, #endElement*, and #characters: events for each element instead of using a single SAX2ContentHandler for everything.

Custom subclasses of SAX2ElementHandler can be mapped to element names, namespace URIs, and attributes using a SAX2PluggableElementHandlerFactory. Factories can be injected with #elementHandlerFactory: before parsing. See #testParsingSampleBooks for an example.

You can have multiple factories by mapping specific SAX2ElementHandlers to element-specific factories using a SAX2PluggableElementHandlerFactoryMapper, which can be injected with #elementHandlerFactoryMapper: before parsing. This can be used to create a finite-state machine, with the element handler instances being the states and the mapped factories being their transitions. See #testParsingSamplePerson for an example.
"
Class {
	#name : #SAX2ElementParser,
	#superclass : #SAX2Parser,
	#instVars : [
		'elementHandler',
		'elementHandlerFactory',
		'elementHandlerFactoryMapper'
	],
	#category : #'XML-Parser'
}

{ #category : #'handling - content' }
SAX2ElementParser >> characters: aString [
	self elementHandler characters: aString
]

{ #category : #private }
SAX2ElementParser >> defaultElementHandlerFactoryClass [
	^ SAX2ElementHandlerFactory
]

{ #category : #private }
SAX2ElementParser >> defaultElementHandlerFactoryMapperClass [
	^ SAX2ElementHandlerFactoryMapper
]

{ #category : #accessing }
SAX2ElementParser >> elementHandler [
	^ elementHandler
]

{ #category : #accessing }
SAX2ElementParser >> elementHandler: anElementHandler [
	elementHandler := anElementHandler
]

{ #category : #accessing }
SAX2ElementParser >> elementHandlerFactory [
	^ elementHandlerFactory
]

{ #category : #accessing }
SAX2ElementParser >> elementHandlerFactory: anElementHandlerFactory [
	elementHandlerFactory := anElementHandlerFactory
]

{ #category : #accessing }
SAX2ElementParser >> elementHandlerFactoryMapper [
	^ elementHandlerFactoryMapper
]

{ #category : #accessing }
SAX2ElementParser >> elementHandlerFactoryMapper: anElementHandlerFactoryMapper [
	elementHandlerFactoryMapper := anElementHandlerFactoryMapper
]

{ #category : #'handling - content' }
SAX2ElementParser >> endElement: aQualifiedName prefix: aPrefix uri: aURI localName: aLocalName [
	| oldElementHandler |

	(oldElementHandler := self elementHandler)
		endElement: aQualifiedName
		prefix: aPrefix
		uri: aURI
		localName: aLocalName.
	self
		elementHandler: oldElementHandler parent;
		elementHandlerFactory: oldElementHandler parentFactory.
]

{ #category : #initialization }
SAX2ElementParser >> on: aStringOrStream [
	super on: aStringOrStream.

	elementHandlerFactory := self defaultElementHandlerFactoryClass new.
	elementHandlerFactoryMapper := self defaultElementHandlerFactoryMapperClass new.
]

{ #category : #'handling - content' }
SAX2ElementParser >> startElement: aQualifiedName prefix: aPrefix uri: aURI localName: aLocalName attributes: aDictionary [
	| newElementHandler |

	newElementHandler :=
		(self elementHandlerFactory
			classForElement: aQualifiedName
			namespaceURI: aURI
			localName: aLocalName
			attributes: aDictionary)
				parser: self
				parent: self elementHandler
				parentFactory: self elementHandlerFactory.
	self
		elementHandler: newElementHandler;
		elementHandlerFactory:
			(self elementHandlerFactoryMapper
				factoryForElementHandler: newElementHandler
				ifNone: [self elementHandlerFactory]).

	newElementHandler
		startElement: aQualifiedName
		prefix: aPrefix
		uri: aURI
		localName: aLocalName
		attributes: aDictionary.
]