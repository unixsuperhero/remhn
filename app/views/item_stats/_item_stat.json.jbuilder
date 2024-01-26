json.extract! item_stat, :id, :item_id, :equipable_stat_id, :qty, :created_at, :updated_at
json.url item_stat_url(item_stat, format: :json)
