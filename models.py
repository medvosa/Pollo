from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
import os
import binascii

Base = declarative_base()

class User(Base):
    __tablename__='users'
    id = Column(Integer, primary_key=True)
    email = Column(String)
    password = Column(String)


    def __init__(self, email, password):
        self.email = email
        self.password = password


    def __repr__(self):
       return "<User(id=%s, email='%s')>" % (
                            self.id, self.email)


class Survey(Base):
    __tablename__='survey'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    owner = Column(Integer)
    image_url=Column(Text)
    hash = Column(Text)
    def __init__(self, name, owner, image_url, private):
        self.name = name
        self.owner = owner
        self.image_url = image_url
        if private:
            self.hash=binascii.hexlify(os.urandom(16))
        else:
            self.hash=""


class Question(Base):
    __tablename__='questions'
    id = Column(Integer, primary_key=True)
    text = Column(String)
    survey_id = Column(Integer)
    answers = Column(String)
    def __init__(self, text, survey_id,answers='да;нет'):
        self.text = text
        self.survey_id = survey_id
        self.answers=answers
        

class Answer(Base):
    __tablename__='answers'
    id = Column(Integer, primary_key=True)
    question_id = Column(Integer)
    user_id = Column(Integer)
    answer_num = Column(Integer)
    def __init__(self, question_id, user_id,answer_num):
        self.question_id = question_id
        self.user_id = user_id
        self.answer_num = answer_num