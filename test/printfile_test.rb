require File.dirname(__FILE__) + '/test_helper.rb'

filescan '/data/from_host/bjorn', 'bjorn*' do
  |file| 
  if file != nil
    puts '---------------'
    puts 'reading file'
    while line = file.gets   
      if (line != nil)
        puts line   
      end
    end  
  end
  puts 'finished reading file'
  puts '---------------'
  
end