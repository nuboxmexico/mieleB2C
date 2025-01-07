module Spree
	StoreController.class_eval do
	   def cart_link
	      render partial: 'spree/shared/link_to_cart_custom'
	      #fresh_when(simple_current_order)
	    end

	    def newsletter
	    	@newsletter_subscriber = NewsletterSubscriber.new
	    	@newsletter_subscriber.email = params[:newsletter_subscriber][:email]
	    	@newsletter_subscriber.active = params[:newsletter_subscriber][:active]
	    	respond_to do |format|
	        if @newsletter_subscriber.unused_email?
	          format.html { redirect_to request.env["HTTP_REFERER"], alert: 'El correo se encuentra registrado' }
	          format.json { render json: @newsletter_subscriber.errors, status: :unprocessable_entity }
	        elsif @newsletter_subscriber.valid_email? and @newsletter_subscriber.save
	          format.html { redirect_to :back, notice: 'Se ha suscrito correctamente, pronto recibirá nuestras noticias.' }
	          format.json { render :show, status: :created, location: @newsletter_subscriber }
	        else
	          format.html { redirect_to request.env["HTTP_REFERER"], alert: 'Ha ocurrido un error inesperado' }
	          format.json { render json: @newsletter_subscriber.errors, status: :unprocessable_entity }
	        end
	      end
	    end

	    def privacy_policy
	    end

	    def returns_policy
	    end

	    def maps_and_address
	    end

	   	def about
	   	end

	   	def info_delivery
			
		end
	   	
	   	def new_contact

			@title = "Hablemos "
			@message = Message.new
			@taxonomies = Spree::Taxonomy.includes(root: :children)
		end

		def send_email_contact
			@message = Message.new(params[:message])
			respond_to do |format|
				if verify_recaptcha(model: @message) and ContactMailer.send_contact_to_section(@message).deliver_later
					format.html{ redirect_to request.env["HTTP_REFERER"], notice: 'Formulario de contacto enviado con éxito!'}
				else
					format.html{ redirect_to request.env["HTTP_REFERER"], alert: 'Hubo un problema al enviar el formulario. Vuelva a intentarlo.'}
				end
			end
		end
	end
end

