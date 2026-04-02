require "spec_helper"

RSpec.describe "Web Automation", type: :system do
    let(:base_url) { "https://jsonplaceholder.typicode.com/" }

    before(:each) do
        @page.goto(base_url)
    end

    it "validates navigation to page" do
        expect(@page.url).to eq(base_url) # verificar que la URL es correcta
    end

    context "validates page content" do
        it "should check the title of the page" do
            expect(@page.title).to eq("JSONPlaceholder - Free Fake REST API")
        end

        it "should extract and validate text from the page" do
            # 2. Extraer un texto de la página y validarlo
            h1 = @page.get_by_role("heading", name: "Free fake and reliable API", exact: false)

            expect(h1.text_content).to include("Free fake and reliable API")
        end

        it "should find a link and navigate to it" do
            # 2. Verificar que existe un link
            link = @page.get_by_role("link", name: "Guide").first # buscar el link con el texto "Guide"

            expect(link).to be_visible # verificar que el link existe y es visible

            # 3. Hacer click en el link
            link.click
            expect(@page.url).to eq("https://jsonplaceholder.typicode.com/guide/")
            expect(@page.url).to include("/guide") # verificar que la URL contiene "/guide"
        end
    end
end

## Selectores user-facing:

# get_by_role(role, options = {}) - para seleccionar elementos por su rol (ej: button, link, heading)
# get_by_test_id(test_id) - para seleccionar elementos con un atributo data-testid específico
# get_by_text(text, options = {}) - para seleccionar elementos que contienen cierto texto
# get_by_label(label, options = {}) - para campos de formulario con etiqueta <label>


# 2. Selectores Clásicos (CSS y XPath)

# CSS Selector: @page.locator(".clase-del-boton") o @page.locator("#id-unico").

# usa locator para interactuar con los elementos, por ejemplo:
# @page.locator("h1")          # por tag HTML
# @page.locator(".mi-clase")   # por clase CSS
# @page.locator("#mi-id")      # por ID
# @page.locator("//div[@id='login']")  # por XPath

#se puede encadenar por .first, .last, .nth(index) para seleccionar un elemento específico dentro de los resultados encontrados:
# @page.locator("h1").first
# @page.locator("h1").last
# @page.locator("h1").nth(1)

# Esperas
# para esperar un elemento -> wait_for_selector('#nombre del selector')
# esperar que sea visible
# wait_for_selector('.clase-del-elemento', state: 'visible')
# esperar que desaparezca
# wait_for_selector('.clase-del-elemento', state: 'hidden')
# definir un timeout personalizado (ej: 10 segundos)
# wait_for_selector('.clase-del-elemento', timeout: 10000)

#como usar filter para refinar la búsqueda de elementos:
# @page.locator("h1").filter("heading", name: "JSONPlaceholder")
    #@page.locator("button").filter("button", name: "Submit")
    #@page.locator("input").filter("textbox", name: "Username")
    #@page.locator("textarea").filter("textbox", name: "Message")
    #@page.locator("select").filter("combobox", name: "Country")
    #@page.locator("checkbox").filter("checkbox", name: "Accept Terms")
