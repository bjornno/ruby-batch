
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
    if !File.exist? path
        FileUtils.mkdir_p(path)
    end
    while true 
      Dir.foreach(path)  do |filename|  
        if (File.fnmatch(regexp, filename)) #File.directory?(file) && 
            file = startProcess(path,filename)
            if file != nil
              #DB.transaction do
              yield block [file]
              #end
              file.close
            end
            endProcess(path, filename)
        end
      end  
      sleep 5 
    end 
  end

end

include Filescanner



