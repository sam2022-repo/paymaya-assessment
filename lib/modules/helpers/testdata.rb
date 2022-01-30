
module TestData

	def self.generate_data(options = {})
	  firstname = Faker::Name.first_name.gsub("'","")
	  lastname = Faker::Name.last_name.gsub("'","")
	  email = "#{firstname.downcase}_#{lastname.downcase}@brandm8.com"
	  code = Faker::Code.isbn
	  code_entry = "#{Faker::Code.isbn}-#{rand(1000..9999)}"
	  barcode = Faker::Code.isbn
	  # number_data = Faker::Number.number(options[:length])
	  code_data = "#{Faker::Code.isbn}-#{Faker::Code.asin}"
	  ph_mobile_number = "+6391#{rand(6..9)}#{rand(1000000..9999999)}" #follows PH mobile number format
	  # place_name = "#{Faker::Book.title}_#{rand(1000..9999)}-#{rand(1000..9999)}"
	  integration_id = "#{DateTime.now.strftime('%y%d%m%H%M%S%L')}"
	  product_name = "#{Faker::Book.title}_#{rand(1000..999999)}_#{DateTime.now.strftime('%y%d%m%H%M%S%L')}"
	  random_number = "#{DateTime.now.strftime('%y%d%m%H%M%S%L')}"
	  us_mobile_no = "+1#{rand(212..218)}#{rand(2..5)}#{rand(100000..999999)}" ## "+1#{rand(2..5)}#{rand(10..99)}#{rand(2..5)}#{rand(100000..999999)}" ## +1{2-9}**{2-9}****** 
	  
	  {
	    :firstname => firstname,
	    :lastname => lastname,
	    :email => email,
	    :code => code,
	    :barcode => barcode,
	    :code_entry => code_entry,
	    # :number_data => number_data,
	    :code_data => code_data,
	    :ph_mobile_number => ph_mobile_number,
	  	:integration_id => integration_id,
	    :product_name => product_name,
	    :random_number => random_number,
	    :us_mobile_no => us_mobile_no,
	  }

	end

	def self.generate_multiple_data(options={})
		count = options[:count]
		fname = []
		lname = []
	  	email = []
	  	ext_parent_id = []
	  	events_integration_id = []
	  	integration_id = []
	  	mobile_phone = []
	  	card_id = []
	  	campaing_id = []
	  	campaing_version = []
	  	campaing_name = []
	  	event_id = []
		client_queue_id = []

		if options[:firstname] || options[:email]
			count.times do
	  			fname.append(Faker::Name.first_name.gsub("'",""))
	  		end #count.times do
	  	end
	  	
	  	if options[:lastname] || options[:email]
			count.times do
	  			lname.append(Faker::Name.last_name.gsub("'",""))
	  		end #count.times do
	  	end
	  	
	  	if options[:email]
			count.times do |x| 
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			email.append("#{fname[x].downcase}_#{lname[x].downcase}#{datetime}@brandm8loyalty.com")
	  			sleep 0.001 ##so datetime wont be the same
	  		end #count.do |x|
	  	end #options[:email]

	  	if options[:extparentid] || options[:eventsintegrationid]
			count.times do
	  			ext_parent_id.append(rand(100000..999999))
	  		end
	  	end

	  	if options[:eventsintegrationid]
			count.times do |x|
	  			events_integration_id.append("#{rand(100000..999999)}-#{generate_code(4)}-#{ext_parent_id[x]}")
	  		end
	  	end

	  	if options[:integrationid]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			integration_id.append("#{rand(100000..999999)}-#{generate_code(4)}-#{datetime}")
	  			sleep 0.001 ##so datetime wont be the same
	  		end
	  	end

	  	if options[:mobilephone]
			count.times do
	  			mobile_phone.append("+6391#{rand(6..9)}#{rand(1000000..9999999)}")
	  		end
	  	end

	  	if options[:cardid]
			count.times do
	  			card_id.append(Luhnacy.generate(ENV['card_length'].to_i))
	  		end
	  	end

	  	if options[:campaignid]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			campid = datetime
	  			campaing_id.append(campid.to_i)
	  			sleep 0.001
	  		end
	  	end

	  	if options[:campaignversion]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			campaing_version.append(generate_code(10) + "#{datetime}")
	  			sleep 0.001
	  		end
	  	end

	  	if options[:campaignname]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			campaing_name.append("Campaña de Automatización #{datetime}")
	  			sleep 0.001
	  		end
	  	end

	  	if options[:eventid]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			eventid = datetime
	  			event_id.append(eventid.to_i)
	  			sleep 0.001
	  		end
	  	end

	  	if options[:clientqueueid]
	  		count.times do
	  			datetime = DateTime.now.strftime('%y%d%m%H%M%S%L')
	  			clientqueueid = datetime
	  			client_queue_id.append(clientqueueid.to_i)
	  			sleep 0.001
	  		end
	  	end

	  	{
			:firstname => fname,
			:lastname => lname ,
		  	:email => email,
		  	:extparentid => ext_parent_id, 
		  	:eventsintegrationid => events_integration_id,
		  	:integrationid => integration_id,
		  	:mobilephone => mobile_phone,
		  	:cardid => card_id,
		  	:campaignid => campaing_id,
		  	:campaignversion => campaing_version,
		  	:campaignname => campaing_name,
		  	:eventid => event_id,
		  	:clientqueueid => client_queue_id
	  	}
	end

	def self.data_storage(options={})
		roles_test_data = "/csv_files/test_data/roles_list.csv"
		usergroup_test_data = "/csv_files/test_data/usergroups_list.csv"
		{
			:roles_csv_path => roles_test_data,
			:usergroup_csv_path => usergroup_test_data,
		}
	end
end
