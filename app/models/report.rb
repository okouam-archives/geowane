class Report < ActiveRecord::Base

  def write(filename, records)

    workbook = WriteExcel.new(filename)

    worksheet  = workbook.add_worksheet
    worksheet2 = workbook.add_worksheet

    format = workbook.add_format
    format.set_bold
    format.set_color('red')
    format.set_align('right')

    worksheet.write(1, 1, 'Hi Excel.', format)
    worksheet.write(2, 1, 'Hi Excel.')

    workbook.close
  end

end