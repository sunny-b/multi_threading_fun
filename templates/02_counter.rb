count = 0
threads = []

1000.times do
  threads << Thread.new do
    sleep 1

    count += 1
  end
end

threads.each(&:join)

puts "count = #{count}"
