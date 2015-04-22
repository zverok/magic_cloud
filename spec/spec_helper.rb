# encoding: utf-8
$:.unshift 'lib'
require 'magic_cloud'

require 'rspec/its'

RSpec::Matchers.define :be_one_of do |expected|
  match do |actual|
    expected.include?(actual)
  end
end
