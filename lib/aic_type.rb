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
  term :ConservationMetadata,
    subClassOf: "aictype:MetadataSet".freeze,
    label: "Conservation Metadata".freeze,
    comment: "Conservation metadata".freeze
  term :Exhibition,
    subClassOf: "aictype:CitiResource".freeze,
    label: "Exhibition".freeze,
    comment: "CITI Exhibition".freeze
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
  term :StillImage,
    subClassOf: "aictype:Asset".freeze,
    label: "Still Image".freeze,
    comment: "Still image".freeze
  term :Text,
    subClassOf: "aictype:Asset".freeze,
    label: "Text Document".freeze,
    comment: "Text document".freeze
  term :Transaction,
    subClassOf: "aictype:CitiResource".freeze,
    label: "Transaction".freeze,
    comment: "CITI Transaction".freeze
  term :Work,
    subClassOf: "aictype:CitiResource".freeze,
    label: "Work".freeze,
    comment: "CITI Object".freeze

end
