Rails.application.routes.draw do
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'

    namespace :api, defaults: { format: :json } do
        scope "(:version)", :version => /v1/, module: :v1 do
            match 'validate/:did', to: 'validations#did',      via: 'get', constraints: {did: /.*/}
            match 'validate',      to: 'validations#document', via: 'post'
            match 'resolve/:did',  to: 'validations#resolve',  via: 'get', constraints: {did: /.*/}

        end
        # template for multiple versions
        # scope "v1", module: :v1 do
        #     match 'active',             to: 'resources#active',       via: 'get'
        # end
        # scope "(:version)", :version => /v2/, module: :v2 do    # default version
        #     match 'active',             to: 'resources#active2',       via: 'get'
        # end
    end

    # UI
    root 'static_pages#home'
    match 'home',       to: 'static_pages#home',     via: 'get'
    match '/resolve',   to: 'static_pages#resolve',  via: 'post'
    match '/validate',  to: 'static_pages#validate', via: 'post'
    match '/validate',  to: 'static_pages#resolve_and_validate', via: 'get'

    # administrative
    # root 'application#home'
    # match '/',          to: 'application#home',    via: 'get'
    match '/version',   to: 'application#version', via: 'get'
    match ':not_found', to: 'application#missing', via: [:get, :post], :constraints => { :not_found => /.*/ }

end
