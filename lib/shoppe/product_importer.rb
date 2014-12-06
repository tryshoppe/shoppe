require 'roo'

module Shoppe
  class ProductImporter
    def initialize(file_path)
      @file_path = file_path
      @spreadsheet = open_spreadsheet(file_path)
    end

    def import!
      @spreadsheet.default_sheet = @spreadsheet.sheets.first
      header = @spreadsheet.row(1)

      (2..@spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
      end
    end

    private

    def open_spreadsheet(file)
      case file.extname(file.original_filename)
      when '.csv' then roo::csv.new(file.path)
      when '.xls' then roo::excel.new(file.path)
      when '.xlsx' then roo::excelx.new(file.path)
      else raise i18n.t('shoppe.imports.errors.unknown_format', filename: file.original_filename)
      end
    end
  end
end
