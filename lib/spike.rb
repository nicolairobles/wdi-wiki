require 'pg'

# this gives you a fresh global var $db to query with in pry
$db = PG.connect dbname: 'hogwarts_crud_test'
