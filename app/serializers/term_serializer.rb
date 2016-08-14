class TermSerializer < ActiveModel::Serializer
  attributes :response_type, :text

  def response_type
    serialization_options[:serializer_params][:response_type]
  end

  def text
    [object.name, object.description].compact.join(': ')
  end
end
