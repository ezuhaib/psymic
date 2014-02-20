class RegistrationsController < Devise::RegistrationsController
# Overriding Devise Internal Registerations Controller

  protected

    def after_update_path_for(resource)
      user_path(resource)
    end
end