# Elastic-Squid

A simple Docker Compose project that makes use of Elastic to monitor Squid proxy logs. This project makes use of:

- Elasticsearch
- Kibana
- Filebeat
- Squid
 
The Docker Compose file is based on [Start the Elastic Stack with Docker Compose](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack-docker.html#get-started-docker-tls) with some slight modification (yaml anchoring, variable changes, etc) and the addition of Filebeat and Squid services.
 
Squid is configured to bind to port 3128 on the host and sends logs via syslog to Filebeat, which uses the Squid module to parse logs, and then forwards to Elasticsearch.

## Instructions

- Read the notes.
- Launch the project with `docker-compose up` from the project directory.
- Wait for all the services to start, this may take a while.
- Set the proxy in your web browser to `localhost:3128`. Firefox works best as Chrome and Edge use system wide settings.
- Perform some web activity.
- Visit Kibana at `localhost:5601` or the relevant port depending on configuration, login with the default credentials `elastic:changeme`.
- Once logged in select `Explore on my own` on the Welcome to Elastic screen, go to `Discover` and you will be prompted to create a data view. Create one to match the index pattern, `filebeat-*` for example, and set the Timestamp field to `@timestamp`. You will only be asked to created a data view after data has been forwarded over from the proxy so this needs to be done after performing some web activity.
- You can now view logs under Discover by changing the data view to `filebeat-*`.
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
