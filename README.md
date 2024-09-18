# redash-deployment-kubernetes

This guide covers the deployment of [Redash](https://redash.io) on a Kubernetes cluster. Redash is an open-source tool for data visualization and querying that supports multiple data sources.

# Redash Deployment on Kubernetes

# What’s Redash?


Redash is designed to enable anyone, regardless of the level of technical sophistication, to harness the power of data big and small. SQL users leverage Redash to explore, query, visualize, and share data from any data sources. Their work in turn enables anybody in their organization to use the data. Every day, millions of users at thousands of organizations around the world use Redash to develop insights and make data-driven decisions. Redash features:


    Browser-based: Everything in your browser, with a shareable URL.
    Ease-of-use: Become immediately productive with data without the need to master complex software.
    Query editor: Quickly compose SQL and NoSQL queries with a schema browser and auto-complete.
    Visualization and dashboards: Create beautiful visualizations with drag and drop, and combine them into a single dashboard.
    Sharing: Collaborate easily by sharing visualizations and their associated queries, enabling peer review of reports and queries.
    Schedule refreshes: Automatically update your charts and dashboards at regular intervals you define.
    Alerts: Define conditions and be alerted instantly when your data changes.
    REST API: Everything that can be done in the UI is also available through REST API.
    Broad support for data sources: Extensible data source API with native support for a long list of common databases and platforms.





## Prerequisites

Before starting, ensure you have the following:

- Clone redahs Repository
- m4 for ubuntu(22.04)
- A Kubernetes cluster (
- `kubectl` installed and configured
- Docker image for Redash (default: `redash/redash`)


## Step 1: Clone Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/<your-repo>/redash-k8s-deployment.git
cd redash-k8s-deployment
```
### step 2: Install & verify m4 on ubuntu-(22.04)

M4 is usually available in the default Ubuntu package repositories. To install it, open your terminal and run the following command:

```bash
sudo apt update
sudo apt install m4
```
# Verify m4

```bash
m4 --version
```

### step 3: apply rdash deployment with m4

```bash

m4 redash-deploymey.m4 | kubectl apply -f -

```

### step 4: now verify with kubectl

```bash

kubectl get pod,svc -A

```

### step 5: You’re almost done. Postgres is not configured so, you need to connect and initialize the database:

```bash
kubectl exec -it redash-f8556648b-tw949 -c server -- bash  # please replace pod name with your actual pod name

## run the below command

redash-f8556648b-tw949:/app$ ./manage.py database create_tables

# the exit from pod

```
### step 6: Now access redash 

http://<node-IP>:5000

![image](https://github.com/user-attachments/assets/e6ccc77c-9391-4c9b-9f30-4e5e6c95faf5)



### Happy Learning :)







