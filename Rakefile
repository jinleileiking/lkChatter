require "pathname"
directory "build"

task :default => 'rb2jar'

desc "building Jars"
task :rb2jar do
#  dirs =  []
#  pa = Pathname.new(".")
#  pa.find do |x|
#    if x.directory?
#      dirs << x.dirname.to_s
#      next
#    end
#    file =  x.dirname.to_s + "/" +  x.basename.to_s
##    %x[jrubyc #{file}]
#  end
#
#  p dirs
  cd "src"
  %x[jrubyc *.rb]
  mv  Dir.glob('*.class'), "../build"
  cd "../build"
  %x[jar cvf build.jar *.class]
  rm_rf   Dir.glob('*.class')
  cd ".."
#  %x[move *.class .\build]
#  %x[cd build]

#  %x[del *.class]
#  %x[cd ..]
end

desc 'convert gems to jars'
task :gem2jar do
  cd "build/gems"
  Dir.glob('*.gem') do |gem_file|
    gem_filename = gem_file[/^(.+).gem$/, 1]
    %x[java -jar ..\\jruby-complete-1.5.1.jar -S gem install -i .\\#{gem_filename} .\\#{gem_filename} --no-rdoc --no-ri]
    %x[jar cf #{gem_filename}.jar -C #{gem_filename} .]
    mv "#{gem_filename}.jar", ".."
    rm_rf(Dir.glob("#{gem_filename}"))
  end
end
