class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)


    elsif req.path.match(/cart/)

      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each {|cart_item| resp.write "#{cart_item}\n"}
      end

    elsif req.path.match(/add/)
      requested_item = req.params["item"]
      
      ## OR can separate the 'add item' method i.e.
      # resp.write add_item_to_cart(item)
      #and remove the next 6 lines (if, else and end)

      if @@items.include?(requested_item)
        @@cart << requested_item
        resp.write "added #{requested_item} to your cart" 
      else
        resp.write "We don't have that item"
      end

      
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end


  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  ##BELOW IS SEPARATE METHOD IF DECIDE TO KEEP IT SEPARATE AS ABOVE IN COMMENTS.
  #
  # def add_item_to_cart(requested_item)
  #   if @@items.include?(requested_item)
  #     @@cart << requested_item
  #     "added #{requested_item}"
  #   else
  #     "We don't have that item"
  #   end
  # end

end


#http://localhost:9292/search?q=Apples #appears to be case sensitive e.g. apples vs Apples
#http://localhost:9292/add?item=Pears
#http://localhost:9292/cart
#http://localhost:9292/add?item=Figs