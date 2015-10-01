class Myapp::Redis < Redis
  REDIS_CONFIG = YAML.load_file(::Rails.root.join "config/database.yml")[::Rails.env]

  def initialize db = 0
    super host: REDIS_CONFIG["redis"]["host"], db: db
  end
end
