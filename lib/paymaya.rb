
require 'rubygems'
require 'rspec' 
require 'selenium-webdriver'
require 'faker'
require 'httpclient'
require 'pry'
require 'rest-client'
#require 'addressable/uri'
require 'json'
require 'jsonclient'
require 'csv'
require 'uri'
require 'net/http'
require 'net/ftp'
require 'dotenv'
require 'aws-sdk-s3'
require 'etc' #no need to install this
require 'docsplit'
require 'pdf-reader'
require 'oauth2'
require 'fileutils'
require 'open-uri'
require 'week_of_month'
require 'time'

require File.expand_path(File.dirname(__FILE__) + '/modules/helpers/webdriver_commands')
require File.expand_path(File.dirname(__FILE__) + '/modules/helpers/locators')
require File.expand_path(File.dirname(__FILE__) + '/modules/helpers/testdata')
require File.expand_path(File.dirname(__FILE__) + '/modules/payee')
require File.expand_path(File.dirname(__FILE__) + '/modules/payment')

Dotenv.load("environments/#{ENV['ENV_NAME']}.env")
WeekOfMonth.configuration.monday_active = true

class WEB < Selenium::WebDriver::Driver

  ###### ---------------- WEB UI ------------------- ######
  include WebDriverCommands
  include Locators
  include TestData
  include Payee
  include Payment

  def initialize
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 200 
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--window-size=1366,768")
      options.add_argument("--disable-gpu")
      options.add_argument("--disable-extensions")
      options.add_argument("--start-maximized")
      #options.add_argument("--proxy-server='direct://'")
      options.add_argument("--enable-features=NetworkService,NetworkServiceInProcess")
      options.add_argument('--ignore-certificate-errors-spki-list')
      #options.add_argument("--proxy-bypass-list=*")
      options.add_argument("--headless") if !(ENV["headless"].to_s == "false")
      options.add_argument("no-sandbox")
    begin
      @driver = Selenium::WebDriver.for :chrome, options: options , http_client: client
      @driver.manage.delete_all_cookies
      @driver.get("#{ENV['URL']}")
    rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::SessionNotCreatedError, Net::ReadTimeout
      # screenshot(:when => "initialize browser")
      ## puts "Rescue in 'initialize'. Reopening browser and url....."
      @driver.close
      @driver = Selenium::WebDriver.for :chrome, options: options , http_client: client
      @driver.manage.delete_all_cookies
      @driver.get("#{ENV['URL']}")
    end
  end

  def close_current_browser_session
    @driver.close
  end

  def quit_current_browser_session
    @driver.quit
  end

end #brandm8 < Selenium::WebDriver::Driver

class API
  def get_api_call(options={}, p_attributes={})
    params = {}
    ## CONNECT TO API SERVER
    client = HTTPClient.new(base_url: "#{ENV['URL']}")
    client.send_timeout = 5000
    client.receive_timeout = 5000
    ## RETRIEVE DATA FROM GIVEN ENDPOINT
    api_response = client.get "#{options[:endpoint]}", params.update(p_attributes)
    puts "get_api_response.code:#{api_response.code}"

    ## CHECK FOR SUCCESS CODE
    if api_response.code != 200
      return "Unable to access api server successfully. Code Response:#{api_response.code}"
    else
      p_attrib = JSON.parse(api_response.body)
      #puts "p_attrib:#{p_attrib}"
      return p_attrib
    end
  end #get_api_call

  def post_api_call(options={}, p_attributes={})
    ## CONNECT TO API SERVER
    client = HTTPClient.new(base_url: "#{ENV['URL']}")
    client.send_timeout = 5000
    client.receive_timeout = 5000

    ## POST DATA TO GIVEN ENDPOINT 
    api_response = client.post "#{options[:endpoint]}", p_attributes
    puts "post_api_response.code:#{api_response.code}"
    ## CHECK FOR SUCCESS CODE 201
    if api_response.code != 201
      return "Unable to access api server successfully. Code Response:#{api_response.code}"
    else
      p_attrib = JSON.parse(api_response.body)
      #puts "p_attrib:#{p_attrib}"
      return p_attrib
    end
  end
end