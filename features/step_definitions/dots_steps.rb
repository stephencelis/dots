Given(/^an \w+ (.+)$/) do |object|
  @enumerable = eval(object)
end

Given(/^a task that takes (\d+) seconds$/) do |number|
  short_second  = 1 / 100
  short_seconds = number.to_i / 100
  @proc = Proc.new { |io| dots(short_second, io) { sleep short_seconds } }
end

When(/^I run it with dots$/) do
  @proc ||= Proc.new { |each| each }
  @io = StringIO.new
  @enumerable.each_with_dots(@io, &@proc)
  @io.rewind
  @content = @io.read
end

When(/^I run it in a dots block$/) do
  @io = StringIO.new ""
  @proc.call(@io)
  @io.rewind
  @content = @io.read
end

When(/^I don't want (\d+)s$/) do |number|
  @proc = Proc.new { |each| raise "No threes!" if each == number.to_i }
  @line = __LINE__ - 1
end

When(/^I divide each by zero$/) do
  @proc = Proc.new { |each| each / 0 }
  @line = __LINE__ - 1
end

Then(/^I should see (\d+) "([^\"])" dots?$/) do |dot, number|
  length = @enumerable.nil? ? -1 : @enumerable.length
  @content[0..length].count(dot).should be(number.to_i)
end

Then(/^I should see how long it took$/) do
  @content.should match(/Finished in .+? seconds/)
end

Then(/^I should see "([^\"]*)" (\d+) times?$/) do |message, number|
  @content.split(message).length.should be(number.to_i + 1)
end

Then(/^I should see "([^\"]*)"$/) do |message|
  @content.should include(message)
end

Then(/^I should not see "([^\"]*)"$/) do |message|
  @content.should_not include(message)
end

Then(/^I should see the exception's line number$/) do
  @content.should include("#{File.basename(__FILE__)}:#@line")
end
