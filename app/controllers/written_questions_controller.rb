#encoding: utf-8
class WrittenQuestionsController < ApplicationController
  before_filter :written_questions_on

  PAGE_SIZE = 20

  def written_questions_on
    @portfolios_on = true
  end

  # GET /written_questions
  # GET /written_questions.xml
  def index
    @oldest_unanswered = WrittenQuestion.find(:first, :conditions => ['status = ?', 'question'], :order => "question_year asc, question_number asc")
    @statuses = {}
    WrittenQuestion.count(:group => 'status').each{|result|
      @statuses[result[0]] = result[1]
    }

    @questions = paginate params[:status]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  def written_questions_by_portfolio_index
    @portfolios = WrittenQuestion.count(:all, :group => "portfolio", :include => "portfolio", :order => "count_all desc")
  end

  def written_questions_by_portfolio
    portfolio = Portfolio.find_by_url params[:name]
    @questions = WrittenQuestion.paginate :page => params[:page], :conditions => ["portfolio_id = ?", portfolio.id], :order => "question_year desc, question_number desc", :per_page => PAGE_SIZE
  end

  def written_questions_by_asker_index
    @askers = WrittenQuestion.count(:all, :group => "asker", :include => "asker", :order => "count_all desc")
  end

  def written_questions_by_asker
    asker = Mp.find_by_id_name params[:name]
    @questions = WrittenQuestion.paginate :page => params[:page], :conditions => ["asker_id = ?", asker.id], :order => "question_year desc, question_number desc", :per_page => PAGE_SIZE
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
      WrittenQuestion.paginate :page => params[:page], :order => "question_year desc, question_number desc", :per_page => PAGE_SIZE
    else
      WrittenQuestion.paginate :page => params[:page], :conditions => ['status = ?', status.singularize], :order => "question_year desc, question_number desc", :per_page => PAGE_SIZE
    end
  end
end
