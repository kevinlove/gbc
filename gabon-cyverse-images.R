library(dplyr)
library(tidyr)
library(jsonlite)
library(uuid)

#####################
# Read in your occurrence spreadsheet
occurrenceFile <- ""
data_long <- read.csv(occurrenceFile,stringsAsFactors = F)


#####################
# Fetch the public access URI from Cyverse
data_long$accessURI <- ""

for(i in seq_along(data_long$GUID)){
  data_long$accessURI[i] <- paste0("https://bisque.cyverse.org/image_service/image/",fromJSON(paste0("https://bisque.cyverse.org/data_service/image?tag_query=filename:",data_long$Photos[i],"*"))$resource$image$resource_uniq,"?resize=1250&format=jpeg")  
}

##Need to mint GUID's for each image record
data_long <- data_long %>% rowwise() %>% mutate(identifier=paste0("urn:uuid:",UUIDgenerate()))

##coreid will be called 'occurrenceID' and is the identifier for the specimen occurrence
data_long$occurrenceid <- data_long$GUID


## Name our outfile
outFile <-""
write.csv(data_long,outFile,row.names = F)