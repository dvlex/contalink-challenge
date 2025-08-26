# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
require 'set'

statuses = [ "Vigente", "Cancelado", "Pagado", "Pendiente" ]
used_numbers = Set.new

def unique_invoice_number(used)
  loop do
    num = "C#{rand(10000..99999)}"
    return num unless used.include?(num)
    used.add(num)
  end
end

def random_total
  rand(1000..999999) / 100.0
end

def random_timestamp
  Faker::Time.between(from: Date.new(2022, 1, 1), to: Date.new(2025, 12, 31), format: :default)
end

puts "Seeding 100,000 invoices..."

Invoice.transaction do
  100_000.times.each_slice(1000) do |batch|
    invoices = batch.map do
      {
        invoice_number: unique_invoice_number(used_numbers),
        total: random_total,
        invoice_date: random_timestamp,
        status: statuses.sample,
        active: [ true, false ].sample
      }
    end
    Invoice.insert_all(invoices)
  end
end

puts "Done!"

# Note: To reset the database and reseed, run:
# bin/rails db:reset
