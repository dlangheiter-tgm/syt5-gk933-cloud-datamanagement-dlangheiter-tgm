FROM google/dart

WORKDIR /app
ADD pubspec.* /app/
RUN pub get --no-precompile
ADD config.yaml /app/
ADD ./bin /app/bin/
ADD ./lib/ /app/lib/
RUN pub get --offline --no-precompile

WORKDIR /app

ENTRYPOINT ["pub", "run", "aqueduct:aqueduct", "serve"]