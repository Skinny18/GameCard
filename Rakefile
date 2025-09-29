require 'rake'
require 'active_record'
require 'logger'

# Configuração do DB
require './config/database.rb'

# Caminho das migrations
migrations_path = File.join('db', 'migrate')

namespace :db do
  desc "Rodar todas as migrations"
  task :migrate do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    migration_context = ActiveRecord::MigrationContext.new(migrations_path)
    migration_context.migrate
    puts "Migrations aplicadas com sucesso!"
  end

  desc "Reverter a última migration"
  task :rollback do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    migration_context = ActiveRecord::MigrationContext.new(migrations_path)
    last_version = migration_context.get_all_versions.max
    if last_version
      migration_context.down(last_version)
      puts "Última migration revertida: #{last_version}"
    else
      puts "Nenhuma migration para reverter"
    end
  end
end
