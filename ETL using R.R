library (dbConnect)
library (RSQLite)

#Extract data from database
db<- dbConnect(SQLite(), dbname="Art.sqlite") 

rs = dbSendQuery(db, "SELECT * FROM artworks") 
artworks = fetch(rs, n=-1) 
dbClearResult(rs)

rs = dbSendQuery(db, "SELECT * FROM locations") 
locations = fetch(rs, n=-1) 
dbClearResult(rs)

rs = dbSendQuery(db, "SELECT * FROM categories")
categories = fetch(rs, n=-1) 
dbClearResult(rs)

rs = dbSendQuery(db, "SELECT * FROM artists") 
artists = fetch(rs, n=-1)
dbClearResult(rs)
dbDisconnect(db)

#Transform and Merge your data
artworks = merge(x=artworks,y=artists,by=c("Artist_No"))
artworks = merge(x=artworks,y=categories,by=c("Category_No")) 
artworks = merge(x=artworks,y=locations,by=c("Location_No"))
artworks = artworks[,c("ArtID","Artist","Title","Date.Acquired","Category","Condition","Location","Appraised.Value")]
names(artworks)[names(artworks)=="Artist"] <- "artistname"
artworks$age<- as.numeric((Sys.Date( )- as.Date(artworks$Date.Acquired, "%m/%d/%y"))/365) 

#Load to a csv file
write.csv(artworks, "artworks.csv") 
