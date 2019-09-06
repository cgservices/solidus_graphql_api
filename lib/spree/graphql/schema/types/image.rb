# frozen_string_literal: true

class Spree::GraphQL::Schema::Types::Image < Spree::GraphQL::Schema::Types::BaseObjectNode
  graphql_name 'Image'

  def self.url_field_default_value
    default_style_value = Spree::Image.styles[:original]

    if !default_style_value || Spree::GraphQL::Schema::Types::ImageStyle.values.none? do |_, enum_value|
         enum_value.value == default_style_value
       end
      return
    end

    default_style_value
  end

  field :alt_text, ::GraphQL::Types::String, null: true do
    description 'A word or phrase to share the nature or contents of an image.'
  end
  def alt_text
    object.alt
  end

  field :url, ::Spree::GraphQL::Schema::Types::URL, null: false do
    description 'The location of the image as a URL.'
    argument :style,
             Spree::GraphQL::Schema::Types::ImageStyle,
             required: false,
             default_value: owner.url_field_default_value,
             description: 'The desired image style.'
  end
  def url(style:)
    context[:helpers].asset_url object.url style
  end
end
