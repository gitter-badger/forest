require "kemal"
require "pg"
require "./forest/*"

module Forest
  dsn = ARGV[0]
  begin
    database = PG.connect(dsn)
  rescue e : PG::ConnectionError
    exit 1
  end

  get "/:table" do |env|
    table = env.params.url["table"]
    begin
      result = database.exec("select * from #{table}")
    rescue 
      env.response.status_code = 404
    else
      result.to_hash
    end
  end

  # Close connection at exit
  at_exit do
    Signal::INT.trap {
      database.finish if database
    }
  end
end
