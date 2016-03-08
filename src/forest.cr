require "kemal"
require "pg"
require "./forest/*"

module Forest
  # Init connection
  dsn = ARGV[0]
  db = PG.connect(dsn)

  get "/:table" do |env|
    table = env.params.url["table"]
    begin
      result = db.exec("select * from #{table}")
    rescue e
      env.response.status_code = 404
    else
      results.to_hash
    end
  end

  # Close connection at exit
  at_exit do
    Signal::INT.trap {
      db.finish
    }
  end
end
