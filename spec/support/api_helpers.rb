module ApiHelpers
  # devuelve el JSON formateado con indentación para facilitar la lectura
  def json_response(response)
    JSON.pretty_generate(response.parsed_response)
  end
end



