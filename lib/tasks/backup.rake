namespace :db do
  namespace :backup do
    
    def interesting_tables
      #['attractions', 'PoiCategory']
      ActiveRecord::Base.connection.tables.sort.reject do |tbl|
        ['schema_migrations', 'schema_info', 'public_exceptions', 'user_sessions'].include?(tbl)
      end
    end
  
    desc "Dump entire db. Use this on Production"
    task :dump => :environment do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        puts "Writing #{tbl}..."
        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }      
      end
    
    end
  
    desc "Load entire db. Use this on Development"
    task :load => [:environment, 'db:schema:load'] do 

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)
    
      interesting_tables.each do |tbl|

        klass = tbl.classify.constantize
        ActiveRecord::Base.transaction do 
        
          puts "Loading #{tbl}..."
          begin
          file = YAML.load_file("#{tbl}.yml").each do |fixture|
            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
          end     
          rescue
            puts "Cannot load #{tbl}"
          end 
        end
      end
    
    end
  
  end
end
