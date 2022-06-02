#!/usr/bin/env ruby

require 'bundler/inline'
require 'fileutils'

gemfile do
  source 'https://rubygems.org'
  gem 'redcarpet'
end

class CustomRender < Redcarpet::Render::HTML
  def doc_header
    %(<html lang="en">
        <head>
          <meta charset="utf-8">
        </head>
        <body>
      )
  end

  def doc_footer
    %(</body></html>)
  end
end

markdown = Redcarpet::Markdown.new(CustomRender, autolink: true, tables: true)

Dir.glob("docs/*.md").each do |filename|
  content = markdown.render(File.read(filename))
  destination = filename.gsub('.md', '.html')
  File.write("#{Dir.pwd}/public/#{destination}", content)
end

FileUtils.cp_r("#{Dir.pwd}/docs/images", "#{Dir.pwd}/public/docs/images")
