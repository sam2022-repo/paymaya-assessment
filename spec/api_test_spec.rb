
require 'paymaya'
context "> spec" do

    describe 'ASSESSMENT' do
        attr_reader :selenium_driver, :api
        alias :web :selenium_driver
        alias :api :api

        before :all do
            #UI INITIALIZATION
            @selenium_driver = WEB.new #open browser instance
            @api = API.new #open browser instance
            @username = ENV['USER1']
        end

        after :all do
            #quit browser
            #web.quit_current_browser_session
        end

        it "TC1: Verify GET Users request" do
            ## GET ALL USERS
            result = api.get_api_call(:endpoint => "/posts")
            expect(result).not_to be == nil
            expect(result).not_to be == []
            expect(result).not_to be == ""
            $result_count = result.count
            $last_userid = result[($result_count -1)]["userId"]
            $result_count.times do |x|
                expect(result[x]).not_to be == [] ##CHECKING FOR NOT AN EMPTY ARRAY
                expect(result[x]).not_to be == {} ##CHECKING FOR NOT AN EMPTY JSON
                expect(result[x]["userId"]).not_to be == nil ##CHECKING FOR NOT NULL
                expect(result[x]["userId"]).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
                expect(web.is_integer(result[x]["userId"].to_i)).to be == true
                expect(result[x]["title"]).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
                expect(result[x]["title"]).not_to be == nil ##CHECKING FOR NOT NULL
                expect(result[x]["body"]).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
                expect(result[x]["body"]).not_to be == nil ##CHECKING FOR NOT NULL
            end 
            #puts "#{JSON.pretty_generate(result)}"
        end

        it "TC2: Verify GET User request by Id" do
            user_id = ENV["USER_ID"] || 1
            @expected_params = {
                                  "userId" => 1,
                                  "id" => 1,
                                  "title" => "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                                  "body" => "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
                                }
            ## GET ALL USERS
            result = api.get_api_call(:endpoint => "/posts/#{user_id}")
            expect(result).not_to be == nil ##CHECKING FOR NOT NULL
            expect(result).not_to be == [] ##CHECKING FOR NOT AN EMPTY ARRAY
            expect(result).not_to be == {} ##CHECKING FOR NOT AN EMPTY JSON
            expect(result).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
            expect(result.select {|k,v| @expected_params.keys.include?(k)}).to eql(@expected_params)
            expect(result["title"]).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
            expect(result["body"]).not_to be == "" ##CHECKING FOR NOT AN EMPTY STRING
            expect(result["id"]).not_to be == "" ##CHECKING FOR NOT A STRING
            expect(result["userId"]).not_to be == "" ##CHECKING FOR NOT A STRING
        end

        it "TC3: Verify POST Users request" do
            ### TEST DATA GENERATION
            $fname = TestData.generate_data[:firstname]
            $lname = TestData.generate_data[:lastname]
            $full_name = "#{$fname} #{$lname}"
            #puts "$full_name:#{$full_name}"
            $username = "#{$fname.downcase}_#{$lname.downcase}#{rand(0..99999)}"
            $email = $username + "@huli_ka.com"

            $next_id = $result_count + 1
            $next_userid = $last_userid + 1
            @payload = {
                        userId: $next_userid,
                        id: $next_id,
                        name: $full_name,
                        title: $username,
                        body: $email
                        }
            @expected_params = {
                        "id" => $next_id
                        }
            result = api.post_api_call({:endpoint => "/posts"}, @payload)
            ### NEGATIVE CHECK FOR POST RESPONSE ###
            expect(result.include?"Unable to access api server successfully.").not_to be == true
            ### CHECK FOR THE ACTUAL RESPONSE OF POST ###
            expect(result.select {|k,v| @expected_params.keys.include?(k)}).to eql(@expected_params)
          
        end

    end #describe
end #context
