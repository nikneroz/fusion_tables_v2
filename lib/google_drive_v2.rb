require 'google/apis/drive_v2'
drive = Google::Apis::DriveV2::DriveService.new
drive.authorization = db.authorization
table_file = drive.list_files.items.find { |file| file.id == db.get_table_by(name: 'macroregions').table_id }
perm = Google::Apis::DriveV2::Permission.new
perm.value = 'test@email.com'
perm.role = 'owner'
perm.type = 'user'
drive.insert_permission(table_file.id, perm)
