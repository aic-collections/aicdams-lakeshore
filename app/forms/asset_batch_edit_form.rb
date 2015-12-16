class AssetBatchEditForm < AssetEditForm
  self.terms = AssetEditForm.terms - [:pref_label]
end
