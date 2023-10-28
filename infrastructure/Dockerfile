FROM ubuntu

WORKDIR /workspace

COPY ./setup.sh .
RUN chmod +x ./setup.sh
RUN ./setup.sh

CMD tail -f > /dev/null
