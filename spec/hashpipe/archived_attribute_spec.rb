require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

module ArchivedAttributeHelpers
  def build_attribute(opts = {})
    opts[:name]    ||= :glorp
    opts[:backend] ||= Moneta::Memory.new
    opts[:scope]   ||= 'unique-id'
    HashPipe::ArchivedAttribute.new(opts.delete(:name),
                                    opts.delete(:scope),
                                    opts.delete(:backend),
                                    opts)
  end

  def clone_attribute(attribute)
    build_attribute(:marshal  => attribute.marshal?,
                    :compress => attribute.compress?,
                    :backend  => attribute.backend,
                    :scope    => attribute.scope,
                    :name     => attribute.name)
  end

  def backend
    subject.backend
  end
end

describe HashPipe::ArchivedAttribute do

  include ArchivedAttributeHelpers

  before { @attribute = build_attribute }

  subject { @attribute }

  it "should not be dirty when a value has not been set" do
    should_not be_dirty
  end

  it "should join the scope and the attribute name as a hash key" do
    subject.key.should == "#{subject.scope}_#{subject.name}"
  end

  it "should allow the scope to be set" do
    new_scope = 'another scope'
    subject.scope = new_scope
    subject.scope.should == new_scope
  end

  it "should use the provided backend" do
    backend = Moneta::Memory.new
    build_attribute(:backend => backend).backend.should == backend
  end

  it "should return when the value has been set" do
    subject.value = 'stuff'
    should be_dirty
  end

  it "should not be dirty after save is called" do
    subject.value = 'stuff'
    subject.save
    should_not be_dirty
  end

  it "should add itself to the backend when saved" do
    value = 'a value'

    backend.should_not have_key(subject.key)

    subject.value = value
    subject.save

    backend[subject.key].should == value
  end

  it "should retrieve itself from the backend" do
    value = 'a value'
    backend[subject.key] = value

    subject.value.should == value
  end

  it "should remove itself from the backend when destroyed" do
    backend[subject.key] = 'value'
    subject.destroy
    backend.should_not have_key(subject.key)
  end

  it "should correctly store a marshalled, compressed value" do
    value = 'the value'
    attribute = build_attribute(:marshal => true, :compress => true)
    attribute.value = value
    attribute.save

    clone_attribute(attribute).value.should == value
  end
end


describe HashPipe::ArchivedAttribute, "when marshal is on" do

  include ArchivedAttributeHelpers

  before { @attribute = build_attribute(:marshal => true) }
  subject { @attribute }

  it "should be marshalled" do
    subject.marshal?.should be
  end

  it "should store a marshalled value" do
    stored = 'stored value'
    actual = 'a value'

    Marshal.expects(:dump).with(actual).returns(stored)

    subject.value = actual
    subject.save

    backend[subject.key].should == stored
  end

  it "should retrieve a marshalled value" do
    stored = 'stored value'
    actual = 'a value'
    backend[subject.key] = stored

    Marshal.expects(:load).with(stored).returns(actual)

    subject.value.should == actual
  end

  it "should correctly store a nil value" do
    subject.value = nil
    subject.save
    clone_attribute(subject).value.should be_nil
  end
end

describe HashPipe::ArchivedAttribute, "when compression is on" do

  include ArchivedAttributeHelpers

  before { @attribute = build_attribute(:compress => true) }
  subject { @attribute }

  it "should be compressed" do
    subject.compress?.should be
  end

  it "should store a compressed value" do
    value = 'a value'
    subject.value = value
    subject.save
    backend[subject.key].should == Zlib::Deflate.deflate(value)
  end

  it "should retrieve a compressed value" do
    value = 'a value'
    backend[subject.key] = Zlib::Deflate.deflate(value)
    subject.value.should == value
  end

  it "should correctly store a nil value" do
    subject.value = nil
    subject.save
    clone_attribute(subject).value.should be_nil
  end
end

