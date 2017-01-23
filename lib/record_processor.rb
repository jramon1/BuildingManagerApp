require 'csv'
class RecordProcessor

  class << self
    def read_csv(path = nil)
      path = Rails.root.join("public", "uploads") unless path
      csv_files = ["buildings.csv", "people.csv"]
      csv_files.each do |csv|
        csv_values = []
        CSV.foreach("#{path}/#{csv}", headers: true) do |row|
          csv_values << row
        end
        check_csv_fields(csv_values, csv)
      end
    end

    def check_csv_fields(csv_rows, csv_file)
      if csv_rows.first.headers == buildings_fields
        parse_buildings(csv_rows)
      elsif csv_rows.first.headers == people_fields
        parse_people(csv_rows)
      end
    end

    def parse_buildings(csv_rows)
      csv_rows.each do |row|
        mgr_name = row["manager_name"]
        ref_id = row["reference"]
        row.delete("manager_name")
        process_buildings(row, mgr_name, ref_id)
      end
    end

    def process_buildings(row, mgr_name, ref_id)
      if Building.exists?(row.to_hash)
        unless Building.exists?(manager_name: mgr_name, reference: ref_id)
          Building.find_by(reference: ref_id).
            update_attribute(:manager_name, mgr_name)
        end
      else
        Building.create(row.to_hash.merge(manager_name: mgr_name))
      end
    end

    def parse_people(csv_rows)
      csv_rows.each do |row|
        @first_name = row["first_name"]
        @last_name = row["last_name"]
        @mobile = row["home_phone_number"]
        @phone = row["mobile_phone_number"]
        @email = row["email"]
        @address = row["address"]
        @ref_id = row["reference"]
        process_people(row)
      end
    end

    def process_people(row)
      if Person.exists?(reference: @ref_id)
        unless Person.exists?(
          home_phone_number: @phone,
          mobile_phone_number: @mobile,
          email: @email,
          address: @address)
        Person.find_by(reference: @ref_id).
        update_attributes(
          home_phone_number: @phone,
          mobile_phone_number: @mobile,
          email: @email,
          address: @address)
        end
      else
        Person.create(row.to_hash)
      end
    end

    def buildings_fields
      ["reference", "address", "zip_code", "city", "country", "manager_name"]
    end

    def people_fields
      ["reference", "firstname", "lastname", "home_phone_number",
       "mobile_phone_number", "email", "address"]
    end
  end
end

