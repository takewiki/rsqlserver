context("Reading data using rsqlserver")

test_that("query in a temporary table works fine ", {

  req <- "create table #tempTable(Test int)
          insert into #tempTable
          select 2
          select * from #tempTable
          drop table #tempTable"
  conn <- dbConnect('SqlServer',user="collateral",password="collat",
                    host="localhost",trusted=TRUE, timeout=30)
  ress <- dbGetScalar(conn, req)
  dbDisconnect(conn)
  expect_equal(ress,2)
})





test_that("Create a table and remove it using handy functions ", {
  
  conn <- dbConnect('SqlServer',user="collateral",password="collat",
                    host="localhost",trusted=TRUE, timeout=30)
  if(dbExistsTable(conn,'T_MTCARS'))
    dbRemoveTable(conn,'T_MTCARS')
  dbWriteTable(conn,name='T_MTCARS',mtcars)
  expect_equal(dbExistsTable(conn,'T_MTCARS'),TRUE)
  dbRemoveTable(conn,'T_MTCARS')
  expect_equal(!dbExistsTable(conn,'T_MTCARS'),TRUE)
  dbDisconnect(conn)
})


test_that(" get some columns from a table ", {
  
  conn <- dbConnect('SqlServer',user="collateral",password="collat",
                    host="localhost",trusted=TRUE, timeout=30)
  if(dbExistsTable(conn,'T_MTCARS'))
    dbRemoveTable(conn,'T_MTCARS')
  dbWriteTable(conn,name='T_MTCARS',mtcars)
  expect_equal(dbExistsTable(conn,'T_MTCARS'),TRUE)
  
  query <- "SELECT  mpg,cyl,wt 
               FROM    T_MTCARS"
  res <- dbGetQuery(conn, query)
  dbRemoveTable(conn,'T_MTCARS')
  expect_equal(!dbExistsTable(conn,'T_MTCARS'),TRUE)
  dbDisconnect(conn)
  expect_is(res,'data.frame')
  expect_equal(nrow(mtcars),nrow(res))
})

