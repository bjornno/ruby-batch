
require 'rubygems'
require 'sequel'
require 'fileutils'
require 'ftools'

module Filescanner

  def moveFile(fromfilename, fromdir, tofilename, todir)
  
    if File.exist? fromdir+'/'+fromfilename
      if !File.exist? todir
        FileUtils.mkdir(todir)
      end
      puts 'moving file: ' + fromfilename
      FileUtils.mv(fromdir+'/'+fromfilename, todir+tofilename)
      end 

  end

  def startProcess(path, file)
    moveFile(file, path, file, path + '/processing/')
    file = File.open(path + '/processing/' + file, "r")  
  end

  def endProcess(path, file)
    moveFile(file, path + '/processing/', file +'-'+rand(999999).to_s.center(6, rand(9).to_s), path + '/processed/')
  end

  def filescan(path, regexp, &block)
    while true 
      Dir.foreach(path)  do |filename|  
        if (File.fnmatch(regexp, filename)) #File.directory?(file) && 
            puts filename+' is not a directory'
            file = startProcess(path,filename)
            #DB.transaction do
              yield block [file]
            #end
            file.close
            endProcess(path, filename)
        end
      end  
      sleep 5 
    end 
  end

end

include Filescanner
filescan 'data', 'bjorn*' do
  |file| 
  #puts file.to_s + 'jippu'
  puts '---------------'
  puts 'reading file'
  while line = file.gets   
    puts line   
  end  
  puts 'finished reading file'
  puts '---------------'
  
end


