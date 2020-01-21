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
$debug = false

# Welcome Screen
puts "       #############################"
puts "       #     Enrollment Search     #"
puts "############################################"
puts "# to exit type \"EXIT\" in to the Department #"
puts "############################################"
# open the Enrollment File
# check if the file exists
if (File.exists?(file_name))
  # check if the file is readable
  if (File.readable?(file_name))
    enrollment_file = File.open(file_name, "r")
  else
    puts "#{file_name} is not readable -- exiting program"
    $run_program = false
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
    # ask for Department
    print "Enter Department abbreviation: "
    department_abbreviation = gets.chomp
    department_abbreviation.upcase! # make it all upper case
    puts department_abbreviation if $debug
    puts ""
    # check if the user is trying to exit
    if !(department_abbreviation == "EXIT")
      # ask for class number
      print "Enter Class Number: "
      class_number = gets.chomp
      puts ""
      # check the input
      if (department_abbreviation =~ /\A[A-Z]{2,4}\z/)
        if (class_number =~ /\A\d{2,3}\z/) || (department_abbreviation == "EXIT")
          input_works = true
        else
          puts "Try Again - Class Number is 2 to 3 digits"
        end
      else
        puts "Try Again - Department Abbreviation is All Caps and 2 to 4 letters"
      end
    else
      input_works = true
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
  # go over the whole file
  while !enrollment_file.eof?
    file_line = Array.new
    file_line[0] = enrollment_file.readline
    file_pos = Marshal.load(Marshal.dump(enrollment_file.pos))
    # ***Print the findings***
    scan_line = file_line[0]
    if scan_line =~ /\s#{department_abbreviation}&{0,1}\s+#{class_number}\s/ # this look for department abbreviation and class number
      puts file_line[0]
      #if !(file_line[1] =~ /\s[A-Z]{2,3}\s+\d{2,3}\s/) # old way it work by looking for a class and if there is a class then it will say do not print
      find_all_line_flag = true
      i = 1
      while find_all_line_flag
        file_line[i] = enrollment_file.readline
        puts "file pos #{enrollment_file.pos} is :#{file_line[i]}" if $debug
        scan_line = file_line[i]
        puts "/ {11}/ is : #{!(!(scan_line =~ /\A( {11}| {58})\w+/))}" if $debug
        if (scan_line =~ /\A( {11}| {58})\w+/) # check the spacing to see if it at note for the class
          puts file_line[i]
        else
          find_all_line_flag = false
        end
        # stop (I put this in here to prevent looping for ever)
        if (i >= 100)
          find_all_line_flag = false
        end
        i = i+1
      end
    end
    enrollment_file.pos = file_pos # set the pos of the file back before look for everything else for the class
  end
# end of Loop and say goodbye
end
enrollment_file.close # close the file
puts ""
puts "GoodBye"