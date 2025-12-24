FROM postgres:16

COPY ./postgres/postgresql.conf /etc/postgresql/postgresql.conf
COPY ./postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

CMD ["postgres", \
     "-c", "config_file=/etc/postgresql/postgresql.conf", \
     "-c", "hba_file=/etc/postgresql/pg_hba.conf"]