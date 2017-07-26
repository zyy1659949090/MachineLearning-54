# http://blog.revolutionanalytics.com/2016/02/ms_sql_azure.html

# Now that the preliminaries are out of the way, you should be able to populate your 
# database with the following code. 
# The RODBC package is used to communicate with SQL Server. 
# The nycflights13 package provides a convenient test data set with over 300,000 rows 
# and 16 columns. The connection string is what I copied from the Azure ODBC text box 
# described above, except that I have replaced my login ID with the text "my_ID". 
# (Let this serve as a gentle reminder not to store your credentials in the source code.) 
# The command odbcDriverConnect() opens the ODBC connection to the database, 
# but the real work is done sqlSave() that populates the database with the flights data. 
# This took about 40 minutes on running from my RStudio R script executing on my lenovo 
# Thinkpad.

# CONNECT TO AN AZURE SQL DATABASE
library(RODBC)           # Provides database connectivity
library(nycflights13)    # SOme sample data
library(dplyr)           # only used for nice format of Head() function here

# The Connection string comes from the Azure ODBC text box
#connectionString <- "Driver={SQL Server Native Client 11.0};Server=tcp:hzgi1l8nwn.database.windows.net,1433;Database=Test_R2;Uid=your_logon_ID@hzgi1l8nwn;Pwd={your_password_here};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
connectionString <- "Driver={SQL Server Native Client 11.0};Server=tcp:mytrialdb.database.windows.net,1433;Database=Trial;Uid=robertandrewstevens@mytrialdb;Pwd=Married123456;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
connectionString <- "Driver={SQL Server Native Client 11.0};Server=tcp:mytrialdb.database.windows.net,1433;Database=Trial;Uid=robertandrewstevens@mytrialdb;Pwd={Married123456};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"

#Open your RODBC connection
myconn <- odbcDriverConnect(connectionString)

# Get some data
# We use the New York City 2013 Flight Data from thepackage nycflights12
dim(flights)
#[1] 336776     16
head(flights)
# Source: local data frame [6 x 16]
# 
# year month   day dep_time dep_delay arr_time arr_delay carrier tailnum
# (int) (int) (int)    (int)     (dbl)    (int)     (dbl)   (chr)   (chr)
# 1  2013     1     1      517         2      830        11      UA  N14228
# 2  2013     1     1      533         4      850        20      UA  N24211
# 3  2013     1     1      542         2      923        33      AA  N619AA
# 4  2013     1     1      544        -1     1004       -18      B6  N804JB
# 5  2013     1     1      554        -6      812       -25      DL  N668DN
# 6  2013     1     1      554        -4      740        12      UA  N39463
# Variables not shown: flight (int), origin (chr), dest (chr), air_time (dbl),
# distance (dbl), hour (dbl), minute (dbl)

# Save the table to the database
sqlSave(channel=myconn, dat=flights, tablename = "flightsTbl")


# The following code executes a SQL query and displays some of the data returned. odbcCloseAll() closes the ODBC connection. 

# Fetch movies with ratings GT 3 from Azure SQL DB
sqlQuery_m1 <- "SELECT * FROM flightsTbl WHERE month < 3"
m1 <- sqlQuery(myconn, sqlQuery_m1)
head(m1)
# rownames year month day dep_time dep_delay arr_time arr_delay carrier
# 1        1 2013     1   1      517         2      830        11      UA
# 2        2 2013     1   1      533         4      850        20      UA
# 3        3 2013     1   1      542         2      923        33      AA
# 4        4 2013     1   1      544        -1     1004       -18      B6
# 5        5 2013     1   1      554        -6      812       -25      DL
# 6        6 2013     1   1      554        -4      740        12      UA
# tailnum flight origin dest air_time distance hour minute
# 1  N14228   1545    EWR  IAH      227     1400    5     17
# 2  N24211   1714    LGA  IAH      227     1416    5     33
# 3  N619AA   1141    JFK  MIA      160     1089    5     42
# 4  N804JB    725    JFK  BQN      183     1576    5     44
# 5  N668DN    461    LGA  ATL      116      762    5     54
# 6  N39463   1696    EWR  ORD      150      719    5     54

dim(m1)
#51955    17

odbcCloseAll()

# To go further, have a look at this tutorial on writing Microsoft SQL queries, or get a more in depth introduction to Microsoft SQL Server here.

