class AIC < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/")

  term :actorType,
    label: "Actor Type".freeze,
    comment: "Type of the actor: individual person, group, corporate entity".freeze
  term :artistUid,
    label: "Artist ID".freeze,
    comment: "Artist ID".freeze
  term :batchUid,
    label: "Batch UID".freeze,
    comment: "UID of batch process that ingested the resource".freeze
  term :birthDate,
    label: "Birth Date".freeze,
    comment: "Birth date".freeze
  term :birthYear,
    label: "Birth Year".freeze,
    comment: "Birth year".freeze
  term :captureDevice,
    label: "Capture Device".freeze,
    comment: "Capture device of original file".freeze
  term :category,
    label: "Category".freeze,
    comment: "Comment category".freeze
  term :citiUid,
    label: "CITI UID".freeze,
    comment: "CITI unique identifier (PKey)".freeze
  term :compositing,
    label: "Compositing".freeze,
    comment: "Compositing type".freeze
  term :conservationDocType,
    label: "Conservation Document Type".freeze,
    comment: "Document type used by Conservation".freeze
  term :content,
    label: "Content".freeze,
    comment: "Annotation content".freeze
  term :contributor,
    label: "Contributor".freeze,
    comment: "Person or corporate body who participated in the creation of the resource".freeze
  term :created,
    label: "Created On".freeze,
    comment: "Creation timestamp for resources not managed by Hydra".freeze
  term :createdBy,
    label: "Created By".freeze,
    comment: "Person or corporate body who was primarily responsible for the creation of the resource".freeze
  term :creatorDisplay,
    label: "Creator".freeze,
    comment: "Creator of the work (display)".freeze
  term :creditLine,
    label: "Credit Line".freeze,
    comment: "Credit line".freeze
  term :dateDisplay,
    label: "Date (display)".freeze,
    comment: "Collocation date(s)".freeze
  term :deathDate,
    label: "Death Date".freeze,
    comment: "Death date".freeze
  term :deathYear,
    label: "Death Year".freeze,
    comment: "Death year".freeze
  term :deptUid,
    label: "Department".freeze,
    comment: "AIC department".freeze
  term :deptCreated,
    label: "Created by Department".freeze,
    comment: "Department of resource creator".freeze
  term :digitizationSource,
    label: "Digitization source".freeze,
    comment: "Original document for non-born-digital assets".freeze
  term :dimensionsDisplay,
    label: "Dimensions Display".freeze,
    comment: "Display dimensions".freeze
  term :documentType,
    label: "Document Type".freeze,
    comment: "Select one document type from the hierarchy".freeze
  term :earliestDate,
    label: "Earliest Date".freeze,
    comment: "Earliest preferred date".freeze
  term :earliestYear,
    label: "Earliest Year".freeze,
    comment: "Earliest preferred year".freeze
  term :endDate,
    label: "End Date".freeze,
    comment: "End date".freeze
  term :exhibitionHistory,
    label: "Exhibition History".freeze,
    comment: "Exhibition history text".freeze
  term :galleryLocation,
    label: "Gallery Location".freeze,
    comment: "Gallery location".freeze
  term :hasComment,
    label: "Comment".freeze,
    comment: "Comment".freeze
  term :hasConstituent,
    label: "Has Constituent".freeze,
    comment: "Asset that is a constituent part of a Work rather than a representation or a document, e.g. an A/V stream that makes up a video artwork".freeze
  term :hasDocument,
    label: "Has Document".freeze,
    comment: "Asset documenting the resource".freeze
  term :hasPreferredRepresentation,
    label: "Has Preferred Image".freeze,
    comment: "Asset that is a primary representation of the Resource. This asset is used to create the thumbnail for non-Asset resources".freeze
  term :hasRepresentation,
    label: "Has Representation".freeze,
    comment: "Asset representing (depicting) the resource".freeze
  term :icon,
    label: "Icon",
    comment: "URI of thumbnail or icon representing the resource"
  term :inscriptions,
    label: "Inscriptions".freeze,
    comment: "Inscriptions on object".freeze
  term :latestDate,
    label: "Latest Date".freeze,
    comment: "Latest preferred date".freeze
  term :latestYear,
    label: "Latest Year".freeze,
    comment: "Latest preferred year".freeze
  term :legacyUid,
    label: "Legacy ID".freeze,
    comment: "UID assigned to resource from a legacy system".freeze
  term :lightType,
    label: "Light Type".freeze,
    comment: "Light type used to capture the image".freeze
  term :mainRefNumber,
    label: "Main Reference Number".freeze,
    comment: "Main reference number".freeze
  term :mediumDisplay,
    label: "Medium Display".freeze,
    comment: "Display medium".freeze
  term :nameOfficial,
    label: "Official Name".freeze,
    comment: "Official name".freeze
  term :nameWorking,
    label: "Working Name".freeze,
    comment: "Working name".freeze
  term :objectType,
    label: "Object Type".freeze,
    comment: "Object type".freeze
  term :placeOfOriginUid,
    label: "Place of Origin".freeze,
    comment: "Place of origin".freeze
  term :provenanceText,
    label: "Provenance Text".freeze,
    comment: "Provenance text".freeze
  term :publicationHistory,
    label: "Publication History".freeze,
    comment: "Publication history text".freeze
  term :publVerLevel,
    label: "Publish Verification Level".freeze,
    comment: "Publish verification level".freeze
  term :specialImageType,
    label: "Special Image Type".freeze,
    comment: "Technical image type".freeze
  term :startDate,
    label: "Start Date".freeze,
    comment: "Start date".freeze
  term :status,
    label: "Status".freeze,
    comment: "Status of the resource".freeze
  term :tag,
    label: "Tag".freeze,
    comment: "Tag attached to the resource".freeze
  term :transcript,
    label: "Transcript".freeze,
    comment: "Plain-text transcription, either manually or automatically extracted from the document".freeze
  term :exhibitionTypeUid,
    label: "Type ID".freeze,
    comment: "Type (ID) of exhibition".freeze
  term :uid,
    label: "UID".freeze,
    comment: "Primary ID of resource. This is generated by UIDminter".freeze
  term :updated,
    label: "Updated On".freeze,
    comment: "Update timestamp for resources not managed by Hydra".freeze
  term :view,
    label: "View".freeze,
    comment: "Viewing angle, overall or detail, etc".freeze

end
