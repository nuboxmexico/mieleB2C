module Spree
  module Admin
    ReportsController.class_eval do
      require 'date'
      require 'axlsx_rails'
      require 'axlsx'
      require 'roo'
      def dashboard

        # Para tarjetas
        month = Date.today.strftime("%m")
        year = Date.today.strftime("%Y")
        
        @new_orders = Spree::Order.where('extract(month from completed_at) = ?',month).where('extract(year from completed_at) = ?',year).count
        @new_users = Spree::User.where('extract(month from created_at) = ?',month).where('extract(year from created_at) = ?',year).count
        @all_users = Spree::User.all.count
        orders = Spree::Order.where(state: "complete")
        month_orders = Spree::Order.where(completed_at: (Time.zone.now.beginning_of_month.at_beginning_of_month)..(Time.zone.now.beginning_of_month.end_of_month))
        @total, @letter_t = short_format(total_ammount(orders).to_i)
        @visitors = Visit.where(user_id: nil).count(:id)
        @returners =  Visit.where.not(user_id: nil).count(:id)
        total_visits = Visit.all.size
        sell_visits = Visit.joins(:orders).size
        if(total_visits > 0 && sell_visits > 0 )
          @conversion = ((sell_visits.to_f/total_visits)*100).round(2)
        else
          @conversion = 0
        end
        #Visit.where(user_id: nil).group(:user_id).count(:id).to_a
        #Visit.where.not(user_id: nil).count(:id)
        #Visit.group(:user_id).count(:id).to_a
        ## Para grafico
        @mont_total, @letter_m = short_format(total_ammount(month_orders).to_i)
        months = []
        (0..5).each do |n|
          months[n] = l((Date.today - n.month), format: "%B")
        end
        @ammount_by_month = {}
        n = 0

        if months.any?  
          months.each do |month|
            month_orders = Spree::Order.where(completed_at: (Time.zone.now.beginning_of_month.at_beginning_of_month - n.month)..(Time.zone.now.beginning_of_month.end_of_month- n.month))
            month_orders = month_orders.where(state: "complete")
            @ammount_by_month[month] = total_ammount(month_orders)
            n+=1
          end
        end
        
        ## Para progress bar
        num_orders = Spree::Order.all.count
        if num_orders > 0
          @complete = ((Spree::Order.where(state: "complete").count).to_f/num_orders*100).round
          @cart = ((Spree::Order.where(state: "cart").count).to_f/num_orders*100).round
          @address = ((Spree::Order.where(state: "address").count).to_f/num_orders*100).round
          @delivery = ((Spree::Order.where(state: "delivery").count).to_f/num_orders*100).round
          @payment = ((Spree::Order.where(state: "payment").count).to_f/num_orders*100).round
        else
          @complete = 0
          @cart = 0
          @address = 0
          @delivery = 0
          @payment = 0
        end
        # carritos abandonados
        if @complete > 0
          @abandoned = 100 - @complete
        else
          @abandoned = 0
        end
        #ticket promedio de compra
        if @new_orders > 0
          @avg_ticket, @letter_avg = short_format((Spree::Order.where('extract(month from completed_at) = ?',month).where('extract(year from completed_at) = ?',year).sum(:total).to_i / @new_orders ))
        end
        # tasa recompra
        # loyal_users = Spree::User.where.not('extract(month from created_at) = ?',month)
        #                          .where('extract(year from created_at) = ?',year)
        #                          .select{ |user| !user.admin? }
        # loyal_users_purchases = loyal_users.sort_by { |k| k.orders.where(state: "complete") }
        # if loyal_users.count != 0
        #   @repurchase = ((loyal_users_purchases.count / loyal_users.count)*100).round(2)
        # else
        #   @repurchase = 0
        # end

         ### Ultimas 4 órdenes
         @orders = Spree::Order.where('extract(month from created_at) = ?',month).where('extract(year from created_at) = ?',year).order(created_at: :desc).limit(4)

        ### Productos más vendidos
        most_seller = Spree::Product.most_seller
        @top_sellers = {}
        n = 0
        if most_seller.any?
          most_seller.each do |unit|
            @top_sellers[n]    = []
            @top_sellers[n][0] = unit[1]
            @top_sellers[n][1] = unit[2]
            n+=1
          end
        end

        ### Ventas por Provincia
        @sales_for_states = {}
        Spree::Country.find_by(name: 'Chile').states.each_with_index do |s, i|
          @sales_for_states[i]    = []
          @sales_for_states[i][0] = s.name                                                                                              # Provincia
          @sales_for_states[i][1] = Spree::Order.where(state: "complete").joins(:bill_address).where(bill_address: { state: s } ).count # Cantidad de ventas
        end
      end

      def promotions
        @promotions = Spree::Promotion.order('created_at DESC').page params[:page]
      end

      def promotions_pdf
        promotions = Spree::Promotion.order('created_at DESC')
        pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
        :template => 'spree/admin/reports/promotions.html.pdf.erb',
        :margin => { :top => 0,
          :left => 0,
          :right => 0
        },
        :footer => {
          :content => render_to_string('spree/layouts/footer.html.pdf.erb')
        },
        :locals => {:tittle => "Informe de uso de cupones de descuento (promociones)",
          :promotions => promotions
        }

        send_data(pdf, :filename => 'promotions%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")
      end

      def download_promotions
        @promotions = Spree::Promotion.order('created_at DESC').page params[:page]
        respond_to do |format|
          format.xlsx {render xlsx: 'download_promotions', filename: "plantilla_uso_de_cupones_de_descuento#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
        end
      end
      
      def sales_product_total
        params[:q] = {} unless params[:q]


        if params[:q][:completed_at_gt].blank?
          params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end
        if !params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day
        end
        if !params[:q][:completed_at_gt].blank? && params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = Time.zone.now.end_of_month
        end

        params[:q][:s] ||= "completed_at desc"
        

        @search = Spree::Product.where(discontinue_on: nil).ransack(params[:q])
        
        products = Spree::Product.where(discontinue_on: nil)
        @product_array = []
        
        products.each do |product_t|
          if !params[:q][:completed_at_gt].blank?
           amount = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:q][:completed_at_gt]..params[:q][:completed_at_lt] }).where(product: { id: product_t.id }).to_a.sum(&:amount).to_i
           quantity = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:q][:completed_at_gt]..params[:q][:completed_at_lt] }).where(product: { id: product_t.id }).to_a.sum(&:quantity).to_i
         else 
           amount = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product_t.id }).to_a.sum(&:amount).to_i  
           quantity = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product_t.id }).to_a.sum(&:quantity).to_i  
         end 
         temp_a = {
          "sku" => product_t.sku,
          "product" => product_t.name,
          "amount" => amount,
          "quantity" => quantity
        }
        @product_array << temp_a
      end
      @product_array = @product_array.sort_by { |k| k["amount"] }
      @product_array = @product_array.reverse
    end
    def sales_product_total_pdf
      p params[:gt]
      params[:gt] = {} unless params[:gt]
      params[:lt] = {} unless params[:lt]
      dates = []
      if params[:gt].blank?
      else
        params[:gt] = Time.zone.parse(params[:gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        dates << params[:gt].to_date.strftime("%d/%m/%Y")
      end
      if params[:gt] && !params[:lt].blank?
        params[:lt] = Time.zone.parse(params[:lt]).end_of_day rescue ""
        dates << params[:lt].to_date.strftime("%d/%m/%Y")
      end
      products = Spree::Product.where(discontinue_on: nil)
      product_array = []
      products.each do |product|
        begin
         amount = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:gt]..params[:lt] }).where(product: { id: product.id }).to_a.sum(&:amount).to_i
         quantity = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:gt]..params[:lt] }).where(product: { id: product.id }).to_a.sum(&:quantity).to_i
       rescue 
         amount = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product.id }).to_a.sum(&:amount).to_i  
         quantity = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product.id }).to_a.sum(&:quantity).to_i  
       end 
       temp_a = {
        "sku" => product.sku,
        "product" => product.name,
        "amount" => amount,
        "quantity" => quantity
      }
      product_array << temp_a
    end
    product_array = product_array.sort_by { |k| k["amount"] }
    product_array = product_array.reverse
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/sales_product_total.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de ventas de productos",
      :product_array => product_array,
      :dates => dates
    }

    send_data(pdf, :filename => 'sales_product_total%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")

  end

  def download_sales_product_total
    params[:gt] = {} unless params[:gt]
    params[:lt] = {} unless params[:lt]
    if !params[:gt].blank?
      params[:gt] = Time.zone.parse(params[:gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:gt] && !params[:lt].blank?
      params[:lt] = Time.zone.parse(params[:lt]).end_of_day rescue ""
    end
    products = Spree::Product.where(discontinue_on: nil)
    @product_array = []
    products.each do |product|
      begin
       amount = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:gt]..params[:lt] }).where(product: { id: product.id }).to_a.sum(&:amount).to_i
       quantity = Spree::LineItem.joins(:product, :order).where(order: { :completed_at => params[:gt]..params[:lt] }).where(product: { id: product.id }).to_a.sum(&:quantity).to_i
      rescue 
       amount = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product.id }).to_a.sum(&:amount).to_i  
       quantity = Spree::LineItem.joins(:product, :order).where(order: { state: "complete" }).where(product: { id: product.id }).to_a.sum(&:quantity).to_i  
      end 
      temp_a = {
       "sku" => product.sku,
       "product" => product.name,
       "amount" => amount,
       "quantity" => quantity
      }
      @product_array << temp_a
    end
    @product_array = @product_array.sort_by { |k| k["amount"] }
    @product_array = @product_array.reverse
    respond_to do |format|
			format.xlsx {render xlsx: 'download_sales_product_total', filename: "plantilla_venta_de_productos#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def viewed_product_total
    products = Spree::Product.where(discontinue_on: nil)
    total_viewed = products.sum(:viewed_count) 
    @product_array = []
    products.each do |product|
      temp_a = {
        "sku" => product.master.sku,
        "product" => product.name,
        "count" => product.viewed_count,
        "percent" => ((product.viewed_count.to_f/total_viewed)*100).round(1)
      }
      @product_array << temp_a
    end
    @product_array = @product_array.sort_by { |k| k["count"] }
    @product_array = @product_array.reverse
  end

  def viewed_product_total_pdf
    products = Spree::Product.where(discontinue_on: nil)
    total_viewed = products.sum(:viewed_count) 
    product_array = []
    products.each do |product|
      temp_a = {
        "sku" => product.master.sku,
        "product" => product.name,
        "count" => product.viewed_count,
        "percent" => ((product.viewed_count.to_f/total_viewed)*100).round(1)
      }
      product_array << temp_a
    end
    product_array = product_array.sort_by { |k| k["count"] }
    product_array = product_array.reverse
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/viewed_product_total.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de productos vistos",
      :product_array => product_array
    }

    send_data(pdf, :filename => 'viewed_product_total%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")
  end

  def download_viewed_product_total
    products = Spree::Product.where(discontinue_on: nil)
    total_viewed = products.sum(:viewed_count) 
    @product_array = []
    products.each do |product|
      temp_a = {
        "sku" => product.master.sku,
        "product" => product.name,
        "count" => product.viewed_count,
        "percent" => ((product.viewed_count.to_f/total_viewed)*100).round(1)
      }
      @product_array << temp_a
    end
    @product_array = @product_array.sort_by { |k| k["count"] }
    @product_array = @product_array.reverse
    respond_to do |format|
			format.xlsx {render xlsx: 'download_viewed_product_total', filename: "plantilla_productos_vistos#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def loyal_customers
    orders = Spree::Order.where(payment_state: 'paid').order(:email)
    buyers_email = orders.map(&:email).uniq    
    @buyers = []
    buyers_email.each do |buyer|
      buyer_orders = Spree::Order.where(email: buyer, payment_state: 'paid')
      data = {}
      user = Spree::User.find_by(email: buyer)
      data['user_id'] = user ? user.id : 0 
      data['email'] = buyer
      data['first_order'] = buyer_orders.first.completed_at
      data['last_order'] = buyer_orders.last.completed_at
      data['count'] = buyer_orders.count
      data['total'] = buyer_orders.average(:total)
      @buyers << data
    end
  end

  def loyal_customers_pdf
    users = Spree::User.all.select{ |user| !user.admin? }
    users = users.sort_by { |k| k.orders.where(state: "complete").average(:total).to_i }
    users = users.reverse
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/loyal_customers.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de fidelidad de clientes",
      :users => users
    }

    send_data(pdf, :filename => 'loyal_customers%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")

  end

  def download_loyal_customers
    orders = Spree::Order.where(payment_state: 'paid').order(:email)
    buyers_email = orders.map(&:email).uniq    
    @buyers = []
    buyers_email.each do |buyer|
      buyer_orders = Spree::Order.where(email: buyer, payment_state: 'paid')
      data = {}
      data['email'] = buyer
      data['first_order'] = buyer_orders.first.completed_at
      data['last_order'] = buyer_orders.last.completed_at
      data['count'] = buyer_orders.count
      data['total'] = buyer_orders.average(:total)
      @buyers << data
    end
    respond_to do |format|
			format.xlsx {render xlsx: 'download_loyal_customers', filename: "plantilla_fidelidad_de_clientes#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def customers_over_time
    current_month = Date.today.month
    current_year = Date.today.year

    @last_year = []
    @users = 0
    @orders = 0
    @total = 0
    (1..12).each do |n|
      temp_orders = Spree::Order.where('extract(month from completed_at) = ?', n)
      temp_users = Spree::User.where('extract(month from created_at) = ?', n)
      if(current_month < n)
        current_year = Date.today.year - 1
      end  
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "orders" => temp_orders,
        "users" => temp_users,
        "date" => DateTime.new(current_year, n, 1)
      }
      @users = @users + temp_users.size
      @orders = @orders + temp_orders.size
      @total = @total + temp_orders.sum(:total)
      @last_year << temp 
    end
    @last_year = @last_year.sort_by {|x| x["date"]}
  end

  def customers_over_time_pdf
    current_month = Date.today.month
    current_year = Date.today.year
    last_year = []
    users = 0
    orders = 0
    total = 0
    (1..12).each do |n|
      temp_orders = Spree::Order.where('extract(month from completed_at) = ?', n)
      temp_users = Spree::User.where('extract(month from created_at) = ?', n)
      if(current_month < n)
        current_year = Date.today.year - 1
      end  
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "orders" => temp_orders,
        "users" => temp_users,
        "date" => DateTime.new(current_year, n, 1)
      }
      users = users + temp_users.size
      orders = orders + temp_orders.size
      total = total + temp_orders.sum(:total)
      last_year << temp 
    end
    last_year = last_year.sort_by {|x| x["date"]}
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/customers_over_time.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de clientes y ventas a lo largo del año",
      :last_year => last_year,
      :users => users,
      :orders => orders,
      :total => total
    }

    send_data(pdf, :filename => 'customers_over_time%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")

  end

  def download_customers_over_time
    current_month = Date.today.month
    current_year = Date.today.year

    @last_year = []
    @users = 0
    @orders = 0
    @total = 0
    (1..12).each do |n|
      temp_orders = Spree::Order.where('extract(month from completed_at) = ?', n)
      temp_users = Spree::User.where('extract(month from created_at) = ?', n)
      if(current_month < n)
        current_year = Date.today.year - 1
      end  
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "orders" => temp_orders,
        "users" => temp_users,
        "date" => DateTime.new(current_year, n, 1)
      }
      @users = @users + temp_users.size
      @orders = @orders + temp_orders.size
      @total = @total + temp_orders.sum(:total)
      @last_year << temp 
    end
    @last_year = @last_year.sort_by {|x| x["date"]}
    respond_to do |format|
			format.xlsx {render xlsx: 'download_customers_over_time', filename: "plantilla_clientes_último_año#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def visits_over_time
    current_month = Date.today.month
    current_year = Date.today.year
    @last_year = []
    @sessions = 0
    @visits = 0
    (1..12).each do |n|
      temp_sessions = Visit.where('extract(month from started_at) = ?', n).where.not(user_id: nil)
      temp_visits = Visit.where('extract(month from started_at) = ?', n).where(user_id: nil)
      if(current_month < n)
        current_year = Date.today.year - 1
      end  
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "sessions" => temp_sessions.size,
        "visits" => temp_visits.size,
        "date" => DateTime.new(current_year, n, 1)
      }
      @sessions = @sessions + temp_sessions.size
      @visits = @visits + temp_visits.size
      @last_year << temp 
    end
    @last_year = @last_year.sort_by {|x| x["date"]}
  end

  def visits_over_time_pdf
    current_month = Date.today.month
    current_year = Date.today.year
    last_year = []
    sessions = 0
    visits = 0
    (1..12).each do |n|
      temp_sessions = Visit.where('extract(month from started_at) = ?', n).where.not(user_id: nil)
      temp_visits = Visit.where('extract(month from started_at) = ?', n).where(user_id: nil)
      if(current_month < n)
        current_year = Date.today.year - 1
      end 
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "sessions" => temp_sessions.size,
        "visits" => temp_visits.size,
        "date" => DateTime.new(current_year, n, 1)
      }
      sessions = sessions + temp_sessions.size
      visits = visits + temp_visits.size
      last_year << temp 
    end
    last_year = last_year.sort_by {|x| x["date"]}
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/visits_over_time.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de visitas en el ecommerce",
      :last_year => last_year,
      :sessions => sessions,
      :visits => visits
    }

    send_data(pdf, :filename => 'visits_over_time%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf") 
  end

  def download_visits_over_time
    current_month = Date.today.month
    current_year = Date.today.year
    @last_year = []
    @sessions = 0
    @visits = 0
    (1..12).each do |n|
      temp_sessions = Visit.where('extract(month from started_at) = ?', n).where.not(user_id: nil)
      temp_visits = Visit.where('extract(month from started_at) = ?', n).where(user_id: nil)
      if(current_month < n)
        current_year = Date.today.year - 1
      end  
      temp = {
        "month" => (I18n.t("date.month_names")[n] +" "+ current_year.to_s),
        "sessions" => temp_sessions.size,
        "visits" => temp_visits.size,
        "date" => DateTime.new(current_year, n, 1)
      }
      @sessions = @sessions + temp_sessions.size
      @visits = @visits + temp_visits.size
      @last_year << temp 
    end
    @last_year = @last_year.sort_by {|x| x["date"]}
    respond_to do |format|
			format.xlsx {render xlsx: 'download_visits_over_time', filename: "plantilla_visitas_último_año#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def visits_by_page
    params[:q] = {} unless params[:q]

    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day
    end
    if !params[:q][:completed_at_gt].blank? && params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.now.end_of_month
    end
    params[:q][:s] ||= "started_at desc"
    
    @search = Visit.ransack(params[:q])

    @visits = Visit.where(started_at: params[:q][:completed_at_gt]..params[:q][:completed_at_lt]).group(:landing_page).count(:landing_page).to_a
    @visits = @visits.sort_by { |k| k[1] }
    @visits = @visits.reverse
    @visits = Kaminari.paginate_array(@visits).page(params[:page]).per(10)
  end

  def visits_by_page_pdf
    visits = Visit.group(:landing_page).count(:landing_page).to_a
    visits = visits.sort_by { |k| k[1] }
    visits = visits.reverse
    pdf =    render_to_string :pdf => 'Reporte %s' % Time.now,
    :template => 'spree/admin/reports/visits_by_page.html.pdf.erb',
    :margin => { :top => 0,
      :left => 0,
      :right => 0
    },
    :footer => {
      :content => render_to_string('spree/layouts/footer.html.pdf.erb')
    },
    :locals => {:tittle => "Informe de páginas visitadas por clientes",
      :visits => visits
    }

    send_data(pdf, :filename => 'visits_by_page%s.pdf' % Time.now,:disposition => 'inline',  :type=>"application/pdf")

  end

  def download_visits_by_page
    params[:gt] = {} unless params[:gt]
    params[:lt] = {} unless params[:lt]
    if !params[:gt].blank?
      params[:gt] = Time.zone.parse(params[:gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:gt] && !params[:lt].blank?
      params[:lt] = Time.zone.parse(params[:lt]).end_of_day rescue ""
    end
    
    @visits = Visit.where(started_at: params[:gt]..params[:lt]).group(:landing_page).count(:landing_page).to_a
    @visits = @visits.sort_by { |k| k[1] }
    @visits = @visits.reverse
    respond_to do |format|
			format.xlsx {render xlsx: 'download_visits_by_page', filename: "plantilla_páginas_visitadas_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def searches
    params[:q] = {} unless params[:q]
    
    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day
    end
    if !params[:q][:completed_at_gt].blank? && params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.now.end_of_month
    end

    params[:q][:s] ||= "completed_at desc"

    @search = Tag.ransack(params[:q])
    @searches = Tag.where(created_at: params[:q][:completed_at_gt]..params[:q][:completed_at_lt]).order('search_count DESC')
    @searches = @searches.page(params[:page]).per(20)
  end

  def download_searches
    params[:gt] = {} unless params[:gt]
    params[:lt] = {} unless params[:lt]
    if !params[:gt].blank?
      params[:gt] = Time.zone.parse(params[:gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:gt] && !params[:lt].blank?
      params[:lt] = Time.zone.parse(params[:lt]).end_of_day rescue ""
    end
    @searches = Tag.where(created_at: params[:gt]..params[:lt]).order('search_count DESC')
		respond_to do |format|
			format.xlsx {render xlsx: 'download_searches', filename: "plantilla_búsquedas_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  def sales_total
    params[:q] = {} unless params[:q]

    if params[:q][:completed_at_gt].blank?
      params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
    else
      params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end

    if params[:q] && !params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
    end

    if !params[:q][:completed_at_gt].blank? && params[:q][:completed_at_lt].blank?
      params[:q][:completed_at_lt] = Time.zone.now.end_of_month
    end

    params[:q][:s] ||= "completed_at desc"

    @search = Order.complete.ransack(params[:q])
    @orders = @search.result

    @totals = {}
    @orders.each do |order|
      unless @totals[order.currency]
        @totals[order.currency] = { 
          item_total: ::Money.new(0, order.currency), 
          adjustment_total: ::Money.new(0, order.currency), 
          shipments_total: ::Money.new(0, order.currency), 
          sales_total: ::Money.new(0, order.currency) 
        } 
      end
      @totals[order.currency][:item_total] += order.display_item_total.money
      @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
      @totals[order.currency][:shipments_total] += order.display_shipment_total.money
      @totals[order.currency][:sales_total] += order.display_total.money
    end
  end

  def download_sales_total
    params[:gt] = {} unless params[:gt]
    params[:lt] = {} unless params[:lt]
    if !params[:gt].blank?
      params[:gt] = Time.zone.parse(params[:gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
    end
    if params[:gt] && !params[:lt].blank?
      params[:lt] = Time.zone.parse(params[:lt]).end_of_day rescue ""
    end
    orders = Order.complete.where(completed_at: params[:gt]..params[:lt])
    @totals = {}
    orders.each do |order|
      unless @totals[order.currency]
        @totals[order.currency] = { 
          item_total: ::Money.new(0, order.currency), 
          adjustment_total: ::Money.new(0, order.currency), 
          shipments_total: ::Money.new(0, order.currency), 
          sales_total: ::Money.new(0, order.currency) 
        } 
      end
      @totals[order.currency][:item_total] += order.display_item_total.money
      @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
      @totals[order.currency][:shipments_total] += order.display_shipment_total.money
      @totals[order.currency][:sales_total] += order.display_total.money
    end
    respond_to do |format|
			format.xlsx {render xlsx: 'download_sales_total', filename: "plantilla_ventas_totales_#{Date.today.strftime("%d/%m/%Y")}.xlsx"}
		end
  end

  private

  def short_format(total)
    letter = ""
    if total > 0
      if(Math.log10(total).to_i + 1)> 3 && (Math.log10(total).to_i + 1) <= 6 
        letter = " K"
        total = total.to_s[0...-3]
      elsif (Math.log10(total).to_i + 1)> 6
        total = total.to_s[0...-6]
        letter = " M"
      end
    end
    return total, letter
  end

  def total_ammount(orders)
    total = 0
    orders.each do |order|
      total+= order.total
    end
    return total
  end

end
end
end
