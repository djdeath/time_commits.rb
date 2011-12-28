require 'time'

class Committer
        attr_reader :name, :nb_commits, :commits_per_hours

        def initialize name
                @name = name
                @nb_commits = 0
                @commits_per_hours = []
                @commits_per_hours[0..23] = 0
        end

        def add_commit date
                t = Time.iso8601(date)
                @nb_commits += 1
                if @commits_per_hours[t.hour] == nil
                        @commits_per_hours[t.hour] = 1
                else
                        @commits_per_hours[t.hour] += 1
                end
        end

        def print
                puts "#{@name} : #{@nb_commits} commit(s)"
                for i in 0..23
                        percent = 0
                        printf ("%02dh : " % i)
                        if @commits_per_hours[i]
                                percent = @commits_per_hours[i] * 100.0 / @nb_commits
                                (percent * 60.0 / 100.0).to_i.times { printf "=" }
                        end
                        puts "| #{percent.to_i}%"
                end
        end
end

committers = {}
current_committer = nil

$stdin.each_line do |line|
        if /^Author:\s+(.*)\<.*/.match(line)
                name = $1.strip
                current_committer = committers[name]
                if current_committer == nil
                        current_committer = Committer.new(name)
                        committers[name] = current_committer
                end
        elsif /^Date:\s+(.*)\s[\+\-].*/.match(line)
                date = $1.tr(' ','T')
                current_committer.add_commit(date)
        end
end

committers.each_value { |c| c.print }
