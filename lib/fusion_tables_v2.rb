require 'google/apis/fusiontables_v2'

class FusionTablesV2
  attr_reader :client, :authorization, :key_path
  def self.connect(key_path: nil)
    if key_path
      new(key_path)
    else
      false
    end
  end

  def initialize(key_path)
    client = Google::Apis::FusiontablesV2::FusiontablesService.new
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
end
# authorization.client_id = '5762206349-q7at9eed5em1ehapi4fkb62oo3u77lqn.apps.googleusercontent.com'
# authorization.username = 'rozenkin'
# authorization.password = '4n66p1kk'
# client.key = 'AIzaSyD2ozFFzpBYQ1XuAlZZq70TrT-6wh2Fp2g'
# require 'googleauth'
# require 'google/apis/fusiontables_v2'
# require 'google/apis/drive_v2'

# Drive = Google::Apis::DriveV2 # Alias the module
# drive = Drive::DriveService.new

# Search for files in Drive (first page only)
# FusionTables = Google::Apis::FusiontablesV2
# client = FusionTables::FusiontablesService.new
# path_to_credentials = '/Users/nikneroz/Downloads/sprut-supervision-7d92349ff47d.json'
# ENV['GOOGLE_APPLICATION_CREDENTIALS'] = path_to_credentials
# scopes =  ['https://www.googleapis.com/auth/drive', 'https://www.googleapis.com/auth/fusiontables', 'https://www.googleapis.com/auth/fusiontables.readonly']
# authorization = Google::Auth.get_application_default(scopes)
# authorization.fetch_access_token!
# client.authorization = authorization
# drive.authorization = authorization # See Googleauth or Signet libraries
# client.list_tables
# files = drive.list_files
# files.items.each do |file|
#   puts file.title
# end
# row = client.sql_query(sql: 'SELECT name FROM 12IyNkqfqlsGC3qsSFnePKJB8WvHybfYUi0yyLMJ7 LIMIT 1')
