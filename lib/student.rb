#Will use the information returned by the above scraper methods
class Student

attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

@@all = []

#Metaprogramming
#Use the send method
#Add newly created student to Student Class @@all array of students
#push self into array
def initialize(student_hash)
  self.send("name=", student_hash[:name])
  self.send("location=", student_hash[:location])
  self.send("profile_url=", student_hash[:profile_url])
  @@all << self
end

#Take in an array of hashes. Self = student
#Student.create will return the value of Scraper.scrape index
#Method should iterate over the array of hashes
def self.create_from_collection(students_array)
students_array.each do |student_hash|
Student.new(student_hash)
end
end
#Student.add student will return value of  scraper.scrape profile page as the argument
#Use meta programming
#Use send method
def add_student_attributes(attributes_hash)
self.send("twitter=", attributes_hash[:twitter])
self.send("linkedin=", attributes_hash[:linkedin])
self.send("github=", attributes_hash[:github])
self.send("blog=", attributes_hash[:blog])
self.send("profile_quote=", attributes_hash[:profile_quote])
self.send("bio=", attributes_hash[:bio])
self.send("profile_url=", attributes_hash[:profile_url])
end


#Class method that should return the contents of the @@all array
def self.all
@@all
  end
end
