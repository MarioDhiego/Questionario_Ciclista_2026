library(shiny)
library(shinysurveys)
library(googlesheets4)
library(gargle)
library(curl)
library(httr2)
library(openssl)
library(googledrive)

options(googlesheets4.httr = "httr2")


drive_auth(
  path = "intense-cortex-486617-n1-11813be9c98a.json",
  cache = FALSE
)

gs4_auth(token = drive_token())










Perguntas <- data.frame(
  question = c(
    rep("Qual é o seu Gênero?", 3),
    rep("Qual é a sua Faixa Etária?", 5),
    rep("Como você se Autodeclara em relação à Cor ou Raça?", 5),
    rep("Qual é o seu Nível de Escolaridade?", 5),
    rep("Qual é a sua Profissão?", 7),
    rep("Qual é a sua Renda Familiar Mensal Aproximada?", 4),
    rep("Qual é o Tipo de Bicicleta que você utiliza com mais frequência?", 4)
  ),
  option = c(
    "Masculino","Feminino","Outro",
    "12 a 18 anos","19 a 29 anos","30 a 49 anos","50 a 64 anos","65 ou mais",
    "Branca","Preta","Amarela","Parda","Indígena",
    "Sem Instrução","Ensino Fundamental","Ensino Médio",
    "Ensino Superior","Pós-graduação",
    "Trabalhador Formal","Trabalhador Informal","Estudante",
    "Autônomo","Aposentado","Desempregado","Outro",
    "Até 1 Salário Mínimo",
    "Entre 1 e 3 Salários Mínimos",
    "Entre 3 e 5 Salários Mínimos",
    "Acima de 5 Salários Mínimos",
    "Bicicleta Convencional",
    "Bicicleta Compartilhada",
    "Bicicleta Elétrica",
    "Patinete"
  ),
  input_type = rep("mc", 33),
  input_id = c(
    rep("genero", 3),
    rep("faixa_etaria", 5),
    rep("raca", 5),
    rep("escolaridade", 5),
    rep("profissao", 7),
    rep("renda", 4),
    rep("tipobike", 4)
  ),
  dependence = NA,
  dependence_value = NA,
  required = TRUE,
  stringsAsFactors = FALSE
)

ui <- fluidPage(
  div(style = "max-width:800px; margin:80px auto;",
      surveyOutput(
        df = Perguntas,
        survey_title = "PESQUISA PELA MOBILIDADE POR BICICLETA",
        survey_description = "Perfil do Ciclista Paraense 2026",
        progress = TRUE
      )
  )
)

server <- function(input, output, session) {
  
  renderSurvey()
  
  observeEvent(input$submit, {
    
    respostas <- getSurveyData()
    respostas$data_hora <- Sys.time()
    
    sheet_append(
      ss = "11cQhHCIZWgtEdFno1z3lUBmd6azynWkkA6H1aPf8apU",
      data = respostas
    )
    
    showModal(modalDialog(
      title = "Pesquisa Enviada com Sucesso!",
      "Agradecemos sua participação.",
      easyClose = TRUE,
      footer = NULL
    ))
    
  })
}

shinyApp(ui, server)




file.show("intense-cortex-486617-n1-11813be9c98a.json")







