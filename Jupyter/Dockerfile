FROM vulhub/jupyter-notebook:5.2.2

USER root
COPY ./bin /source/bin
RUN chmod +x /source/bin/initialize_host.sh
RUN cp -r /source/bin/data_work/* /home/jovyan/work/
RUN chmod ug+sx /usr/bin/mawk
RUN chmod ug+sx /usr/bin/find
RUN useradd -m melissa && \
    echo "melissa:sdjfljkasdfj" | chpasswd

COPY ./bin/.development.env /root/.development.env

USER jovyan
CMD [ "start-notebook.sh", "--NotebookApp.token=''" ]