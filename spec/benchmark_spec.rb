require "minitest/benchmark"
require 'benchmark'
require 'posix/spawn'
require 'procinfo'

describe "Process information retrieval" do
  Benchmark.bm  do |x|
    x.report {System.uname}
  end

  Benchmark.bm  do |x|
    x.report {Process.stats}
  end

  Benchmark.bm  do |x|
    x.report {Process.stats(:self)}
  end

  Benchmark.bm  do |x|
    x.report {Process.stats(:children)}
  end

  Benchmark.bm do |x|
    x.report {`ps -o rss= -p #{Process.pid}`.to_i}
  end

  Benchmark.bm  do |x|
    x.report {
      begin
        pid, stdin, stdout, stderr = POSIX::Spawn.popen4('ps', )
        stdin.close
        rss = stdout.read.to_i
      rescue => e
      # nothing right now.
      ensure 
        [stdin, stdout, stderr].each { |fd| fd.close unless fd.closed? }
        stat = Process::waitpid(pid)
      end
    }
  end
end
