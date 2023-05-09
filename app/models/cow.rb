class Cow < ApplicationRecord

    has_one_attached :image
    has_many :cows

    def image_url
        Rails.application.routes.url_helpers.url_for(image) if image.attached?
    end
    
end
