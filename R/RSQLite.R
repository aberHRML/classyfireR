#### read packages ####
library(readr)
library(magrittr)
library(classyfireR)
library(RSQLite)
library(rinchi)

#### load and config data ####
data <- read.csv("~/R/classyfireR/sample_export.csv")

InChiKey <- as.character(read.csv("~/R/classyfireR/sample_export.csv")[["InChI"]])

smiles <- as.character(read.csv("~/R/classyfireR/sample_export.csv")[["canonical.smiles"]])
InChi <- as.character(sapply(smiles, get.inchi))
Classification <- sapply(InChiKey, classyfireR::get_classification)

#### loop for serialization ######
output <-list(vector())
for (i in 1:length(Classification)) {
  output[[i]] <- rawToChar(serialize(Classification[[i]], connection=NULL, ascii=TRUE))
}
output

#### list of raw-vectors in dataframe ###########
dataset_class <- data.frame(InChiKey,InChi,Classification=I(output)) 
Raw_to_class <- unserialize(charToRaw(dataset_class$Classification[[2]]))

####database####

conn <- dbConnect(RSQLite::SQLite(), "~/R/classyfireR/classyfireR.db") #":memory:"

dbExecute(conn,"CREATE TABLE IF NOT EXISTS 'classyfire' (
          InChikey CHAR(27) PRIMARY KEY,
          InChi TEXT,
          Classification TEXT)")
          #Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")


rd<-dbSendStatement(conn,"INSERT OR IGNORE INTO classyfire (InChiKey,InChi,Classification) VALUES(?,?,?)")
dbBind(rd, list(dataset_class$InChiKey,dataset_class$InChi,unlist(dataset_class$Classification)))


#### queries ####
dbSendQuery(conn,"SELECT InChiKey FROM classyfire")

dbGetQuery(conn, "SELECT InChiKey,Inchi,Classification FROM classyfire WHERE InChiKey='WTMBTNXPPIBZFI-UHFFFAOYSA-N'")
dbGetQuery(conn, "SELECT InChiKey FROM classyfire")
dbGetQuery(conn, "SELECT InChi FROM classyfire")
dbGetQuery(conn, "SELECT Classification FROM classyfire")
print(dbGetQuery(conn, "SELECT COUNT(*) FROM dummy;"))

dbDisconnect(conn)
dbRemoveTable(conn,"classyfire")
dbListTables(conn)
dbListFields(conn,"classyfire")
print(dbGetQuery(conn, "SELECT COUNT(*) FROM classyfire"))


#### database try####
#dbWriteTable(conn, "dataset_write", dataset_class,append=TRUE)
#dbExecute(conn, "INSERT OR IGNORE INTO dummy (InChiKey,InChi,Classification) VALUES ('",inchikey[1], "')")
#dbExecute(conn, "DELETE FROM dataset WHERE rowid NOT IN(SELECT min(rowid) FROM dataset GROUP BY inchikey,inchi,Classification_List)")
#dbSendQuery(conn, paste0("INSERT OR IGNORE INTO dummy (InChiKey,InChi,Classification) VALUES('",dataset_class$InChiKey[5], "','",dataset_class$InChi[5], "','",dataset_class$Classification[5], "')"))
# for (i in 1:nrow(dataset_class)) {
#   dbSendQuery(conn, paste0("INSERT OR IGNORE INTO classyfire (InChiKey,InChi,Classification) VALUES('",dataset_class$InChiKey[i], "','",dataset_class$InChi[i], "','",dataset_class$Classification[i], "')"))
#   }

# for (i in 1:nrow(dataset_class)) {
#   rs<-dbSendStatement(conn,"INSERT OR IGNORE INTO classyfire (InChiKey,InChi,Classification) VALUES(?,?,?)",params=list(dataset_class$InChiKey[i],dataset_class$InChi[i],dataset_class$Classification[[i]]))
# }
# dbClearResult(rs)
# 
# for (i in 1:nrow(dataset_class)) {
#   rd<-dbSendStatement(conn,"INSERT OR IGNORE INTO classyfire (InChiKey,InChi,Classification) VALUES(?,?,?)")
#   dbBind(rd, list(dataset_class$InChiKey[i],dataset_class$InChi[i],dataset_class$Classification[[i]]))
#   }
# dbClearResult(rd)