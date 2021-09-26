module SerializableResource
  def parse_json
    ActiveModelSerializers::SerializableResource.new(object).as_json
  end
end