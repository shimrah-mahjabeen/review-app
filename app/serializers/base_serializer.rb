class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def generate_image_url(image)
    return nil unless image.attached?

    variant = image.variant(resize: '500x500')
    rails_representation_url(variant)
  end

  def generate_image_urls(images)
    return nil unless images.attached?

    images.map do |image|
      variant = image.variant(resize: '500x500')
      rails_representation_url(variant)
    end
  end
end
