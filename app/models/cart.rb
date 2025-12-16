class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
      current_item.price = product.price * current_item.quantity
    else
      current_item = line_items.build(product_id: product.id, price: product.price)
    end
    current_item
  end

  # def delete_product(product)
  #   current_item = line_items.find_by(product_id: product.id)
  #   if current_item.quantity == 1
  #     current_item = line_items.destroy(product_id: product.id)
  #   else
  #     current_item.quantity -= 1
  #   end
  #   current_item
  # end

  def total_price
    line_items.sum { |item| item.price }
  end
end
