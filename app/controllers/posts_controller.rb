class PostsController < ApplicationController

	before_action :find_post, only: [:destroy]
  def index
  	@posts = Post.all
  end
  def new
  	@post = Post.new
  end
  def create
  	require 'nokogiri'
  	require 'open-uri'
  	url = "http://www.walmart.com/search/?query=#{params[:post][:title]}"
  	doc = Nokogiri::HTML(open(url))
  	@title = params[:post][:title]
  	import = doc.at_css(".price-display")
  	if import != nil
  		@price = import.text
  	else
  		@price = "?"
  	end
  	@post = Post.new({title: @title, price: @price})

  	if @post.save
  		redirect_to root_path
  	else
  		render :create
  	end
  end

  def update
  end
  def edit
  end
  def destroy
  	@post.destroy
  	redirect_to root_path

  end

  private

  def find_post
  	@post = Post.find(params[:id])
  end

end
