#First step: Require Nokogiri and Open URI
require 'open-uri'
require 'nokogiri'
require 'pry'

#Responsible for scraping the index page that lists all of the students:
#URL: https://learn-co-curriculum.github.io/student-scraper-test-page/index.html
#Use Nokogiri and URI
#Use Element Inspector
class Scraper
def self.scrape_index_page(index_url)
students = []   #Return an array of Hashes, each hash represents a single student

#Nokogiri::HTML method to take the string of HTML returned by open-URI's open method and convert into nested nodes:
page = Nokogiri::HTML(open(index_url))

#Call .css on page and give it the argument of our css selector and iterate over each student:
page.css("div.student-card").each do |student|

name = student.css(".student-name").text
location = student.css(".student-location").text
profile_url = student.css("a").attribute("href").value
student_info = {:name => name,
                :location => location,
                :profile_url => profile_url}
#add the student info to the student hash:
students << student_info
end
#return the student hash:
students
end

#responsible for scraping an individual student's profile page to further get info about that student:
#Class method that should use Nokogiri and URI
#Returns a hash that describes individual students: Twitter URL, Linkedin URL, Github URL, blob URL, profile quote, bio

def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    student_profiles = {}

    social_link = doc.css(".vitals-container .social-icon-container a")

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

    student_profiles[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    student_profiles[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

    student_profiles
  end
end
