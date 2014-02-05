class Impulse

attr_accessor :raw

def initialize raw
@raw = raw
end

def raw= raw
@raw = raw
end

#extracts all the synapses within the raw text.
def synapses
@simple = @raw.scan(/(?:^|\s)(?:#)(?!\d+(?:\s|$))([a-zA-Z0-9@\.?!-_><\\\/]+)(?:\z|$|\s)/)
@compound = @raw.scan(/(?:^|\n)([a-zA-Z0-9-_]+)#(.+)(?:\z|\r)/)
@synapses = {}
@compound.each do |k,v|
	k = k.to_sym
	@synapses[k] ||= []
	@synapses[k] << v
end
@synapses[:tags] = @simple.flatten
@synapses
end

#extract the main body from raw text
#TODO: add logic to rip hashes from valid inline tags
def body
#same regex as the one in @raw.scan but with capturing groups removed
@body = @raw.split(/(?:^|\n)[a-zA-Z0-9-_]+#.+(?:\z|\r)/).join
#Remove hashtags which are NOT inline
@body = @body.split(/(?:^|\n)(?:#)(?!\d+(?:\s|$))[a-zA-Z0-9@\.?!-_><\\\/]+/).join
#Remove hash sign from valid inline hashtags
end

#finds out if a synapse is being created or queried?
def question?
@raw =~ /\A.+\?\z/
end

#take approprate action based on the tags etc only for non-questions
def parse
#get infomation about the tags and then store that alongwith "body" within the "parsed" variable
# First looked in the predefined synapses
# Then in the synapsedefs table for custom synapses
# Lastly loads definitions from the synapse's action if it provides those
@synapses ||= synapses
@parsed ={}
@synapses.each do |k,v|
	@parsed[k] ||= {}
	@parsed[k][:type]="blank"
	@parsed[k][:value]=v
end
@parsed
end 

end