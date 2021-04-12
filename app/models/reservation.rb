class Reservation < ApplicationRecord
  belongs_to :room

  validates_presence_of :start_date, :end_date, :guest_name, :number_of_guests
  validates_numericality_of :number_of_guests, greater_than: 0, less_than_or_equal_to: 10
  validate :start_date_is_before_end_date, :start_date_is_before_actual_date, :couldnt_create_reservation

  def duration
    if start_date.present? && end_date.present? && end_date > start_date
      (end_date - start_date).to_i
    end
  end

  def code
    if id.present? && room&.code.present?
      formatted_id = '%02d' % id
      "#{room.code}-#{formatted_id}"
    end
  end

  private
  def start_date_is_before_actual_date
    if start_date.present? && start_date < Date.today.to_time 
      errors.add(:base, :invalid_dates, message: "The start date should be after #{Date.today.to_time}")
    end
  end
  
  def start_date_is_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date    
      errors.add(:base, :invalid_dates, message: 'The start date should be before the end date')
    end
  end

  def couldnt_create_reservation
    if start_date.present?
    check_reservation = Reservation.where(room_id:room_id)
    for reservation in check_reservation
      if start_date.between?(reservation.start_date,reservation.end_date-1) || end_date.between?(reservation.start_date+1, reservation.end_date)
        errors.add(:base, :invalid_dates, message: 'There is not avaliable date ')
        return
      elsif start_date < reservation.end_date && end_date > reservation.end_date   
        errors.add(:base, :invalid_dates, message: 'There is not avaliable date ')
        return
      end
    end
  end
  end

end
