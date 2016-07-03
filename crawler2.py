
import model.model_datastore as model


def temp_news():
	news={'url':'this_url','title':'oneone','dikt':176523 }
	model.update('news',news)
	lis,c=model.list('news')
	return lis
	
print temp_news()	