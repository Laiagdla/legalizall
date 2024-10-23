# frozen_string_literal: true

# user data
class Player
  include ActiveModel::Model
  attr_accessor :body_weight, :height

  # Optional: Add validations if necessary
  validates :body_weight, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }

  # You can define custom methods or logic as needed
  def bmi
    return nil if body_weight.nil? || height.nil?

    if height > 3
      (body_weight / ((height / 100)**2)).round(2)
    else
      (body_weight / (height**2)).round(2)
    end
  end
end
