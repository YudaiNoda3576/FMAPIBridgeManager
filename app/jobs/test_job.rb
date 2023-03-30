# frozen_string_literal: true

class TestJob
  include Sidekiq::Job
  def perform(text)
    p text
  end
end
