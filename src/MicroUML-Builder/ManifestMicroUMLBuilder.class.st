"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestMicroUMLBuilder',
	#superclass : 'PackageManifest',
	#category : 'MicroUML-Builder-Manifest',
	#package : 'MicroUML-Builder',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestMicroUMLBuilder class >> ruleThreeElementPointRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'MicroUMLAstBuilder class' #exampleSerie #true)) #'2026-07-09T15:25:17.240565+03:00') #(#(#RGMethodDefinition #(#'MicroUMLAstBuilder class' #exampleSerie2 #true)) #'2026-07-09T15:25:26.141484+03:00') )
]
