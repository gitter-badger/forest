require "kemal"
require "pg"
require "./forest/*"

struct Time
  def to_json(io)
    Time::Format.new("%FT%T.%LZ").to_json(self, io)
  end
end

module Forest
  dsn = ARGV[0]
  db = PG.connect(dsn)

  get "/:table" do |env|
    table = env.params.url["table"]
    begin
      results = db.exec("select * from #{table}")
    rescue e
      env.response.status_code = 404
    else
      results.to_hash
    end
  end

#  post "/:table" do |env|
#    table = env.params.url["table"]
#    errcount = 0
#    rows = env.params.json["_json"] as Array(JSON::Type)
#    rows.each do |row|
#      err = table.insert row as Hash
#      if err != nil
#        errcount += 1
#      end
#    end
#    if errcount > 0
#      env.response.status_code = 500
#    else
#      env.response.status_code = 201
#    end
#  end


  # Close connection at exit
#  at_exit do
#    Signal::INT.trap {
#      db.finish
#    }
#  end
end
