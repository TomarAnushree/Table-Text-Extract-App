
library('docxtractr')

docx<-read_docx(choose.files())

extracted<-data.frame(docx_extract_all_tbls(docx,guess_header = TRUE,trim = TRUE))

extracted1<-as.data.frame(t(gsub(" ","_",extracted[1,])))

colnames(extracted)<-as.matrix(extracted1[1,])

extracted<-extracted[-1,]

table<-extracted


library('textreadr')

text<-textreadr::read_docx(choose.files())

text<-as.data.frame(text)

finaltable<-text


library(dbConnect)
library(RMySQL)
library(gWidgets)
library(odbc)
library(DBI)

con <- dbConnect(odbc::odbc(),user='root',password='123456',host='localhost', .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};")

Myquery<-"USE Project;"

dbGetQuery(con,Myquery)


dbWriteTable(con,"table_docx",value =table,row.names = NULL,append=FALSE,overwrite=TRUE)
            

table2df <- dbGetQuery(con, "SELECT * FROM table_docx")

databasetable<-table2df


dbDisconnect(con)


detach("package:docxtractr", unload=TRUE)

detach("package:textreadr", unload=TRUE)


