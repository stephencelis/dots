# Dots makes dots.
module Dots
  VERSION = "0.0.1"

  class InvalidDot < StandardError
  end

  #--
  # Allows us direct access to +Enumerator+, ensuring compatibility with 1.8.7
  # and 1.9.
  #++
  include Enumerable

  #--
  # How dots appear.
  #++
  @@dots = { "." => ".", "F" => "F", "E" => "E" }

  # Access how a dot should appear.
  def [](key)
    raise InvalidDot unless @@dots.keys.include? key.to_s
    dot = @@dots[key.to_s]
    dot.respond_to?(:call) ? dot.call : dot
  end

  # Configure how dots appear. For red and green:
  #
  #   Dots["."] = "\e[32m.\e[0m"
  #   Dots["F"] = "\e[31mF\e[0m"
  #   Dots["E"] = "\e[31mE\e[0m"
  #
  # Or, just <tt>require "dots/redgreen"</tt>.
  #
  # For a random rainbow, <tt>require "dots/rainbow"</tt>, or use a procedure:
  #
  #   Dots["."] = Proc.new { \e[%dm.\e[0m" % [rand(10) + 30] }
  def []=(key, value)
    raise InvalidDot unless @@dots.keys.include? key.to_s
    @@dots[key.to_s] = value
  end

  Enumerable.module_eval do
    # Sends a dot to standard output (or designated IO) after each iteration.
    #
    # If an exception is raised during an iteration, an "E" or "F" will be
    # sent in dot's stead: "F" for instances of +RuntimeError+, which may be
    # raised blankly in an iteration, and "E" otherwise, assuming
    # unanticipated errors.
    #
    # Example:
    #
    #   >> require "dots"
    #   => true
    #   >> (0..5).each_with_dots do |n|
    #   ?>   100 / n
    #   ?>   raise "No fours!" if n == 4
    #   ?> end
    #   E...F.
    #   Finished in 0.000430 seconds.
    # 
    #     1) Error
    #   ZeroDivisionError: divided by 0
    #   with <0>
    #     (irb):3:in `/'
    #     (irb):3:in `irb_binding'
    #     (irb):2:in `irb_binding'
    #     /usr/local/lib/ruby/1.8/irb/workspace.rb:52:in `irb_binding'
    #     /usr/local/lib/ruby/1.8/irb/workspace.rb:52
    # 
    #     2) Failure
    #   No fours! 
    #   with <4>
    #   [(irb):4]
    def each_with_dots(io = $stdout)
      old_sync, io.sync = io.sync, true
      exceptions, passed, start = [], 0, Time.now
      trap("INT") { return io.puts "abort!" }
      each do |object|
        begin
          yield object
          io.print Dots["."]
          passed += 1
        rescue => e
          if e.is_a? RuntimeError
            io.print Dots["F"]
          else
            io.print Dots["E"]
          end
          exceptions << [object, e] unless exceptions.nil?
        end
      end
    ensure
      Dots.report exceptions, passed, start, io
      io.sync = old_sync
    end
  end

  Enumerator.class_eval do
    # Returns an <tt>Enumerator</tt> for <tt>Enumerable#each_with_dots</tt>.
    def with_dots(io = $stdout, &block)
      enum = enum_for :each_with_dots, io
      block_given? ? enum.each(&block) : enum
    end
  end if RUBY_VERSION >= "1.8.7"

  Kernel.module_eval do
    private
    # Sends dots to standard output (or designated IO) on an interval for the
    # duration of the block.
    #
    # Example:
    #
    #   >> dots do
    #   ?>   sleep 5
    #   ?> end
    #   .....=> 5
    def dots(interval = 1, io = $stdout)
      old_sync, io.sync = io.sync, true 

      thread = Thread.new do
        dot = lambda do
          io.print Dots["."]
          sleep interval and dot.call
        end
        dot.call
      end

      yield
    ensure
      io.sync = old_sync
      thread.kill
    end
  end

  # Formats reports for +each_with_dots+.
  def report(exceptions, passed = 0, start = nil, io = $stdout)
    failed = erred = 0

    io.puts
    io.puts "Finished in #{Time.now - start} seconds." unless start.nil?
    exceptions.each_with_index do |(o, e), i|
      io.puts
      if e.is_a? RuntimeError
        failed += 1
        io.puts "%3d) Failure" % [i + 1]
        io.puts "#{e.message} " unless e.message.empty?
        io.puts "with <#{o.inspect}>"
        io.puts "[#{e.backtrace.first[/.+\d+/]}]"
      else
        erred += 1
        io.puts "%3d) Error" % [i + 1]
        io.puts "#{e.class.name}: #{e.message}"
        io.puts "with <#{o.inspect}>"
        io.puts e.backtrace.select { |l| l !~ /dots.rb/ }.map { |l| "\t#{l}" }
      end
    end
    io.puts
    io.puts summary(passed, failed, erred)
  end

  private

  def summary(passed, failed, erred)
    "%d total, %d passed, %d failed, %d erred" %
      [passed + failed + erred, passed, failed, erred]
  end

  extend self
end
