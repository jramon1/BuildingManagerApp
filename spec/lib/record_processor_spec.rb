require "rails_helper"
RSpec.describe RecordProcessor, type: :record_processor do
  describe RecordProcessor do
      path = Rails.root.join("spec", "support", "csvs")
    before :each do
      RecordProcessor.read_csv(path)
    end

    context "read_csv" do

      it "should create new buildings" do

        expect(Building.count).to eq 4
      end

      it "should not modify existing buildings with existing data" do
        CSV.open("#{path}/buildings.csv", "a") do |csv|

          csv << Building.second.attributes.values[1..6]
        end
        RecordProcessor.read_csv(path)

        expect(Building.count).to eq 4
      end

      it "should create new people" do
        expect(Person.count).to eq 4
      end

      it "should not modify existing people with existing data" do
        CSV.open("#{path}/people.csv", "a") do |csv|
          csv << Person.second.attributes.values[1..7]
        end
        RecordProcessor.read_csv(path)

        expect(Person.count).to eq 4
      end




    end
  end
end
