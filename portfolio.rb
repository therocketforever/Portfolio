require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'thin'
require 'mongoid'

require 'haml'
require 'sass'

Mongoid.load!("config/mongoid.yml")

class Entry
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :imageurl, type: String
  field :videourl, type: String
  field :filedownload, type: String
  field :tag, type: Array
  field :made, type: String
end

get '/' do  
  @entries = Entry.all
  haml :layout
end

get '/new' do
  haml :'entry/new', :locals => { :title => "New Portfolio Entry"}
end

post '/new' do
  @entry = params[:entry]
  @doc = Entry.new
  @doc.title = @entry[:title]
  @doc.description = @entry[:description]
  @doc.imageurl = @entry[:imageurl]
  @doc.videourl = @entry[:videourl]
  @doc.filedownload = @entry[:filedownload]
  @doc.tag = @entry[:tag]
  @doc.made = @entry[:made]
  if @doc.save
    p 'Entry Saved'
  else
    p 'Entry Failed'
  end
  redirect '/show'+@doc.id
end

get '/show.id' do |id|
  @entry = Entry.find(id)
  @title = "##{@entry.title}, ##{@entry.tag}"
  haml :'entry/show'
end

get '/edit.:id' do |id|
  @doc = Entry.find(id)
  haml :'entry/edit', :locals => { :title => "Edit Blog", :entry => @doc}
end

put '/edit.:id' do |id|
  @doc = entry.find(id)
  @doc.update_attributes(params[:entry])
  redirect '/show.'+id
end
