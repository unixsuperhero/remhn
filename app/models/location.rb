class Location < ApplicationRecord
  has_many :location_areas
  has_many :areas, through: :location_areas
end
