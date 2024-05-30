class Customer < ApplicationRecord
  encrypts :name, deterministic: true, ignore_case: true
end
