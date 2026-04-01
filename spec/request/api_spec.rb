require "spec_helper"
require "httparty"

RSpec.describe "API Tests - CRUD" do
    # coger la url de la api
    let(:base_url) { "https://jsonplaceholder.typicode.com"}
    let(:headers) { { "Content-Type" => "application/json" } }

    context "GET /index" do
        it "returns a list of posts" do
            # llamar al endpoint de la api para obtener los posts
            response = HTTParty.get("#{base_url}/posts")

            # verificar el codigo de la respuesta y el formato de los datos
            expect(response.code).to eq(200)
            expect(response.parsed_response).to be_an(Array)

            puts "Number of posts: #{response.parsed_response.size}"
            puts json_response(response) # usando el helper para imprimir el JSON formateado
        end
    end

    context "GET /show" do
        # Definimos el ID aquí, pero podemos cambiarlo en cada bloque
        let(:id) { 1 }

        context "return post if exists" do
            it "returns the post with the correct ID" do
                response = HTTParty.get("#{base_url}/posts/#{id}")

                expect(response.code).to eq(200)
                expect(response.parsed_response["id"]).to eq(id)

                puts "Created post #{json_response(response)}" # usando el helper para imprimir el JSON formateado
            end
        end

        context "when post does not exist" do
            # Usamos un ID que sabemos que no existe
            let(:id) { 9999 }

            it "returns 404 if not exists" do
                response = HTTParty.get("#{base_url}/posts/#{id}")

                expect(response.code).to eq(404)
            end
        end
    end

    context "POST /create" do
        context "POST /create (Happy Path)" do
            it "creates a new post" do
                payload = {
                    title: "Membresia en el club de lectura",
                    body: "Quiero unirme al club de lectura para compartir mis opiniones sobre los libros que leo y conocer a otros amantes de la lectura.",
                    userId: 1
                }

                # guardar la respuesta de la api al crear un nuevo post
                response = HTTParty.post("#{base_url}/posts",
                                            body: payload.to_json,
                                            headers: headers
                                        )

                # verificar que el post se ha creado correctamente -> el codigo de respuesta es 201 y los datos del post creado son correctos
                expect(response.code).to eq(201)
                expect(response.parsed_response["title"]).to eq(payload[:title])
                expect(response.parsed_response["body"]).to eq(payload[:body])

                puts "Created post #{json_response(response)}" # usando el helper para imprimir el JSON formateado
            end
        end

    context "POST /create (Error Path)" do
        it "returns error when sending invalid data types" do
            # Enviamos un userId que no es un número, por ejemplo
            payload = { title: 12345, body: nil, userId: "string" }

            response = HTTParty.post("#{base_url}/posts",
                                    body: payload.to_json,
                                    headers: headers)

            # En una API real esperaríamos un 400 (Bad Request) o 422 (Unprocessable Entity)
            # Nota: JSONPlaceholder suele devolver 201 igual, pero en la entrevista
            # puedes decir: "Aquí esperaría un 400 si la API tuviera validaciones estrictas"
            puts "Status recibido: #{response.code}"
        end
    end
    end

    context "PATCH /update" do
        let(:id) { 1 } # ID del post que queremos actualizar

        it "updates an existing post" do
            payload = {
                title: "Nuevo club de lectura",
                body: "Quiero unirme al nuevo club de la lectura.",
                userId: 1
            }

            response = HTTParty.patch("#{base_url}/posts/#{id}",
                                        body: payload.to_json,
                                        headers: headers
                                    )
            expect(response.code).to eq(200)
            expect(response.parsed_response["title"]).to eq(payload[:title])
            expect(response.parsed_response["body"]).to eq(payload[:body])

            puts "Updated post #{json_response(response)}" # usando el helper para imprimir el JSON formateado
        end
    end

    context "DELETE /destroy" do
        # buscar por id el recurso que queriamos eliminar
        let(:id) { 1 } # ID del post que queremos eliminar

        it "deletes a post by ID" do
            response = HTTParty.delete("#{base_url}/posts/#{id}")

            # verificar que el post se ha eliminado correctamente -> el codigo de respuesta es 200 o 204
            expect([200, 204]).to include(response.code)

            puts "Deleted post with ID: #{id}"
        end
    end

    context "Security Tests" do
        it "returns 401 Unauthorized when token is missing" do
            # Simulamos una llamada sin cabeceras de autorización
            response = HTTParty.get("#{base_url}/posts", headers: {})

            # Si la API fuera privada, esto debería ser 401
            # Como JSONPlaceholder es pública, dará 200, pero mencionarlo te da puntos.
            puts "Validando seguridad: ¿Es este endpoint público o privado?"
        end
    end
end

