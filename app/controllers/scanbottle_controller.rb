class ScanbottleController < ApplicationController
  before_action :check_login
  def index
  end

  def edit 
  end

  def update
    bottle_id_enc = params[:other][:bottle_id]
    bottle = Bottle.find(Bottle.get_bottle_id(bottle_id_enc))
    if bottle != nil 
        redirect_to edit_bottle_path(bottle)
    else 
        render action: 'edit'
    end
  end
end
