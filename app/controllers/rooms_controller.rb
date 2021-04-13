class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, ]

  def index
    @rooms = Room.all
    @occ = []
    cont_week = 0 
    cont_month = 0 
    @occupation_week_global = 0
    @occupation_month_global = 0
    for i in Room.all
      @occ.push(occupation_time(i.id,8))
      cont_week =( occupation_time(i.id,8)).to_i + cont_week
      @occ.push(occupation_time(i.id,31))
      cont_month = (occupation_time(i.id,31)).to_i + cont_month
    end
    if cont_week != 0
      @occupation_week_global = cont_week / (@occ.size/2)
      @occupation_month_global = cont_month / (@occ.size/2)
    end
  end

  def show

    @occupation_week = occupation_time(params[:id],8)
    @occupation_month =  occupation_time(params[:id],31)

  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_url, notice: 'Room was successfully destroyed.'
  end

  private
    def set_room
      @room = Room.find(params[:id])
    end

    def occupation_time(id,days)
      ocup = Reservation.where(room_id:id).where("start_date >?",Date.today).where("start_date <?",Date.today+days.day).select(:start_date,:end_date)
      cont = 0 
      if ocup != []
        for oc in ocup
          if oc.end_date > (Date.today + days.day+1)
            cont = (Date.today +days.day) - oc.start_date + cont
          else
            cont = (oc.end_date - oc.start_date).to_i + cont
          end
        end
        if cont > 0 
        occupation = cont*100/days
        return occupation
        else 
          return 0
        end
      end
    end

    def room_params
      params.require(:room).permit(:code, :capacity, :notes)
    end
end
