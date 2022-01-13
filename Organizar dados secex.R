# Rotina para organizar os dados da SECEX
# Feito por: Marcelo Vilas Boas de Castro
# última atualização: 11/08/2020


# Definindo diretórios a serem utilizados
getwd()
# setwd("//srjn4/projetos/Projeto GAP-DIMAC/Automatizações/Att semanais")
setwd("D:\\Documentos")

# Carregando pacotes que serão utilizados
library(dplyr)
library(zoo)
library(rio)

# Download dos dados
temp <- tempfile()
download.file("https://balanca.economia.gov.br/balanca/IPQ/arquivos/Dados_brutos.zip",temp)
dados <- read.csv2(unz(temp, "arquivos/Dados_totais_mensal.csv"), row.names = 1)
unlink(temp)

# Organização dos dados
dados$DATA <- as.yearmon(paste(dados$CO_ANO, dados$CO_MES), "%Y %m")

tipo <- unique(dados$TIPO)

tipo_indice <- unique(dados$TIPO_INDICE)

nomes <- NA
for (i in 1:length(tipo)){
  for (j in 1:length(tipo_indice)){
    nome <- paste(tipo[i] , tipo_indice[j], sep = "_")
    data_f <- dados %>% filter(TIPO == tipo[i], TIPO_INDICE == tipo_indice[j]) %>% select(DATA, INDICE) %>% arrange(DATA)
    assign(nome, data_f)
    nomes <- append(nomes, nome)
  }
}

nomes <- nomes[-1]

for (i in 1:length(nomes)){
  if (i == 1)
    export(get(nomes[i]), "dados.xlsx", sheetName = nomes[i])
  else
    export(get(nomes[i]), "dados.xlsx", which = nomes[i])
}

