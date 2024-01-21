class Monster < ApplicationRecord
  enum size: { small: 1, large: 2 }
  enum poison: { small: 1, medium: 2, large: 3 }, _scopes: false, _prefix: true
  enum paralysis: { small: 1, medium: 2, large: 3 }, _scopes: false, _prefix: true
  enum stun: { small: 1, medium: 2, large: 3 }, _scopes: false, _prefix: true
  enum sleep: { small: 1, medium: 2, large: 3 }, _scopes: false, _prefix: true
end
