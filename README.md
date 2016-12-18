![alt text](http://www.dfs.co.uk/wcsstore/DFSStorefrontAssetStore/images/dfs_logo.svg "DFS")

# Sofa: Distributed File System

# Peter Meehan - 13318021

## Description

Sofa is a submission for the CS4032 Distributed Systems module project component.

Sofa is a "dropbox like" web based file system written in Elixir [Phoenix](http://www.phoenixframework.org/) which leverages an Erlang distributed key value store for file storage.

Sofa allows for user account creation and subsequent authorized access to user files. Due to the chosen architecture, the user navigates to sofa in their web browser, authorizes, and can then access their files which are distributed over many nodes transparently.

Sofa is a fully functional end to end solution. Screenshots of operation can be found in the sections below.

## Architecture Decisions

I have designed the system to provide "dropbox like" file access functionality transparently with the files redundantly stored physically distributed. The system is comprised of one(or more, more on this later) Phoenix web applications acting as a middleman between the user (via their web browser) and the file storage mechanism. The storage is supported by an open source key value store called [Riak](http://docs.basho.com/riak/kv/2.2.0/) and storage patterns, retrieval, and access authorisation are controlled by the phoenix system. The files are stored in different virtual key spaces(buckets) per user in a cluster that is composed of a number of different docker backed instances. I believe that the Phoenix framework is a very good fit for this application due to its ability to scale horizontally as well as vertically thanks to running on the erlang virtual machine.

#### Distributed Transparent File Access
Due to the upload+download nature of the sofa phoenix web service, the user has absolutely no idea where their files are stored or that they're replicated in any way, all of this is abstracted away transparently. When the user clicks upload they select a file and it gets stored, that's it, they don't have to worry about where to put it etc. The same if true for download, they are presented with a list of files and can download without knowing anything about where the files live.

#### Security Service
Secure access to user files is guaranteed by the Coherence token authorization system which restricts access to any files without a valid login and provides access to only the files that the authorised user has access to once authenticated and authorized. Due to how the system is designed, there is no need for 3 way key handshake as the web browser will only ever speak to the service over https which will handle encryption of the communication channel.

#### Replication
I have selected an `n_val` for the storage cluster that ensures complete replication of every file across all nodes in the cluster. This will ensure that files will not be lost if even a majority of nodes are taken off-line for whatever reason.

#### Directory Service
As mentioned above, the system runs on complete replication across all nodes so a directory service is unnecessary as the given file can be queried from any one of the nodes in the cluster, so the system can choose to retrieve the value from any of the nodes, and it does.

#### Caching
As alluded to in the brief, given the upload/download nature of this implementation there is little need for server side caching, simple cdn/browser caching should be sufficient to ensure speedy file retrieval.

#### Transactions + Lock Service
Considering the problemspace I have decided eventual consistency is suitable for this application, riak supports last write wins which I believe will work well with the given upload/download model where rolling back system state upon failed atomic blocks doesn't make much sense. Timing conflicts are mitigated in the web application's controllers which mitigate overwrite conflicts.


## Demo

This project was developed on [digital ocean](https://www.digitalocean.com/) droplets with the separate components on physically distinct machines.

However if this system were deployed for real I would suspect it would be best deployed on some bigger cloud hosting platform such as [Amazon Web Services](https://aws.amazon.com/) where the different components can communicate freely over the closed internal network.

## Setup

##### Sofa Web App
To start the Sofa Phoenix application:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

##### Riak Cluster:

```
git clone https://github.com/hectcastro/docker-riak.git
cd docker-riak
make build
DOCKER_RIAK_AUTOMATIC_CLUSTERING=1 DOCKER_RIAK_CLUSTER_SIZE=5 DOCKER_RIAK_BACKEND=leveldb make start-cluster
./bin/start-cluster.sh
```
Now the cluster can be controlled via docker commands.

Individual nodes can be taken off-line, for example:
```
docker stop riak02
```
to simulate a fault in the system and can be restored with:
```
docker start riak02
```
