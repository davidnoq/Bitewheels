class Message < ApplicationRecord
    belongs_to :event_application
    belongs_to :user
    validates :content, presence: true
end
