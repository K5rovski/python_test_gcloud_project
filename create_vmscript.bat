gcloud compute instances create news-reader-big ^
    --image=debian-8 ^
    --machine-type=n1-standard-4 ^
    --scopes userinfo-email,cloud-platform ^
    --metadata-from-file startup-script=gce/startup-script.sh ^
    --zone europe-west1-b ^
    --tags http-server