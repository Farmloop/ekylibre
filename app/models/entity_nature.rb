# == Schema Information
# Schema version: 20090512102847
#
# Table name: entity_natures
#
#  id           :integer       not null, primary key
#  name         :string(255)   not null
#  abbreviation :string(255)   not null
#  active       :boolean       default(TRUE), not null
#  physical     :boolean       not null
#  in_name      :boolean       default(TRUE), not null
#  title        :string(255)   
#  description  :text          
#  company_id   :integer       not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  created_by   :integer       
#  updated_by   :integer       
#  lock_version :integer       default(0), not null
#

class EntityNature < ActiveRecord::Base
  belongs_to :company
  has_many :entities, :foreign_key=>:nature_id


  def before_validation
    self.in_name = false if self.physical
    if self.physical
      self.title = self.abbreviation if self.title.blank?
    else
      self.title = ''
    end
  end



end
