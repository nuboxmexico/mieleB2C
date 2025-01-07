class NewsletterSubscribersController < Spree::Admin::BaseController
    include Spree::Core::Engine.routes.url_helpers
    include Spree::Core::Engine.helpers
    include Spree::Core::ControllerHelpers
    include Spree::AuthenticationHelpers
    include Spree::Backend::Callbacks
    helper 'spree/admin/navigation'
    layout '/spree/layouts/admin'
    before_action :set_newsletter_subscriber, only: [:show, :edit, :update, :destroy]

    # GET /spree_newsletter_subscribers
    # GET /spree_newsletter_subscribers.json
    def index
      @newsletter_subscribers = NewsletterSubscriber.all
    end

    # GET /newsletter_subscribers/new
    def new
      @newsletter_subscriber = NewsletterSubscriber.new
    end

    # GET /newsletter_subscribers/id/edit
    def edit
    end
    
    # POST /newsletter_subscribers
    # POST /newsletter_subscribers.json
    def create
      @newsletter_subscriber = NewsletterSubscriber.new(newsletter_subscriber_params)

      respond_to do |format|
        if @newsletter_subscriber.unused_email?
          format.html { redirect_to '/newsletter_subscribers', alert: 'El correo se encuentra registrado' }
          format.json { render json: @newsletter_subscriber.errors, status: :unprocessable_entity }
        elsif @newsletter_subscriber.valid_email? and @newsletter_subscriber.save
          format.html { redirect_to '/newsletter_subscribers', notice: 'Se ha suscrito correctamente, pronto recibirá nuestras noticias.' }
          format.json { render :show, status: :created, location: @newsletter_subscriber }
        else
          format.html { redirect_to '/newsletter_subscribers', alert: 'Ha ocurrido un error inesperado' }
          format.json { render json: @newsletter_subscriber.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /newsletter_subscribers/1
    # PATCH/PUT /newsletter_subscribers/1.json
    def update
      respond_to do |format|
        @newsletter_subscriber.email = params[:newsletter_subscriber][:email]
        @newsletter_subscriber.active = params[:newsletter_subscriber][:active]
        if @newsletter_subscriber.save
          format.html { redirect_to '/newsletter_subscribers', notice: 'Se ha actualizado la subscripción.' }
          format.json { render :show, status: :ok, location: @newsletter_subscriber }
        else
          format.html { render :edit }
          format.json { render json: @newsletter_subscriber.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /newsletter_subscribers/1
    # DELETE /newsletter_subscribers/1.json
    def destroy
      if @newsletter_subscriber.destroy
        invoke_callbacks(:destroy, :after)
        flash[:success] =  Spree.t(:successfully_removed, resource: "El subscriptor ")
      else
        invoke_callbacks(:destroy, :fails)
        flash[:error] = @newsletter_subscriber.errors.full_messages.join(', ')
      end

      respond_with(@newsletter_subscriber) do |format|
        format.html { redirect_to location_after_destroy }
        format.js   { render_js_for_destroy }
      end
    end

    def download_all
      send_data NewsletterSubscriber.download_all_csv, type: "application/csv", filename: "Subscriptores_#{Date.today.strftime("%d-%m-%Y")}.csv"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_newsletter_subscriber
        @newsletter_subscriber = NewsletterSubscriber.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def newsletter_subscriber_params
        params.require(:newsletter_subscriber).permit(:email, :active)
      end
end

