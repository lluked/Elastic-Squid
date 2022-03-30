# Elastic-Squid

A simple Docker Compose project that makes use of Elastic to monitor Squid proxy logs. This project makes use of:

- Elasticsearch
- Kibana
- Filebeat
- Squid
 
The Docker Compose file was originally based on [Start the Elastic Stack with Docker Compose](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack-docker.html#get-started-docker-tls), however now:

- All elastic based configurations have been moved from environment variables into their own config files.
- The setup service has had its command moved out into a script with a supporting file for defining instances rather than the file being created by the script.
- YAML anchoring has been used to define services.
- Filebeat and Squid services have been added.
 
Squid is configured to bind to port 3128 on the host and sends logs via syslog to Filebeat, which uses the Squid module to parse logs, and then forwards to Elasticsearch.

## Instructions

- Read the notes.
- Launch the project with `docker-compose up` from the project directory.
- Wait for all the services to start, this may take a while.
- Set the proxy in your web browser to `localhost:3128`. Firefox works best as Chrome and Edge use system wide settings.
- Perform some web activity.
- Visit Kibana at `localhost:5601` or the relevant port depending on configuration, login with the default credentials `elastic:changeme`.

- Once logged in select the burger navigation icon, select Management -> Stack Management, select Kibana -> Data Views, you will then be prompted to create a data view. Create one with the Name matching the index pattern, `filebeat-*`, and set the Timestamp field to `@timestamp`. You will only be able to created a data view after data has been forwarded over from the proxy so this needs to be done after performing some web activity and there may be a slight delay.
- You can now view logs under Discover, under the navigation icon, by changing the data view to `filebeat-*`.
- Analyse the data and then create visualisations and dashboards to extract more information.

## Notes

- If you haven't run the Elastic Stack before you may come into errors related to memory allocation and be asked to set `sysctl.vm.max_map_count` to `262144`.
- On macOS docker may also fail to bind Kibana to port `5601`, change `KIBANA_PORT` in the `.env` file to a free port, `5602` for example.

#### Windows 
To set `sysctl.vm.max_map_count` create or append to the `.wslconfig` file in your home directory with the following config:

```
[wsl2]
kernelCommandLine = "sysctl.vm.max_map_count=262144"
```

#### Linux 
To set `sysctl.vm.max_map_count`  run `sysctl -w vm.max_map_count=262144` as root.

#### macOS
Open docker desktop, go to Settings -> Resources -> Memory and set to `4GB`, I have found es03 crashes when set lower. This has only been a problem for me on macOS so far.
