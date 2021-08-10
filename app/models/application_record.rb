class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :csv_body, -> { map(&:attributes).map(&:values).map { |values| values.join(',') }.join("\n") }

  class << self
    def csv
      "#{csv_header}\n#{csv_body}"
    end

    def csv_header
      new.attributes.keys.join(',')
    end
  end
end
