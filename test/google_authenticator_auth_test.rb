# encoding: utf-8
require 'test/unit'
require 'timecop'
require_relative '../lib/google_authenticator_auth.rb'

class GoogleAuthenticatorAuthTest < Test::Unit::TestCase

  test "should create a random key when started with no paramaters" do
    ga = GoogleAuthenticator.new
    assert_not_nil ga.secret_key
  end
 
  test "should use provided secret key" do
    ga = GoogleAuthenticator.new('NINWS2QUIQD2LA2Z')
    assert_equal ga.secret_key, 'NINWS2QUIQD2LA2Z'
  end

  test "should return three keys" do
    ga = GoogleAuthenticator.new
    assert_equal ga.get_keys.length, 3
  end 

  test "should return a valid qrcode url" do
    ga = GoogleAuthenticator.new('NINWS2QUIQD2LA2Z')
    assert_equal ga.qrcode_image_url("user@domain.com"), "https://chart.googleapis.com/chart?chs=350x350&cht=qr&choe=UTF-8&chl=otpauth://totp/user@domain.com?secret=NINWS2QUIQD2LA2Z"
    assert_equal ga.qrcode_url("user@domain.com"), "otpauth://totp/user@domain.com?secret=NINWS2QUIQD2LA2Z"
  end

  test "returned keys should be valid" do
    ga = GoogleAuthenticator.new
    ga.get_keys.each do |key|
      assert ga.key_valid?(key)
    end
  end
  
  test "test vectors should match" do
	baseTime = Time.utc(1970, 1, 1, 0, 0, 0)
	ga = GoogleAuthenticator.new('GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ')
	
	# test vectors from draft (https://tools.ietf.org/html/draft-mraihi-totp-timebased-01#page-12)
	testvectors = {
		1111111111 => '050471',
		1234567890 => '005924',
		2000000000 => '279037'
	}
	
	testvectors.each do |t, k|
		Timecop.freeze(baseTime + t) do
			assert ga.key_valid?(k)
		end
	end
  end
  
  test "key is valid within timespan" do
  	baseTime = Time.utc(1970, 1, 1, 0, 0, 0)
	ga = GoogleAuthenticator.new('GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ')
	
	testdata = {
		1111111111 - 60 => false,
		1111111111 - 30 => true,
		1111111111 => true,
		1111111111 + 30 => true,
		1111111111 + 60 => false
	}
	
	testdata.each do |t, e|
		Timecop.freeze(baseTime + t) do
			assert (ga.key_valid?('050471') == e)
		end
	end
  end

end
