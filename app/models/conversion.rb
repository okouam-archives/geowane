require 'enumerated_attribute'

class Conversion < ActiveRecord::Base
   has_attached_file :input
   has_attached_file :output
   attr_protected :input_file_name, :input_content_type, :input_size
   attr_protected :output_file_name, :output_content_type, :output_size
   enum_attr :input_format, %w(^.MP .SHP)
   enum_attr :output_format, %w(.MP ^.SHP)

   def execute
     if self.input_format == :".MP" && self.output_format == :".SHP"
       conversion_binary = locate_binary
       temp_directory = Dir.mktmpdir
       command = "cd #{temp_directory} && #{conversion_binary} shp #{self.input.path}"
       `#{command}`
       `cd /tmp && tar czvf #{input.original_filename}.tgz #{temp_directory}`
       File.open("/tmp/#{input.original_filename}.tgz", 'rb') do |output_file|
         self.output = output_file
       end
     else
       raise "Conversion from #{self.input_format} to #{self.output_format} is not currently supported."
     end
   end

  private

  def locate_binary
    conversion_binaries = `locate cgpsmapper-static`
    unless conversion_binaries && !conversion_binaries.blank?
      raise "The cgpsmapper-static binary cannot be found."
    end
    conversion_binaries.split("\n")[0]
  end

end