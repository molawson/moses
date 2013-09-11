module Moses
  class Database
    Sequel.extension :pagination

    attr_reader :connection

    def initialize(uri)
      @connection = Sequel.connect(uri)
      Sequel::MySQL.convert_invalid_date_time = nil if @connection.adapter_scheme == :mysql
    end

    def transfer_to(db, &cb)
      cb.call(:tables, tables.length)
      tables.each do |name|
        next if name == :schema_migrations

        cb.call(:table, [name, connection[name].count])
        transfer_table(name, db, &cb)
      end
    end

    def transfer_table(name, db, &cb)
      columns = connection.schema(name).map(&:first)
      dataset = connection[name.to_sym]

      cb.call(:rows)
      buffer = []
      count = 0

      dataset.each do |row|
        buffer << row
        count  += 1

        if buffer.length > 500
          cb.call(:row, count)
          send_rows(db, name, columns, buffer)
          buffer.clear
          count=0
        end
      end

      cb.call(:row, count)
      send_rows(db, name, columns, buffer) if buffer.length > 0
      cb.call(:end)

      columns
    end

    def send_rows(db, name, columns, rows)
      data = rows.map { |row| columns.map { |c| row[c] } }
      db.connection[name].insert_multiple data
    end

    def tables
      @tables ||= connection.tables
    end
  end
end
