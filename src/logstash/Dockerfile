FROM logstash:8.5.3 

RUN cat /etc/os-release
USER root

COPY ./configs/logstash.yml /usr/share/logstash/config/logstash.yml
COPY ./configs/pipelines.yml /usr/share/logstash/config/pipelines.yml
COPY ./pipelines/logstash.conf /usr/share/logstash/config/pipelines/service_stamped_json_logs.conf

RUN chmod +rwx /usr/share/logstash/config/pipelines/service_stamped_json_logs.conf
RUN chown logstash /usr/share/logstash/config/pipelines/service_stamped_json_logs.conf

USER logstash
