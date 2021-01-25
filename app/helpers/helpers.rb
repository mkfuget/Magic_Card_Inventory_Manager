

class Helpers

    def self.current_user(session)
      User.find(session[:user_id])
    end
  
    def self.is_logged_in?(session)
      !!session[:user_id]
    end

    def self.checked_logged_in(session)
        if !is_logged_in?(session)
            flash[:message] = "Please sign up or login to view that page"
            redirect to('/')
        end
    end
  end
  