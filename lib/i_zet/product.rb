class IZet::Product
  attr_reader :product
  def initialize(product)
    product.each do |key,value|
      self.instance_variable_set("@#{key}", value.is_a?(Hash) ? Product.new(value) : value)
      self.class.send(:define_method, key, proc{self.instance_variable_get("@#{key}")})
      self.class.send(:define_method, "#{key}=", proc{|value| self.instance_variable_set("@#{key}", value)})
    end
  end

  def category
    product['category']
  end

  def self.all
    IZet.products.map do | product |
      new(product)
    end
  end
  def self.active_categories
    categories = all.map(&:category).uniq! {|category| category unless !category }
    categories.compact
  end
end