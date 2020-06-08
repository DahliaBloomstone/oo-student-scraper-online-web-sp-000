#First step: Require Nokogiri and Open URI
require 'open-uri'
require 'nokogiri'
require 'pry'
#attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url
#Responsible for scraping the index page that lists all of the students:
#URL: https://learn-co-curriculum.github.io/student-scraper-test-page/index.html
#Use Nokogiri and URI
#Use Element Inspector
class Scraper
def self.scrape_index_page(index_url)
students = []   #Return an array of Hashes, each hash represents a single student

#Nokogiri::HTML method to take the string of HTML returned by open-URI's open method and convert into nested nodes:
#Code for grabbing the page itself:
page = Nokogiri::HTML(open(index_url))

#Call .css on page and give it the argument of our css selector and iterate over each student, adding it to the student hash, which we will fill with scraped data:
#page.css("div.student-card") code for grabbing each student on the page:
page.css("div.student-card").each do |student|

#Code for grabbing each student name:
name = student.css(".student-name").text
#Code for grabbing each student location:
location = student.css(".student-location").text
#Code for grabbing each profile URL:
profile_url = student.css("a").attribute("href").value
#Outlines the hash that we want. Student info = name, location, and url. Example below.
#attr_accessors in the student.rb file
student_info = {:name => name,
                :location => location,
                :profile_url => profile_url}
#add the student info to the student hash:
students << student_info
end
#return the student hash:
students
end

#Ex: {:name => "Abby Smith", :location => "Brooklyn, NY", :profile_url => "students/abby-smith.html"},


#Responsible for scraping an individual student's profile page to further get info about that student:
def self.scrape_profile_page(profile_url)

#Use Nokogiri and open URI to access profile page:
html = open(profile_url)
doc = Nokogiri::HTML(html)

##Returns a hash that describes individual students: Twitter URL, Linkedin URL, Github URL, blob URL, profile quote, bio
student_profiles = {}

#Code for grabbing each social link: calling the .css on the document
#Looks like: <div class="vitals-container">
#Looks like: <div class="social-icon-container">...</div>
social_link = doc.css(".vitals-container .social-icon-container a")

#Iterate over each element in the social link:
#Attr_accessors in the student.rb file
#Have to iterate through each element because not everyone has every single social profile like twitter. 
social_link.each do |element|
      if element.attr("href").include?("twitter")
        student_profiles[:twitter] = element.attr('href')
      elsif element.attr("href").include?("linkedin")
        student_profiles[:linkedin] = element.attr("href")
      elsif element.attr("href").include?("github")
        student_profiles[:github] = element.attr("href")
      elsif element.attr("href").include?("com/")
      student_profiles[:blog] = element.attr("href")
      end
    end
#Every student has a profile quote and bio, so does not need to be included in the iteration method.
    student_profiles[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    student_profiles[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

#return the student_profiles hash:
    student_profiles
  end
end


#Example returned info: {
#  :twitter=>"http://twitter.com/flatironschool",
#  :linkedin=>"https://www.linkedin.com/in/flatironschool",
#  :github=>"https://github.com/learn-co",
#  :blog=>"http://flatironschool.com",
#  :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
#  :bio=> "I'm a school"
#                      }
