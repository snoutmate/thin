require File.dirname(__FILE__) + '/../spec_helper'

describe Connectors::UnixServer do
  before do
    @connector = Connectors::UnixServer.new('/tmp/thin-test.sock')
  end
  
  it "should connect" do
    EventMachine.run do
      @connector.connect
      EventMachine.stop
    end
  end
  
  it "should disconnect" do
    EventMachine.run do
      @connector.connect
      @connector.disconnect
      EventMachine.stop
    end
  end
  
  it "should remove socket file on close" do
    @connector.close
    File.exist?('/tmp/thin-test.sock').should be_false
  end
end

describe UnixConnection do
  before do
    @connection = UnixConnection.new(nil)
  end
  
  it "should return nil on error retreiving remote_address" do
    @connection.stub!(:get_peername).and_raise(RuntimeError)
    @connection.remote_address.should be_nil
  end
  
  it "should return remote_address" do
    @connection.stub!(:get_peername).and_return("\000\001127.0.0.1\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000")
    @connection.remote_address.should == '127.0.0.1'
  end
end