require_relative "../weblog_info"

RSpec.describe WeblogInfo do
  describe "WeblogInfo.call" do
    it "outputs message when invalid input given" do
      expect { WeblogInfo.new.call }.to output("argument given was not a valid log file\n").to_stdout
    end

    it "outputs correctly formatted data" do
      arg = File.open("spec/fixtures/webserver.log")
      expect { WeblogInfo.new(arg).call }.to_not output("argument given was not a valid log file\n").to_stdout

      expect { WeblogInfo.new(arg).call }.to output(<<~OUTPUT
        List of pages ordered by total views:
        /about/2: 90 views.
        /contact: 89 views.
        /index: 82 views.
        /about: 81 views.
        /help_page/1: 80 views.
        /home: 78 views.
        List of pages ordered by total unique views:
        /index: 24 unique views.
        /home: 24 unique views.
        /contact: 24 unique views.
        /help_page/1: 24 unique views.
        /about/2: 23 unique views.
        /about: 22 unique views.
      OUTPUT
      ).to_stdout
    end
  end
end
