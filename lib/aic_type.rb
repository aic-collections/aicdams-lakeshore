class AICType < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/type/")
  term :Actor,
       subClassOf: "aictype:CitiResource".freeze,
       label: "Actor".freeze,
       comment: "Actor (CITI Agent): a person or corporate body".freeze
  term :Annotation,
       subClassOf: "aictype:Resource".freeze,
       label: "Annotation".freeze,
       comment: "Annotation".freeze
  term :Asset,
       subClassOf: "aictype:Resource".freeze,
       label: "Asset".freeze
  term :CitiResource,
       subClassOf: "aictype:Resource".freeze,
       label: "CITI Resource".freeze,
       comment: "Resource imported from CITI".freeze
  term :Comment,
       subClassOf: "aictype:Annotation".freeze,
       label: "Comment".freeze,
       comment: "Comment".freeze
  term :CommentCategory,
       subClassOf: "aictype:ListItem".freeze,
       label: "Comment category".freeze,
       comment: "Comment category".freeze
  term :CompositingType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Compositing".freeze,
       comment: "Compositing type".freeze
  term :ConservationDocumentType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Conservation document type".freeze,
       comment: "Conservation document type".freeze
  term :ConservationImageType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Conservation image type".freeze,
       comment: "Conservation image type".freeze
  term :ConservationMetadata,
       subClassOf: "aictype:MetadataSet".freeze,
       label: "Conservation Metadata".freeze,
       comment: "Conservation metadata".freeze
  term :Department,
       subClassOf: "aictype:ListItem".freeze,
       label: "Department".freeze,
       comment: "Department".freeze
  term :DigitizationSource,
       subClassOf: "aictype:ListItem".freeze,
       label: "Digitization source".freeze,
       comment: "Digitization source".freeze
  term :DocumentType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Document type".freeze,
       comment: "Document type".freeze
  term :Exhibition,
       subClassOf: "aictype:CitiResource".freeze,
       label: "Exhibition".freeze,
       comment: "CITI Exhibition".freeze
  term :LightType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Light type".freeze,
       comment: "Light type".freeze
  term :List,
       subClassOf: "aictype:Resource".freeze,
       label: "List".freeze,
       comment: "List of options".freeze
  term :ListItem,
       subClassOf: "aictype:Resource".freeze,
       label: "List Item".freeze,
       comment: "Item (option) in a list".freeze
  term :MetadataSet,
       subClassOf: "aictype:Resource".freeze,
       label: "Metadata Set".freeze,
       comment: "Metadata set".freeze
  term :Resource,
       label: "Resource".freeze,
       comment: "LAKE base resource".freeze
  term :Shipment,
       subClassOf: "aictype:CitiResource".freeze,
       label: "Shipment".freeze,
       comment: "CITI Shipment".freeze
  term :StatusType,
       subClassOf: "aictype:ListItem".freeze,
       label: "Status".freeze,
       comment: "The status of a resource".freeze
  term :StillImage,
       subClassOf: "aictype:Asset".freeze,
       label: "Still Image".freeze,
       comment: "Still image".freeze
  term :Tag,
       subClassOf: "aictype:ListItem".freeze,
       label: "Tag".freeze,
       comment: "Tag".freeze
  term :Text,
       subClassOf: "aictype:Asset".freeze,
       label: "Text Document".freeze,
       comment: "Text document".freeze
  term :Transaction,
       subClassOf: "aictype:CitiResource".freeze,
       label: "Transaction".freeze,
       comment: "CITI Transaction".freeze
  term :ViewType,
       subClassOf: "aictype:ListItem".freeze,
       label: "View Type".freeze,
       comment: "View type".freeze
  term :Work,
       subClassOf: "aictype:CitiResource".freeze,
       label: "Work".freeze,
       comment: "CITI Object".freeze
end
