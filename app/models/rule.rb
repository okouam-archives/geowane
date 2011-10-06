class Rule  < ActiveRecord::Base
  belongs_to :category
  belongs_to :ruleset

end