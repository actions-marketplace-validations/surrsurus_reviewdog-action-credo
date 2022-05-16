FROM hexpm/elixir:1.13.1-erlang-24.2-debian-bullseye-20210902-slim

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.13.0

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git curl gnupg \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

ENV MIX_HOME /var/mix
ENV MIX_ENV="test"

COPY config/config.exs config/${MIX_ENV}.exs config/

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix archive.install --force github rrrene/bunt && \
    mix archive.install --force github rrrene/credo && \

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
