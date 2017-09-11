#!/usr/bin/env ruby
require 'ostruct'

class WeblogInfo
  attr_accessor :pages
  def initialize(file = nil)
    @pages = []
    unless ARGV.empty?
      @log = ARGV.first
    else
      @log = file
    end
  end

  def call
    if logfile_given?(@log)
      parse_log(@log)
      display_info(@pages)
    else
      puts "argument given was not a valid log file"
    end
  end

private

  def logfile_given?(log)
    if log.is_a?(String)
      log.include? '.log'
    elsif log.is_a?(File)
      log.path.include? '.log'
    else
      false
    end
  end

  def parse_log(log)
    IO.foreach(@log) do |line|
      line_data = line.split(" ")
      page_name = line_data.first
      ip_addr = line_data[1]

      page = find_or_create_page(line_data)
      page.total_views += 1
      unique_views(page, line)
    end
  end

  def find_or_create_page(line_data)
    unless @pages.any? { |page| page.name == line_data.first }
      pagename = OpenStruct.new
      pagename.name = line_data.first
      pagename.unique_ips = []
      pagename.unique_ips << line_data[1]
      pagename.total_views = 0
      @pages << pagename
      pagename
    else
      @pages.find { |page| page.name == line_data.first }
    end
  end

  def existing_ip_address?(page, ip)
    page.unique_ips.any? { |ip_addr| ip_addr == ip }
  end

  def unique_views(page, ip)
    unless existing_ip_address?(page, ip)
      page.unique_ips << ip
    end
  end

  def display_info(pages)
    puts "List of pages ordered by total views:"

    sorted_views = pages.sort_by { |page| page.total_views }

    sorted_views.reverse.each do |page|
      puts "#{page.name}: #{page.total_views} views."
    end

    puts "List of pages ordered by total unique views:"

      sorted_unique_views = pages.sort_by { |page| page.unique_ips.count }

      sorted_unique_views.reverse.each do |page|
        puts "#{page.name}: #{page.unique_ips.count} unique views."
      end
  end
end

WeblogInfo.new.call
