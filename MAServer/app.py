import json
from socket import SocketIO

from flask import Flask, request, jsonify, session
from yaml import emit

async_mode = None
app = Flask(__name__)
socket_ = SocketIO(app, async_mode=async_mode)


@socket_.on('my_broadcast_event', namespace='/test')
def test_broadcast_message(message):
    session['receive_count'] = session.get('receive_count', 0) + 1
    emit('my_response',
         {'data': message['data'], 'count': session['receive_count']},
         broadcast=True)

def fetchId():
    with open('books.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        return int(records[-1]['id']) + 1


ID = fetchId()


@app.route('/')
def index():
    print(ID)
    return jsonify({'msg': 'hello world'})


@app.route('/books', methods=['GET'])
def getBooks():
    with open('books.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        return jsonify(records)


@app.route('/books/<id>', methods=['GET'])
def getBook(id):
    id = int(request.view_args['id'])
    with open('books.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        for r in records:
            if int(r['id']) == id:
                return jsonify(r)
        return jsonify({'error': 'no such record'})


@app.route('/books', methods=['POST'])
def addBook():
    global ID
    record = json.loads(request.data)
    record['id'] = str(ID)  # the id is managed by the server
    ID += 1
    with open('books.txt', 'r') as f:
        data = f.read()
    if not data:
        records = [record]
    else:
        records = json.loads(data)
        records.append(record)
    with open('books.txt', 'w') as f:
        f.write(json.dumps(records, indent=2))
    record['id'] = int(record['id'])
    return jsonify(record)

"""
 "author": "fjjhgh",
    "description": "dfjhdhfjd",
    "genre": "dfjdfhj",
    "pageNumber": 45,
    "quotes": "",
    "review": "",
    "title": "testtt",
    "id": 15
"""

@app.route('/books', methods=['PUT'])
def updateBook():
    book = json.loads(request.data)
    updatedBookList = []
    with open('books.txt', 'r') as f:
        data = f.read()
        books = json.loads(data)
    for b in books:
        if int(b['id']) == book['id']:
            b['title'] = book['title']
            b['author'] = book['author']
            b['pageNumber'] = book['pageNumber']
            b['description'] = book['description']
            b['genre'] = book['genre']
            b['quotes'] = book['quotes']
            b['review'] = book['review']
        updatedBookList.append(b)
    with open('books.txt', 'w') as f:
        f.write(json.dumps(updatedBookList, indent=2))
    return jsonify(book)


@app.route('/books/<id>', methods=['DELETE'])
def deleteBook(id):
    id = int(request.view_args['id'])
    print("id = ", id)
    newBooks = []
    with open('books.txt', 'r') as f:
        data = f.read()
        books = json.loads(data)
        for b in books:
            if int(b['id']) == id:
                print("Found")
                continue
            else:
                print("Not found", b['id'])
                newBooks.append(b)
    with open('books.txt', 'w') as f:
        f.write(json.dumps(newBooks, indent=2))
    return jsonify()


app.run()