from flask import Flask, render_template, request, session as ses, redirect
from config.base import *
from config.local import *
from sqlalchemy import create_engine, MetaData, inspect
from sqlalchemy.orm import sessionmaker, scoped_session
from models import *

engine = create_engine('sqlite:///'+db_path+'?check_same_thread=false', echo=True)
con = engine.connect()
session = scoped_session(sessionmaker(bind=engine))
inspector = inspect(engine)

metadata = MetaData()
# metadata.create_all(engine)
app = Flask(__name__)

app.config['SECRET_KEY']='sdfvsdh43f3f34'

# User.__table__.create(engine)
# Survey.__table__.create(engine)
# Word.__table__.create(engine)

# u1 = User("medvosa","passwd")
# session.add(u1)
# session.commit()
# s1 = Survey('sur1',u1.id)
# session.add(s1)
# session.commit()
# print(session.query(Survey,User).join(User,
#                                       User.id == Survey.owner).first())

@app.route('/')
def hello_world():
    return render_template('index.html',user = (None if 'userEmail' not in ses else ses['userEmail']))


@app.route('/login', methods=["POST"])
def lp():
    email = request.form.get('email',None)
    password = request.form.get('password',None)
    user = session.query(User).filter_by(email = email, password = password).first()
    print(user)
    if not user:
        return 'error'
    if user.password != password:
        return 'error'
    ses['userId']=user.id
    ses['userEmail']=user.email
    return redirect('/')


@app.route('/signup', methods=["POST"])
def rp():
    email = request.form.get('email',None)
    password = request.form.get('password',None)
    password_repeat = request.form.get('passwordRepeat',None)
    import re
    if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
        return 'неверный email'
    if len(password)<8:
        return 'слишком простой пароль'
    if password_repeat!=password:
        return 'пароль и повтор пароля должны совпадать'
    user = session.query(User).filter_by(email = email).first()
    print(user)
    if user:
        return 'пользователь с таким email уже существует'
    user = User(email,password)
    session.add(user)
    session.commit()
    ses['userId']=user.id
    ses['userEmail']=email
    return redirect('/')

@app.route('/infop')
def ip():
    return str('userId' in ses)
    if 'userId' not in ses:
        return 'None'
    return str(ses['userId'])

@app.route('/logout')
def lop():
    # if 'userId' in ses:
    #     ses.pop('userId')
    ses['userId']=None
    ses['userEmail']=None
    return redirect('/')
    # ses.pop('userId')
    # return redirect('/')

@app.route('/createsurvey')
def crp():
    if 'userId' not in ses:
        return redirect('/')
    return render_template('create.html')

if __name__ == '__main__':
    app.run()
