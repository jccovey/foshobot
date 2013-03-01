require 'key'

class Error < StandardError
end

def run(a, b = nil)
	unless b == nil
		puts b
	else
		puts a
	end
end

begin
	run 1, 2
	run 1
	puts EMAIL
rescue => ex
	puts ex
end