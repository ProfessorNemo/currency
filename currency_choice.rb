class CurrencyChoice
  def initialize(params)
    @id = params[:id]
    @name = params[:name]
  end

  def self.from_xml(node)
    new(
      id: node.attributes['ID'],
      name: node.elements['Name'].text
    )
  end

  def to_s
    @name.to_s
  end
end
