class WrittenQuestionsController < ApplicationController
  # GET /written_questions
  # GET /written_questions.xml
  def index
    @oldest_unanswered = WrittenQuestion.find(:first, :conditions => ['status = ?', 'question'], :order => "question_year asc, question_number asc")
    @statuses = {}
    WrittenQuestion.count(:group => 'status').each{|result|
      @statuses[result[0]] = result[1]
    }

    @questions = paginate params[:status].nil? ? nil : params[:status].singularize

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end
  
  def index_by_answered
    @questions = paginate "reply"
    re
    render :action => :index
  end


  # GET /written_questions/1
  # GET /written_questions/1.xml
  def show
    @question = WrittenQuestion.find(:first, :conditions => {:question_year => params[:year], :question_number => params[:question_number]})
    @questions = WrittenQuestion.find(:all, :conditions => ['question_year = ? and question_number > ? and question_number < ?', params[:year], params[:question_number].to_i - 5, params[:question_number].to_i + 5], :order => "question_number")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  private
  def paginate status=nil
    if status.nil?
      WrittenQuestion.paginate :page => params[:page], :order => "question_year desc, question_number desc", :per_page => 10
    else
      WrittenQuestion.paginate :page => params[:page], :conditions => ['status = ?', status], :order => "question_year desc, question_number desc", :per_page => 10
    end
  end
end
