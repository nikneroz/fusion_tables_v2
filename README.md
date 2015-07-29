# Fusion Tables V2(Under Development)

### Get connection
    db = FusionTablesV2.connect(key_path: path_string)

### List all tables
    db.list_tables

### Build table
    my_table = db.build_table('my_table') do |table|
      table.string :string_col
      table.integer :integer_col
      table.datetime :datetime_col
      table.location :location_col
    end

### Create builded table
    my_table = db.create_table(my_table)

### Create table
    my_table = db.create_table('my_table') do |table|
      table.string :string_col
      table.integer :integer_col
      table.datetime :datetime_col
      table.location :location_col
    end

### Drop table
    db.drop_table(table_id)
    db.drop_table_by(name: table_name)

### Get table
    db.get_table(table_id)
    db.get_table_by(name: table_name)

### Import rows from file
    db.import_rows(table_id, file: file_or_stream, header: true)
