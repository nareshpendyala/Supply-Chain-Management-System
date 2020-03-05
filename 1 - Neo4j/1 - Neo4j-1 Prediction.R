install.package("RNeo4j")
library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/", 
                   username="neo4j", password="password")

query3 = "match (u:Order)-[:Order]->(b:Retailer)
return b.id, u.name, u.price,u.quantity, u.time"

d <- cypher(graph,query3)

reg <-lm(u.quantity~u.price+u.time, data =  d,
         na.action=na.exclude)

d$u.time <- as.factor(d$u.time)

PvA<- function(model,varlist=NULL,smooth=.5) { #Plot predicted vs actual for a model
  
  indvars <- attr(terms(model),"term.labels")
  
  if (is.null(varlist)) {
    varlist <- indvars
  }
  
  Y <- as.character(as.list(attr(terms(model),"variables"))[2])
  P.Y <- paste('P',Y,sep='.')
  
  DF <- as.data.frame(get(as.character(model$call$data)))
  DF[,P.Y] <- predict.lm(model)
  
  par(ask=TRUE)
  for (X in varlist) {
    print(X)
    A <- na.omit(DF[,c(X,Y)])
    P <- na.omit(DF[,c(X,P.Y)])
    plot(A)
    points(P,col=2)
    lines(lowess(A,f=smooth),col=1)
    lines(lowess(P,f=smooth),col=2)
  }
  
}



pred <- predict(reg, 
                  newdata = BostonHousing[validation,], 
                  na.action = na.pass)

summary(reg)
PvA(reg)
