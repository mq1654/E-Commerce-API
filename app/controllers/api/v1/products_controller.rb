class Api::V1::ProductsController < ApplicationController
   skip_before_action :verify_authenticity_token
   before_action :set_product, only: [ :show, :update, :destroy ]
   def create
      ActiveRecord::Base.transaction do
      product = Product.new(product_params)
      if product.save
         if params[:options].present?
            variant_count = 1
            vov_count = 1
            variant_ids = []
            option_ids = []
            option_value_ids = []
            # opt
            params[:options].each do |option|
               values = []
               variant_count *= option[:option_values].size
               opt = Option.create(name: option[:name], product_id: product.id)
               option_ids.push(opt.id)
               option[:option_values].each do |opt_val|
               option_value = OptionValue.create(value: opt_val, option_id: opt.id)
               values.push(option_value.id)
               end
               option_value_ids.push(values)
            end
             # variant
             variant_count.times do |i|
            variant = Variant.create(
               product_id: product.id,
               sku: "SKU-#{product.id}-#{i + 1}",
               price: product.base_price,
               stock: 0
               )
               variant_ids.push(variant.id)
            end
            # variant_option_value
            combinations = option_value_ids[0].product(*option_value_ids[1..])
            variant_count.times do |i|
               cur_variant_id = variant_ids[i]
               cur_combination = combinations[i]
               cur_combination.each do |opt_val_id|
                  VariantOptionValue.create(
                     variant_id: cur_variant_id,
                     option_value_id: opt_val_id
                  )
               end
            end
         end
         render json: product, status: :created
      else
      render json: product.errors, status: :unprocessable_entity
      end
      end
   end

   def index
      products = Product.all
      render json: products, status: :ok
   end

   def show
      render json: @product.as_json(
         include: {
            options: {
               include: :option_values
            },
            variants: {}
         }
      ), status: :ok
   end

   def update
      if @product.update(product_params)
         render json: @product, status: :ok
      else
         render json: @product.errors, status: :unprocessable_entity
      end
   end

   def destroy
      @product.destroy
      head :no_content
   end

   private
   def set_product
      @product = Product.includes(options: :option_values, variants: {}).find_by(id: params[:id])
      render json: { error: "Product not found" }, status: :not_found unless @product
   end

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
