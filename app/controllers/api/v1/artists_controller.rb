module Api
  module V1
    class ArtistsController < ApplicationController
      skip_before_action :verify_authenticity_token
      
      # Permitimos acceso público a la lista y al perfil detallado del artista
      before_action :authenticate_api_user, except: [:index, :artist_profile]

      def index
        artists = User.where(role: 'artist')
        render json: artists.map { |artist| serialize_artist(artist) }
      end

      def artist_profile
        artist = User.where(role: 'artist').find(params[:id])
        products = artist.products

        render json: {
          artist: serialize_artist(artist),
          products: products.map { |product| serialize_product(product) }
        }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Artista no encontrado" }, status: :not_found
      end

      private

      def serialize_artist(artist)
        {
           id: artist.id,
           name: artist.name,
           email: artist.email,
           bio: artist.respond_to?(:bio) ? (artist.bio || '') : '',
           commissions_enabled: artist.respond_to?(:commissions_enabled) ? (artist.commissions_enabled.nil? ? true : artist.commissions_enabled) : true,
           avatar_url: artist.avatar.attached? ? rails_blob_url(artist.avatar, only_path: false) : nil
        }
      end

      def serialize_product(product)
        {
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          stock: product.stock,
          image_url: product.image.attached? ? rails_blob_url(product.image, only_path: false) : nil
        }
      end
    end
  end
end