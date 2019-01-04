def output(num)
  sleep 1
  puts num
end

start = Time.now

(1..10).each do |num|
  output(num)
end

diff = Time.now.to_f - start.to_f
puts "#{diff} seconds to complete."
