class DictionariesController < ApplicationController
  before_action :set_dictionary, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :check_words
  # GET /dictionaries
  # GET /dictionaries.json
  def index
    @dictionaries = Dictionary.where(id: (1..10).to_a)
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.json
  def show
  end

  # GET /dictionaries/new
  def new
    @dictionary = Dictionary.new
  end

  # GET /dictionaries/1/edit
  def edit
  end

  # POST /dictionaries
  # POST /dictionaries.json
  def create
    @dictionary = Dictionary.add_word dictionary_params[:word], dictionary_params[:meaning]

    respond_to do |format|
      if @dictionary
        format.html { redirect_to @dictionary, notice: 'Dictionary was successfully created.' }
        format.json { render :show, status: :created, location: @dictionary }
      else
        format.html { render :new }
        format.json { render json: @dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dictionaries/1
  # PATCH/PUT /dictionaries/1.json
  def update
    respond_to do |format|
      if @dictionary.update(dictionary_params)
        format.html { redirect_to @dictionary, notice: 'Dictionary was successfully updated.' }
        format.json { render :show, status: :ok, location: @dictionary }
      else
        format.html { render :edit }
        format.json { render json: @dictionary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dictionaries/1
  # DELETE /dictionaries/1.json
  def destroy
    @dictionary.destroy
    respond_to do |format|
      format.html { redirect_to dictionaries_url, notice: 'Dictionary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def corrector

  end

  def check_words
    p params
    words = params['input'].split
    array = []
    words.each do |word|
      dict = Dictionary.is_word_present? word
      if dict.present?
        dict.increase_word_count 1
        array.push word
      else
        probable_words = Dictionary.probable_words(word)[1..5]
        if probable_words.present?
          array.push "\n<autocorrect>"+probable_words.join("</autocorrect>\n<autocorrect>") + "</autocorrect>\n"
        else
          array.push word
        end
      end
    end

    render json: {output: array.join(' ') }
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary
      @dictionary = Dictionary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dictionary_params
      params[:dictionary]
    end
end
