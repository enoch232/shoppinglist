class PostsController < ApplicationController

	before_action :find_post, only: [:destroy]
  def index
  	@posts = Post.all
    @post = Post.new
  end

  def new
  	@post = Post.new
  end
  def create
  	require 'nokogiri'
  	require 'open-uri'
    begin
     url = "http://www.walmart.com/search/?query=#{params[:post][:title]}"
     doc1 = Nokogiri::HTML(open(url))
     import1 = doc1.at_css(".price-display")
    rescue
      import1 = nil
    end
    #walmart

    begin
    url = "http://www.target.com/s?searchTerm=#{params[:post][:title]}&category=0%7CAll%7Cmatchallpartial%7Call+categories&lnk=snav_sbox_#{params[:post][:title]}"
    doc2 = Nokogiri::HTML(open(url))
    import2 = doc2.at_css(".price-label")
    rescue
      import2 = nil
    end
    #target
    begin
    url = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=#{params[:post][:title]}"
    doc3 = Nokogiri::HTML(open(url))
    import3 = doc3.at_css(".s-price")
    rescue
      import3 = nil
    end



    #amazon

    
    
    


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

    if import3 != nil
      @price3 = import3.text
      @price3 = (@price3[1..@price3.length-1]).to_f
      
    else
      @price3 = 0
    end

    
    
    if @price1 > 0 && @price2 > 0 && @price3 > 0
      #if there is bigger difference from price1 and price2, than from price1 and price2
      if (@price1-@price2).abs > (@price1- @price3).abs
        @price = (@price1+@price3)/2
      elsif (@price1-@price2).abs < (@price1- @price3).abs
       @price = (@price1+@price2)/2
     else
      @price = (@price1+@price2+@price3)/3
    end
      #if price3 is null, then average the two between price1 and price2
    elsif @price1 > 0 && @price2 > 0 && @price3 == 0
      @price = (@price1 +@price2)/2
    elsif @price1 > 0 && @price3 > 0 && @price2 == 0
      @price = (@price1 +@price3)/2
    elsif @price2 > 0 && @price3 > 0 && @price1 == 0
      @price = (@price2+@price3)/2
      #next three checking if two are null, then make the one as the only source.
    elsif @price1 > 0 && @price2 == 0 && @price3 == 0
      @price = @price1
    elsif @price2 > 0 && @price3 == 0 && @price1 == 0
      @price = @price2
    elsif @price3 > 0 && @price1 == 0 && @price2 == 0
      @price = @price3
    else
      @price = 0
    end

    #if @price1 > 0 && @price2 > 0 && @price3> 0
    #  @price = (@price1+@price2+@price3)/3
    #elsif @price1 && (@price2 == 0)
    #  @price = @price1
    #elsif @price1 == 0 && @price2
    #  @price = @price2
    #else
    #  @price = 0
    #end

    



    @post = Post.new({title: @title, price: @price.round(2)})
    $number += 1
    if @post.save
      respond_to do |format|
        format.html{redirect_to root_path}
        format.js
      end
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
    respond_to do |format|
      format.html{redirect_to root_path}
      format.js
    end

  end

  private

  def find_post
  	@post = Post.find(params[:id])
  end

end
