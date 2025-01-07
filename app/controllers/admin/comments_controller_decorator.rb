Spree::Admin::CommentsController.class_eval do
	def destroy
		if Spree::Comment.find_by(id: params[:id]).destroy
			redirect_to :back, notice: 'Comentario eliminado con éxito!'
		else
			redirect_to :back, alert: 'No se pudo eliminar el comentario.'
		end
	end
end