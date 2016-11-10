# = Informations
#
# == License
#
# Ekylibre - Simple agricultural ERP
# Copyright (C) 2008-2009 Brice Texier, Thibaud Merigon
# Copyright (C) 2010-2012 Brice Texier
# Copyright (C) 2012-2016 Brice Texier, David Joulin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: synchronization_operations
#
#  created_at     :datetime         not null
#  creator_id     :integer
#  id             :integer          not null, primary key
#  lock_version   :integer          default(0), not null
#  operation_name :string           not null
#  request        :jsonb
#  response       :jsonb
#  state          :string           not null
#  status         :string
#  updated_at     :datetime         not null
#  updater_id     :integer
#
class SynchronizationOperation < Ekylibre::Record::Base
  enumerize :state, in: [:undone, :in_progress, :errored, :aborted, :finished], predicates: true, default: :undone
  enumerize :operation_name, in: [:get_inventory, :authenticate, :get_urls], predicates: true

  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates :operation_name, :state, presence: true
  validates :status, length: { maximum: 500 }, allow_blank: true
  # ]VALIDATORS]
  has_many :calls, as: :source

  scope :operation, lambda {|name, options={}|
    options[:state] ||= :finished
    order(created_at: :desc).where(operation_name: name, state: options[:state])
  }
end
