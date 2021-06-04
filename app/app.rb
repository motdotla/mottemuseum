class Mottemuseum < Padrino::Application
  set :haml, :format => :html5 # sets haml to html5  
  
  PUBLIC_STRIPE_API_KEY   = ENV['PUBLIC_STRIPE_API_KEY']
  PRIVATE_STRIPE_API_KEY  = ENV['PRIVATE_STRIPE_API_KEY']
  CONTACT_EMAIL           = "info@mottemuseum.com"
  SUPPORT_EMAIL           = "scott@scottmotte.com"

  configure do
    register Padrino::Mailer
    register Padrino::Helpers

    Stripe.api_key = PRIVATE_STRIPE_API_KEY

    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'heroku.com',
        :user_name => ENV['SENDGRID_USERNAME'],
        :password => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    }
  end
  
  get "/" do
    render :index
  end

  get "/about" do
    render :about
  end

  get "/carcollection" do
    render :carcollection
  end

  get "/carcollection/:slug" do
    render :"carcollection/#{params[:slug]}"
  end

  get "/rentalfacility" do
    render :rentalfacility
  end

  get "/visit" do
    render :visit
  end

  get "/contact" do
    render :contact
  end
  
  get "/donate" do
    render :donate
  end

  get "/pay" do
    render :pay, :layout => "layouts/pay"
  end

  post "/pay" do
    amount = convert_amount_to_float(params[:amount])
    if is_number?(amount)
      begin
        amount = (amount*100).to_i
        @charge = Stripe::Charge.create(:amount => amount, :currency => "usd", :card => params[:stripeToken], :description => params[:description])
        
        @receipt_text = "Thank you for your payment. You have been charged $#{@charge.amount / 100.0} to your #{@charge.card.type} ending in #{@charge.card.last4}.\n\n#{params[:description]}\n\nPlease keep this as your receipt.\n\nThank You, Motte Historical Museum"

        Pony.mail(
          :to       => (params[:email].blank? ? CONTACT_EMAIL : params[:email]),
          :bcc      => CONTACT_EMAIL,
          :from     => CONTACT_EMAIL,
          :subject  => '[Motte Historical Museum Receipt] Your payment was successful.',
          :body     => @receipt_text
        )

        render :thanks, :layout => "layouts/pay"
      rescue => e
        @backtrace = e.backtrace.join("\n")
        Pony.mail(
          :to       => SUPPORT_EMAIL, 
          :bcc      => CONTACT_EMAIL,
          :from     => CONTACT_EMAIL,
          :subject  => '[Motte Historical Museum Receipt ERROR!]',
          :body     => "There was an error that went like this: #{@backtrace}"
        )

        render :error, :layout => "layouts/pay"
      end
    else
      redirect "/pay"
    end
  end

  private

  def is_number?(i)
    true if Float(i) rescue false
  end

  def convert_amount_to_float(amount)
    amount.to_s.gsub(/\$|\,/, "").to_f
  end
end
