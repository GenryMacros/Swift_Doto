import flask
from flask import request, jsonify
from flask_api import status
from db import *
from flask_api import status

app = flask.Flask(__name__)

@app.route('/users', methods=['POST'])
def login():
    content = request.json
    if content['login'] == None or content['pass'] == None:
        return jsonify(message="Missing \'login\' and \'pass\' in json body"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    select_query = "SELECT ID FROM Users WHERE Logn=\'{}\' and Pass=\'{}\'".format(content['login'], content['pass'])
    insert_query = "INSERT INTO Users(Logn, Pass) VALUES(\'{}\', \'{}\')".format(content['login'], content['pass'])
    result = read_query(select_query)
    if len(result) == 0:
        write_query(insert_query)
        result = read_query(select_query)
        ret = {
            'id':result[0][0]
        }
        return jsonify(ret), status.HTTP_200_OK, {'ContentType':'application/json'} 
    else:
        ret = {
            'id':result[0][0]
        }
        return jsonify(ret), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/<int:id>', methods=['DELETE'])
def delete_user(id: int):

    select_query = "SELECT * FROM Users WHERE ID={}".format(id)
    delete_query = "DELETE FROM Users WHERE ID={}".format(id)
    result = read_query(select_query)
    if len(result) == 0:
        return jsonify(message="No user with given ID"), status.HTTP_404_NOT_FOUND, {'ContentType':'application/json'}

    write_query(delete_query)
    return jsonify(message="OK"), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/<int:id>/channels', methods=['POST'])
def new_channel(id: int):
    content = request.json
    if content['name'] == None:
        return jsonify(message="Missing \'name\' in json body"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    select_query = "SELECT ID FROM Channels WHERE U_ID={} AND CName=\'{}\'".format(id, content['name'])
    insert_query = "INSERT INTO Channels(U_ID, CName) VALUES({}, \'{}\')".format(id, content['name'])

    result = read_query(select_query)
    if len(result) != 0:
        return jsonify(message="Channel already exists"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    write_query(insert_query)
    result = read_query(select_query)
    message = {
        'ID': result[0][0]
    }
    return jsonify(message), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/<int:id>/channels', methods=['GET'])
def get_channel(id: int):
    content = request.json

    select_query = "SELECT ID,CName FROM Channels WHERE U_ID={}".format(id)
    result = read_query(select_query)
    channels = []
    for resp in result:
        channels.append({'ID': resp[0], 'Name': resp[1]})

    return jsonify(channels=channels), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/channels/<int:cid>', methods=['DELETE'])
def delete_channel(cid: int):

    select_query = "SELECT CName FROM Channels WHERE ID={}".format(cid)
    delete_query = "DELETE FROM Channels WHERE ID={}".format(cid)
    result = read_query(select_query)
    if len(result) == 0:
        return jsonify(message="No channel with given ID"), status.HTTP_404_NOT_FOUND, {'ContentType':'application/json'}

    write_query(delete_query)
    return jsonify(message="OK"), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/channels/<int:cid>/tasks', methods=['POST'])
def new_task(cid: int):
    content = request.json
    if content['name'] == None:
        return jsonify(message="Missing \'name\' in json body"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    select_query = "SELECT ID FROM Tasks WHERE C_ID=\'{}\' AND Task=\'{}\'".format(cid, content['name'])
    insert_query = "INSERT INTO Tasks(C_ID, Task, selected) VALUES({}, \'{}\', {})".format(cid, content['name'], 'FALSE')
    result = read_query(select_query)

    if len(result) != 0:
        return jsonify(message="Task already exists"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    write_query(insert_query)
    result = read_query(select_query)
    message = {
        'ID': result[0][0]
    }
    return jsonify(message), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/channels/tasks/<int:tid>', methods=['PUT'])
def update_task(tid: int):
    
    select_query = "SELECT selected FROM Tasks WHERE ID={}".format(tid)
    result = read_query(select_query)
    tasks = []
    if len(result) == 0:
        return jsonify(message="Task doesn't exist"), status.HTTP_406_NOT_ACCEPTABLE, {'ContentType':'application/json'}

    new_state = not(result[0][0])
    put_query = "UPDATE Tasks SET selected={} WHERE ID={}".format(new_state, tid)
    write_query(put_query)
    return jsonify(tasks=tasks), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/channels/<int:cid>/tasks', methods=['GET'])
def get_task(cid: int):
    content = request.json

    select_query = "SELECT ID,Task,selected FROM Tasks WHERE C_ID={}".format(cid)
    result = read_query(select_query)
    tasks = []
    for resp in result:
        tasks.append({'ID': resp[0], 'Name': resp[1], 'Selected': resp[2]})

    return jsonify(tasks=tasks), status.HTTP_200_OK, {'ContentType':'application/json'}

@app.route('/users/channels/tasks/<int:tid>', methods=['DELETE'])
def delete_task(tid: int):

    select_query = "SELECT Task FROM Tasks WHERE ID={}".format(tid)
    delete_query = "DELETE FROM Tasks WHERE ID={}".format(tid)
    result = read_query(select_query)
    if len(result) == 0:
        return jsonify(message="No task with given ID"), status.HTTP_404_NOT_FOUND, {'ContentType':'application/json'}

    write_query(delete_query)
    return jsonify(message="OK"), status.HTTP_200_OK, {'ContentType':'application/json'}

if __name__ == '__main__':
    app.run(host='0.0.0.0')