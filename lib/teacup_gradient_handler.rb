Teacup.handler UIView, :gradient { |layer|
  gradient = CAGradientLayer.layer
  gradient.frame = self.bounds
  layer.each do |key, value|
    gradient.send("#{key}=", value)
  end
  self.layer.insertSublayer(gradient, atIndex:0)
}
