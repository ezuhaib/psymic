class TagsController < ApplicationController

# Currently there's no original page for taggings, one
# may be created in future

def show
redirect_to controller: 'mindlogs', action: 'index', query: params[:tag]
end

end