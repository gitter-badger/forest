require "kemal"
require "pg"
require "./forest/*"

module Forest
  # Init connection
  dsn = ARGV[0]
  db = PG.connect(dsn)

  # Close connection at exit
  at_exit do
    Signal::INT.trap {
      db.finish
    }
  end
end
