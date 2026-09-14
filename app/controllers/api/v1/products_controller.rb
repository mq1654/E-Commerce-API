class Api::V1::ProductsController < ApplicationController
   def create
      product = Product.new(product_params)
      if product.save
         if params[:options].present?
            variant_count = 1
            vov_count = 1
            variant_ids = []
            option_ids = []
            option_value_ids = []
            params[:options].each do |option|
               variant_count *= option[:option_values].size
               opt = Option.create(name: option[:name], product_id: product.id)
               option_ids.push(opt.id)
               values = []
               option[:option_values].each do |opt_val|
               option_value = OptionValue.create(value: opt_val, option_id: opt.id)
               values.push(option_value.id)
               end
               option_value_ids.push(values)
            end
             variant_count.times do |i|
            variant = Variant.create(
               product_id: product.id,
               sku: "SKU-#{product.id}-#{i + 1}",
               price: product.base_price,
               stock: 0
               )
               variant_ids.push(variant.id)
            end
            vov_count = variant_count * params[:options].size
            vov_count.times do |i|
            VariantOptionValue.create(
               option_id: option.id,

               )
            end
         end
         render json: product, status: :created
      else
      render json: product.errors, status: :unprocessable_entity
      end
   end

   private
   def product_params
      params.require(:product).permit(
         :name,
         :description,
         :brand,
         :base_price,
         :category_id,
         :image_url
   )
   end
end
