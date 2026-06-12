require "./spec_helper"

# Top-level smoke test: ensure the module loads and both version parsers are accessible
describe "ISO8583" do
  it "exposes V1987::Parser" do
    ISO8583::V1987::Parser.responds_to?(:parse).should be_true
  end

  it "exposes V1993::Parser" do
    ISO8583::V1993::Parser.responds_to?(:parse).should be_true
  end
end
