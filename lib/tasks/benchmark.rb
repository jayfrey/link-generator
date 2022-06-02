def run_benchmarking_server(pid_file="tmp/pids/benchmark.pid")
  puts "running the benchmarking server"
  `bundle exec rails s -e benchmark --pid tmp/pids/benchmark.pid --port 8888 --daemon`
  sleep 10

  pid = File.read(pid_file).to_i
  puts "done, server pid is #{pid}"

  pid
end

def kill_benchmarking_server(pid, pid_file="tmp/pids/benchmark.pid")
  puts "killing test server"
  Process.kill "INT", pid
  File.delete pid_file
end

def run_benchmark(num_minutes, urls)
  puts "running benchmark for #{num_minutes} minutes:"
  concurrency = ENV.fetch("RAILS_MAX_THREADS") { 10 } * 10
  benchmark_cmd = "siege -c #{concurrency} -f #{urls} --internet --no-follow --time=#{num_minutes}M"
  IO.popen(benchmark_cmd) { |f| puts f.gets }
end

namespace :benchmark do
  task :check_env do
    raise "RAILS_ENV=#{ENV['RAILS_ENV']} detected, must be RAILS_ENV=benchmark" unless ENV["RAILS_ENV"] == "benchmark"
  end

  namespace :slow_redirection do
    desc "prepares the urls necessary for the slow redirection benchmark"
    task prepare: [:check_env, :environment] do |_t, args|
      puts "generating siege urls"
      urls = "/tmp/slow_redirection.txt"
      File.open(urls, "w") do |f|
        Url.find_each do |url|
          f.write "http://localhost:8888/o/#{url.slug}\n"
        end
      end
      puts "done generating urls in #{urls}"
    end

    desc "runs the slow redirection benchmark"
    task run: [:check_env, :environment] do |_t, args|
      begin
        urls = "/tmp/slow_redirection.txt"
        pid = run_benchmarking_server

        num_minutes = 5
        run_benchmark(num_minutes, urls)
      ensure
        kill_benchmarking_server(pid)
      end

      puts "all done"
    end
  end

  namespace :url_generation do
    desc "prepares the urls necessary for the url generation benchmark"
    task prepare: [:check_env, :environment] do |_t, args|
      puts "generating siege urls"
      urls = "/tmp/url_generation.txt"
      url_count = Url.count
      File.open(urls, "w") do |f|
        url_count.times do
          f.write("http://localhost:8888/api/urls POST url=https://#{rand * url_count}.example.com\n")
        end
      end
      puts "done generating urls in #{urls}"
    end

    desc "runs the url generation benchmark"
    task run: [:check_env, :environment] do |_t, args|
      begin
        urls = "/tmp/url_generation.txt"
        pid = run_benchmarking_server

        num_minutes = 5
        run_benchmark(num_minutes, urls)
      ensure
        kill_benchmarking_server(pid)
      end

      puts "all done"
    end
  end
end
