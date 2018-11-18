class Task < ApplicationRecord
  
  #before_validation :set_nameless_name  
  validates :name, presence: true      # 「スケジュール名：name」は必須
  validates :name, length: {maximum: 30} # 「スケジュール名：name」は30文字以内 

  belongs_to :user

  # scope method
  scope :recent, -> { order(created_at: :desc) }


  private
    def set_nameless_name
      self.name = '名無しの権兵衛' if name.blank?
    end
end