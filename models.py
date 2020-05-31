from sqlalchemy import Column, Integer, String, ForeignKey
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
    def __init__(self, name, owner):
        self.name = name
        self.owner = owner
