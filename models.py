from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

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
    def __init__(self, name, owner, image_url):
        self.name = name
        self.owner = owner
        self.image_url = image_url


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