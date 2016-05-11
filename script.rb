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
		if line_num != 1 
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
		$answers.each { |e|
			e.each { |x|
				f.write(x)
				f.write("\n")
			}
			f.write("\n")
		}
	}
end

# main functions
read_headers("data.csv")
read_answers("data.csv")
fill_in_blanks()
print_to_file("out.txt")