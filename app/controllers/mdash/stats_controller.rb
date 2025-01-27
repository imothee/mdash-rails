module Mdash
  class StatsController < ApplicationController
    def index
      @stats = Mdash.stats
      render json: @stats
    end
  end
end