desc "updates the database when it is running"
task update_data: :environment do
  puts "Processing Data..."
  RecordProcessor.read_csv
  puts "Data Processed"
end
