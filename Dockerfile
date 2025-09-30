FROM ruby:3.2

# Criar diretório da aplicação
WORKDIR /app

# Copiar Gemfile e instalar dependências
COPY Gemfile .
RUN bundle install

# Copiar código da aplicação
COPY . .

# Expor a porta
EXPOSE 4567

# Rodar o servidor Sinatra
CMD ["bundle", "exec", "rerun", "--background", "--dir", "app", "--", "puma", "-p", "4567", "-b", "tcp://0.0.0.0", "config.ru"]
