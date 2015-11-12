class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        message = find_message(:signed_up)
        flash[:notice] = message
        sign_up(resource_name, resource)
        if request.xhr?
          return render :json => {:success => true, :data =>  {:message => message}}
        else
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        message = find_message(:"signed_up_but_#{resource.inactive_message}" )
        expire_data_after_sign_in!
        if request.xhr?
         return render :json => {:success => true, :data =>  {:message => message}}
        else
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      end
    else
      clean_up_passwords resource
      messages = resource.errors.messages
      if request.xhr?
       return render :json => {:success => false, :data =>  {:message => messages}}
      else
        respond_with resource
      end
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
