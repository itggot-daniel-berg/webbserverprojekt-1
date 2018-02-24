class Main < Sinatra::Base

    enable :sessions

    get '/' do
        @items = Item.get()
        slim :home
    end
        slim :shop
    end

    get '/log-in' do
        slim :'log-in'
    end

    post '/log-in' do
        email = params['inputEmail']
        password = params['inputPassword']

        if User.authenticate(email, password, session)
            redirect '/'
        else
            redirect '/log-in'
        end
    end

    get '/register' do
        slim :register
    end

    post '/register' do
        username = params['inputUsername']
        email = params['inputEmail']
        password = params['inputPassword']

        if User.create(username, email, password, session)
            redirect '/'
        else
            redirect '/register'
        end
    end

    get '/log-out' do
        session.destroy
        redirect '/log-in'
    end

    get '/my-profile' do
        if session[:id]
            @user = User.get(session[:id].to_i)
            slim :'my-profile'
        else
            redirect '/log'
        end
    end

    get '/items' do
        redirect '/'
    end

    get '/items/:id' do
        id = params[:id].to_i
        @items = Item.get_merch(id)
        slim :show
    end

    get '/about' do
        slim :about
    end

    get '/cart' do
        if session[:id]
            @cart = Cart.get(session[:cart], session[:id])
            @items = []
            @cart.each do |x|
                @items << Item.new(x)
            end
            slim :cart
        else
            redirect '/log-in'
        end
    end

    post '/cart' do
        if session[:id]
            item = params['item']

            if item == nil
                redirect '/shop'
            end

            if Cart.add(item, session)
                redirect '/shop'
            else
                redirect '/shop'
            end

        else
            redirect '/log-in'
        end
    end

    # Admin
    get '/admin' do
        if session[:admin]
            slim :'admin/admin'
        else
            redirect '/log-in'
        end
    end

    get '/admin/brands' do
        if session[:admin]
            slim :'admin/brands'
        else
            redirect '/log-in'
        end
    end

    get '/admin/items' do
        if session[:admin]
            slim :'admin/items'
        else
            redirect '/log-in'
        end
    end

end