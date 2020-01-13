###########################################################################################################################
#
#  Name:        Timbre Freeman
#  Assignment:  Text Search Regular Expressions Assignment
#  Date:        01/08/2020
#  Class:       CIS 283
#  Description: Write a program that will search through a data file using regular expressions. Using Enrollment.txt file.
#
###########################################################################################################################

file_name = "Enrollment.txt"
$run_program = true
$debug = true

# open the Enrollment File
# check if the file exists
if (File.exists?(file_name))
  if (File.readable?(file_name))
    enrollment_file = File.open(file_name, "r")
  else
    puts "#{file_name} is not readable -- exiting program"
  end
else
  puts "#{file_name} dose not exists -- exiting program"
  $run_program = false
end
# Loop
while $run_program == true
  # Ask the User for the class they are looking for
  input_works = false
  while !input_works
    print "Enter Department abbreviation: "
    department_abbreviation = gets.chomp
    puts ""
    print "Enter Class Number: "
    class_number = gets.chomp.to_i
    puts ""
    # need to add a check for the input
    if (department_abbreviation =~ /\A[A-Z]{2,4}\z/)
      input_works = true
    else
      puts "Department Abbreviation is All Caps and 2 to 4 letters"
    end
  end
  # if the User enter EXIT than close the program
  if (department_abbreviation == "EXIT")
    $run_program == false
    break
  end
  # ***Search the text for the class***
  # go to the beginning of the file
  enrollment_file.pos = 0
  class_location_in_file = Array.new
  # go over the whole file
  while !enrollment_file.eof?
    file_line = Array.new
    file_line[0] = enrollment_file.readline
    file_line_number = enrollment_file.lineno
    # ***Print the findings***
    if file_line[0] =~ /\s#{department_abbreviation}\s+#{class_number}\s/
      class_location_in_file.push(file_line_number)
      puts file_line[0]
      enrollment_file.lineno = file_line_number+1
      file_line[1] = enrollment_file.readline
      if !(file_line[1] =~ /\s[A-Z]{2,3}\s+\d{2,3}\s/)
        puts file_line[1]
      end
    end
    enrollment_file.lineno = file_line_number
  end
# end of Loop and say goodbye
end
enrollment_file.close
puts ""
puts "GoodBye"