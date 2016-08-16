class Term < ApplicationRecord
  belongs_to :team
  validates :name, presence: true
  validates :description, presence: true

  def self.from_text(text)
    separator = if text.include?(':')
      ':'
    else
      ' '
    end
    name, description = text.split(separator, 2).map(&:strip)
    term = find_or_initialize_by(name: name)
    term.assign_attributes(name: name, description: description)
    term
  end
end
