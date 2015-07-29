require 'google/apis/fusiontables_v2'

class FusionTablesV2
  API = Google::Apis::FusiontablesV2
  AVAILABLE_COLUMN_TYPES = ['DATETIME', 'LOCATION', 'NUMBER', 'STRING']

  class Table < API::Table
    attr_accessor :db

    # attribution	string	Attribution assigned to the table.	writable
    # attributionLink	string	Optional link for attribution.	writable
    # baseTableIds[]	list	Base table identifier if this table is a view or merged table.	
    # columnPropertiesJsonSchema	string	Default JSON schema for validating all JSON column properties.	writable
    # columns[]	list	Columns in the table.	writable
    # description	string	Description assigned to the table.	writable
    # isExportable	boolean	Variable for whether table is exportable.	writable
    # kind	string	The kind of item this is. For table, this is always fusiontables#table.	
    # name	string	Name assigned to a table.	writable
    # sql	string	SQL that encodes the table definition for derived tables.	
    # tableId	string	Encrypted unique alphanumeric identifier for the table.	
    # tablePropertiesJson	string	JSON object containing custom table properties.	writable
    # tablePropertiesJsonSchema	string	JSON schema for validating the JSON table properties.
    def self.build(is_exportable: false, name:, db:)
      new_table = new
      new_table.db = db
      new_table.name = name
      new_table.columns = []
      new_table.kind = 'fusiontables#table'
      new_table.is_exportable = is_exportable
      new_table
    end

    def string(column_name)
      puts db
      columns << db.build_column(name: column_name, type: 'STRING', table: self)
      self
    end
    
    def datetime(column_name)
      columns << db.build_column(name: column_name, type: 'DATETIME', table: self)
      self
    end

    def integer(column_name)
      columns << db.build_column(name: column_name, type: 'NUMBER', table: self)
      self
    end

    def location(column_name)
      columns << db.build_column(name: column_name, type: 'LOCATION', table: self)
      self
    end
  end

  class Column < API::Column
  end

  attr_reader :client, :authorization, :key_path

  def self.connect(key_path: nil)
    if key_path
      new(key_path)
    else
      false
    end
  end

  def initialize(key_path)
    client = API::FusiontablesService.new
    authorization = get_authorization(key_path)
    client.authorization = authorization
    @key_path = key_path
    @authorization = authorization
    @client = client
  end

  def get_authorization(key_path)
    ENV['GOOGLE_APPLICATION_CREDENTIALS'] = key_path
    scopes =  ['https://www.googleapis.com/auth/fusiontables']
    authorization = Google::Auth.get_application_default(scopes)
    authorization.fetch_access_token!
    authorization
  end

  def list_tables
    @client.list_tables
  end

  def build_table(table_name, &block)
    new_table = Table.build(name: table_name, db: self)
    if block_given?
      new_table.instance_eval(&block)
    end
    new_table
  end

  def create_table(table, &block)
    if table.is_a?(Table)
      @client.insert_table(table)
    elsif table.is_a?(String)
      if block_given?
        builded_table = build_table(table, &block)
        @client.insert_table(builded_table)
      else
        raise ArgumentError.new('Please specify migration block')
      end
    else
      raise ArgumentError.new('Table must be String or Table object')
    end
  end

  def drop_table(table_id)
    client.delete_table(table_id)
    true
  rescue Google::Apis::ClientError
    "Table doesn't exist"
  end

  def drop_table_by(name:)
    tables = tables_hash 
    raise ArgumentError.new('There are more than 1 table with this name') if tables.count { |el| el[:name] == name } > 1
    table_id = tables.find { |el| el[:name] == name }[:id]
    drop_table(table_id)
  end

  def get_table(table_id)
    client.get_table(table_id)
  rescue Google::Apis::ClientError
    "Table doesn't exist"
  end

  def get_table_by(name:)
    tables = tables_hash 
    if tables.count { |el| el[:name] == name } > 1
      client.list_tables.items.select {|t| t.name == 'my_table' }
    elsif tables.count { |el| el[:name] == name } == 1
      client.get_table(tables.find { |el| el[:name] == name }[:id])
    else
      "Table doesn't exist"
    end
  end

  def import_rows(table_id, file:, delimiter: ",", content_type: 'application/octet-stream', header: true)
    start_line = ( header ? 0 : 1 )
    client.import_rows("1YfKucvH1uRG6RBlJhF4XaCvCZkIIgOLUCBi8SUOA", delimiter: ";", upload_source: file, content_type: content_type, start_line: start_line)
  end

  def tables_hash
    items = client.list_tables.items || []
    items.map { |t| { name: t.name, id: t.table_id } }
  end

  # baseColumn	object	Optional identifier of the base column. If present, this column is derived from the specified base column.	
  # baseColumn.columnId	integer	The ID of the column in the base table from which this column is derived.	
  # baseColumn.tableIndex	integer	Offset to the entry in the list of base tables in the table definition.	
  # columnId	integer	Identifier for the column.	
  # kind	string	The kind of item this is. For column, this is always fusiontables#column.	
  # name	string	Required name of the column.	writable
  # type	string	Required type of the column. Type can be "NUMBER", "STRING", "LOCATION", or "DATETIME". 
  # Acceptable values are:
  #   "DATETIME":
  #   "LOCATION":
  #   "NUMBER":
  #   "STRING":
  def build_column(column_id: nil, validate_data: false, format_pattern: 'NONE', name:, type:, table:)
    column_id ||= table.columns.size
    raise ArgumentError.new('Column ID must be Integer') unless column_id.is_a?(Integer)
    raise ArgumentError.new("Column type must be #{ AVAILABLE_COLUMN_TYPES }") unless AVAILABLE_COLUMN_TYPES.include?(type)
    new_column = Column.new()
    new_column.name = name
    new_column.type = type
    new_column.kind = 'fusiontables#column'
    new_column.validate_data = validate_data
    new_column.format_pattern = format_pattern
    new_column
  end
end
