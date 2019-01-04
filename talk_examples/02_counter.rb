count = 0
threads = []
mutex = Mutex.new

1000.times do
  threads << Thread.new do
    sleep 1

    mutex.synchronize do
      count += 1
    end
  end
end

threads.each(&:join)

puts "count = #{count}"
