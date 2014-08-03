# Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv "
download.file(url, "getdata-Fdata-Fss06hid.csv")
data <- read.csv("getdata-Fdata-Fss06hid.csv")
strsplit(names(data)[123],"wgtp")

#Question2
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 190))
GDP <- dtGDP[,dtGDP$X.4]
GDP1 <- as.integer(gsub(",", "", GDP))
mean(GDP1)

#Question 3
countryNames <- dtGDP[,dtGDP$X.3]
grep("^United",countryNames)

#Question 4
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv "
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip=4, nrows=215, stringsAsFactors=FALSE))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv "
f1 <- file.path(getwd(), "Country.csv")
download.file(url, f1)
Country <- read.csv(f1)

dt <- merge(dtGDP, Country, all=TRUE, by=c("CountryCode"))
isFiscalYearEnd <- grepl("fiscal year end", tolower(dt$Special.Notes))
isJune <- grepl("june", tolower(dt$Special.Notes))
table(isFiscalYearEnd, isJune)
dt[isFiscalYearEnd & isJune, Special.Notes]

#Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
