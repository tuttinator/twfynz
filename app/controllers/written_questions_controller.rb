class WrittenQuestionsController < ApplicationController
  # GET /written_questions
  # GET /written_questions.xml
  def index
    @questions = WrittenQuestion.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /written_questions/1
  # GET /written_questions/1.xml
  def show
    @question = WrittenQuestion.find(:first, :conditions => {:question_year => params[:year], :question_number => params[:question_number]})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end
end
