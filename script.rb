require 'csv'

$labels = []
$answers = []

def read_headers(filename)
	File.open(filename, "r") { |f|
		line = f.readline
		headers = CSV.parse_line(line, col_sep: ",")
		headers.each { |i|
			i =~ /(Q[0-9]+\s-\s)(.+)/
			$labels.push($2)
		}
	}
end

def read_answers(filename)
	File.foreach(filename).with_index do |line, line_num| 
		if line_num != 0 
			begin
				answers = CSV.parse_line(line, col_sep: ",")
			rescue CSV::MalformedCSVError => er
				puts er.message
				puts "#{line_num}: #{line}"
				puts
			end

			$answers.push(answers)
		end
	end
end

def fill_in_blanks
	$answers.each do |e|
		e.collect! {|x|
			x == nil ? "None" : x	
		}
	end
end

def print_to_file(out_file)
	File.open(out_file, "w") { |f|
		$answers.each_with_index { |e, index|
			e.each_with_index { |x, i|
				f.write($labels[i])
				f.write(": ")

				f.write(x)
				f.write("\n")
			}
			f.write("\n")
		}
	}
end

# read field headers
read_headers("data.csv")
puts $labels

# read responses
read_answers("data.csv")
fill_in_blanks()

# print formatted contents to file
print_to_file("out.txt")