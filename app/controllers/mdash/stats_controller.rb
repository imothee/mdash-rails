module Mdash
  class StatsController < ApplicationController
    def index
      render json: {
        stats: Mdash.stats,
        last_updated: Mdash.last_updated
      }.as_json
    end
  end
end