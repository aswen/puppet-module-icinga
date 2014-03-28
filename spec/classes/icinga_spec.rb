require 'spec_helper'

describe 'icinga' do
  it "should fail because only the server and client classes are used" do
    expect { subject }.to raise_error(/The class Icinga does nothing on its own/)
  end
end
