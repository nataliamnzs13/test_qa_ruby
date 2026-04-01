require 'httparty'

class ApiClient
  include HTTParty
  # cambiar a la url de la api que se va a consumir
  base_uri 'https://jsonplaceholder.typicode.com'

  def initialize(token = nil)
    @headers = { 'Content-Type' => 'application/json' }
    # Si la API require autenticación
    @headers['Authorization'] = "Bearer #{token}" if token
  end

  def get_all(endpoint)
    self.class.get(endpoint)
  end

  def get_one(endpoint, id)
    self.class.get("#{endpoint}/#{id}")
  end

  def create(endpoint, payload)
    self.class.post(endpoint, headers: @headers, body: payload.to_json)
  end

  def update(endpoint, id, payload)
    self.class.patch("#{endpoint}/#{id}", headers: @headers, body: payload.to_json)
  end

  def delete(endpoint, id)
    self.class.delete("#{endpoint}/#{id}", headers: @headers)
  end
end