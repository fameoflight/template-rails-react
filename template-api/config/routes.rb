# == Route Map
#
#                                   Prefix Verb    URI Pattern                                                                                       Controller#Action
#                           graphiql_rails         /graphiql                                                                                         GraphiQL::Rails::Engine {:graphql_path=>"/graphql"}
#                               api_health GET     /api/health(.:format)                                                                             api/health#index
#            new_api_internal_user_session GET     /api/internal/auth/sign_in(.:format)                                                              api/internal/auth/sessions#new
#                api_internal_user_session POST    /api/internal/auth/sign_in(.:format)                                                              api/internal/auth/sessions#create
#        destroy_api_internal_user_session DELETE  /api/internal/auth/sign_out(.:format)                                                             api/internal/auth/sessions#destroy
#           new_api_internal_user_password GET     /api/internal/auth/password/new(.:format)                                                         devise_token_auth/passwords#new
#          edit_api_internal_user_password GET     /api/internal/auth/password/edit(.:format)                                                        devise_token_auth/passwords#edit
#               api_internal_user_password PATCH   /api/internal/auth/password(.:format)                                                             devise_token_auth/passwords#update
#                                          PUT     /api/internal/auth/password(.:format)                                                             devise_token_auth/passwords#update
#                                          POST    /api/internal/auth/password(.:format)                                                             devise_token_auth/passwords#create
#    cancel_api_internal_user_registration GET     /api/internal/auth/cancel(.:format)                                                               api/internal/auth/registrations#cancel
#       new_api_internal_user_registration GET     /api/internal/auth/sign_up(.:format)                                                              api/internal/auth/registrations#new
#      edit_api_internal_user_registration GET     /api/internal/auth/edit(.:format)                                                                 api/internal/auth/registrations#edit
#           api_internal_user_registration PATCH   /api/internal/auth(.:format)                                                                      api/internal/auth/registrations#update
#                                          PUT     /api/internal/auth(.:format)                                                                      api/internal/auth/registrations#update
#                                          DELETE  /api/internal/auth(.:format)                                                                      api/internal/auth/registrations#destroy
#                                          POST    /api/internal/auth(.:format)                                                                      api/internal/auth/registrations#create
#       new_api_internal_user_confirmation GET     /api/internal/auth/confirmation/new(.:format)                                                     devise_token_auth/confirmations#new
#           api_internal_user_confirmation GET     /api/internal/auth/confirmation(.:format)                                                         devise_token_auth/confirmations#show
#                                          POST    /api/internal/auth/confirmation(.:format)                                                         devise_token_auth/confirmations#create
#         api_internal_auth_validate_token GET     /api/internal/auth/validate_token(.:format)                                                       devise_token_auth/token_validations#validate_token
#                api_internal_users_avatar POST    /api/internal/users/avatar(.:format)                                                              api/internal/users#avatar
#          api_internal_users_google_login POST    /api/internal/users/google_login(.:format)                                                        api/internal/users#google_login
#                     api_internal_graphql POST    /api/internal/graphql(.:format)                                                                   api/internal/graphql#execute {:format=>:json}
#                         api_public_v1_me GET     /api/public/v1/me(.:format)                                                                       api/public/v1/me#index {:format=>"json"}
#                                          OPTIONS /*path(.:format)                                                                                  application#cors_preflight_check
#         turbo_recede_historical_location GET     /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET     /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET     /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST    /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST    /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST    /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET     /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST    /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET     /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#            rails_conductor_inbound_email GET     /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                          PATCH   /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          PUT     /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                          DELETE  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
# new_rails_conductor_inbound_email_source GET     /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST    /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST    /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST    /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET     /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET     /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET     /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET     /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET     /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET     /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET     /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT     /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST    /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for GraphiQL::Rails::Engine:
#        GET  /           graphiql/rails/editors#show

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  devise_for :users, skip: :all

  namespace :api do
    get 'health', to: 'health#index'

    namespace :internal do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/internal/auth/registrations',
        sessions: 'api/internal/auth/sessions'
      }
      post 'users/avatar'
      post 'users/google_login'
      post '/graphql', to: 'graphql#execute', defaults: { format: :json }
    end

    namespace :public, defaults: { format: 'json' } do
      namespace :v1 do
        get 'me', to: 'me#index'
      end
    end
  end

  options '*path', to: 'application#cors_preflight_check'
end
