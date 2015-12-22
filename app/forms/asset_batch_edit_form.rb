class AssetBatchEditForm < AssetEditForm
  self.terms = AssetEditForm.terms - [:pref_label, :document_type_ids]
end
