class PriceCalculator

  PRODUCTS = ["Milk", "Bread", "Apple", "Banana"]

  PRICE_MAP = {
    "Milk" => { unit_price: 3.97, sale_price: {qty: 2, price: 5.00} },
    "Bread" => { unit_price: 2.17, sale_price: {qty: 3, price: 6.00} },
    "Banana" => { unit_price: 0.99 },
    "Apple" => { unit_price: 0.89 }
  }

  def initialize(items)
    @items = items
  end

  # Purchased items in cart
  def purchased_items
    @items.inject({}) do |hash, item|
      item = item.capitalize
      if PRODUCTS.include? item
        hash[item] = 0 unless hash[item.to_s]
        hash[item] += 1
      end
      hash
    end
  end

  # To print a total cost of purchased items
  def print_total_cost
    order_desc = []
    order_desc << "----------------------------"
    order_desc << "Item     Quantity      Price"
    order_desc << "----------------------------"
    
    total_price = 0
    saved_cost = 0
    purchased_items.each do |item, count|
      unit_price = PRICE_MAP[item][:unit_price].to_f

      if PRICE_MAP[item][:sale_price]
        qty = PRICE_MAP[item][:sale_price][:qty]
        unit_qty = qty.to_i.zero? ? 1 : qty
        if count < unit_qty
          unit_price *= count
        else
          sale_price = PRICE_MAP[item][:sale_price][:price].to_f
          offer_price = (unit_price * (count % unit_qty)) + (sale_price * (count / unit_qty))
          saved_cost += (unit_price * count) - offer_price
          unit_price = offer_price
        end
      else
        unit_price *= count
      end
      unit_price = ('%.2f' % unit_price).to_f
      order_desc << "#{item}     #{count}      $#{unit_price}"
      total_price += unit_price
    end
    order_desc << ""
    order_desc << "Total price : $#{'%.2f' % total_price}"
    order_desc << "You saved $#{'%.2f' % saved_cost} today." unless saved_cost.zero?
    order_desc << ""
    order_desc.map {|d| puts d }
  end

end

params = ARGV.join(",").split(/,/).reject { |c| c.empty? }

pc = PriceCalculator.new(params)
pc.print_total_cost

