import MySQLdb 

db = MySQLdb.connect("localhost", "newuser", "password", "TODO") 
curs = db.cursor() 


def read_query(query):
    curs.execute(query)
    reading = curs.fetchall() 
    return reading

def write_query(query):
    curs.execute(query)
    reading = curs.fetchall() 
    db.commit()
    return reading
