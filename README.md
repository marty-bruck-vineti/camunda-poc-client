# README

# Camunda Java POC Client
This project implements both a Rails server and a Poller script. Both interact with the Java POC Server.  It provides the following:
- Implements a UI for interacting with the Java POC Service
- Makes REST calls to the Java POC Service to interact with Camunda
- Sends and Receives JMS messages as appropriate (via the poller task)


## Running the Demo
To start the Service, first make sure that activemq broker is running locally and that the Java POC service is running.
Then run the following command to start the rails server

`./rails server`

and the following command to start the poller

`script/poller start`
## Documentation
Full documentation for the POC can be found on the wiki at https://vineti.atlassian.net/wiki/spaces/EN/pages/2033254433/Camunda+API+vs+Rest
