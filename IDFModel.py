__author__ = 'igorpetrovski'

#in this class we will access the idf values


from google.appengine.ext import ndb

class IDFModel(ndb.Model):

    word = ndb.StringProperty()
    value = ndb.FloatProperty()

