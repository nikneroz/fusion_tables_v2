# Fusion Tables V2(Under Development)

### Get connection
    db = FusionTablesV2.connect(key_path: path_string)

### List all tables
    db.list_tables

### Build table
    my_table = db.build_table('my_table') do |table|
      table.string :name
      table.integer :name
      table.datetime :name
      table.location :name
    end

### Create builded table
    my_table = db.create_table(my_table)

### Create table
    my_table = db.create_table('my_table') do |table|
      table.string :name
      table.integer :name
      table.datetime :name
      table.location :name
    end

### Drop table
    db.drop_table(table_id)
    db.drop_table_by(name: table_name)
