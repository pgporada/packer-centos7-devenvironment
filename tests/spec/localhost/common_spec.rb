require 'spec_helper'

describe group('root') do
  it { should have_gid 0 }
end

describe group('wheel') do
  it { should exist }
end
