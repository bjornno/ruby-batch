require 'rubygems'
require 'sequel'
require 'fileutils'
require 'ftools'

module BatchFile

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
    puts 'starting file pump'
    Thread.new do
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
  
  def writefile(filepath, filename, content)
    if !File.exist? filepath+'/tmp/'
        FileUtils.mkdir_p(filepath+'/tmp/')
      end
    File.open(filepath+'/tmp/'+filename, 'w') {|f| f.write(content) }
    moveFile(filename, filepath+'/tmp/', filename, filepath+'/tmp/')
  end
  
end

module BatchDatabase
  def createDb(db)
    db << "CREATE TABLE work_item (id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT, work_id INTEGER UNSIGNED NOT NULL, processing_state INTEGER UNSIGNED NOT NULL, work_queue_id INTEGER UNSIGNED NOT NULL,PRIMARY KEY(id))"
  end
  

  def dbscan(db, queue, &block)
    puts 'starting db pump'
    Thread.new do
      loop do
        db.transaction do
          workset = db[:work_item].where(:processing_state => 0).where(:work_queue_id => queue)
          work = workset.first
          if work != nil
            yield block [work]
            workset.filter(:id => work[:id]).update(:processing_state => 3)
          else
            sleep 10
          end
        end
      end 
    end
  end
  
  def dbpost(db, queue, work_id)
    dataset = db[:work_item]
    dataset.insert(:processing_state => 0, :work_queue_id => queue, :work_id => work_id)
  end
  
end

include BatchFile
include BatchDatabase



