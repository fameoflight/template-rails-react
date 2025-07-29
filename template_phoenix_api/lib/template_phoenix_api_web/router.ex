defmodule TemplatePhoenixApiWeb.Router do
  use TemplatePhoenixApiWeb, :router

  pipeline :api do
    plug :accepts, ["json", "msgpack"]
    plug TemplatePhoenixApiWeb.Plugs.MsgpackParser
    plug CORSPlug, 
      origin: "*",
      max_age: 86400,
      headers: ["authorization", "content-type", "accept", "origin", "user-agent", "x-requested-with", "access-token", "token-type", "client", "expiry", "uid", "cache-control", "pragma", "if-modified-since", "if-none-match", "if-match", "if-unmodified-since", "if-range"],
      expose: ["access-token", "token-type", "client", "expiry", "uid"],
      methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"]
  end

  pipeline :auth do
    plug TemplatePhoenixApiWeb.Plugs.AuthPipeline
  end

  pipeline :optional_auth do
    plug TemplatePhoenixApiWeb.Plugs.OptionalAuth
  end

  pipeline :api_auth do
    plug TemplatePhoenixApiWeb.Plugs.ApiAuthPipeline
  end

  scope "/api", TemplatePhoenixApiWeb do
    pipe_through :api

    # Health check
    get "/health", HealthController, :index

    # Authentication routes
    post "/auth/register", AuthController, :register
    options "/auth/register", AuthController, :options
    post "/auth/login", AuthController, :login
    options "/auth/login", AuthController, :options
    post "/auth/confirm/:token", AuthController, :confirm
    options "/auth/confirm/:token", AuthController, :options
    post "/auth/resend_confirmation", AuthController, :resend_confirmation
    options "/auth/resend_confirmation", AuthController, :options
    post "/auth/forgot_password", AuthController, :forgot_password
    options "/auth/forgot_password", AuthController, :options
    post "/auth/reset_password", AuthController, :reset_password
    options "/auth/reset_password", AuthController, :options
    
    # Internal API routes
    scope "/internal", Internal do
      post "/users/google_login", UsersController, :google_login
      options "/users/google_login", UsersController, :options
    end
    
    # Legacy auth endpoint for frontend compatibility
    scope "/internal/auth" do
      post "/sign_in", AuthController, :login
      options "/sign_in", AuthController, :options
    end
  end

  scope "/api", TemplatePhoenixApiWeb do
    pipe_through [:api, :auth]

    # Protected routes
    get "/auth/me", AuthController, :me
    options "/auth/me", AuthController, :options
    delete "/auth/logout", AuthController, :logout
    options "/auth/logout", AuthController, :options
    
    
    # Internal API routes  
    scope "/internal", Internal do
      post "/users/avatar", UsersController, :avatar
      options "/users/avatar", UsersController, :options
    end
  end

  scope "/api", TemplatePhoenixApiWeb do
    pipe_through [:api, :optional_auth]

    # GraphQL endpoint
    post "/graphql", GraphqlController, :execute
    
    # Internal GraphQL endpoint with msgpack support
    scope "/internal" do
      post "/graphql.msgpack", GraphqlController, :execute
      options "/graphql.msgpack", GraphqlController, :options
      
      # DeviseTokenAuth compatible endpoints
      scope "/auth" do
        get "/validate_token", AuthController, :validate_token
        options "/validate_token", AuthController, :options
      end
    end
  end

  scope "/api/public/v1", TemplatePhoenixApiWeb.Api do
    pipe_through [:api, :api_auth]

    # API token protected routes
    get "/me", PublicController, :me
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:template_phoenix_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TemplatePhoenixApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
