Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
end

if Rails.env.production?
  # see https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284
  OmniAuth.config.allowed_request_methods = [:post]
else
  OmniAuth.config.silence_get_warning = true
  OmniAuth.config.allowed_request_methods = [:get, :post]
end
