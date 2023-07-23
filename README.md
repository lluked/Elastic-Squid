# Elastic-Squid

A Docker Compose project that makes use of Elastic to monitor Squid proxy logs. This project makes use of:

- Elasticsearch
- Kibana
- Filebeat
- Squid

## Elastic
The Docker Compose file was originally based on [Start the Elastic Stack with Docker Compose](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack-docker.html#get-started-docker-tls), however now:

- All elastic based configurations have been moved from environment variables into their own config files.
- Only one Elasticsearch node is being used.
- The setup service has had its commands moved out into a script with a supporting file for defining instances, rather than the file being created by the script.
- Filebeat and Squid services have been added.

## Squid

Squid is built from source to be able to carry out ssl bumping. Please refer to [docker-squid](https://github.com/lluked/docker-squid) for more information. Squid is configured to bind to ports 3128 (normal) and 3129 (ssl bumping) on the host and sends logs via syslog to Filebeat. Filebeat then uses the Squid module to parse logs, and forward to Elasticsearch.

## Instructions

- Read the notes.
- Launch the project with `docker-compose up` from the project directory.
- Wait for all the services to start, this may take a while.
- Set the proxy in your web browser to `localhost:3128` or `localhost:3129` for ssl inspection. Firefox works best as Chrome and Edge use system wide settings. If using the ssl bump port `squid-certs/myCA.der` needs installing as mentioned in the docker-squid repository.
- Perform some web activity.
- Visit Kibana at `localhost:5601`, login with the default credentials `elastic:changeme`.

- Once logged in select the burger navigation icon, select Management -> Stack Management, select Kibana -> Data Views, you will then be prompted to create a data view. Create one with the Name matching the index pattern, `filebeat-*`, and set the Timestamp field to `@timestamp`. You will only be able to created a data view after data has been forwarded over from the proxy so this needs to be done after performing some web activity and there may be a slight delay.
- You can now view logs under Discover, under the navigation icon, by changing the data view to `filebeat-*`.
- Analyse the data and then create visualisations and dashboards to extract more information.

## Notes

- If you haven't run the Elastic Stack before you may come into errors related to memory allocation and be asked to set `sysctl.vm.max_map_count` to `262144`.

### Windows 
To set `sysctl.vm.max_map_count` create or append to the `.wslconfig` file in your home directory with the following config:

```
[wsl2]
kernelCommandLine = "sysctl.vm.max_map_count=262144"
```

### Linux 
To set `sysctl.vm.max_map_count`  run `sysctl -w vm.max_map_count=262144` as root.

### macOS
Open docker desktop, go to Settings -> Resources -> Memory and set to around `4GB`.
