module WebDriverCommands 

  def webdriver_element(options={})
    web_element = @driver.find_element(:id, options[:id]) if options[:id]
    web_element = @driver.find_element(:xpath, options[:xpath]) if options[:xpath]
    web_element = @driver.find_element(:css, options[:css]) if options[:css]
    web_element = @driver.find_element(:name, options[:name])if options[:name]
    web_element = @driver.find_element(:class, options[:class])if options[:class]
    web_element = @driver.find_element(:class_name, options[:class_name]) if options[:class_name]
    web_element = @driver.find_element(:link, options[:link]) if options[:link]
    web_element = @driver.find_element(:link_text, options[:link_text]) if options[:link_text]
    web_element = @driver.find_element(:partial_link_text, options[:partial_link_text]) if options[:partial_link_text]
    web_element = @driver.find_element(:tag_name, options[:tag_name]) if options[:tag_name]
    return web_element 
  end #webdriver_element

  def element_displayed(options={})
    begin
      element = webdriver_element(options).displayed?
    rescue
      element = false
    end
    return element
  end #element_displayed

  def element_finder(locator)
    if element_displayed(:id =>locator)
      return @driver.find_element(:id, locator)
    elsif element_displayed(:name =>locator) 
      return @driver.find_element(:name, locator)
    elsif element_displayed(:xpath =>locator)
      return @driver.find_element(:xpath, locator)
    elsif element_displayed(:css =>locator)
      return @driver.find_element(:css, locator)
    elsif element_displayed(:link =>locator) 
      return @driver.find_element(:link, locator)
    elsif element_displayed(:link_text =>locator)
      return @driver.find_element(:link_text, locator)
    elsif element_displayed(:class =>locator) 
      return @driver.find_element(:class, locator)
    elsif element_displayed(:class_name =>locator) 
      return @driver.find_element(:class_name, locator)
    elsif element_displayed(:partial_link_text =>locator) 
      return @driver.find_element(:partial_link_text, locator)
    elsif element_displayed(:href =>locator) 
      return @driver.find_element(:href, locator)
    elsif element_displayed(:tag_name =>locator)
      return @driver.find_element(:tag_name, locator)
    end
  end #element_finder

  def wait_element(locator)
    result = sleep_refresh_until_element_present("sleep", locator)
    puts "wait_element_result:#{result}" if result != true
    if result != true
      return result
    else
      wait = Selenium::WebDriver::Wait.new(:timeout => 0.5)
      input = element_finder(locator)
      input = wait.until {
                            element_finder(locator)
                          }
      return input
      #return element_finder(locator)
    end
  end #wait_element
  
  def click(locator)
    # begin
      wait_element(locator).click
    # rescue Selenium::WebDriver::Error::ElementClickInterceptedError, Selenium::WebDriver::Error::StaleElementReferenceError
    #   puts "NagRescue sa click: #{locator}"
    #   sleep 2
    #   wait_element(locator).click
    # end
  end

  def click_hold(locator)
    button = wait_element(locator)
    @driver.action.click_and_hold(button).perform
    sleep(3)
    @driver.action.release.perform
  end

  def click_enter()
    sleep 1
    @driver.action.send_keys(:return).perform
  end
  
  def type(locator,value)
    input = wait_element(locator)
    input.clear
    input.send_keys(value)
  end

  def type_enter(locator,value)
    input = wait_element(locator)
    input.clear
    input.send_keys(value)
    sleep 1
    @driver.action.send_keys(input, :return).perform
  end

  def perform_tab(locator)
    input = wait_element(locator)
    @driver.action.send_keys(input, :tab).perform
  end

  def shift_tab(locator)
    input = wait_element(locator)
    @driver.action.send_keys(input, :shift).send_keys(input, :tab).perform
  end

  def type_click_choice(locator_type, value)
    input = wait_element(locator_type)
    input.click
    @driver.action.key_down(:control).send_keys(input, "a").send_keys(:backspace).key_up(:control).send_keys(input, value).perform
    sleep 0.5
    list_count = get_xpath_count(Locators.common_locator[:dropdown_selection_list2])
    #puts "list_count:#{list_count}"
    list_count.times do |x|
      list_item = get_text(Locators.common_locator(:row_count => x+1)[:dropdown_item2])
      if list_item == value
        click Locators.common_locator(:row_count => x+1)[:dropdown_item2]
      end

      if (list_count == (x+1)) && !(list_item == value)
        list_items = get_text(Locators.common_locator[:dropdown_selection_list2])
        raise "Option #{value} not found on list_items:#{list_items}"
      end
    end
  end  

  def type_highlight(locator,value)
    input = wait_element(locator)
    input.click
    @driver.action.key_down(:control).click(input).send_keys("a").key_up(:control).perform #for windows only
    # @driver.action.key_down(input, :shift).send_keys(input, "a").send_keys(input, :backspace).key_up(:shift).perform #for MAC ONLY
    input.send_keys(value)
  end

  def type_highlight_tab(locator,value)
    input = wait_element(locator)
    # @driver.action.key_down(:control).click(input).send_keys("a").key_up(:control).perform #for windows only
    input.click
    @driver.action.key_down(:control).send_keys(input, "a").send_keys(:backspace).key_up(:control).send_keys(input, value).send_keys(input,:tab).perform #for WINDOWS ONLY
    # input.send_keys(value)
    @driver.action.send_keys(input,:tab).perform
  end

  def type_highlight_enter(locator,value)
    input = wait_element(locator)
    # @driver.action.key_down(:control).click(input).send_keys("a").key_up(:control).perform #for windows only
    #input.click
    @driver.action.key_down(:control).send_keys(input, "a").send_keys(:backspace).key_up(:control).send_keys(input, value).perform #for WINDOWS ONLY
    #binding.pry /html/body/div[5]/div/div/div/div[1]/div/div[1]/div[2]/div[1]/div
    #input.send_keys(value) //*[@id="dx-744d166c-1627-3c75-d67a-ef4ba534489e"]/div[1]/div/div[1]/div[2]
    @driver.action.send_keys(input, :return).perform
  end

  def type_tab(locator,value)
    input = wait_element(locator)
    input.clear
    sleep 0.1
    input.send_keys(value)
    sleep 0.1
    @driver.action.send_keys(input,:tab).perform
  end

  def type_remove_readonly(locator,value)
    remove_readonly_attribute(locator)
    type(locator,value)
  end

  def select_option(locator,value)
    selected = wait_element(locator)
    options = selected.find_elements(:tag_name => "*")
    options_count = options.count
    all_options = []
    x = 0
    options.each do |el|
      all_options.append(el.text)
      if (el.text == "#{value}")
        el.click
        sleep 1
        break
      end

      if (x+1) == options_count
        puts "Expected Option: '#{value}' is not on the list of available options='#{all_options.join(",")}'"
      end
      x += 1
    end
  end

  def select_option_in_list(locator,value,tagname)
    selected = wait_element(locator)
    options = selected.find_elements(:tag_name => tagname)
    options.each do |el|
      if (el.text == "#{value}")
        el.click
        sleep 1
        break
      end
    end
  end

  def is_element_present(locator)
    begin
      element = wait_element(locator).displayed?
        #if element == true
         #   element_enabled = wait_element(locator).enabled?
    rescue
      element = false
    end
    return element
  end

  def is_element_present_enabled(locator)
    begin
      element = wait_element(locator).displayed?
        if element == true
          element_enabled = wait_element(locator).enabled?
        end   
    rescue
      element = false
    end
    return element_enabled
  end

  def get_text(locator)
    begin
      text = wait_element(locator).text()
    rescue Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::TimeoutError
     # puts "Nag Rescue sa get_text: #{locator}"
      sleep 1
      text = wait_element(locator).text()
    end
    return text
  end

  def count_options(locator)
    selected = wait_element(locator)
    options = selected.find_elements(:tag_name => "option").count
    return options
  end

  def mouse_hover_element(locator)
    @driver.action.move_to(wait_element(locator)).perform
    sleep 1.5
  end

  def get_element_attribute(locator,attribute)
    value = wait_element(locator).attribute("#{attribute}")
    return value
  end

  # def get_element_attribute_not_displayed(options={})
  #   element = webdriver_element(options)
  #   value = element.attribute(options[:attribute])
  #   return value
  # end

  def is_element_enabled(locator)
    wait_element(locator).enabled?
  end

  def get_selected_option(locator)
    element = wait_element(locator)
    labels = element.find_elements(:tag_name => "option")
    labels.each do |el|
      if el.selected?
        return el.text
        break
      end
    end
  end

  def get_selected_default_option(locator)
    dropdownmenu = wait_element(locator)
    option = Selenium::WebDriver::Support::Select.new(dropdownmenu)
    option.select_by(locator[:text])
  end

	def get_options(locator) # use get_text if not working
    dropdown_option = wait_element(locator)
    dropdown_option.each do |action|
      return action.text()
    end
  end

  def wait_until(condition)
    wait = Selenium::WebDriver::Wait.new(:timeout => 50).until {condition}
    return wait
  end
  
  def is_element_selected(locator)
    wait_element(locator).selected?
  end

  def is_checkbox_checked(locator)
    check_status = get_element_attribute(locator,"checked")
    if check_status == "true"
      return true
    else
      return false
    end
  end  

  def click_checkbox(locator)
    check = wait_element(locator).attribute("checked") #false
    if(check)
      check.click
    end
    check.attribute("checked") #true
  end

  def remove_readonly_attribute(locator)
    element = wait_element(locator)
    @driver.execute_script('arguments[0].removeAttribute("readonly");', element)
  end

  def is_element_editable(locator)
    editable = true
    input = wait_element(locator)
    begin
      attribute = input.attribute("readonly")
      editable = false if (attribute== "readonly" || attribute== ""||attribute == "true")
      return editable
    rescue
      return true
    end
  end

  def set_element_attribute(locator,attribute,value)
    attribute_locator = wait_element(locator)
    script = "return arguments[0].#{attribute} = '#{value}'"
    @driver.execute_script(script, attribute_locator)
    # @driver.execute_script("arguments[0].setAttribute('#{attribute}', '#{value}');",[attribute_locator])
  end

  def scroll_to_element(element)
    elem = wait_element(element)
    @driver.execute_script("arguments[0].scrollIntoView();",elem)
  end

  def scroll_to_top_page
    @driver.execute_script("window.scrollTo(0,0)")
    sleep 1
  end  
  
  def scroll_to_end_page
    @driver.action.key_down(:page_down).perform
    sleep 0.5
  end 

  def is_text_present(text)
    @driver.page_source.include?text
  end

  def open_url(url)
    wd_open = @driver.get(url)
    return wd_open
  end

  def navigate_to_url(url)
    @driver.navigate().to(url)
    pageurl = get_page_url
    if pageurl == url
      return true
    else
      return pageurl
    end
  end

  def get_element_value(selector)
    return get_element_attribute(selector,"value")
  end
    
  def get_value_byid(selector)
    value = @driver.execute_script("var val = document.getElementById('#{selector}').value; return val;")
    return value
  end

  def get_value_byname(selector)
    value = @driver.execute_script("var val = document.getElementsByName('#{selector}')[0].value; return val;")
    return value
  end

  def get_value_xpath(selector)
    value = @driver.execute_script("var val = document.evaluate(#{selector}, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;; return val;")
    return value
  end

  def get_xpath_count(xpath)
    element = wait_element(xpath)
    element.find_elements(:xpath => "*").size
  end

  def get_xpath_count_of(xpath,div)
    element = wait_element(xpath)
    element.find_elements(:xpath => "#{div}").size
  end

  def get_css_count(css)
    @driver.find_elements(:css,css).size
  end

  def get_alert
    begin
      alert = @driver.switch_to.alert
      alert_value = alert.text()
      alert.accept
      return alert_value
    rescue
      alert = false
    end
  end

  def get_confirmation(options = {})
    x = 0
    begin
      confirmation = @driver.switch_to.alert
      sleep 0.5
      confirmation_value = confirmation.text()
     # puts "confirmation_value:#{confirmation_value}"
      if options[:cancel]
        confirmation.dismiss
      else
       # puts "accept confirmation"
        confirmation.accept
        return confirmation_value
      end
    rescue
      retry
      x = x + 1
      sleep 0.5
      if x == 10
        return "No Confirmation Pop-up found!!"
      end  
    end
  end

  def is_alert_confirmation_present
    begin
      a_c = wait_until(@driver.switch_to.alert)
      if a_c
        return true
      end
    rescue
      false
    end
  end

  def screenshot(options={})
    $i = Time.now.strftime('%Y%m%d%H%M%S')
    @driver.save_screenshot("target/#{ENV['envi_name']}/#{Time.new.strftime("%m-%d-%Y")}/'#{options[:when]}' #{$i}.png")
    # $i += 1
  end

  def get_page_title
    return @driver.title()
  end

  def execute_event_change(input)
    if wd_is_element_present :id => input
      script = "document.getElementById('#{input}').dispatchEvent(new Event('change'))"
    else
      script = "document.getElementsByName('#{input}')[0].dispatchEvent(new Event('change'))"
    end
    @driver.execute_script(script)
  end

  def execute_event_blur(input)
    if wd_is_element_present :id => input
      script = "document.getElementById('#{input}').dispatchEvent(new Event('blur'))"
    else
      script = "document.getElementsByName('#{input}')[0].dispatchEvent(new Event('blur'))"
    end
    @driver.execute_script(script)
  end

  def execute_event_type(input,event_type)
    if wd_is_element_present :id => input
      script = "document.getElementById('#{input}').dispatchEvent(new Event('#{event_type}'))"
    else
      script = "document.getElementsByName('#{input}')[0].dispatchEvent(new Event('#{event_type}'))"
    end
    @driver.execute_script(script)
  end

  def set_attribute(locator,attribute,v)
    if wd_is_element_present(:id => locator)
      attribute_value = @driver.find_element(:id=> locator)
    else
      attribute_value = @driver.find_element(:name=> locator)
    end
    script = "return arguments[0].#{attribute} = '#{v}'"
    @driver.execute_script(script, attribute_value)
  end

  def verify_text_in_pdf(text)
    reader = PDF::Reader.new(filename)
    reader.pages.each do |page|
      spec_text = page.text
      visible_text = spec_text.scan(/#{text}/)
      if visible_text
        return true
      else
        return false
      end
    end
  end

  def get_tagname_text(options={})
    select =  wd_element(options)
    span = select.find_elements(:tag_name=>"span").text()
    return span
  end

  def focus_to_window(index)
    @driver.switch_to.window(@driver.window_handles[index])
  end

  def select_window(title)
    index = get_window_index_count(title)
    handles = @driver.window_handles
    handles.each do |windows|
      windows = wd_get_title
      if windows.include?title
        @driver.switch_to.window(@driver.window_handles[index]) #for switching windows
      end
    end
    @driver.switch_to.window(@driver.window_handles[index])
  end

  def get_window_index_count(title)
    window_count = @driver.window_handles.count
    handles = @driver.window_handles
    index = window_count - 1
    handles.each do |windows|
      @driver.switch_to.window(@driver.window_handles[index])
      windows = wd_get_title
      if windows.include?title
        @driver.switch_to.window(@driver.window_handles[index])
        return index
        break
      end #windows.include?title
        index -= 1
    end
        return index
  end #get_window_index_count

  def get_page_url
    return @driver.current_url()
  end

  def refresh_page(wait,options={})
    # sleep wait
    @driver.navigate().refresh()
    sleep wait
    if options[:check_element]
      sleep_refresh_until_element_present("refresh_page",options[:check_element])
    end  
  end

  def element_present(locator)
    begin
      element = element_finder(locator).displayed?
    rescue
      element = false
    end
    return element
  end

  def elem_wait(mode,locator)
    sleep 0.7
    counter = 75
    counter.times do |x|
      if element_present(locator)
        break
      else
        if mode == "refresh_page"
          refresh_page(4)
        elsif mode == "sleep"
          sleep 1.5
        end #mode == "refresh_page"
        wait_for_page_loader_to_disappear
        
        if (x == (counter*0.20).to_i) || (x == (counter*0.5).to_i) || (x == (counter*0.70).to_i) || (x == (counter*0.90).to_i) ## FOR DEBUGGING OF ELEMENT
          puts "elem_finder_loop_count:#{x}\nUnable to locate this element: #{locator}"
          if (x == (counter*0.20).to_i)
            puts "#{locator}:#{element_present(locator)}"
            puts "src:#{element_present Locators.common_locator[:page_loader_src]}"
            puts "xpath:#{element_present Locators.common_locator[:page_loader_xpath]}"
            puts "pageloading:#{element_present Locators.common_locator[:page_loading]}"
            if (element_present Locators.common_locator[:page_loader_src]) || (element_present Locators.common_locator[:page_loading])
              raise "Page Loader gif is still visible"
            end
            puts "Taking a screenshot now..."
            screenshot(:when => "ELEM-") 
            break
          end
        end

        if (element_present Locators.common_locator[:error_class]) #|| (element_present Locators.common_locator[:webservice_timeout])
          page_url = get_page_url
          errmsg1 = get_text Locators.common_locator[:error_class] if element_present Locators.common_locator[:error_class]
          errmsg2 = get_text Locators.common_locator[:flash_message] if element_present Locators.common_locator[:flash_message]
          puts "#{page_url}-ErrorMsg:#{errmsg1}\n#{page_url}-ErrorMsg:#{errmsg2}"
        end
        # ## Handling if Page is Inaccessible
        # if element_present("//*[@class='errormsg']") 
        #   errormsg = get_text("//*[@class='errormsg']")
        #   puts "errormsg_in_sleep_refresh_until_element_present:#{errormsg}"
        #   if errormsg.include?"Webservice currently unavailable "
        #     page_url = get_page_url
        #     raise "#{page_url}||#{errormsg}"
        #   end
        # end #//*[@class='errormsg']
        
        ## Handling for webservice timeout
        if element_present(Locators.common_locator[:webservice_timeout])
          webservice_timeout = get_text(Locators.common_locator[:webservice_timeout])
          if webservice_timeout.include?"web service timeout:#{page_url}"
            raise "webservice_timeout"
          end
        end

        ## Handling if Page is DOWN
        if element_present("main-frame-error") || element_present("//div[@class='dialog']")
          errormsg = get_text("main-frame-error") if element_present("main-frame-error")
          errormsg = get_text("//div[@class='dialog']") if element_present("//div[@class='dialog']")
          puts "main-frame-error_errormsg:#{errormsg}||#{(errormsg.include?"This page isn’t working")}||#{(errormsg.include?"took too long to respond.")}"
          if (errormsg.include?"This page isn’t working") || (errormsg.include?"This site can't be reached") || (errormsg.include?"Your connection was interrupted") || (errormsg.include?"took too long to respond.")
            puts "pumasok sa refresh_page"
            refresh_page(2)
          end
        end #main-frame-error
      end #counter.times
    end #counter.times do
  end #elem_wait

  def sleep_refresh_until_element_present(mode,locator)
    begin
      elem_wait(mode,locator)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::ElementClickInterceptedError
      elem_wait(mode,locator)
    end

    if !(element_present(locator))
      return "Elem '#{locator}' not present"
    else
      return true
    end
  end  #sleep_refresh_until_element_present

  def sleep_refresh_until_get_text_true(mode,locator,text)
    sleep 0.5
    
    counter = 100
    # puts "get_text_true:#{counter}||mode:#{mode}"
    counter.times do |x|
      comparison = get_text(locator)
      if comparison.include?"#{text}"
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #mode == "refresh_page"

        if (x == (counter*0.20).to_i) || (x == (counter*0.5).to_i) || (x == (counter*0.70).to_i) || (x == (counter*0.90).to_i) ## FOR DEBUGGING OF ELEMENT
          puts "comparison:#{comparison} != text:#{text}"
          # break
          if (x == (counter*0.90).to_i)
            
            raise "element '#{locator}' not found!!!"
          end
        end
      end
    end
  end  #sleep_until

  def sleep_refresh_until_element_is_not_present(mode,locator)
    sleep 0.1
    
    counter = 200
    counter.times do |x|
      if !(element_present(locator))
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 0.50
        end #mode == "refresh_page"
        if (x == (counter*0.20).to_i) || (x == (counter*0.5).to_i) || (x == (counter*0.70).to_i) || (x == (counter*0.90).to_i) ## FOR DEBUGGING OF ELEMENT
          puts "#{x}=#{locator}||#{element_present locator}"
        end
        # puts "locator:#{locator}" if (locator == Locators.common_locator[:page_loader_src])
        # puts "locator2:#{locator}" if (locator == Locators.common_locator[:page_loader_xpath])
        # puts "locator3:#{locator}" if (locator == Locators.common_locator[:page_loading])
        # puts "locator4:#{locator}" if (locator == Locators.common_locator[:page_loader_class])
        if (x+1) == counter
          #binding.pry
          raise "Elem is still present:#{locator}"
        end
      end
    end
  end  #sleep_until

  def sleep_refresh_until_xpath_count_true(mode,locator,count)
    sleep 0.5
    300.times do |x|
      total_count = get_xpath_count(locator)
      if total_count.to_i == count.to_i
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #mode == "refresh_page"
      end
    end
  end  #sleep_refresh_until_xpath_count_true

  def sleep_refresh_until_element_attribute_true(mode,locator,attribute,value)
    300.times do |x|
      elem_attribute = get_element_attribute(locator,attribute)
      if elem_attribute == attribute
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #mode == "refresh_page"
      end
    end
  end  #sleep_refresh_until_element_attribute_true

  def convert(x)
    Float(x)
    i, f = x.to_i, x.to_f
    i == f ? i : f
    return x
  end
  
  def encrypt(input_string)
    Base64.encode64(input_string)
  end

  def decrypt(encrypted_string)
    Base64.decode64(encrypted_string)
  end

  def type_key_down_tab(locator,value)
    input = wait_element(locator)
    input.clear
    @driver.action.send_keys(input,value).send_keys(input,:arrow_down).send_keys(input,:tab).perform
  end

  def wd_get_title
    return @driver.title()
  end
  
  def press_escape(locator)
    input = wait_element(locator)
    @driver.action.send_keys(input,:escape).perform
  end

  def sleep_refresh_until_get_text_not_true(mode,locator,text)
    500.times do
      comparison = get_text(locator)
      if !(comparison.include?text)
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #
      end #500.times do
    end
  end  #sleep_refresh_until_get_text_not_true
  
  def double_click(locator)
    input = wait_element(locator) 
    sleep 1
    @driver.action.double_click(input).perform
  end

  def is_number(object)
    true if Float(object) rescue false
  end
  
  def sleep_refresh_until_text_is_present(mode,text)
    300.times do
      page = @driver.page_source
      if page.include?"#{text}"
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #mode == "refresh_page"
      end #page.include?"#{text}"
    end
  end  #sleep_refresh_until_text_is_present

  def is_element_label_bold(locator)
    web_element = @driver.find_element(:xpath, locator)
    if (web_element.style('font-weight')).to_i >= 700
      return true
    else
      return false
    end
  end

  # def upload_file(options={})
  #   element = webdriver_element(options)
  #   element.send_keys(options[:file_location])
  # end

  # def element_status(locator)  #return false if no element is found
  #   webdriver_element(options) rescue false
  # end

  def back_to_previous_page
    @driver.navigate().back()
  end

  def switch_frame(locator)
    elem = wait_element(locator)
    @driver.switch_to.frame(elem)
  end

  def switch_to_parent_frame
    @driver.switch_to.default_content
  end

  def is_integer(value)
    begin
      Integer(value)
      return true
    rescue
      return false
    end
  end

  def type_click_include(locator_type, value, locator_click)
    wait_element(locator_type).send_keys(value)
    sleep 0.5
    selection = (get_text locator_click).downcase
    if is_integer(value) ## to check if value is integer since integer cannot be .downcased
      value_a = value
    else
      value_a = value.downcase
    end
    y = 0
    puts "#{selection.to_s.include?value_a.to_s}||selection:#{selection}||value_a:#{value_a}"
    if selection.to_s.include?value_a.to_s
      wait_element(locator_click).click
    else
      return "value not found on list"
    end #selection == value   
  end  

  def open_new_tab(options={})
    first_window = @driver.window_handles.first
    @driver.execute_script("window.open()")
    second_window = @driver.window_handles.last
    @driver.switch_to.window(second_window)
    navigate_to_url(options[:url])

    page_url_after = get_page_url
    url = options[:url]
    url = "#{ENV["URL"]}/dashboard/show/samsmoketestdashboard" if options[:url].include?"#{ENV["URL"]}/dashboard/?dashid="
    if page_url_after.include?url
      return true
    else
      return page_url_after
    end
  end

  def close_new_tab(options={})
    url = get_page_url
    if url == options[:url]
      @driver.close
    else
      find_and_switch_to_tab(:url => options[:url])
      @driver.close
    end
    sleep 1
    
    return find_and_switch_to_tab(:url => options[:prev_url])
  end

  def find_and_switch_to_tab(options={})
    open_tabs = @driver.window_handles
    open_tabs.count.times do |x|
      @driver.switch_to.window(open_tabs[x])
      if options[:url]
        page_url = get_page_url
        if page_url.include?options[:url]
          puts "FOUND THE RIGHT WINDOW"
          break
        end
      elsif options[:page_title]
        page_title = get_page_title
        if page_title == options[:page_title]
          puts "FOUND THE RIGHT WINDOW"
          break
        end
      elsif options[:unique_value]
        if (is_text_present("#{options[:unique_value]}"))
          puts "FOUND THE RIGHT WINDOW"
          break
        end
      end
    end

    if options[:url]
      page_url_after = get_page_url
      url = options[:url]
      url = "#{ENV["URL"]}/dashboard/show/samsmoketestdashboard" if options[:url].include?"#{ENV["URL"]}/dashboard/?dashid="
      if page_url_after.include?url
        return true
      else
        binding.pry
        return "page_url_after:#{page_url_after}||expected_url:#{url}"
      end
    elsif options[:page_title]
      page_title_after = get_page_title
      if page_title_after == options[:page_title]
        return true
      else
        return "page_title_after:#{page_title_after}"
      end
    elsif options[:unique_value]
      if (is_text_present("#{options[:unique_value]}"))
        return true 
      else
        return "Cant find window with value #{options[:unique_value]}"
      end
    end

  end #find_and_switch_to_tab

  def is_datetime(date_time_string)
    begin
      DateTime.parse(date_time_string)
      return true
    rescue ArgumentError
      return false
    end
  end #is_datetime

  def type_select_choice(type_locator,value,select_locator,value_select)### PARA TO SA PESTENG DROPDOWN NG DESTINATION NG IMPORT DEF DAHIL NAPAKA INCONSISTENT NG MGA DEV ../.. by SAM :D
    type type_locator, value
    selected = wait_element(select_locator)
    puts "options.text:#{selected.text}"
    sleep 2
    puts "selected:#{(selected.text.include?"#{value_select}")}"
    if !(selected.text.include?"#{value_select}")
      puts "pumasok sa handling"
      5.times do
        sleep 2
        if (selected.text.include?"#{value_select}")
          puts "value_select:#{(selected.text.include?"#{value_select}")}"
          break
        end
      end
    end
    options = selected.find_elements(:tag_name=> "*")
    options.each do |el|
      # puts "el.text:#{el.text}"
      selections = el.text
      if (selections == "#{value_select}")
        el.click
        sleep 1
        break   
      end
    end
  end

  def node_finder(options={})
      child_node = options[:child_node] || "/tr" #ROW ELEMENT
      additional_node = options[:additional_node] || "/div" #ELEMENT OF THE NODE TO FIND
      # puts "#{options[:table_elem]}"
      # puts "#{element_present options[:table_elem]}"
      table_count = get_xpath_count(options[:table_elem]).to_i ## TABLE ELEM SHOULD BE IN XPATH FORMAT
      # puts "table_count:#{table_count}"
      table_count.times do |x|
          elem_row = "#{options[:table_elem]}" + "#{child_node}[#{x + 1}]"
          # puts "elem_row:#{elem_row}"
          row_name = get_text(elem_row)
          # puts "row_name:#{row_name}||#{options[:node_label]}\nnode_label:#{row_name.include?"#{options[:node_label]}"}"
          if row_name.include?"#{options[:node_label]}"
              checkbox_node = elem_row + "#{additional_node}"
              # puts "checkbox_node:#{checkbox_node}"
              if element_present checkbox_node
                return checkbox_node
              else
                return "Element: #{element_present checkbox_node}"
              end
          end #row_name.include?"#{options[:node_label]}"
      end #table_count.times do |x|
  end #node_finder

  def is_array(var)
    is_it = var.is_a?(Array)
    return is_it
  end
  
  def sleep_refresh_until_file_exist(mode,file_path)
    500.times do |x|
      file_exist = File.file?(file_path.to_s)
      if file_exist
        puts "file_exist#{x}:#{file_exist}"
        break
      else
        if mode == "refresh_page"
          refresh_page(2)
          sleep 1
        elsif mode == "sleep"
          sleep 1.5
        end #
      end #500.times do
    end
  end  #sleep_refresh_until_get_text_not_true

  def is_element_disabled(locator)
    wait_element(locator).disabled?
    disabled = wait_element(locator).disabled?# get_element_attribute(locator,"disabled")
    puts "disabled:#{disabled}"
    if disabled == true
      return true
    else
      return "Element Disabled"
    end
  end #is_element_disabled

  def get_week_of_day_in_month(options={})
    date = Date.new(options[:year].to_i,options[:month].to_i,options[:day].to_i)
    days = options[:day].to_i
    day_str_int = date.strftime("%a")
    #day_minus =
    w = 1
    days.times do |y|
      date = date - 1
      day_minus_str = date.strftime("%a")
      month = date.strftime("%m")
      break if (month.to_i != options[:month].to_i)
      puts "date:#{date}" if (day_minus_str == day_str_int)
      w += 1 if (day_minus_str == day_str_int)
      puts "w:#{w}" if (day_minus_str == day_str_int)
    end

    # w = date.week_of_month #week_of_month_in_eng
    # puts "week_of_month:#{w}"
    # puts "(#{options[:day].to_i} - 3)"
    # date_minus = date - (options[:day].to_i - 3)
    # puts "date_minus:#{date_minus}"
    # day_minus_str = date_minus.strftime("%a")
    # puts "day_minus_str:#{day_minus_str} != day_str_int:#{day_str_int}"
    # if day_minus_str != day_str_int
    #   puts "PUMASOK SA HANDLING NG DAYS"
    #   31.times do |g|
    #     date_minus = date_minus - 1
    #     day_minus_str = date_minus.strftime("%a")
    #     puts "#{day_minus_str} == #{day_str_int}" if day_minus_str == day_str_int
    #     break if day_minus_str == day_str_int
    #     if g == 30
    #       raise "Day is not set"
    #     end
    #   end
    # end
    # date_minus_month = date_minus.strftime("%m")
    # puts "date_minus_month:#{date_minus_month}||options[:month]:#{options[:month]}"
    
    # if date_minus_month.to_i < options[:month].to_i
    #   w = w - 1
    # end

    if w == 1
      w = "1st"
    elsif w == 2
      w = "2nd"
    elsif w == 3
      w = "3rd"
    elsif w == 4
      w = "4th"
    elsif w == 5
      w = "last"
    end
    return w
  end

  def press_arrowkey_down_until_element_present(locator)
    1000.times do |x|
      if element_present locator
        break
      else
        @driver.action.send_keys(:arrow_down).perform
      end

      if x == 999
        raise "Element #{locator} not found"
      end
    end
  end
  
  def wait_for_page_loader_to_disappear
    assertion = true
    value_false = []
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loader_src])
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loader_xpath])
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loading])
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loader_class])
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loading2_xpath])
    sleep_refresh_until_element_is_not_present("sleep",Locators.common_locator[:page_loading2_class])
    value_false.append("Page Loader #{Locators.common_locator[:page_loader_src]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loader_src])
    value_false.append("Page Loader #{Locators.common_locator[:page_loader_xpath]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loader_xpath])
    value_false.append("Page Loader #{Locators.common_locator[:page_loading]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loading])
    value_false.append("Page Loader #{Locators.common_locator[:page_loader_class]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loader_class])
    value_false.append("Page Loader #{Locators.common_locator[:page_loading2_xpath]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loading2_xpath])
    value_false.append("Page Loader #{Locators.common_locator[:page_loading2_class]} is STILL PRESENT!!") if (element_present Locators.common_locator[:page_loading2_class])
    value_false.append("Page Loader #{Locators.common_locator[:a_page_loader]} is STILL PRESENT!!") if (element_present Locators.common_locator[:a_page_loader])
    value_false.append("Page Loader #{Locators.common_locator[:i_page_loader]} is STILL PRESENT!!") if (element_present Locators.common_locator[:i_page_loader])

    if value_false != []
      #binding.pry
      return value_false.join(",")
    else
      return assertion
    end
  end #wait_for_page_loader_to_disappear

  def select_option_dropdown(options={})
    click Locators.common_locator(:column_no => options[:column_no])[:dropdown_button]
    sleep 0.2
    list_count = get_xpath_count(Locators.common_locator[:dropdown_selection_list])
    puts "list_count:#{list_count}"
    list_elem = wait_element(Locators.common_locator[:dropdown_selection_list])
    list_count.times do |x|
      @driver.action.send_keys(:arrow_down).perform
      elem = list_elem.find_element(:xpath, Locators.common_locator(:row_count => x+1)[:dropdown_item])
      item = elem.text
      if item == options[:item]
        puts "item#{x}:#{item}||options[:item]:#{options[:item]}"
        click Locators.common_locator(:row_count => x+1)[:dropdown_item]
        break
      end #item == options[:item]

      if (x+1 == list_count) && !(item == options[:item])
        #binding.pry
        raise "Dropdown Option:'#{options[:item]}' NOT FOUND!!"
      end
    end #list_count.times do |x|
  end #select_option_dropdown
  
  def select_option_dropdown_modal(elem_dropdown,value)
    click elem_dropdown
    @driver.action.send_keys(:arrow_down).perform
    sleep 0.2

    list_elem = wait_element(Locators.common_locator[:dropdown_selection_list_modal])
    
    list_count = get_xpath_count(Locators.common_locator[:dropdown_selection_list_modal])
    #puts "list_count:#{list_count}"
    list_count.times do |x|
      @driver.action.send_keys(:arrow_down).perform
      elem = list_elem.find_element(:xpath, Locators.common_locator(:row_count => x+1)[:dropdown_selection_list_modal_item])
      item = elem.text
      if item == value
        #puts "item#{x}:#{item}||value:#{value}"
        click Locators.common_locator(:row_count => x+1)[:dropdown_selection_list_modal_item]
        break
      end #item == options[:item]

      if (x+1 == list_count) && !(item == value)
        #binding.pry
        raise "Dropdown Value:#{value} NOT FOUND!!||item#{x+1}:#{item}||value:#{value}"
      end
    end #list_count.times do |x|
  end #select_option_dropdown
end
