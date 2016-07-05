
# Exporting Data

# To A Tab Delimited Text File
write.table(mydata, "c:/mydata.txt", sep="\t")

# To an Excel Spreadsheet
library(xlsx)
write.xlsx(mydata, "c:/mydata.xlsx")

# To SPSS
# write out text datafile and an SPSS program to read it
library(foreign)
write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sps",   package="SPSS")

# To SAS
# write out text datafile and an SAS program to read it
library(foreign)
write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sas",   package="SAS")

# To Stata
# export data frame to Stata binary format 
library(foreign)
write.dta(mydata, "c:/mydata.dta")

?with
