require 'playwright'
require_relative 'support/api_helpers'

RSpec.configure do |config|
    #around(:each) sirve para garantizar que cada test tenga un navegador limpio
    config.around(:each, type: :system) do |example|
        Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
        # Configuramos el navegador una sola vez por test
        browser = playwright.chromium.launch(headless: false) # abrir la ventana del navegador
        @page = browser.new_page # abrir una nueva pestaña

        example.run # Aquí se ejecuta tu bloque "it"

        browser.close
        end
    end
    config.include ApiHelpers # aplica el módulo en todos los specs
end
