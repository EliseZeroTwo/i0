require './config.rb'
require 'json'
require 'pathname'
require 'sinatra'

set bind: '127.0.0.1'
set port: 1042

DEFAULT_PROJECT_JSON = [['A Project Title', 'A short summary', 'https://github.com/EliseZeroTwo/i0',
                         'https://github.com/EliseZeroTwo/i0']].freeze

def make_dir_structure
begin
  Dir.mkdir(CONFIG[:directory])
  Dir.mkdir(CONFIG[:directory] + '/articles')
rescue Errno::EEXIST
end
unless File.file?(CONFIG[:directory] + '/projects.json')
  File.write(CONFIG[:directory] + '/projects.json', DEFAULT_PROJECT_JSON.to_s)
end
end

make_dir_structure

def article_path
  CONFIG[:directory] + '/articles/'
end

def calculate_read_time(content)
  return '0 minute read' unless content.is_a?(String)

  (content.split(' ').length / 200).to_s + ' minute read'
end

get '/' do
  article_paths = Dir.children(article_path)
  article_meta = []
  article_paths.each do |file_name|
    file = File.open(article_path + file_name)
    cont = file.read
    article_meta << [file_name, cont, calculate_read_time(cont)]
  end
  proj_file = File.open(CONFIG[:directory] + '/projects.json')
  project_meta = JSON.parse(proj_file.read)
  erb :index, locals: { title: CONFIG[:title], articles: article_meta, projects: project_meta }
end

get '/article/:path' do |path|
  name = path.gsub('.md', '').gsub('.', '')
  pathname = Pathname.new(article_path + name + '.md')
  p pathname.dirname.to_s
  p article_path
  valid_path = true if pathname.exist?

  if valid_path
    content = pathname.read
    title = name.gsub('-', ' ')
    erb :article, locals: { title: CONFIG[:title], author: CONFIG[:author], content: content, read_time: calculate_read_time(content),
                           title: title }
  else
    erb :article, locals: { title: CONFIG[:title], author: 'N/A', content: '', read_time: calculate_read_time(nil),
                            title: 'Not found' }
  end

end