require 'rubygems'
require 'mini/test'
require 'mocha'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ec2_select'
include Ec2Select

class Mini::Test::TestCase
  def setup
    ENV['EC2_PRIVATE_KEY']  = 'pk-foob.pem'
    ENV['EC2_CERT']         = 'cert-foob.pem'
  end
end

Mini::Test.autorun
