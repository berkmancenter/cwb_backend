require 'test_helper'

describe "PIM" do
  it "inherits from RDF::Vocabulary" do
    PIM.ancestors.must_include RDF::Vocabulary
  end
end
