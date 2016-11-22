class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

	def index
		#@micropost = current_user.microposts.build
    #	@feed_items = current_user.microposts
     @microposts = Micropost.paginate(page: params[:page], per_page: 50)
	end

	def create
		@micropost = current_user.microposts.build(micropost_params)
	    if @micropost.save
	      flash[:success] = "Micropost created!"
	      redirect_to root_url
	    else
	      @feed_items = []
	      render 'index/home'
	    end
	end

	def destroy
		@micropost.destroy
	    flash[:success] = "Micropost deleted"
	    redirect_to request.referrer || root_url
	end

    def correct_user
    	@micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end

    def show 
    	# binding.pry
    	@micropost = Micropost.find_by(id: params[:id])
	    @comments  = @micropost.comments.paginate(page: params[:page])
	    @comment = Comment.new
	    #@micropost = Micropost.includes(:comments).find_by_id params[:id] @comment = Comment.new
    end

    private

	    def micropost_params
	        params.require(:micropost).permit(:content, :picture)
	    end
	    def correct_user
	    	@micropost = current_user.microposts.find_by(id: params[:id])
	      	redirect_to root_url if @micropost.nil?
	    end

end
