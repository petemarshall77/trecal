class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  def calendar
    @year  = (params[:year]  || Date.current.year).to_i
    @month = (params[:month] || Date.current.month).to_i.clamp(1, 12)

    @current_month_start = Date.new(@year, @month, 1)

    prev_m = @current_month_start.prev_month
    next_m = @current_month_start.next_month
    @prev_month_path = calendar_month_path(year: prev_m.year, month: prev_m.month)
    @next_month_path = calendar_month_path(year: next_m.year, month: next_m.month) if next_m <= Date.current.beginning_of_month

    photos_this_month = Photo.for_month(@year, @month).with_attached_image
    @photos_by_date   = photos_this_month.index_by(&:taken_on)
    @weeks            = build_calendar_weeks(@current_month_start)
  end

  def show
    @prev_photo = Photo.previous_photo(@photo.taken_on)
    @next_photo = Photo.next_photo(@photo.taken_on)
  end

  def roll
    @photos = Photo.chronological.with_attached_image
  end

  def bulk_upload
    return unless request.post?

    @results = { added: [], failed: [] }

    Array(params[:photos]).each do |file|
      stem = File.basename(file.original_filename, ".*")
      begin
        taken_on = Date.strptime(stem, "%Y%m%d")
      rescue Date::Error
        next  # silently ignore non-conforming filenames
      end

      photo = Photo.find_or_initialize_by(taken_on: taken_on)
      photo.image = file
      if photo.save
        @results[:added] << "#{file.original_filename} → #{taken_on}"
      else
        @results[:failed] << "#{file.original_filename} — #{photo.errors.full_messages.to_sentence}"
      end
    end
  end

  def new
    @photo = Photo.new(taken_on: Date.current)
    @photo.taken_on = Date.parse(params[:date]) if params[:date].present?
  rescue Date::Error
    @photo = Photo.new(taken_on: Date.current)
  end

  def create
    @photo = Photo.new(photo_params)
    existing = Photo.for_date(@photo.taken_on)
    if existing
      redirect_to existing, alert: "A photo for #{@photo.taken_on.strftime('%B %-d, %Y')} already exists."
      return
    end
    if @photo.save
      redirect_to @photo, notice: "Photo uploaded successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @photo.update(update_params)
      redirect_to @photo, notice: "Photo updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @photo.destroy
    redirect_to calendar_path, notice: "Photo deleted."
  end

  private

  def set_photo
    @photo = Photo.with_attached_image.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:taken_on, :image)
  end

  def update_params
    # Date is not editable on update; only the image can be replaced
    params.require(:photo).permit(:image)
  end

  def build_calendar_weeks(first_of_month)
    start_date = first_of_month.beginning_of_week(:sunday)
    end_date   = first_of_month.end_of_month.end_of_week(:sunday)
    weeks = []
    current = start_date
    while current <= end_date
      weeks << (0..6).map { |offset| current + offset }
      current += 7
    end
    weeks
  end
end
