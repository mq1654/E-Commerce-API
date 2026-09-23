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
      products = Product.includes(:variants)
      if params[:search].present?
         products = products.where("name ILIKE ?", "%#{params[:search]}%")
      end
      if params[:category_id].present?
         products = products.where(category_id: params[:category_id])
      end

      if params[:min_price].present?
         products = products.where("base_price >= ?", params[:min_price])
      end
      if params[:max_price].present?
         products = products.where("base_price <= ?", params[:max_price])
      end

      allowed_sorts = [ "name", "base_price", "created_at" ]
      sort_column = allowed_sorts.include?(params[:sort]) ? params[:sort] : "created_at"
      order_direction = (params[:order] == "asc") ? "asc" : "desc"
      products = products.order(sort_column => order_direction)

      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
      per_page = 50 if per_page > 50

      offset = (page - 1) * per_page
      total = products.count
      total_pages = (total.to_f / per_page).ceil
      products = products.limit(per_page).offset(offset)

      product_summaries = products.map do |product|
      prices = product.variants.map(&:price)
      {
         id: product.id,
         name: product.name,
         description: product.description,
         base_price: product.base_price,
         image_url: product.image_url,
         variant_count: product.variants.size,
         price_min: prices.min,
         price_max: prices.max,
         created_at: product.created_at,
         updated_at: product.updated_at
      }
      end
      render json: {
         data: product_summaries,
         meta: {
            page: page,
            per_page: per_page,
            total: total,
            total_pages: total_pages
         }
      }, status: :ok
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
      render json: { error: { code: "product_not_found", message: "Product not found" } }, status: :not_found unless @product
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
