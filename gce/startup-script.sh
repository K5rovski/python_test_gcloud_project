set -v

# Talk to the metadata server to get the project id
PROJECTID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")

# Install logging monitor. The monitor will automatically pickup logs sent to
# syslog.
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash
service google-fluentd restart &

# Install dependencies from apt
apt-get update
apt-get install -yq \
    git build-essential supervisor python python-dev python-pip libffi-dev \
    libssl-dev unzip
	
	
# For appengine 
sudo wget -P /home/pythonapp https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.38.zip

sudo unzip /home/pythonapp/google_appengine_1.9.38.zip -d /home/pythonapp
export PYTHONPATH=$PYTHONPATH:/home/pythonapp/google_appengine/
# Create a pythonapp user. The application will run as this user.
useradd -m -d /home/pythonapp pythonapp

# pip from apt is out of date, so make it update itself and install virtualenv.
pip install --upgrade pip virtualenv

# Get the source code from the Google Cloud Repository
# git requires $HOME and it's not set during the startup script.
export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/$PROJECTID/r/newsreader /opt/app

# Install app dependencies
virtualenv /opt/app/env
/opt/app/env/bin/pip install -r /opt/app/requirements.txt

# Make sure the pythonapp user owns the application code
chown -R pythonapp:pythonapp /opt/app

# Configure supervisor to start gunicorn inside of our virtualenv and run the
# applicaiton.
cat >/etc/supervisor/conf.d/python-app.conf << EOF
[program:pythonapp]
directory=/opt/app/
command=/opt/app/env/bin/gunicorn handlers:app --bind 0.0.0.0:8080 --error-logfile /home/pythonapp/myerrlog.log --access-logfile /home/pythonapp/myaccess.log
autostart=true
autorestart=true
user=pythonapp
# Environment variables ensure that the application runs inside of the
# configured virtualenv.
environment=VIRTUAL_ENV="/opt/app/env",PATH="/opt/app/env/bin",\
    HOME="/home/pythonapp",USER="pythonapp",PYTHONPATH="/home/pythonapp/google_appengine"
stdout_logfile=syslog
stderr_logfile=syslog
EOF

supervisorctl reread
supervisorctl update

# Application should now be running under supervisor