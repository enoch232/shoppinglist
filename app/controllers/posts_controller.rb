class PostsController < ApplicationController

	before_action :find_post, only: [:destroy]
  def index
  	@posts = Post.all
    @total = @total
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
    @total ||= 0
  	if import != nil
  		@price = import.text
      @price = (@price[2..@price.length-1]).to_f
      @total = @total + @price
  	else
  		@price = 0
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
