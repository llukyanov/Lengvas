RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Clearance ==
  config.parent_controller = "::ApplicationController"

  config.authorize_with do |controller|
    unless current_user && current_user.admin?
      redirect_to(
        '/sign_in'#,
        #alert:  "Hi #{current_user.name}!"
      )
    end
  end

  config.current_user_method(&:current_user)

  config.model 'User' do
    edit do
      field :password do
        help 'Required. Length of 8-128. <br />(leave blank if you don\'t want to change it)'.html_safe
      end
      field :password_confirmation do
        hide
      end
      include_all_fields
    end
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
