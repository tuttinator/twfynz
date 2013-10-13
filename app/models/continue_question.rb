# encoding: UTF-8
class ContinueQuestion < Question

  alias_method :original_is_question?, :is_question?

  def is_question?
    false
  end
end
