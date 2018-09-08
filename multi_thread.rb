def output(num)
  sleep 1
  puts num
end

# (1..10).each { |num| output(num) }
# (1..10).map { |num| Thread.new { output(num) } }.each(&:join)

# count = 0
# arr = []
# hash = {count: 0}
#
# 100.times do |i|
#   arr[i] = Thread.new do
#     hash[:count] += 1
#     count += 1
#   end
# end
#
# arr.each(&:join)
# puts "hash[:count] = #{hash[:count]}"
# puts "count = #{count}"
#
# count1 = count2 = 0
# arr = []
# counter = (1..10).to_a.map do
#   Thread.new do
#       count1 += 1
#       count2 += 1
#       arr << [count1]
#       arr.last << count2
#   end
# end
# counter.each(&:join)
# arr.each do |tuple|
#   puts "count1 :  #{tuple.first}"
#   puts "count2 :  #{tuple.last}"
#
# end
# puts "count1 :  #{count1}"
# puts "count2 :  #{count2}"

class Counter
    attr_accessor :count, :tmp

    def initialize
      @count = 0
      @tmp = 0
      @mutex = Mutex.new
    end

    def increment
      self.count += 1
    end

    private

    attr_reader :mutex
end

mutex = Mutex.new
c = Counter.new

start_time = Time.now
t1 = (1..500).to_a.map do |_|
  Thread.start do
    mutex.synchronize do
      sleep 0.01
      c.increment
      c.tmp += 1 if c.count.even?
    end
  end
end
t2 = (1..500).to_a.map do |_|
  Thread.start do
    mutex.synchronize do
      sleep 0.01
      c.increment
      c.tmp += 1 if c.count.even?
    end
  end
end


t1.each(&:join)
t2.each(&:join)
end_time = Time.now

p c.count #200_0000
p c.tmp #100_000
p (end_time.to_f - start_time.to_f)
#
# class Sheep
#   def initialize
#     @shorn = false
#   end
#
#   def shorn?
#     @shorn
#   end
#
#   def shear!
#     puts "shearing..."
#     @shorn = true
#   end
# end
#
#
# sheep = Sheep.new
#
# 5.times.map do
#   Thread.new do
#     unless sheep.shorn?
#       sheep.shear!
#     end
#   end
# end.each(&:join)
