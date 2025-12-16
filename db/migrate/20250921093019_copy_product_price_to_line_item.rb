class CopyProductPriceToLineItem < ActiveRecord::Migration[8.0]
  def up
    LineItem.all.each do |line_item|
      # price = line_item.products.where(product_id: product_id).price
      price = line_item.product.price * line_item.quantity
      line_item.price = price
      line_item.save!


      # def add_product(product)
      #   current_item = line_items.find_by(product_id: product.id)
      #   if current_item
      #     current_item.quantity += 1
      #   else
      #     current_item = line_items.build(product_id: product.id)
      #   end
      #   current_item
      # end
      # current_item = line_items.find_by(product_id: product.id)
      # current_price = products.find_by(line_item)
    end
  end
  def down
    LineItem.all.each do |line_item|
      line_item.price = nil
      line_item.save!
    end
  end
end
