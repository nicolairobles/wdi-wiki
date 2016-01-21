require 'pg'

# this gives you a fresh global var $db to query with in pry
$db = PG.connect dbname: 'WDIWiki'
