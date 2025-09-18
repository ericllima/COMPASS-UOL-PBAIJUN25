from robot.api.deco import keyword
from pymongo import MongoClient

client = MongoClient('mongodb+srv://qa:qa123@cluster0.ymh3xsh.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')

db = client['markdb']

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_many({'email': email})
    print('removing user by ' + email)

"""@keyword('Insert user into database')
def insert_user(name, email, password):
    doc = {
        'name': name,
        'email': email,
        'password': password
    }
    users = db['users']
    users.insert_one(doc)
    print(doc)"""

@keyword('Insert user into database')
def insert_user(user):
    users = db['users']
    users.insert_one(user)
    print(user)
