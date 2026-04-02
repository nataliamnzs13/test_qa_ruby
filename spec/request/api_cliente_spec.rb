require_relative '../../lib/api_client'

RSpec.describe "api test" do
    let(:client) { ApiClient.new }
    let(:endpoint) { '/posts' } # modifica esto según el endpoint que quieras probar

    describe "GET /index" do
        context "when the user requests all posts" do
            it "returns a list of posts" do
                response = client.get_all(endpoint)

                expect(response.code).to eq(200)
                expect(response.parsed_response).to all(include("id", "title", "body", "userId")) # para verificar que cada post tiene los campos esperados
                expect(response.parsed_response).to be_an(Array)

                puts "Response body: #{response.body}"
                puts "Response size: #{response.parsed_response.size}"
            end
        end
    end

    describe "GET /show" do
        # coger el primero de la lista para probar el GET /show
        let(:id) do
            lista = client.get_all(endpoint).parsed_response
            lista.first['id'] # obtiene el ID del primer post para la prueba
        end
        # crear un nuevo post para probar el GET /show con un ID válido
        # let(:id_created) do
        #     payload = { title: 'foo', body: 'bar', userId: 1 }
        #     response = client.create(endpoint, payload)
        #     response.parsed_response['id'] # obtiene el ID del post creado para la prueba
        # end

        context "when the resource exists" do
            it "returns the one resource" do
                response = client.get_one(endpoint, id) # prueba con un ID válido

                expect(response.code).to eq(200)
                expect(response.parsed_response['id']).to eq(id)

                puts "Response body show: #{response.body}"
            end
        end

        context "when the resource does not exist" do
            let(:invalid_id) { 9999 } # ID que no existe en la API

            it "returns 404" do
                response = client.get_one(endpoint, invalid_id)
                expect(response.code).to eq(404)

                puts "Response body show invalid: #{response.body}"
            end
        end
    end
end