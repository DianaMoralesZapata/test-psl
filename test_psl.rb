# RSPEC: Framework para pruebas usando el lenguaje Ruby
require "rspec"
require "selenium-webdriver"
require 'net/http'
require 'json'

RSpec.describe "Cita" do

  # Caso de prueba 1
  it "muestra mensaje de error si no ingresa un documento de identidad" do
    
    # Variables
    url = "http://automatizacion.herokuapp.com/dianamorales/appointmentScheduling"
    texto_fecha = "08/16/2016"
    
    # Iniciar el navegador con selenium
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to url

    # Llenar campo de fecha
    input_fecha = driver.find_element(:id, "datepicker")
    input_fecha.send_keys texto_fecha
    
    # Click en el botón Guardar
    boton = driver.find_element(:class, "btn")
    boton.click

    # Obtener el texto de la página de respuesta
    texto_errores = driver.find_element(:class, "panel-danger").text
    texto_tabla   = driver.find_element(:class, "table").text

    # Pruebas - Resultados Esperados
    expect(texto_errores).to include("*El campo 'Documento de identidad' es requerido.")
    expect(texto_tabla).to   include(texto_fecha)

    # Cierra el navegador
    sleep(5)
    driver.quit
  end


  # Caso de prueba 2
  it "muestra mensaje de error cuando se ingresa un número de documento incorrecto" do
    
    # Variables
    url         = "http://automatizacion.herokuapp.com/dianamorales/appointmentScheduling"
    texto_fecha = "08/16/2016"
    id_doctor   = "123"
    id_paciente = "456"
    
    # Iniciar el navegador con selenium
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to url

    # Llenar campo de fecha
    fecha = driver.find_element(:id, "datepicker")
    fecha.send_keys texto_fecha

    # Buscar los campos de doctor y paciente usando xpath con el atributo 'placeholder'
    input_paciente = driver.find_element(:xpath, "//input[@placeholder='Ingrese el documento de identidad del paciente']")
    input_doctor   = driver.find_element(:xpath, "//input[@placeholder='Ingrese el documento de identidad del doctor']")
    
    # Llenar campos de Documento de identidad de doctor y paciente
    input_paciente.send_keys id_paciente
    input_doctor.send_keys id_doctor
    
    # Click en el botón Guardar
    boton = driver.find_element(:class, "btn")
    boton.click

    # Obtener el texto de la página de respuesta
    texto_errores = driver.find_element(:class, "panel-danger").text
    texto_tabla   = driver.find_element(:class, "table").text

    # Pruebas - Resultados Esperados
    expect(texto_errores).to include("*El campo 'Documento de identidad' no se encuentra entre nuestros doctores.")
    expect(texto_errores).to include("*El campo 'Documento de identidad' no se encuentra entre nuestros pacientes registrados.")
    expect(texto_tabla).to   include(texto_fecha)
    expect(texto_tabla).to   include(id_doctor)
    expect(texto_tabla).to   include(id_paciente)

    # Cierra el navegador
    sleep(5)
    driver.quit
  end


  # Caso de prueba 3
  it "muestra mensaje de error cuando se ingresa un número de documento incorrecto" do
    
    # Variables
    url         = "http://automatizacion.herokuapp.com/dianamorales/appointmentScheduling"
    texto_fecha = "08/16/2016"
    id_doctor   = "12345"
    id_paciente = "54321"
    
    # Iniciar el navegador con selenium
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to url

    # Llenar campo de fecha
    fecha = driver.find_element(:id, "datepicker")
    fecha.send_keys texto_fecha

    # Buscar los campos de doctor y paciente usando xpath con el atributo 'placeholder'
    input_paciente = driver.find_element(:xpath, "//input[@placeholder='Ingrese el documento de identidad del paciente']")
    input_doctor   = driver.find_element(:xpath, "//input[@placeholder='Ingrese el documento de identidad del doctor']")
    
    # Llenar campos de Documento de identidad de doctor y paciente
    input_paciente.send_keys id_paciente
    input_doctor.send_keys id_doctor
    
    # Click en el botón Guardar
    boton = driver.find_element(:class, "btn")
    boton.click

    # Obtener el texto de la página de respuesta
    texto_guardado = driver.find_element(:class, "panel-success").text
    texto_tabla    = driver.find_element(:class, "table").text

    # Pruebas - Resultados Esperados
    expect(texto_guardado).to include("Datos guardados correctamente.")
    expect(texto_tabla).to    include(texto_fecha)
    expect(texto_tabla).to    include(id_doctor)
    expect(texto_tabla).to    include(id_paciente)
    expect(texto_tabla).to    include("Juan")
    expect(texto_tabla).to    include("Pedro")

    # Cierra el navegador
    sleep(5)
    driver.quit
  end
  
  
  # Caso de Prueba consumiendo un API
  # API Usado: https://jsonplaceholder.typicode.com

  it "consumir api de prueba y verificar datos de un usuario" do
    
    url = "https://jsonplaceholder.typicode.com/users"
    uri = URI(url)
    respuesta_api = Net::HTTP.get(uri)
    datos_json = JSON.parse(respuesta_api)

    nombre = datos_json.first["name"];

    expect(nombre).to eq "Leanne Graham"
  end

end
