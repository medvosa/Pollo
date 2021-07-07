from flask import Flask, render_template, request, session as ses, redirect
from config.base import *
from config.local import *
from sqlalchemy import create_engine, MetaData, inspect, and_
from sqlalchemy.orm import sessionmaker, scoped_session
import json
from jinja2 import Markup
from models import *

engine = create_engine('sqlite:///'+db_path+'?check_same_thread=false', echo=True)
con = engine.connect()
session = scoped_session(sessionmaker(bind=engine))
inspector = inspect(engine)

metadata = MetaData()
# metadata.create_all(engine)
app = Flask(__name__)

app.jinja_env.globals['include_raw'] = lambda filename : Markup(app.jinja_loader.get_source(app.jinja_env, filename)[0])
app.config['SECRET_KEY']='sdfvsdh43f3f34'
app.config['TEMPLATES_AUTO_RELOAD'] = True

# User.__table__.create(engine)
# Survey.__table__.create(engine)
# Word.__table__.create(engine)
# Question.__table__.create(engine)
# Answer.__table__.create(engine)

# u1 = User("medvosa","passwd")
# session.add(u1)
# session.commit()
# s1 = Survey('sur1',u1.id)
# session.add(s1)
# session.commit()
# print(session.query(Survey,User).join(User,
#                                       User.id == Survey.owner).first())

@app.context_processor
def t():
    return {
        "user": (None if 'userEmail' not in ses else ses['userEmail']),
    }

@app.route('/')
def hello_world():
    surveys = session.query(Survey).all()
    user_surveys=[]
    # print(ses['userId'])
    if 'userId' in ses:
        print('here')
        user_surveys = session.query(Survey).filter_by(owner=ses['userId']).all()
        print(user_surveys)
    print(user_surveys)
    print(surveys)
    return render_template('index.html', surveys=surveys, user_surveys=user_surveys, is_main=True)


@app.route('/login', methods=["POST"])
def lp():
    email = request.form.get('email',None)
    password = request.form.get('password',None)
    user = session.query(User).filter_by(email = email, password = password).first()
    print(user)
    if not user:
        return redirect('/#errorlogin')
    if user.password != password:
        return redirect('/#errorlogin')
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
        return redirect('/#errorreg_invalid_mail')
    if len(password)<8:
        return redirect('/#errorreg_easy_password')
    if password_repeat!=password:
        return redirect('/#errorreg_not_match')
    user = session.query(User).filter_by(email = email).first()
    print(user)
    if user:
        return redirect('/#errorreg_exists')
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


@app.route('/runpoll/<id>')
def runp(id):
    survey = session.query(Survey).filter_by(id=id).all()
    if(len(survey)<1):
        return redirect('/')
    if 'userId' not in ses:
        return 'error'
    survey = survey[0]
    if len(survey.t_hash)>0:
        return render_template('cannotComplete.html', name=survey.name)
    questions = session.query(Question).filter_by(survey_id=id).all()
    print(questions);
    exists = session.query(Answer)\
        .join(Question,
            Answer.question_id==Question.id,
            )\
        .filter(
            and_(
                Answer.user_id==ses['userId'],
                Question.survey_id == id
            )
        )\
        .first()
    print("exists: ",exists)
    if exists is not None:
        return render_template('cannotComplete.html', name=survey.name)
    return render_template('runpoll.html', canComplete=True, survey_id=id, name=survey.name, questions=questions)


@app.route('/hash/<hsh>')
def runphash(hsh):
    survey = session.query(Survey).filter(Survey.t_hash.like(hsh)).all()
    if(len(survey)<1):
        return 'no such survey'
    if 'userId' not in ses:
        return 'error'
    survey = survey[0]
    id = survey.id
    questions = session.query(Question).filter_by(survey_id=id).all()
    print(questions);
    exists = session.query(Answer)\
        .join(Question,
            Answer.question_id==Question.id,
            )\
        .filter(
            and_(
                Answer.user_id==ses['userId'],
                Question.survey_id == id
            )
        )\
        .first()
    print("exists: ",exists)
    if exists is not None:
        return render_template('cannotComplete.html', name=survey.name)
    return render_template('runpoll.html', canComplete=True, survey_id=id, name=survey.name, questions=questions)


@app.route('/stats/<poll_id>')
def statsp(poll_id):
    if 'userId' not in ses:
        return 'error'
    survey = session.query(Survey).filter_by(id=poll_id).first()
    questions = session.query(Question).filter_by(survey_id=poll_id).all()
    print(survey)
    if not survey:
        return render_template("pollDoesNotExist.html")
    res_answers=[]
    for i in questions:
        print(i.id)
        print("Number of answers: ",len(i.answers.split(';')))
        answers = [i.answer_num for i in session.query(Answer).filter_by(question_id=i.id).all()]
        res_answers.append(answers)
        print(answers)
        print(i.answers)
        print([answers.count(j) for j in range(len(i.answers.split(';')))])
    return render_template('pollstats.html', survey=survey,
                           questions=questions,
                           times=len(answers),
                           answers=[[k for k in [answers.count(j) for j in range(len(i.answers.split(';')))]] for answers in res_answers]
    #";".join([str(k) for k in [answers.count(j) for j in range(len(i.answers.split(';')))]])
                           )


@app.route('/pollsave',methods=['POST'])
def spp():
    if 'userId' not in ses:
        return 'error'
    poll_id = request.json['pollId']
    answers = request.json['answers']
    questions = request.json['questions']
    # survey = Survey(title,ses['userId'],image_url)
    print(poll_id, answers, ses['userId'], questions)
    print(questions)
    print(answers)
    for i in range(len(answers)):
        print(questions[i],answers[i])
        session.add(Answer(questions[i],ses['userId'],answers[i]))
    session.commit()
    return 'ok'

@app.route('/logout')
def lop():
    ses['userId']=None
    ses['userEmail']=None
    return redirect('/')

@app.route('/createsurvey')
def crp():
    if 'userId' not in ses:
        return redirect('/')
    return render_template('create.html')

@app.route('/create',methods=['POST'])
def crpp():
    if 'userId' not in ses:
        return 'error'
    title = request.json['title']
    questions = request.json['questions']
    private=request.json['isPrivate']
    print(private)
    image_url=request.json['imageUrl']
    survey = Survey(title,ses['userId'],image_url,private)
    session.add(survey);
    session.commit()
    print(survey.id)
    for question in questions:
        ans = question['answers']
        if len(ans) <2:
            session.add(Question(question['caption'],survey.id))
        session.add(Question(question['caption'], survey.id, ";".join(ans)))
    session.commit()
    print(title,questions)
    return 'ok:'+str(survey.t_hash if private else '')


if __name__ == '__main__':
    app.run()
