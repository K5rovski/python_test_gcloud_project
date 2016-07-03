
import model.model_datastore as model


def temp_news():
	news={'url':'this_url','title':'oneone','dikt':{1:2,2:3} }
	model.update('news',news,id='ova_id')
	lis,c=model.list('news')
	return lis