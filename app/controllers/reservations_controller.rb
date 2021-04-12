class ReservationsController < ApplicationController
  def search
    @should_show_results = params[:start_date].present? &&
    params[:end_date].present? &&
    params[:number_of_guests].present?
  
    if params[:number_of_guests].present?
      @available_rooms =  Room.where("capacity >= ?",params[:number_of_guests]) 
      
      room_id = []
      for uid in @available_rooms
        room_id.push(uid.id)
      end

      all_reservation = Reservation.where(room_id:room_id).select(:start_date, :end_date,:room_id)

      unavailabel_room_id = []
      for reservation in all_reservation
        if (params[:start_date]).to_date.between?(reservation.start_date,reservation.end_date-1) || (params[:end_date]).to_date.between?(reservation.start_date+1, reservation.end_date)
          if !unavailabel_room_id.include? reservation.room_id
            unavailabel_room_id.push(reservation.room_id)
          end

        elsif (params[:start_date]).to_date < reservation.end_date && (params[:end_date]).to_date > reservation.end_date   
          if !unavailabel_room_id.include? reservation.room_id
            unavailabel_room_id.push(reservation.room_id)
          end
          
        end
      end

     
      if unavailabel_room_id != []
        @available_rooms = @should_show_results ? Room.where.not(id:unavailabel_room_id).where("capacity >= ?",params[:number_of_guests]) : Room.none
        puts @available_rooms
      end
    
    else 
      @available_rooms = Room.none
    end
  end

  def new
    @reservation = Reservation.new(reservation_params)
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation.room,
        notice: "Reservation #{@reservation.code} was successfully created."
    else
      render :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to room_path(@reservation.room),
      notice: "Reservation #{@reservation.code} was successfully destroyed."
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :number_of_guests, :guest_name, :room_id)
  end
end
