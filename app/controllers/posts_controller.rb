# frozen_string_literal: true

class PostsController < ApplicationController
  include CustomControllerHelpers

  def create
    if IPFilter.by_ip(request.remote_ip).take_action?(:block_posting)
      render_jsonapi_error(400, 'Your IP address has been blocked from posting')
    else
      super
    end
  end
end
