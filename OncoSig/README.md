# Overview

[OncoSig-RF](https://pubmed.ncbi.nlm.nih.gov/32929263/) is an algorithm for the systematic, *de novo* reconstruction of tumor-specific molecular interaction signaling maps (SigMaps), anchored on any oncoprotein of interest. An oncoprotein-specific SigMap recapitulates the molecular architecture necessary to functionally modulate and mediate its activity within a specific cellular context, including its physical, cognate-binding partners.

OncoSig-RF uses a random forest classifier. The classifier is trained on a "gold standard" set of known SigMap members , assembled from literature reports. OncoSig-RF integrates diverse evidence sources (including protein structure, gene expression and mutational profiles) from a number of computational tools.

# Code and Data

The algorithm is implemented in R; the source files can be found under the R directory. The script titled `oncosigrf_test.R` demonstrates all the steps involved in the execution of OncoSig-RF. Sample network data as well as gold standard sets for a number of oncoproteins are available in the Data_files directory. The file `oncosigrf_test.Rmd` is a markdown version of the script (with some additional documentation). A knitr-rendered version of the Rmd file is available on [Rpubs](https://rpubs.com/castcenter/oncosig-rf-test).

# Docker

To support local execution of the oncosigrf_test.R script, we have packaged all the needed code, data, and tools into a Docker image.

## Existing Docker Environment

If a local docker installation is available, the image can be deployed by running the following commands from a system shell:

> `# Fetch latest docker image`  
`docker pull castcenter/onco-sig`  <br><br>
`# Start the container`  
`docker run -ti --entrypoint=/bin/bash --rm castcenter/onco-sig`

This will deploy the OncoSig container and start a new shell session, with all code and data deployed under the session's home directory. The script can be executed by simply running:

> `Rscript oncosigrf_test.R`

## Running on cloud

### Google Cloud Platform

The Docker image can also be deployed on a GCP, along with the Docker execution environment (thus, obviating the need to download, install, and configure Docker). E.g., for GCP, a VM can be instantiated from the command line (if the Google Cloud SDK installed) or through the cloud shell, in a browser. In both cases, the command to use is (a valid GCP account and billing projects will be needed):

> `gcloud compute instances create-with-container onco-sig-instance --container-image=castcenter/onco-sig --container-command "tail" --container-arg="-f" --container-arg="/dev/null" --zone=us-east1-b --container-privileged --machine-type n4-standard-8 --project=<your_billing_project>`

You can log in with the new VM by running `gcloud compute ssh onco-sig-instance --project=<your_billing_project>` or using any ssh client. After logging in, use `docker exec -it klt-onco-sig-instance-jzpf bash` to connect to the container and then use it the same manner as described under the "Existing Docker Environment" case.

### Amazon Web Services

In case of using AWS, example steps of experimenting look like this:

1. create a instance using `aws ec2 run-instances --image-id ami-0df0b6b7f8f5ea0d0 --instance-type t2.2xlarge --key-name my-key-pair`, where `my-key-pair` can be any name you have used to create the kay pair, using `aws ec2 create-key-pair --key-name my-key-pair --key-type rsa --query "KeyMaterial" --output text > my-key-pair.pem` in advance. While that requires you have aws cli installed first, you can also do this from the web console. In either way you need to log into you AWS account first.
2. connect to the VM instance, using `ssh -i "<key file name>" <instance name>`, where `<key file name>` is the file name of your private key, e.g. `my-key-pair.pem` as describe in the previous step. `<instance name>` is the name of the VM instance created in the previous step, and you can also find it later using `aws ec2 describe-instances`.
3. once logged into the VM instance, install docker using `sudo snap install docker`.
4. Use `sudo docker run -ti --entrypoint=/bin/bash --rm castcenter/onco-sig` to start and connect to the container so you can try experiments like `Rscript oncosigrf_test.R`, or run the batch job like `sudo docker run -ti -v ~/onco-sig-result:/usr/result castcenter/onco-sig`.
5. Make sure to terminate the VM instance when you are done using it, with command `aws ec2 terminate-instances --instance-ids <instance ID>` or from the web console.
