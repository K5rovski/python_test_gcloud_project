the repo is located at https://github.com/K5rovski/python_test_gcloud_project

Okay so the startup script is in the gce folder, you can look it over , its mostly based on the old startup script.
Except that as you can see there is an if that pulls or clones the git repository, and at the end it stops the process and restarts it (this should make it so that you can write sth in the repo than restart the instance and see changes).



Python stdout and stderr is redirected to /home/pythonapp/myerrlog.log, 
each request is logged to /home/pythonapp/myaccesslog

the startup script log is logged to /var/log/daemon.log

 
 this is the startup code that creates the instance:
 
gcloud compute instances create news-reader-big \
    --image=debian-8 \
    --machine-type=n1-standard-4 \
    --scopes userinfo-email,cloud-platform,datastore \
    --metadata startup-script-url=gs://pythontestproject-1359/startup-script.sh \
    --zone europe-west1-b \
    --tags http-server
	
	
	
 
(!!you need to upload the startup script to the storage so you can better work with it. change the storage url) 



 this is the code that redos the startup script (you do this everytime you make a repo change): 
1.   http://prntscr.com/bq3gnz 
!!!! READ HERE here: https://cloud.google.com/compute/docs/startupscript#startupscriptrunninginstances

 
 
 
also in the repo in model/model_datastore.py  there is a code that connects to the datastore and has basic functionality for a generic datastore key, i think you'll easily understand it.



these are the requests that work with the model_datastore api
1. /test_datastore
this basically adds an entity and prints the results back, like this [,,,]


2. /test_greet
this is used with connection with http://pythontestproject-1359.appspot.com/ to query what greetings you created here http://pythontestproject-1359.appspot.com/