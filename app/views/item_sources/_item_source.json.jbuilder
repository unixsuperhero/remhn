json.extract! item_source, :id, :item_id, :source_id, :source_type, :stars, :created_at, :updated_at
json.url item_source_url(item_source, format: :json)
