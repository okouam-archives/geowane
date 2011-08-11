require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do

  it "can be instantiated" do
    pending
  end

  context "when valid" do

    it "can be saved" do
      pending
    end

    context "when saving" do

      context "and the icon link starts with http" do

        it "renames the icon link to be the local path" do
          pending
        end

        it "copies the external resource to the local filesystem if not already present" do
          pending
        end

        it "keeps the local resource if one is already present" do
          pending
        end

      end

      context "and the icon link does not start with http" do

        it "does not modify the icon link" do
          pending
        end

      end

    end

  end

  it "can output a JSON representation" do
    pending
  end

  it "can output its bilingual name" do
    pending
  end

  it "provides a list of categories for use in dropdowns" do
    pending
  end


end
