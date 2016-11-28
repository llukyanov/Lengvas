class SessionsController < Clearance::SessionsController

	def new
		if signed_in?
			if current_user.present? and current_user.admin?  
				redirect_to '/admin'
			else
				redirect_to sign_out_path
			end
		else
			render template: 'sessions/new'
		end
	end
end