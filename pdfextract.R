library(tabulizer)

library(stringr)

library(dbConnect)

library(RMySQL)

library(gWidgets)

library(odbc)

library(DBI)

out <- extract_tables(choose.files())

final <- do.call(rbind, out)

final <- as.data.frame(final[1:nrow(final), ])

colnames(final)<-as.matrix(final[1,])

final<-final[-1,]

table<-final

out2<-extract_text(choose.files(), pages = NULL, area =NULL , password = NULL,
                   encoding = 'UTF-8', copy = FALSE)

final1 <- do.call(rbind, list(out2))


text<-as.data.frame(strsplit(final1,"\n"))
colnames(text)<-("text")

finaltable<-text

con <- dbConnect(odbc::odbc(),user='root',password='123456',host='localhost', .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};")

Myquery<-"USE Project;"

dbGetQuery(con,Myquery)

dbWriteTable(con,"table_pdf",value = table,row.names = NULL,append=FALSE,overwrite = TRUE)

table2df <- dbGetQuery(con, "SELECT * FROM table_pdf")

databasetable<-table2df

dbDisconnect(con)



