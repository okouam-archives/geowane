require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Conversion do

  before(:all) do
    @example_file = File.expand_path(File.join(File.dirname(__FILE__), "../samples/example2.mp"))
  end

  describe "when executing a conversion" do

    describe "and the conversion is not supported" do
      
      it "throws an error" do
        @conversion = Conversion.new(:input_format => :".SHP", :output_format => :".SHP")
        File.open(@example_file, 'rb') do |input_file|
          @conversion.input = input_file
        end
        @conversion.save!
        lambda {@conversion.execute}.should raise_error
      end

    end

    describe "and going from .MP to .SHP" do

    before(:each) do
        @conversion = Conversion.new(:input_format => :".MP", :output_format => :".SHP")
        File.open(@example_file, 'rb') do |input_file|
          @conversion.input = input_file
        end
        @conversion.save!
      end

      it "creates a temporary directory to store the .SHP output" do
        Dir.should_receive(:mktmpdir)
        @conversion.stub(:`).and_return("X")
        File.stub(:open)
        @conversion.execute
      end

      it "locates the cgpsmapper binary" do
        Dir.stub(:mktmpdir)
        File.stub(:open)
        @conversion.should_receive(:`).with("locate cgpsmapper-static").and_return("X")
        @conversion.stub(:`)
        @conversion.execute
      end

      it "converts the input file to a .SHP fileset" do
        @conversion.stub(:`).and_return("X")
        Dir.stub(:mktmpdir).and_return("/a_temp_dir")
        @conversion.should_receive(:`).with("cd /a_temp_dir && X shp #{@conversion.input.path}")
        File.stub(:open)
        @conversion.execute
      end

      it "compresses and archives the .SHP fileset" do
        @conversion.stub(:`).and_return("X")
        Dir.stub(:mktmpdir).and_return("/a_temp_dir")
        @conversion.should_receive(:`).with("cd /tmp && tar czvf example2.mp.tgz /a_temp_dir")
        File.stub(:open)
        @conversion.execute
      end

      it "assigns the created fileset to the object" do
        Dir.should_receive(:mktmpdir)
        @conversion.stub(:`).and_return("X")
        File.should_receive(:open).with("/tmp/example2.mp.tgz", 'rb')
        @conversion.execute
      end

    end

  end

end