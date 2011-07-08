class AttractionsController < ApplicationController
  # GET /attractions
  # GET /attractions.xml
  def index
    @attractions = Attraction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attractions }
    end
  end

  # GET /attractions/1
  # GET /attractions/1.xml
  def show
    @attraction = Attraction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attraction }
    end
  end

  # GET /attractions/new
  # GET /attractions/new.xml
  def new
    @attraction = Attraction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attraction }
    end
  end

  # GET /attractions/1/edit
  def edit
    @attraction = Attraction.find(params[:id])
  end

  # POST /attractions
  # POST /attractions.xml
  def create
    @attraction = Attraction.new(params[:attraction])

    respond_to do |format|
      if @attraction.save
        format.html { redirect_to(@attraction, :notice => 'Attraction was successfully created.') }
        format.xml  { render :xml => @attraction, :status => :created, :location => @attraction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attractions/1
  # PUT /attractions/1.xml
  def update
    @attraction = Attraction.find(params[:id])

    respond_to do |format|
      if @attraction.update_attributes(params[:attraction])
        format.html { redirect_to(@attraction, :notice => 'Attraction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attractions/1
  # DELETE /attractions/1.xml
  def destroy
    @attraction = Attraction.find(params[:id])
    @attraction.destroy

    respond_to do |format|
      format.html { redirect_to(attractions_url) }
      format.xml  { head :ok }
    end
  end
end
