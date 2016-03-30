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
  	doc1 = Nokogiri::HTML(open(url))
  	
    #walmart
  	import1 = doc1.at_css(".price-display")

    url = "http://www.target.com/s?searchTerm=#{params[:post][:title]}&category=0%7CAll%7Cmatchallpartial%7Call+categories&lnk=snav_sbox_#{params[:post][:title]}"
    doc2 = Nokogiri::HTML(open(url))
    
    #target
    import2 = doc2.at_css(".price-label")
    @title = params[:post][:title]
  	if import1 != nil
  		@price1 = import1.text
      @price1 = (@price1[2..@price1.length-1]).to_f
      
  	else
  		@price1 = 0
  	end

    if import2 != nil
      @price2 = import2.text
      @price2 = (@price2[8..@price2.length-1]).to_f
      
    else
      @price2 = 0
    end

    if @price1 > 0 && @price2 > 0
      @price = (@price1+@price2)/2
    elsif @price1 && @price2 == 0
      @price = @price1
    elsif @price1 == 0 && @price2
      @price = @price2
    else
      @price = 0
    end


      
      

  	@post = Post.new({title: @title, price: @price.round(2)})

  	if @post.save
  		redirect_to root_path
  	else
  		render :new
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
