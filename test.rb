require 'date'
1.upto(20).with_index do |index|
  num_days_to_collect = 4
  date = Date.today.next_day(1)
  if num_days_to_collect.nonzero?
    if date > Date.today
      next unless (index % num_days_to_collect === 0)
    end
  end
  puts "#{date.next_day(index)}. index: #{index}"
end