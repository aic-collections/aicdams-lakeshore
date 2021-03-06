# frozen_string_literal: true
class AICType < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/type/")
  term :Agent,
       subClassOf: "aictype:CitiResource",
       label: "Actor",
       comment: "A person, group of people or corporate body involved in some way in the lifecycle of a physical or digital resource."
  term :AICUser,
       subClassOf: "aictype:CitiResource",
       label: "AIC User",
       comment: "AIC User"
  term :Annotation,
       subClassOf: "aictype:Resource",
       label: "Annotation",
       comment: "Annotation"
  term :Archive,
       subClassOf: "aictype:Asset",
       label: "Archive",
       comment: "Archive"
  term :Asset,
       subClassOf: "aictype:Resource",
       label: "Asset"
  term :Authority,
       label: "Authority",
       comment: "Authority"
  term :CitiResource,
       subClassOf: "aictype:Resource",
       label: "CITI Resource",
       comment: "Resource imported from CITI"
  term :CollectionTypeList,
       subClassOf: "aictype:List",
       label: "Collection Type List",
       comment: "Collection type list"
  term :CollectionType,
       subClassOf: "aictype:ListItem",
       label: "Collection Type",
       comment: "Collection type"
  term :Comment,
       subClassOf: "aictype:Annotation",
       label: "Comment",
       comment: "Comment"
  term :CompositingType,
       subClassOf: "aictype:ListItem",
       label: "Compositing Type",
       comment: "Compositing type"
  term :CompositingTypeList,
       subClassOf: "aictype:List",
       label: "Compositing Type List",
       comment: "Compositing type list"
  term :ConservationMetadata,
       subClassOf: "aictype:MetadataSet",
       label: "Conservation Metadata",
       comment: "Conservation metadata"
  term :Dataset,
       subClassOf: "aictype:Asset",
       label: "Dataset",
       comment: "Dataset"
  term :Department,
       subClassOf: "aictype:ListItem",
       label: "Department",
       comment: "Department"
  term :DigitizationSource,
       subClassOf: "aictype:ListItem",
       label: "Digitization source",
       comment: "Digitization source"
  term :DigitizationSourceList,
       subClassOf: "aictype:List",
       label: "Digitization source list",
       comment: "Digitization source list"
  term :DocumentType,
       subClassOf: "aictype:ListItem",
       label: "Document type",
       comment: "Document type"
  term :Exhibition,
       subClassOf: "aictype:CitiResource",
       label: "Exhibition",
       comment: "CITI Exhibition"
  term :IntermediateFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Intermediate File Set",
       comment: "Intermediate file set"
  term :Keyword,
       subClassOf: "aictype:ListItem",
       label: "Keyword",
       comment: "Keyword"
  term :KeywordList,
       subClassOf: "aictype:List",
       label: "Keyword List",
       comment: "Keyword list"
  term :LegacyFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Legacy File Set",
       comment: "Legacy file set"
  term :LicensingRestriction,
       subClassOf: "aictype:ListItem",
       label: "Licensing Restriction",
       comment: "Licensing restriction"
  term :LicensingRestrictionList,
       subClassOf: "aictype:List",
       label: "Licensing Restriction List",
       comment: "Licensing restriction list"
  term :LightType,
       subClassOf: "aictype:ListItem",
       label: "Light type",
       comment: "Light type"
  term :LightTypeList,
       subClassOf: "aictype:List",
       label: "Light type list",
       comment: "Light type list"
  term :List,
       subClassOf: "aictype:Resource",
       label: "List",
       comment: "List of options"
  term :ListItem,
       subClassOf: "aictype:Resource",
       label: "List Item",
       comment: "Item (option) in a list"
  term :MovingImage,
       subClassOf: "aictype:Asset",
       label: "Moving Image",
       comment: "Moving image"
  term :OriginalFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Original File Set",
       comment: "Original file set"
  term :Place,
       subClassOf: "aictype:CitiResource",
       label: "Place",
       comment: "Place"
  term :PreservationMasterFileSet,
       subClassOf: Hydra::Works::Vocab::WorksTerms.FileSet,
       label: "Preservation File Set",
       comment: "Preservation file set"
  term :Resource,
       label: "Resource",
       comment: "LAKE base resource"
  term :Shipment,
       subClassOf: "aictype:CitiResource",
       label: "Shipment",
       comment: "CITI Shipment"
  term :Sound,
       subClassOf: "aictype:Asset",
       label: "Sound",
       comment: "Sound"
  term :StatusType,
       subClassOf: "aictype:ListItem",
       label: "Status",
       comment: "The status of a resource"
  term :StatusTypeList,
       subClassOf: "aictype:List",
       label: "Status List",
       comment: "List of status types"
  term :StillImage,
       subClassOf: "aictype:Asset",
       label: "Still Image",
       comment: "Still image"
  term :Tag,
       subClassOf: "aictype:ListItem",
       label: "Tag",
       comment: "Tag"
  term :Text,
       subClassOf: "aictype:Asset",
       label: "Text",
       comment: "Text"
  term :Transaction,
       subClassOf: "aictype:CitiResource",
       label: "Transaction",
       comment: "CITI Transaction"
  term :ViewType,
       subClassOf: "aictype:ListItem",
       label: "View Type",
       comment: "View type"
  term :ViewTypeList,
       subClassOf: "aictype:List",
       label: "View Type List",
       comment: "View type list"
  term :Work,
       subClassOf: "aictype:CitiResource",
       label: "Work",
       comment: "CITI Object"
end
